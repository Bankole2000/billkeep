import 'package:pocketbase/pocketbase.dart';
import '../models/merchant_model.dart';
import 'base_api_service.dart';

class MerchantService extends BaseApiService {
  MerchantService() {
    _setupRealtimeSync();
  }

  /// Setup realtime sync for merchants collection
  void _setupRealtimeSync() {
    subscribeToCollection('merchants', _handleMerchantUpdate);
  }

  /// Handle realtime updates from PocketBase
  void _handleMerchantUpdate(RecordSubscriptionEvent event) {
    print('🔄 Merchant ${event.action}: ${event.record?.id}');

    try {
      switch (event.action) {
        case 'create':
        case 'update':
          if (event.record != null) {
            _syncMerchantFromBackend(event.record!);
          }
          break;
        case 'delete':
          if (event.record != null) {
            // TODO: Handle merchant deletion in local DB if needed
            print('🗑️ Merchant deleted: ${event.record!.id}');
          }
          break;
      }
    } catch (e) {
      print('❌ Error handling merchant update: $e');
    }
  }

  /// Sync merchant from backend to local DB
  Future<void> _syncMerchantFromBackend(RecordModel record) async {
    try {
      final canonicalId = record.id;
      print('📥 Syncing merchant: canonicalId=$canonicalId');
      // TODO: Implement local DB sync if needed
      // This would involve updating providers or local state
    } catch (e) {
      print('⚠️ Error syncing merchant: $e');
    }
  }

  /// Create a new merchant
  Future<MerchantModel> createMerchant({
    required String name,
    String? description,
    String? website,
    String? imageUrl,
    String? localImagePath,
    int? iconCodePoint,
    String? iconEmoji,
    String? iconType,
    String? color,
    bool? isDefault,
  }) async {
    return executeRequest<MerchantModel>(
      request: () => dio.post(
        '/merchants',
        data: {
          'name': name,
          'description': description,
          'website': website,
          'imageUrl': imageUrl,
          'localImagePath': localImagePath,
          'iconCodePoint': iconCodePoint,
          'iconEmoji': iconEmoji,
          'iconType': iconType,
          'color': color,
          'isDefault': isDefault,
        },
      ),
      parser: (data) => MerchantModel.fromJson(data),
    );
  }

  /// Get all merchants
  Future<List<MerchantModel>> getAllMerchants({
    bool? isDefault,
    int? page,
    int? limit,
  }) async {
    final queryParameters = <String, dynamic>{};

    if (isDefault != null) queryParameters['isDefault'] = isDefault;
    if (page != null) queryParameters['page'] = page;
    if (limit != null) queryParameters['limit'] = limit;

    return executeListRequest<MerchantModel>(
      request: () => dio.get(
        '/merchants',
        queryParameters: queryParameters,
      ),
      itemParser: (json) => MerchantModel.fromJson(json),
    );
  }

  /// Get a single merchant by ID
  Future<MerchantModel> getMerchantById(String id) async {
    return executeRequest<MerchantModel>(
      request: () => dio.get('/merchants/$id'),
      parser: (data) => MerchantModel.fromJson(data),
    );
  }

  /// Update an existing merchant
  Future<MerchantModel> updateMerchant({
    required String id,
    String? name,
    String? description,
    String? website,
    String? imageUrl,
    String? localImagePath,
    int? iconCodePoint,
    String? iconEmoji,
    String? iconType,
    String? color,
    bool? isDefault,
  }) async {
    final data = <String, dynamic>{};

    if (name != null) data['name'] = name;
    if (description != null) data['description'] = description;
    if (website != null) data['website'] = website;
    if (imageUrl != null) data['imageUrl'] = imageUrl;
    if (localImagePath != null) data['localImagePath'] = localImagePath;
    if (iconCodePoint != null) data['iconCodePoint'] = iconCodePoint;
    if (iconEmoji != null) data['iconEmoji'] = iconEmoji;
    if (iconType != null) data['iconType'] = iconType;
    if (color != null) data['color'] = color;
    if (isDefault != null) data['isDefault'] = isDefault;

    return executeRequest<MerchantModel>(
      request: () => dio.put('/merchants/$id', data: data),
      parser: (data) => MerchantModel.fromJson(data),
    );
  }

  /// Delete a merchant
  Future<void> deleteMerchant(String id) async {
    return executeVoidRequest(
      request: () => dio.delete('/merchants/$id'),
    );
  }
}
