import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';
import '../services/pocketbase_realtime_service.dart';
import '../services/logging_service.dart';
import 'database_provider.dart';
// import 'sync_provider.dart';

/// Provider for the PocketBase realtime service
final realtimeServiceProvider = Provider<PocketBaseRealtimeService>((ref) {
  return PocketBaseRealtimeService();
});

/// Provider to manage realtime sync state
class RealtimeSyncNotifier extends StateNotifier<RealtimeSyncState> {
  final PocketBaseRealtimeService _realtimeService;
  final AppDatabase _database;
  final Ref _ref;

  RealtimeSyncNotifier(this._realtimeService, this._database, this._ref)
    : super(const RealtimeSyncState.disconnected());

  /// Start listening to real-time updates for all collections
  Future<void> startListening() async {
    try {
      state = const RealtimeSyncState.connecting();

      // Initialize the realtime service
      await _realtimeService.initialize();

      // Subscribe to projects
      _subscribeToProjects();

      // Subscribe to expenses
      _subscribeToExpenses();

      // TODO: Add more collection subscriptions as needed

      state = RealtimeSyncState.connected(
        collections: ['projects', 'expenses'],
        connectedAt: DateTime.now(),
      );

      LoggingService.info('Realtime sync started');
    } catch (e) {
      state = RealtimeSyncState.error(message: e.toString());
      LoggingService.error('Failed to start realtime sync', error: e);
    }
  }

  /// Subscribe to project changes
  void _subscribeToProjects() {
    _realtimeService
        .subscribe('projects')
        .listen(
          (event) async {
            LoggingService.sync(
              'Project realtime event',
              entity: 'Project',
              data: {'action': event.action, 'recordId': event.recordId},
            );

            try {
              if (event.isCreate || event.isUpdate) {
                // Update or insert the project in local database
                await _handleProjectUpsert(event.record!);
              } else if (event.isDelete) {
                // Delete the project from local database
                await _handleProjectDelete(event.recordId);
              }
            } catch (e) {
              LoggingService.error(
                'Failed to handle project realtime event',
                error: e,
              );
            }
          },
          onError: (error) {
            LoggingService.error(
              'Project realtime subscription error',
              error: error,
            );
          },
        );
  }

  /// Subscribe to expense changes
  void _subscribeToExpenses() {
    _realtimeService
        .subscribe('expenses')
        .listen(
          (event) async {
            LoggingService.sync(
              'Expense realtime event',
              entity: 'Expense',
              data: {'action': event.action, 'recordId': event.recordId},
            );

            try {
              if (event.isCreate || event.isUpdate) {
                await _handleExpenseUpsert(event.record!);
              } else if (event.isDelete) {
                await _handleExpenseDelete(event.recordId);
              }
            } catch (e) {
              LoggingService.error(
                'Failed to handle expense realtime event',
                error: e,
              );
            }
          },
          onError: (error) {
            LoggingService.error(
              'Expense realtime subscription error',
              error: error,
            );
          },
        );
  }

  /// Handle project create/update from realtime
  Future<void> _handleProjectUpsert(Map<String, dynamic> data) async {
    final projectId = data['id'] as String;

    // Check if project exists locally
    final existingProject = await (_database.select(
      _database.projects,
    )..where((p) => p.id.equals(projectId))).getSingleOrNull();

    if (existingProject != null) {
      // Update existing project
      await (_database.update(
        _database.projects,
      )..where((p) => p.id.equals(projectId))).write(
        ProjectsCompanion(
          name: Value(data['name'] as String),
          description: Value(data['description'] as String?),
          isSynced: const Value(true),
        ),
      );
      LoggingService.debug(
        'Project updated from realtime',
        data: {'id': projectId},
      );
    } else {
      // Insert new project
      await _database
          .into(_database.projects)
          .insert(
            ProjectsCompanion(
              id: Value(projectId),
              name: Value(data['name'] as String),
              description: Value(data['description'] as String?),
              isSynced: const Value(true),
            ),
          );
      LoggingService.debug(
        'Project created from realtime',
        data: {'id': projectId},
      );
    }
  }

  /// Handle project delete from realtime
  Future<void> _handleProjectDelete(String projectId) async {
    await (_database.delete(
      _database.projects,
    )..where((p) => p.id.equals(projectId))).go();
    LoggingService.debug(
      'Project deleted from realtime',
      data: {'id': projectId},
    );
  }

  /// Handle expense create/update from realtime
  Future<void> _handleExpenseUpsert(Map<String, dynamic> data) async {
    final expenseId = data['id'] as String;

    final existingExpense = await (_database.select(
      _database.expenses,
    )..where((e) => e.id.equals(expenseId))).getSingleOrNull();

    if (existingExpense != null) {
      // Update existing expense
      await (_database.update(
        _database.expenses,
      )..where((e) => e.id.equals(expenseId))).write(
        ExpensesCompanion(
          name: Value(data['name'] as String),
          expectedAmount: Value(data['expectedAmount'] as int),
          currency: Value(data['currency'] as String),
          // Add more fields as needed
          isSynced: const Value(true),
        ),
      );
      LoggingService.debug(
        'Expense updated from realtime',
        data: {'id': expenseId},
      );
    } else {
      // Insert new expense
      await _database
          .into(_database.expenses)
          .insert(
            ExpensesCompanion(
              id: Value(expenseId),
              projectId: Value(data['projectId'] as String),
              name: Value(data['name'] as String),
              expectedAmount: Value(data['expectedAmount'] as int),
              currency: Value(data['currency'] as String),
              // Add more fields as needed
              isSynced: const Value(true),
            ),
          );
      LoggingService.debug(
        'Expense created from realtime',
        data: {'id': expenseId},
      );
    }
  }

  /// Handle expense delete from realtime
  Future<void> _handleExpenseDelete(String expenseId) async {
    await (_database.delete(
      _database.expenses,
    )..where((e) => e.id.equals(expenseId))).go();
    LoggingService.debug(
      'Expense deleted from realtime',
      data: {'id': expenseId},
    );
  }

  /// Stop listening to real-time updates
  void stopListening() {
    _realtimeService.unsubscribeAll();
    state = const RealtimeSyncState.disconnected();
    LoggingService.info('Realtime sync stopped');
  }

  @override
  void dispose() {
    _realtimeService.dispose();
    super.dispose();
  }
}

/// Provider for realtime sync state
final realtimeSyncProvider =
    StateNotifierProvider<RealtimeSyncNotifier, RealtimeSyncState>((ref) {
      final realtimeService = ref.watch(realtimeServiceProvider);
      final database = ref.watch(databaseProvider);
      return RealtimeSyncNotifier(realtimeService, database, ref);
    });

/// State for realtime sync
class RealtimeSyncState {
  final RealtimeStatus status;
  final List<String> collections;
  final DateTime? connectedAt;
  final String? errorMessage;

  const RealtimeSyncState({
    required this.status,
    this.collections = const [],
    this.connectedAt,
    this.errorMessage,
  });

  const RealtimeSyncState.disconnected()
    : status = RealtimeStatus.disconnected,
      collections = const [],
      connectedAt = null,
      errorMessage = null;

  const RealtimeSyncState.connecting()
    : status = RealtimeStatus.connecting,
      collections = const [],
      connectedAt = null,
      errorMessage = null;

  const RealtimeSyncState.connected({
    required List<String> collections,
    required DateTime connectedAt,
  }) : status = RealtimeStatus.connected,
       collections = collections,
       connectedAt = connectedAt,
       errorMessage = null;

  const RealtimeSyncState.error({required String message})
    : status = RealtimeStatus.error,
      collections = const [],
      connectedAt = null,
      errorMessage = message;

  bool get isConnected => status == RealtimeStatus.connected;
  bool get isDisconnected => status == RealtimeStatus.disconnected;
  bool get isConnecting => status == RealtimeStatus.connecting;
  bool get hasError => status == RealtimeStatus.error;
}

enum RealtimeStatus { disconnected, connecting, connected, error }
