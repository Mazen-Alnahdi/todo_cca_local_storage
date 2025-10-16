import 'package:flutter/material.dart';
import 'package:todo_cca_local/core/usecase/usecase.dart';
import 'package:todo_cca_local/features/todos/domain/usecases/get_completed_todos.dart';
import 'package:todo_cca_local/features/todos/domain/usecases/get_uncompleted_todos.dart';
import 'package:todo_cca_local/features/todos/domain/usecases/remove_todo.dart';
import 'package:todo_cca_local/features/todos/domain/usecases/retrieve_todos.dart';
import 'package:todo_cca_local/features/todos/domain/usecases/save_todo.dart';
import 'package:todo_cca_local/features/todos/domain/usecases/toggle_todo_completed.dart';

import '../../domain/entities/todo_entity.dart';
import 'todo_state.dart';

class TodoNotifier extends ChangeNotifier {
  final GetCompletedTodosUseCase getCompletedTodosUseCase;
  final GetUncompletedTodosUseCase getUncompletedTodosUseCase;
  final SaveTodoUseCase saveTodoUseCase;
  final RemoveTodoUseCase removeTodoUseCase;
  final RetrieveTodosUseCase retrieveTodosUseCase;
  final ToggleTodoCompletedUseCase todoCompletedUseCase;

  TodoNotifier({
    required this.getCompletedTodosUseCase,
    required this.getUncompletedTodosUseCase,
    required this.saveTodoUseCase,
    required this.removeTodoUseCase,
    required this.retrieveTodosUseCase,
    required this.todoCompletedUseCase,
  });

  TodoState _state = const TodoState();

  TodoState get state => _state;

  void _setState(TodoState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> retrieveTodos() async {
    _setState(
      state.copyWith(
        status: Status.fetching,
        errorMessage: '',
        successMessage: '',
      ),
    );
    try {
      final todos = await retrieveTodosUseCase(params: NoParams());
      _setState(
        state.copyWith(
          status: Status.success,
          successMessage: "Successfully Retrieved All",
          todos: todos,
        ),
      );
    } catch (e) {
      _setState(
        state.copyWith(status: Status.error, errorMessage: e.toString()),
      );
    }
    _setState(state.copyWith(status: Status.idle));
  }

  Future<void> getCompletedTodos() async {
    _setState(
      state.copyWith(
        status: Status.fetching,
        errorMessage: '',
        successMessage: '',
      ),
    );
    try {
      final todos = await getCompletedTodosUseCase(params: NoParams());
      _setState(
        state.copyWith(
          status: Status.success,
          successMessage: "Successfully Retrieved Completed",
          todos: todos,
        ),
      );
    } catch (e) {
      _setState(
        state.copyWith(status: Status.error, errorMessage: e.toString()),
      );
    }
    _setState(state.copyWith(status: Status.idle));
  }

  Future<void> getUncompletedTodos() async {
    _setState(
      state.copyWith(
        status: Status.fetching,
        errorMessage: '',
        successMessage: '',
      ),
    );
    try {
      final todos = await getUncompletedTodosUseCase(params: NoParams());
      _setState(
        state.copyWith(
          status: Status.success,
          successMessage: "Successfully Retrieved Uncompleted",
          todos: todos,
        ),
      );
    } catch (e) {
      _setState(
        state.copyWith(status: Status.error, errorMessage: e.toString()),
      );
    }
    _setState(state.copyWith(status: Status.idle));
  }

  Future<void> saveTodo(TodoEntity entity) async {
    _setState(
      state.copyWith(
        status: Status.adding,
        errorMessage: '',
        successMessage: '',
      ),
    );
    try {
      await saveTodoUseCase(params: entity);
      _setState(
        state.copyWith(
          status: Status.success,
          successMessage: "Successfully Saved",
        ),
      );
      // Refresh the list to show the new todo.
      await retrieveTodos();
    } catch (e) {
      _setState(
        state.copyWith(status: Status.error, errorMessage: e.toString()),
      );
    }
    _setState(state.copyWith(status: Status.idle));
  }

  Future<void> removeTodo(TodoEntity entity) async {
    _setState(
      state.copyWith(
        status: Status.deleting,
        errorMessage: '',
        successMessage: '',
      ),
    );
    try {
      await removeTodoUseCase(params: entity);
      _setState(
        state.copyWith(
          status: Status.success,
          successMessage: "Successfully Removed",
        ),
      );
      // Refresh the list to reflect the deletion.
      await retrieveTodos();
    } catch (e) {
      _setState(
        state.copyWith(status: Status.error, errorMessage: e.toString()),
      );
    }
    _setState(state.copyWith(status: Status.idle));
  }

  Future<void> toggleTodoCompleted(String id) async {
    _setState(
      state.copyWith(
        status: Status.updating,
        errorMessage: '',
        successMessage: '',
      ),
    );
    try {
      await todoCompletedUseCase(params: id);
      _setState(
        state.copyWith(
          status: Status.success,
          successMessage: "Successfully Updated",
        ),
      );
      // Refresh the list to show the updated status.
      await retrieveTodos();
    } catch (e) {
      _setState(
        state.copyWith(status: Status.error, errorMessage: e.toString()),
      );
    }
    _setState(state.copyWith(status: Status.idle));
  }
}
