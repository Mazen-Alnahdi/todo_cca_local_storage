import 'package:todo_cca_local/features/todos/domain/entities/todo_entity.dart';
import 'package:todo_cca_local/features/todos/domain/repositories/todo_repository.dart';

import '../../../../core/errors/exceptions.dart';
import '../datasources/local/app_database.dart';
import '../datasources/remote/todo_remote_data_source.dart';
import '../models/todo_model.dart';

/// The concrete implementation of the [TodoRepository].
///
/// This class acts as the single source of truth for all Todo-related data.
/// It is responsible for coordinating data between the remote and local data sources.
class TodoRepositoryImplementation implements TodoRepository {
  final AppDatabase _appDatabase;
  final TodoRemoteDataSource _remoteDataSource;

  TodoRepositoryImplementation({
    required AppDatabase appDatabase,
    required TodoRemoteDataSource remoteDataSource,
  }) : _appDatabase = appDatabase,
       _remoteDataSource = remoteDataSource;

  /// Retrieves all todos.
  ///
  /// This implementation follows a "network-first, then cache" strategy.
  /// 1. It attempts to fetch the latest list from the remote source.
  /// 2. If successful, it clears the local cache and replaces it with the fresh data.
  /// 3. If the remote fetch fails (e.g., no internet), it falls back to returning
  ///    data from the local cache, ensuring offline availability.
  @override
  Future<List<TodoEntity>> retrieveTodos() async {
    try {
      final remoteTodos = await _remoteDataSource.retrieveTodos();
      // Clear local cache to remove any stale or deleted items.
      final dao = _appDatabase.todoDao;
      final localTodos = await dao.getTodos();
      for (final todo in localTodos) {
        await dao.deleteTodo(todo);
      }
      // Cache the fresh todos from the remote source.
      for (final todo in remoteTodos) {
        await dao.insertTodo(todo);
      }
      return remoteTodos;
    } on ServerException {
      // If the remote call fails, fall back to the local database.
      return await _appDatabase.todoDao.getTodos();
    }
  }

  /// Saves a new todo.
  ///
  /// It first saves the todo to the remote source. If that operation succeeds,
  /// it saves the todo to the local database.
  @override
  Future<void> saveTodo(TodoEntity todo) async {
    try {
      await _remoteDataSource.saveTodo(todo);
      await _appDatabase.todoDao.insertTodo(TodoModel.fromEntity(todo));
    } on ServerException {
      // Re-throw to be handled by the presentation layer.
      rethrow;
    }
  }

  /// Removes a todo.
  ///
  /// It first attempts to delete the todo from the remote source. If successful,
  /// it then removes the corresponding todo from the local database.
  @override
  Future<void> removeTodo(TodoEntity todo) async {
    try {
      await _remoteDataSource.removeTodo(todo);
      await _appDatabase.todoDao.deleteTodo(TodoModel.fromEntity(todo));
    } on ServerException {
      rethrow;
    }
  }

  /// Toggles the completion status of a todo.
  ///
  /// It first updates the status on the remote server and then applies the
  /// same change to the local database.
  @override
  Future<void> toggleTodoCompleted(String id) async {
    try {
      await _remoteDataSource.toggleTodoCompleted(id);
      await _appDatabase.todoDao.toggleTodoCompleted(id);
    } on ServerException {
      rethrow;
    }
  }

  /// Retrieves only the completed todos from the local database.
  /// This operation reads directly from the cache for speed.
  @override
  Future<List<TodoEntity>> getCompletedTodos() {
    return _appDatabase.todoDao.getCompletedTodos();
  }

  /// Retrieves only the uncompleted todos from the local database.
  /// This operation reads directly from the cache for speed.
  @override
  Future<List<TodoEntity>> getUncompletedTodos() {
    return _appDatabase.todoDao.getUncompletedTodos();
  }
}
