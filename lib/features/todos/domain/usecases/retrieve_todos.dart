import '../../../../core/usecase/usecase.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class RetrieveTodosUseCase implements UseCase<List<TodoEntity>, NoParams> {
  final TodoRepository _todoRepository;

  RetrieveTodosUseCase({required TodoRepository todoRepository})
    : _todoRepository = todoRepository;

  @override
  Future<List<TodoEntity>> call({required NoParams params}) {
    return _todoRepository.retrieveTodos();
  }
}
