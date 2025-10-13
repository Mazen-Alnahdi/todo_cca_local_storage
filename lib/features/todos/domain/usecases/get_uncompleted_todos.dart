import 'package:todo_cca_local/core/usecase/usecase.dart';
import 'package:todo_cca_local/features/todos/domain/entities/todo_entity.dart';
import 'package:todo_cca_local/features/todos/domain/repositories/todo_repository.dart';

class GetUncompletedTodosUseCase implements UseCase<List<TodoEntity>, void> {
  final TodoRepository _todoRepository;

  GetUncompletedTodosUseCase({required TodoRepository todoRepository})
    : _todoRepository = todoRepository;

  @override
  Future<List<TodoEntity>> call({void params}) {
    return _todoRepository.getUncompletedTodos();
  }
}
