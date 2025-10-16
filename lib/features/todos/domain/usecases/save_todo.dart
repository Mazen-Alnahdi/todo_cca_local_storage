import '../../../../core/usecase/usecase.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class SaveTodoUseCase implements UseCase<void, TodoEntity> {
  final TodoRepository _todoRepository;

  SaveTodoUseCase({required TodoRepository todoRepository})
    : _todoRepository = todoRepository;

  @override
  Future<void> call({required TodoEntity params}) {
    return _todoRepository.saveTodo(params);
  }
}
