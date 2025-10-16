import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/todos/presentation/pages/todo_page.dart';
import 'features/todos/presentation/provider/todo_notifier.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpDependencies(); // Ensure dependencies are set up before running app

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoNotifier>(
      create: (_) => sl<TodoNotifier>(),
      child: MaterialApp(
        title: 'Todo App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const TodoPage(),
      ),
    );
  }
}
