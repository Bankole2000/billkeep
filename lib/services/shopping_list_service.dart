import 'package:dio/dio.dart';
import '../models/shopping_list_model.dart';
import 'api_client.dart';

class ShoppingListService {
  final ApiClient _apiClient;

  ShoppingListService() : _apiClient = ApiClient();

  /// Create a new shopping list
  Future<ShoppingListModel> createShoppingList({
    required String projectId,
    required String name,
    String? description,
    String? linkedExpenseId,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/shopping-lists',
        data: {
          'projectId': projectId,
          'name': name,
          'description': description,
          'linkedExpenseId': linkedExpenseId,
        },
      );

      return ShoppingListModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get all shopping lists
  Future<List<ShoppingListModel>> getAllShoppingLists({
    String? projectId,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};

      if (projectId != null) queryParameters['projectId'] = projectId;
      if (page != null) queryParameters['page'] = page;
      if (limit != null) queryParameters['limit'] = limit;

      final response = await _apiClient.dio.get(
        '/shopping-lists',
        queryParameters: queryParameters,
      );

      if (response.data is List) {
        return (response.data as List)
            .map((list) => ShoppingListModel.fromJson(list))
            .toList();
      } else if (response.data is Map && response.data['data'] != null) {
        return (response.data['data'] as List)
            .map((list) => ShoppingListModel.fromJson(list))
            .toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get a single shopping list by ID
  Future<ShoppingListModel> getShoppingListById(String id) async {
    try {
      final response = await _apiClient.dio.get('/shopping-lists/$id');
      return ShoppingListModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update an existing shopping list
  Future<ShoppingListModel> updateShoppingList({
    required String id,
    String? name,
    String? description,
    String? linkedExpenseId,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (name != null) data['name'] = name;
      if (description != null) data['description'] = description;
      if (linkedExpenseId != null) data['linkedExpenseId'] = linkedExpenseId;

      final response =
          await _apiClient.dio.put('/shopping-lists/$id', data: data);
      return ShoppingListModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete a shopping list
  Future<void> deleteShoppingList(String id) async {
    try {
      await _apiClient.dio.delete('/shopping-lists/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
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
    try {
      final response = await _apiClient.dio.post(
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
      );

      return ShoppingListItemModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get all items for a shopping list
  Future<List<ShoppingListItemModel>> getShoppingListItems({
    required String shoppingListId,
    bool? isPurchased,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (isPurchased != null) queryParameters['isPurchased'] = isPurchased;

      final response = await _apiClient.dio.get(
        '/shopping-lists/$shoppingListId/items',
        queryParameters: queryParameters,
      );

      if (response.data is List) {
        return (response.data as List)
            .map((item) => ShoppingListItemModel.fromJson(item))
            .toList();
      } else if (response.data is Map && response.data['data'] != null) {
        return (response.data['data'] as List)
            .map((item) => ShoppingListItemModel.fromJson(item))
            .toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
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
    try {
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

      final response = await _apiClient.dio.put(
        '/shopping-lists/$shoppingListId/items/$itemId',
        data: data,
      );
      return ShoppingListItemModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete a shopping list item
  Future<void> deleteShoppingListItem({
    required String shoppingListId,
    required String itemId,
  }) async {
    try {
      await _apiClient.dio
          .delete('/shopping-lists/$shoppingListId/items/$itemId');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle DioException and return appropriate error message
  String _handleError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final data = error.response!.data;

      switch (statusCode) {
        case 400:
          return data['message'] ?? 'Bad request';
        case 401:
          return data['message'] ?? 'Unauthorized';
        case 403:
          return data['message'] ?? 'Forbidden';
        case 404:
          return data['message'] ?? 'Shopping list not found';
        case 409:
          return data['message'] ?? 'Conflict';
        case 500:
          return 'Internal server error';
        default:
          return data['message'] ?? 'An error occurred';
      }
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Connection timeout';
    } else if (error.type == DioExceptionType.connectionError) {
      return 'No internet connection';
    } else {
      return error.message ?? 'An unexpected error occurred';
    }
  }
}
