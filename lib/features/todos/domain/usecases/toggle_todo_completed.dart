import '../../../../core/usecase/usecase.dart';
import '../repositories/todo_repository.dart';

class ToggleTodoCompletedUseCase implements UseCase<void, String> {
  final TodoRepository _todoRepository;

  ToggleTodoCompletedUseCase({required TodoRepository todoRepository})
    : _todoRepository = todoRepository;

  @override
  Future<void> call({required String params}) {
    return _todoRepository.toggleTodoCompleted(params);
  }
}
