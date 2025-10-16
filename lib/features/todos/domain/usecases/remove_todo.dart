import '../../../../core/usecase/usecase.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class RemoveTodoUseCase implements UseCase<void, TodoEntity> {
  final TodoRepository _todoRepository;

  RemoveTodoUseCase({required TodoRepository todoRepository})
    : _todoRepository = todoRepository;

  @override
  Future<void> call({required TodoEntity params}) {
    return _todoRepository.removeTodo(params);
  }
}
