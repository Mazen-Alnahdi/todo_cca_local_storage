import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/todo_entity.dart';
import '../provider/todo_notifier.dart';
import '../provider/todo_state.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

enum TodoFilter { all, completed, uncompleted }

class _TodoPageState extends State<TodoPage> {
  TodoFilter _filter = TodoFilter.all;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = Provider.of<TodoNotifier>(context, listen: false);
      notifier.retrieveTodos();
    });
  }

  void _filterTodos(TodoFilter filter, TodoNotifier notifier) {
    setState(() {
      _filter = filter;
    });
    switch (filter) {
      case TodoFilter.all:
        notifier.retrieveTodos();
        break;
      case TodoFilter.completed:
        notifier.getCompletedTodos();
        break;
      case TodoFilter.uncompleted:
        notifier.getUncompletedTodos();
        break;
    }
  }

  Future<void> _showAddTodoDialog(TodoNotifier notifier) async {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    bool isSaving = false;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Add Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: bodyController,
                decoration: const InputDecoration(labelText: 'Body'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isSaving ? null : () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isSaving
                  ? null
                  : () async {
                      setStateDialog(() => isSaving = true);
                      final newTodo = TodoEntity(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: titleController.text.trim(),
                        body: bodyController.text.trim(),
                        isCompleted: false,
                      );
                      await notifier.saveTodo(newTodo);
                      _filterTodos(
                        _filter,
                        notifier,
                      ); // Refresh with current filter
                      Navigator.of(context).pop();
                    },
              child: isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoNotifier>(
      builder: (context, notifier, _) {
        final state = notifier.state;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Todo List'),
            actions: [
              PopupMenuButton<TodoFilter>(
                initialValue: _filter,
                onSelected: (filter) => _filterTodos(filter, notifier),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: TodoFilter.all,
                    child: Text('All'),
                  ),
                  const PopupMenuItem(
                    value: TodoFilter.completed,
                    child: Text('Completed'),
                  ),
                  const PopupMenuItem(
                    value: TodoFilter.uncompleted,
                    child: Text('Not Completed'),
                  ),
                ],
              ),
            ],
          ),
          body: Builder(
            builder: (context) {
              if (state.status == Status.fetching ||
                  state.status == Status.adding ||
                  state.status == Status.deleting ||
                  state.status == Status.updating) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.errorMessage.isNotEmpty) {
                return Center(child: Text(state.errorMessage));
              }
              final todos = state.todos ?? [];
              if (todos.isEmpty) {
                return const Center(child: Text('No todos found.'));
              }
              return ListView.separated(
                itemCount: todos.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return ListTile(
                    title: Text(
                      todo.title,
                      style: TextStyle(
                        decoration: todo.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text(todo.body),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await notifier.removeTodo(todo);
                        _filterTodos(_filter, notifier);
                      },
                    ),
                    leading: Checkbox(
                      value: todo.isCompleted,
                      onChanged: (_) async {
                        await notifier.toggleTodoCompleted(todo.id);
                        _filterTodos(_filter, notifier);
                      },
                    ),
                  );
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddTodoDialog(notifier),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
