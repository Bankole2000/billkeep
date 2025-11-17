import 'package:dio/dio.dart';
import '../../database/database.dart';
import '../../services/api_client.dart';
import '../../utils/exceptions.dart';
import '../../utils/id_generator.dart';
import 'base_sync_service.dart';

/// Synchronization service for Payments
///
/// Handles bidirectional sync between local Drift database and remote API
/// Makes DIRECT API calls (not through PaymentService) to avoid double-writing
///
/// NOTE: This is a template. Adjust field mappings based on your Payment model.
class PaymentSyncService extends BaseSyncService {
  final AppDatabase _database;
  final Dio _dio;

  PaymentSyncService({
    required AppDatabase database,
    Dio? dio,
  })  : _database = database,
        _dio = dio ?? ApiClient().dio;

  @override
  Future<void> syncEntity(String tempId) async {
    if (!IdGenerator.isTemporaryId(tempId)) {
      return;
    }

    // TODO: Implement payment sync
    // 1. Get local payment from database
    // 2. Send to API via _dio.post('/payments/records', data: {...})
    // 3. Update local with canonical ID

    throw UnimplementedError('Payment sync not yet implemented - adjust field mappings');
  }

  @override
  Future<List<String>> getUnsyncedEntityIds() async {
    // TODO: Query database for unsynced payments
    return [];
  }

  @override
  Future<void> pullFromServer() async {
    // TODO: Implement pull from server
    throw UnimplementedError('Payment pull not yet implemented - adjust field mappings');
  }
}
