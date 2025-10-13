import 'package:todo_cca_local/core/usecase/usecase.dart';
import 'package:todo_cca_local/features/todos/domain/entities/todo_entity.dart';
import 'package:todo_cca_local/features/todos/domain/repositories/todo_repository.dart';

class SaveTodoUseCase implements UseCase<void, TodoEntity> {
  final TodoRepository _todoRepository;

  SaveTodoUseCase({required TodoRepository todoRepository})
    : _todoRepository = todoRepository;

  @override
  Future<void> call({TodoEntity? params}) {
    return _todoRepository.saveTodo(params!);
  }
}
