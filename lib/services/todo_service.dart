import '../models/todo_model.dart';
import 'base_api_service.dart';

class TodoService extends BaseApiService {
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
    return executeRequest<TodoModel>(
      request: () => dio.post(
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
      ),
      parser: (data) => TodoModel.fromJson(data),
    );
  }

  /// Get all todos
  Future<List<TodoModel>> getAllTodos({
    String? projectId,
    bool? isCompleted,
    String? parentTodoId,
    int? page,
    int? limit,
  }) async {
    final queryParameters = <String, dynamic>{};

    if (projectId != null) queryParameters['projectId'] = projectId;
    if (isCompleted != null) queryParameters['isCompleted'] = isCompleted;
    if (parentTodoId != null) queryParameters['parentTodoId'] = parentTodoId;
    if (page != null) queryParameters['page'] = page;
    if (limit != null) queryParameters['limit'] = limit;

    return executeListRequest<TodoModel>(
      request: () => dio.get(
        '/todos',
        queryParameters: queryParameters,
      ),
      itemParser: (json) => TodoModel.fromJson(json),
    );
  }

  /// Get a single todo by ID
  Future<TodoModel> getTodoById(String id) async {
    return executeRequest<TodoModel>(
      request: () => dio.get('/todos/$id'),
      parser: (data) => TodoModel.fromJson(data),
    );
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

    return executeRequest<TodoModel>(
      request: () => dio.put('/todos/$id', data: data),
      parser: (data) => TodoModel.fromJson(data),
    );
  }

  /// Delete a todo
  Future<void> deleteTodo(String id) async {
    return executeVoidRequest(
      request: () => dio.delete('/todos/$id'),
    );
  }
}
