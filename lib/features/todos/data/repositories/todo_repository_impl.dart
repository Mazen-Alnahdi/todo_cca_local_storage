import '../../domain/entities/todo_entity.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/local/app_database.dart';
import '../models/todo_model.dart';

class TodoRepositoryImplementation implements TodoRepository {
  final AppDatabase _appDatabase;

  TodoRepositoryImplementation({required AppDatabase appDatabase})
    : _appDatabase = appDatabase;

  @override
  Future<void> removeTodo(TodoEntity todo) {
    return _appDatabase.todoDao.deleteTodo(TodoModel.fromEntity(todo));
  }

  @override
  Future<List<TodoEntity>> retrieveTodos() {
    return _appDatabase.todoDao.getTodos();
  }

  @override
  Future<void> saveTodo(TodoEntity todo) {
    return _appDatabase.todoDao.insertTodo(TodoModel.fromEntity(todo));
  }

  @override
  Future<List<TodoEntity>> getCompletedTodos() {
    return _appDatabase.todoDao.getCompletedTodos();
  }

  @override
  Future<List<TodoEntity>> getUncompletedTodos() {
    return _appDatabase.todoDao.getUncompletedTodos();
  }

  @override
  Future<void> toggleTodoCompleted(String id) {
    return _appDatabase.todoDao.toggleTodoCompleted(id);
  }
}
