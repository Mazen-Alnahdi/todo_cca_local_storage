import 'package:todo_cca_local/core/usecase/usecase.dart';
import 'package:todo_cca_local/features/todos/domain/repositories/todo_repository.dart';

class ToggleTodoCompletedUseCase implements UseCase<void, String> {
  final TodoRepository _todoRepository;

  ToggleTodoCompletedUseCase({required TodoRepository todoRepository})
    : _todoRepository = todoRepository;

  @override
  Future<void> call({String? params}) {
    return _todoRepository.toggleTodoCompleted(params!);
  }
}
