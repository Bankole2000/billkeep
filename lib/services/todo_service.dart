import 'package:dio/dio.dart';
import '../models/todo_model.dart';
import 'api_client.dart';

class TodoService {
  final ApiClient _apiClient;

  TodoService() : _apiClient = ApiClient();

  /// Create a new todo
  Future<TodoModel> createTodo({
    required String projectId,
    required String title,
    String? description,
    bool? isCompleted,
    DateTime? completedAt,
    int? directExpenseAmount,
    String? directExpenseCurrency,
    String? directExpenseType,
    String? directExpenseFrequency,
    String? directExpenseDescription,
    String? linkedShoppingListId,
    String? parentTodoId,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/todos',
        data: {
          'projectId': projectId,
          'title': title,
          'description': description,
          'isCompleted': isCompleted,
          'completedAt': completedAt?.toIso8601String(),
          'directExpenseAmount': directExpenseAmount,
          'directExpenseCurrency': directExpenseCurrency,
          'directExpenseType': directExpenseType,
          'directExpenseFrequency': directExpenseFrequency,
          'directExpenseDescription': directExpenseDescription,
          'linkedShoppingListId': linkedShoppingListId,
          'parentTodoId': parentTodoId,
        },
      );

      return TodoModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get all todos
  Future<List<TodoModel>> getAllTodos({
    String? projectId,
    bool? isCompleted,
    String? parentTodoId,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};

      if (projectId != null) queryParameters['projectId'] = projectId;
      if (isCompleted != null) queryParameters['isCompleted'] = isCompleted;
      if (parentTodoId != null) queryParameters['parentTodoId'] = parentTodoId;
      if (page != null) queryParameters['page'] = page;
      if (limit != null) queryParameters['limit'] = limit;

      final response = await _apiClient.dio.get(
        '/todos',
        queryParameters: queryParameters,
      );

      if (response.data is List) {
        return (response.data as List)
            .map((todo) => TodoModel.fromJson(todo))
            .toList();
      } else if (response.data is Map && response.data['data'] != null) {
        return (response.data['data'] as List)
            .map((todo) => TodoModel.fromJson(todo))
            .toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get a single todo by ID
  Future<TodoModel> getTodoById(String id) async {
    try {
      final response = await _apiClient.dio.get('/todos/$id');
      return TodoModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update an existing todo
  Future<TodoModel> updateTodo({
    required String id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? completedAt,
    int? directExpenseAmount,
    String? directExpenseCurrency,
    String? directExpenseType,
    String? directExpenseFrequency,
    String? directExpenseDescription,
    String? linkedShoppingListId,
    String? parentTodoId,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (title != null) data['title'] = title;
      if (description != null) data['description'] = description;
      if (isCompleted != null) data['isCompleted'] = isCompleted;
      if (completedAt != null) {
        data['completedAt'] = completedAt.toIso8601String();
      }
      if (directExpenseAmount != null) {
        data['directExpenseAmount'] = directExpenseAmount;
      }
      if (directExpenseCurrency != null) {
        data['directExpenseCurrency'] = directExpenseCurrency;
      }
      if (directExpenseType != null) {
        data['directExpenseType'] = directExpenseType;
      }
      if (directExpenseFrequency != null) {
        data['directExpenseFrequency'] = directExpenseFrequency;
      }
      if (directExpenseDescription != null) {
        data['directExpenseDescription'] = directExpenseDescription;
      }
      if (linkedShoppingListId != null) {
        data['linkedShoppingListId'] = linkedShoppingListId;
      }
      if (parentTodoId != null) data['parentTodoId'] = parentTodoId;

      final response = await _apiClient.dio.put('/todos/$id', data: data);
      return TodoModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete a todo
  Future<void> deleteTodo(String id) async {
    try {
      await _apiClient.dio.delete('/todos/$id');
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
          return data['message'] ?? 'Todo not found';
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
