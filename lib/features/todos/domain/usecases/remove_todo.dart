import 'package:todo_cca_local/features/todos/domain/repositories/todo_repository.dart';

import '../entities/todo_entity.dart';

class RemoveTodoUseCase {
  final TodoRepository _todoRepository;

  RemoveTodoUseCase({required TodoRepository todoRepository})
    : _todoRepository = todoRepository;

  Future<void> call({TodoEntity? params}) {
    return _todoRepository.removeTodo(params!);
  }
}
