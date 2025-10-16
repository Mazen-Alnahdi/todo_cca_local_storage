import '../../../../core/usecase/usecase.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class GetCompletedTodosUseCase implements UseCase<List<TodoEntity>, NoParams> {
  final TodoRepository _todoRepository;

  GetCompletedTodosUseCase({required TodoRepository todoRepository})
    : _todoRepository = todoRepository;

  @override
  Future<List<TodoEntity>> call({required NoParams params}) {
    return _todoRepository.getCompletedTodos();
  }
}
