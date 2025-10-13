import '../../domain/entities/todo_entity.dart';

class TodoState {
  final Status status;
  final String errorMessage;
  final String successMessage;
  final List<TodoEntity> todos;

  const TodoState({
    this.status = Status.idle,
    this.errorMessage = '',
    this.successMessage = '',
    this.todos = const [],
  });

  TodoState copyWith({
    Status? status,
    String? errorMessage,
    String? successMessage,
    List<TodoEntity>? todos,
  }) {
    return TodoState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      todos: todos ?? this.todos,
    );
  }
}

enum Status {
  idle,
  adding,
  fetching,
  loading,
  success,
  error,
  updating,
  deleting,
}
