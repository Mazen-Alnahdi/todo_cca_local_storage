import 'package:get_it/get_it.dart';
import 'package:todo_cca_local/features/todos/data/datasources/local/app_database.dart';
import 'package:todo_cca_local/features/todos/data/repositories/todo_repository_impl.dart';
import 'package:todo_cca_local/features/todos/domain/repositories/todo_repository.dart';
import 'package:todo_cca_local/features/todos/domain/usecases/get_completed_todos.dart';
import 'package:todo_cca_local/features/todos/domain/usecases/get_uncompleted_todos.dart';
import 'package:todo_cca_local/features/todos/domain/usecases/remove_todo.dart';
import 'package:todo_cca_local/features/todos/domain/usecases/retrieve_todos.dart';
import 'package:todo_cca_local/features/todos/domain/usecases/save_todo.dart';
import 'package:todo_cca_local/features/todos/presentation/provider/todo_notifier.dart';

import 'features/todos/domain/usecases/toggle_todo_completed.dart';

final GetIt sl = GetIt.instance;

Future<void> setUpDependencies() async {
  //DataSource
  sl.registerSingletonAsync<AppDatabase>(
    () => $FloorAppDatabase.databaseBuilder('app_database.db').build(),
  );

  //registers the DAO after the db is ready
  sl.registerSingletonWithDependencies(
    () => sl<AppDatabase>().todoDao,
    dependsOn: [AppDatabase],
  );

  //Repo
  sl.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImplementation(appDatabase: sl<AppDatabase>()),
  );

  //UseCases
  sl.registerLazySingleton<GetCompletedTodosUseCase>(
    () => GetCompletedTodosUseCase(todoRepository: sl()),
  );
  sl.registerLazySingleton<GetUncompletedTodosUseCase>(
    () => GetUncompletedTodosUseCase(todoRepository: sl()),
  );
  sl.registerLazySingleton<RemoveTodoUseCase>(
    () => RemoveTodoUseCase(todoRepository: sl()),
  );
  sl.registerLazySingleton<RetrieveTodosUseCase>(
    () => RetrieveTodosUseCase(todoRepository: sl()),
  );
  sl.registerLazySingleton<SaveTodoUseCase>(
    () => SaveTodoUseCase(todoRepository: sl()),
  );
  sl.registerLazySingleton<ToggleTodoCompletedUseCase>(
    () => ToggleTodoCompletedUseCase(todoRepository: sl()),
  );

  //Provider
  sl.registerFactory(
    () => TodoNotifier(
      getCompletedTodosUseCase: sl(),
      getUncompletedTodosUseCase: sl(),
      saveTodoUseCase: sl(),
      removeTodoUseCase: sl(),
      retrieveTodosUseCase: sl(),
      todoCompletedUseCase: sl(),
    ),
  );

  await sl.allReady();
}
