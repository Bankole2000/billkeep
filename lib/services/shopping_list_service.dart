import 'package:pocketbase/pocketbase.dart';
import '../models/shopping_list_model.dart';
import 'base_api_service.dart';

class ShoppingListService extends BaseApiService {
  ShoppingListService() {
    _setupRealtimeSync();
  }

  /// Setup realtime sync for shopping_lists collection
  void _setupRealtimeSync() {
    subscribeToCollection('shopping_lists', _handleShoppingListUpdate);
  }

  /// Handle realtime updates from PocketBase
  void _handleShoppingListUpdate(RecordSubscriptionEvent event) {
    print('🔄 ShoppingList ${event.action}: ${event.record?.id}');

    try {
      switch (event.action) {
        case 'create':
        case 'update':
          if (event.record != null) {
            _syncShoppingListFromBackend(event.record!);
          }
          break;
        case 'delete':
          if (event.record != null) {
            // TODO: Handle shopping list deletion in local DB if needed
            print('🗑️ ShoppingList deleted: ${event.record!.id}');
          }
          break;
      }
    } catch (e) {
      print('❌ Error handling shopping list update: $e');
    }
  }

  /// Sync shopping list from backend to local DB
  Future<void> _syncShoppingListFromBackend(RecordModel record) async {
    try {
      final canonicalId = record.id;
      print('📥 Syncing shopping list: canonicalId=$canonicalId');
      // TODO: Implement local DB sync if needed
      // This would involve updating providers or local state
    } catch (e) {
      print('⚠️ Error syncing shopping list: $e');
    }
  }

  /// Create a new shopping list
  Future<ShoppingListModel> createShoppingList({
    required String projectId,
    required String name,
    String? description,
    String? linkedExpenseId,
  }) async {
    return executeRequest<ShoppingListModel>(
      request: () => dio.post(
        '/shopping-lists',
        data: {
          'projectId': projectId,
          'name': name,
          'description': description,
          'linkedExpenseId': linkedExpenseId,
        },
      ),
      parser: (data) => ShoppingListModel.fromJson(data),
    );
  }

  /// Get all shopping lists
  Future<List<ShoppingListModel>> getAllShoppingLists({
    String? projectId,
    int? page,
    int? limit,
  }) async {
    final queryParameters = <String, dynamic>{};

    if (projectId != null) queryParameters['projectId'] = projectId;
    if (page != null) queryParameters['page'] = page;
    if (limit != null) queryParameters['limit'] = limit;

    return executeListRequest<ShoppingListModel>(
      request: () => dio.get(
        '/shopping-lists',
        queryParameters: queryParameters,
      ),
      itemParser: (json) => ShoppingListModel.fromJson(json),
    );
  }

  /// Get a single shopping list by ID
  Future<ShoppingListModel> getShoppingListById(String id) async {
    return executeRequest<ShoppingListModel>(
      request: () => dio.get('/shopping-lists/$id'),
      parser: (data) => ShoppingListModel.fromJson(data),
    );
  }

  /// Update an existing shopping list
  Future<ShoppingListModel> updateShoppingList({
    required String id,
    String? name,
    String? description,
    String? linkedExpenseId,
  }) async {
    final data = <String, dynamic>{};

    if (name != null) data['name'] = name;
    if (description != null) data['description'] = description;
    if (linkedExpenseId != null) data['linkedExpenseId'] = linkedExpenseId;

    return executeRequest<ShoppingListModel>(
      request: () => dio.put('/shopping-lists/$id', data: data),
      parser: (data) => ShoppingListModel.fromJson(data),
    );
  }

  /// Delete a shopping list
  Future<void> deleteShoppingList(String id) async {
    return executeVoidRequest(
      request: () => dio.delete('/shopping-lists/$id'),
    );
  }

  /// Create a new shopping list item
  Future<ShoppingListItemModel> createShoppingListItem({
    required String shoppingListId,
    required String name,
    int? estimatedAmount,
    int? actualAmount,
    String? currency,
    int? quantity,
    bool? isPurchased,
    DateTime? purchasedAt,
    String? notes,
  }) async {
    return executeRequest<ShoppingListItemModel>(
      request: () => dio.post(
        '/shopping-lists/$shoppingListId/items',
        data: {
          'name': name,
          'estimatedAmount': estimatedAmount,
          'actualAmount': actualAmount,
          'currency': currency,
          'quantity': quantity,
          'isPurchased': isPurchased,
          'purchasedAt': purchasedAt?.toIso8601String(),
          'notes': notes,
        },
      ),
      parser: (data) => ShoppingListItemModel.fromJson(data),
    );
  }

  /// Get all items for a shopping list
  Future<List<ShoppingListItemModel>> getShoppingListItems({
    required String shoppingListId,
    bool? isPurchased,
  }) async {
    final queryParameters = <String, dynamic>{};
    if (isPurchased != null) queryParameters['isPurchased'] = isPurchased;

    return executeListRequest<ShoppingListItemModel>(
      request: () => dio.get(
        '/shopping-lists/$shoppingListId/items',
        queryParameters: queryParameters,
      ),
      itemParser: (json) => ShoppingListItemModel.fromJson(json),
    );
  }

  /// Update a shopping list item
  Future<ShoppingListItemModel> updateShoppingListItem({
    required String shoppingListId,
    required String itemId,
    String? name,
    int? estimatedAmount,
    int? actualAmount,
    String? currency,
    int? quantity,
    bool? isPurchased,
    DateTime? purchasedAt,
    String? notes,
  }) async {
    final data = <String, dynamic>{};

    if (name != null) data['name'] = name;
    if (estimatedAmount != null) data['estimatedAmount'] = estimatedAmount;
    if (actualAmount != null) data['actualAmount'] = actualAmount;
    if (currency != null) data['currency'] = currency;
    if (quantity != null) data['quantity'] = quantity;
    if (isPurchased != null) data['isPurchased'] = isPurchased;
    if (purchasedAt != null) {
      data['purchasedAt'] = purchasedAt.toIso8601String();
    }
    if (notes != null) data['notes'] = notes;

    return executeRequest<ShoppingListItemModel>(
      request: () => dio.put(
        '/shopping-lists/$shoppingListId/items/$itemId',
        data: data,
      ),
      parser: (data) => ShoppingListItemModel.fromJson(data),
    );
  }

  /// Delete a shopping list item
  Future<void> deleteShoppingListItem({
    required String shoppingListId,
    required String itemId,
  }) async {
    return executeVoidRequest(
      request: () => dio.delete('/shopping-lists/$shoppingListId/items/$itemId'),
    );
  }
}
