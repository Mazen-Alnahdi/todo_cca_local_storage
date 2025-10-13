import '../entities/todo_entity.dart';

abstract class TodoRepository {
  Future<void> saveTodo(TodoEntity todo);

  Future<void> removeTodo(TodoEntity todo);

  Future<List<TodoEntity>> retrieveTodos();

  Future<List<TodoEntity>> getCompletedTodos();

  Future<List<TodoEntity>> getUncompletedTodos();
}
