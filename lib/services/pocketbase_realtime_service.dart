import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../services/api_client.dart';
import '../utils/exceptions.dart';
import 'logging_service.dart';

/// PocketBase Realtime Service using Server-Sent Events (SSE)
///
/// Provides real-time data synchronization by listening to PocketBase's
/// SSE endpoint for collection changes (create, update, delete)
class PocketBaseRealtimeService {
  static final PocketBaseRealtimeService _instance =
      PocketBaseRealtimeService._internal();
  factory PocketBaseRealtimeService() => _instance;
  PocketBaseRealtimeService._internal();

  // Active SSE connections by collection name
  final Map<String, _CollectionSubscription> _subscriptions = {};

  // Stream controllers for broadcasting events
  final Map<String, StreamController<RealtimeEvent>> _controllers = {};

  bool _isInitialized = false;
  String? _clientId;

  /// Initialize the realtime service
  ///
  /// Call this once when the app starts and user is authenticated
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Generate a unique client ID for this session
      _clientId = DateTime.now().millisecondsSinceEpoch.toString();
      _isInitialized = true;

      LoggingService.info(
        'PocketBase Realtime initialized',
        data: {'clientId': _clientId},
      );
    } catch (e) {
      LoggingService.error('Failed to initialize realtime service', error: e);
      throw NetworkException(
        'Failed to initialize realtime service: $e',
        'Unable to connect to real-time updates',
      );
    }
  }

  /// Subscribe to a collection's real-time events
  ///
  /// [collection] - The PocketBase collection name (e.g., 'projects', 'expenses')
  /// [recordId] - Optional: Subscribe to a specific record only
  ///
  /// Returns a Stream of RealtimeEvent that you can listen to
  Stream<RealtimeEvent> subscribe(String collection, {String? recordId}) {
    if (!_isInitialized) {
      throw StateError(
        'PocketBaseRealtimeService not initialized. Call initialize() first.',
      );
    }

    final subscriptionKey = recordId != null
        ? '$collection:$recordId'
        : collection;

    // Return existing subscription if already active
    if (_controllers.containsKey(subscriptionKey)) {
      return _controllers[subscriptionKey]!.stream;
    }

    // Create new stream controller
    final controller = StreamController<RealtimeEvent>.broadcast(
      onListen: () => _startSubscription(collection, recordId),
      onCancel: () => _stopSubscription(subscriptionKey),
    );

    _controllers[subscriptionKey] = controller;

    return controller.stream;
  }

  /// Start an SSE subscription for a collection
  Future<void> _startSubscription(String collection, String? recordId) async {
    final subscriptionKey = recordId != null
        ? '$collection:$recordId'
        : collection;

    if (_subscriptions.containsKey(subscriptionKey)) {
      return; // Already subscribed
    }

    try {
      final token = await ApiClient.getToken();
      if (token == null) {
        throw AuthenticationException(
          'No auth token available',
          'Please log in to enable real-time updates',
        );
      }

      // Build SSE URL
      final baseUrl = AppConfig.apiBaseUrl.replaceAll('/api/collections', '');
      final uri = recordId != null
          ? Uri.parse(
              '$baseUrl/api/realtime?collection=$collection&recordId=$recordId',
            )
          : Uri.parse('$baseUrl/api/realtime?collection=$collection');

      LoggingService.debug(
        'Starting SSE subscription',
        data: {
          'collection': collection,
          'recordId': recordId,
          'url': uri.toString(),
        },
      );

      // Create HTTP client for SSE
      final client = http.Client();
      final request = http.Request('GET', uri)
        ..headers.addAll({
          'Authorization': 'Bearer $token',
          'Accept': 'text/event-stream',
          'Cache-Control': 'no-cache',
        });

      final response = await client.send(request);

      if (response.statusCode != 200) {
        throw NetworkException(
          'SSE connection failed: ${response.statusCode}',
          'Unable to establish real-time connection',
        );
      }

      // Store subscription
      final subscription = _CollectionSubscription(
        collection: collection,
        recordId: recordId,
        client: client,
        streamSubscription: null,
      );
      _subscriptions[subscriptionKey] = subscription;

      // Listen to SSE stream
      subscription.streamSubscription = response.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(
            (line) => _handleSSEMessage(subscriptionKey, line),
            onError: (error) => _handleSSEError(subscriptionKey, error),
            onDone: () => _handleSSEDone(subscriptionKey),
            cancelOnError: false,
          );

      LoggingService.info(
        'SSE subscription active',
        data: {'collection': collection, 'recordId': recordId},
      );
    } catch (e, stackTrace) {
      LoggingService.error(
        'Failed to start SSE subscription',
        error: e,
        stackTrace: stackTrace,
      );
      _stopSubscription(subscriptionKey);
      rethrow;
    }
  }

  /// Handle incoming SSE message
  void _handleSSEMessage(String subscriptionKey, String line) {
    if (line.isEmpty) return;

    try {
      // SSE format: "data: {json}"
      if (line.startsWith('data: ')) {
        final jsonStr = line.substring(6); // Remove "data: " prefix
        final json = jsonDecode(jsonStr) as Map<String, dynamic>;

        final event = RealtimeEvent.fromJson(json);

        LoggingService.debug(
          'Realtime event received',
          data: {
            'action': event.action,
            'collection': event.collection,
            'recordId': event.record!['id'],
          },
        );

        // Broadcast to listeners
        _controllers[subscriptionKey]?.add(event);
      } else if (line.startsWith('event: ')) {
        // PocketBase sends keep-alive "event: ping" messages
        final eventType = line.substring(7);
        if (eventType == 'ping') {
          LoggingService.debug('SSE ping received', tag: 'Realtime');
        }
      }
    } catch (e) {
      LoggingService.error(
        'Failed to parse SSE message',
        error: e,
        data: {'line': line},
      );
    }
  }

  /// Handle SSE error
  void _handleSSEError(String subscriptionKey, Object error) {
    LoggingService.error('SSE error', error: error, tag: 'Realtime');

    final controller = _controllers[subscriptionKey];
    if (controller != null && !controller.isClosed) {
      controller.addError(
        NetworkException(
          'Real-time connection error: $error',
          'Real-time updates temporarily unavailable',
        ),
      );
    }

    // Attempt to reconnect after delay
    Future.delayed(const Duration(seconds: 5), () {
      if (_controllers.containsKey(subscriptionKey)) {
        final subscription = _subscriptions[subscriptionKey];
        if (subscription != null) {
          LoggingService.info(
            'Attempting to reconnect SSE',
            data: {'collection': subscription.collection},
          );
          _startSubscription(subscription.collection, subscription.recordId);
        }
      }
    });
  }

  /// Handle SSE connection closed
  void _handleSSEDone(String subscriptionKey) {
    LoggingService.info(
      'SSE connection closed',
      data: {'subscriptionKey': subscriptionKey},
    );

    _stopSubscription(subscriptionKey);
  }

  /// Stop a subscription
  void _stopSubscription(String subscriptionKey) {
    final subscription = _subscriptions.remove(subscriptionKey);
    subscription?.streamSubscription?.cancel();
    subscription?.client.close();

    final controller = _controllers.remove(subscriptionKey);
    controller?.close();

    LoggingService.debug(
      'SSE subscription stopped',
      data: {'subscriptionKey': subscriptionKey},
    );
  }

  /// Unsubscribe from a collection
  void unsubscribe(String collection, {String? recordId}) {
    final subscriptionKey = recordId != null
        ? '$collection:$recordId'
        : collection;
    _stopSubscription(subscriptionKey);
  }

  /// Unsubscribe from all collections
  void unsubscribeAll() {
    final keys = _subscriptions.keys.toList();
    for (final key in keys) {
      _stopSubscription(key);
    }
  }

  /// Dispose the service (call when user logs out)
  void dispose() {
    unsubscribeAll();
    _isInitialized = false;
    _clientId = null;
    LoggingService.info('PocketBase Realtime disposed');
  }
}

/// Internal class to track active subscriptions
class _CollectionSubscription {
  final String collection;
  final String? recordId;
  final http.Client client;
  StreamSubscription<String>? streamSubscription;

  _CollectionSubscription({
    required this.collection,
    required this.recordId,
    required this.client,
    required this.streamSubscription,
  });
}

/// Represents a real-time event from PocketBase
class RealtimeEvent {
  final String action; // "create", "update", "delete"
  final String collection;
  final Map<String, dynamic>? record;

  RealtimeEvent({required this.action, required this.collection, this.record});

  factory RealtimeEvent.fromJson(Map<String, dynamic> json) {
    return RealtimeEvent(
      action: json['action'] as String,
      collection: json['collection'] as String,
      record: json['record'] as Map<String, dynamic>?,
    );
  }

  bool get isCreate => action == 'create';
  bool get isUpdate => action == 'update';
  bool get isDelete => action == 'delete';

  String get recordId => record?['id'] as String? ?? '';

  @override
  String toString() => 'RealtimeEvent($action, $collection, ${record?['id']})';
}
