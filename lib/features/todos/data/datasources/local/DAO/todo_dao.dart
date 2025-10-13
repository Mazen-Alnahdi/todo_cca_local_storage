import 'package:floor/floor.dart';

import '../../../models/todo_model.dart';

@dao
abstract class TodoDao {
  @Insert()
  Future<void> insertTodo(TodoModel todo);

  @delete
  Future<void> deleteTodo(TodoModel todo);

  @Query('SELECT * FROM todos')
  Future<List<TodoModel>> getTodos();

  @Query('SELECT * FROM todos WHERE isCompleted = 1')
  Future<List<TodoModel>> getCompletedTodos();

  @Query('SELECT * FROM todos WHERE isCompleted = 0')
  Future<List<TodoModel>> getUncompletedTodos();

  @Query(
    'UPDATE todos SET isCompleted = CASE WHEN isCompleted = 1 THEN 0 ELSE 1 END WHERE id = :id',
  )
  Future<void> toggleTodoCompleted(String id);
}
