import 'package:pocketbase/pocketbase.dart';
import '../models/todo_model.dart';
import 'base_api_service.dart';

class TodoService extends BaseApiService {
  TodoService() {
    _setupRealtimeSync();
  }

  /// Setup realtime sync for todos collection
  void _setupRealtimeSync() {
    subscribeToCollection('todos', _handleTodoUpdate);
  }

  /// Handle realtime updates from PocketBase
  void _handleTodoUpdate(RecordSubscriptionEvent event) {
    print('🔄 Todo ${event.action}: ${event.record?.id}');

    try {
      switch (event.action) {
        case 'create':
        case 'update':
          if (event.record != null) {
            _syncTodoFromBackend(event.record!);
          }
          break;
        case 'delete':
          if (event.record != null) {
            // TODO: Handle todo deletion in local DB if needed
            print('🗑️ Todo deleted: ${event.record!.id}');
          }
          break;
      }
    } catch (e) {
      print('❌ Error handling todo update: $e');
    }
  }

  /// Sync todo from backend to local DB
  Future<void> _syncTodoFromBackend(RecordModel record) async {
    try {
      final canonicalId = record.id;
      print('📥 Syncing todo: canonicalId=$canonicalId');
      // TODO: Implement local DB sync if needed
      // This would involve updating providers or local state
    } catch (e) {
      print('⚠️ Error syncing todo: $e');
    }
  }

  /// Create a new todo
  Future<TodoItemModel> createTodo({
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
    return executeRequest<TodoItemModel>(
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
      parser: (data) => TodoItemModel.fromJson(data),
    );
  }

  /// Get all todos
  Future<List<TodoItemModel>> getAllTodos({
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

    return executeListRequest<TodoItemModel>(
      request: () => dio.get(
        '/todos',
        queryParameters: queryParameters,
      ),
      itemParser: (json) => TodoItemModel.fromJson(json),
    );
  }

  /// Get a single todo by ID
  Future<TodoItemModel> getTodoById(String id) async {
    return executeRequest<TodoItemModel>(
      request: () => dio.get('/todos/$id'),
      parser: (data) => TodoItemModel.fromJson(data),
    );
  }

  /// Update an existing todo
  Future<TodoItemModel> updateTodo({
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

    return executeRequest<TodoItemModel>(
      request: () => dio.put('/todos/$id', data: data),
      parser: (data) => TodoItemModel.fromJson(data),
    );
  }

  /// Delete a todo
  Future<void> deleteTodo(String id) async {
    return executeVoidRequest(
      request: () => dio.delete('/todos/$id'),
    );
  }
}
