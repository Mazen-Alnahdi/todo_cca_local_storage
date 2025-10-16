import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:todo_cca_local/features/todos/data/models/todo_model.dart';
import 'package:todo_cca_local/features/todos/domain/entities/todo_entity.dart';

import '../../../../../core/errors/exceptions.dart';

abstract class TodoRemoteDataSource {
  Future<List<TodoModel>> retrieveTodos();
  Future<void> saveTodo(TodoEntity todo);
  Future<void> removeTodo(TodoEntity todo);
  Future<void> toggleTodoCompleted(String id);
}

class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  final http.Client client;
  final String pantryId;

  TodoRemoteDataSourceImpl({required this.client, required this.pantryId});

  Uri get _uri => Uri.parse(
    'https://getpantry.cloud/apiv1/pantry/$pantryId/basket/todo_cca',
  );

  @override
  Future<List<TodoModel>> retrieveTodos() async {
    try {
      final response = await client.get(_uri);

      if (response.statusCode == 200) {
        // Handle cases where the basket might be empty and return an empty object
        if (response.body.isEmpty || response.body == '{}') {
          return [];
        }

        // The API returns a map {'todos': [...]}, not a direct list.
        final Map<String, dynamic> data = json.decode(response.body);

        // Safely access the 'todos' list, defaulting to an empty list if not found.
        final List<dynamic> todoListJson =
            data['todos'] as List<dynamic>? ?? [];

        return todoListJson
            .map((json) => TodoModel.fromMap(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          'Failed to retrieve todos. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw ServerException('Error connecting to the remote source: $e');
    }
  }

  // Helper method to update the entire basket on pantry.
  Future<void> _updateRemoteTodos(List<TodoModel> todos) async {
    try {
      // We must send back the data in the format {'todos': [...]}
      final body = json.encode({
        'todos': todos.map((todo) => todo.toMap()).toList(),
      });

      final response = await client.post(
        _uri,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode != 200) {
        throw ServerException(
          'Failed to update remote todos. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw ServerException('Error updating remote source: $e');
    }
  }

  @override
  Future<void> saveTodo(TodoEntity todo) async {
    final todos = await retrieveTodos();
    todos.add(TodoModel.fromEntity(todo));
    await _updateRemoteTodos(todos);
  }

  @override
  Future<void> removeTodo(TodoEntity todo) async {
    final todos = await retrieveTodos();
    todos.removeWhere((t) => t.id == todo.id);
    await _updateRemoteTodos(todos);
  }

  @override
  Future<void> toggleTodoCompleted(String id) async {
    final todos = await retrieveTodos();
    final index = todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      final todo = todos[index];
      todos[index] = todo.copyWith(isCompleted: !todo.isCompleted);
      await _updateRemoteTodos(todos);
    }
  }
}
