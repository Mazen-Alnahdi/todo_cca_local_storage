import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:todo_cca_local/features/todos/data/datasources/local/app_database.dart';
import 'package:todo_cca_local/features/todos/data/repositories/todo_repository_impl.dart';
import 'package:todo_cca_local/features/todos/domain/repositories/todo_repository.dart';
import 'package:todo_cca_local/features/todos/domain/usecases/get_completed_todos.dart';
import 'package:todo_cca_local/features/todos/domain/usecases/get_uncompleted_todos.dart';
import 'package:todo_cca_local/features/todos/domain/usecases/remove_todo.dart';
import 'package:todo_cca_local/features/todos/domain/usecases/retrieve_todos.dart';
import 'package:todo_cca_local/features/todos/domain/usecases/save_todo.dart';

import '../features/todos/domain/usecases/toggle_todo_completed.dart';
import 'features/todos/data/datasources/remote/todo_remote_data_source.dart';
import 'features/todos/presentation/provider/todo_notifier.dart';

final GetIt sl = GetIt.instance;

Future<void> setUpDependencies() async {
  // External
  sl.registerLazySingleton(() => http.Client());

  // DataSources
  sl.registerSingletonAsync<AppDatabase>(
    () => $FloorAppDatabase.databaseBuilder('app_database.db').build(),
  );

  // You will need to replace 'YOUR_PANTRY_ID' with your actual ID from getpantry.io
  sl.registerLazySingleton<TodoRemoteDataSource>(
    () => TodoRemoteDataSourceImpl(
      client: sl(),
      // vvvvvvvvvvvv THIS IS THE LINE TO FIX vvvvvvvvvvvv
      pantryId:
          '48a9aeb1-a420-48d6-a241-57223bd81706', // <-- Go to getpantry.io, get your ID, and paste it here.
      // ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    ),
  );

  // DAO (depends on AppDatabase being ready)
  sl.registerSingletonWithDependencies(
    () => sl<AppDatabase>().todoDao,
    dependsOn: [AppDatabase],
  );

  // Repository
  sl.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImplementation(
      appDatabase: sl<AppDatabase>(),
      remoteDataSource: sl<TodoRemoteDataSource>(),
    ),
  );

  // UseCases
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

  // Notifier
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

  // Ensure all asynchronous singletons are ready before the app starts.
  await sl.allReady();
}
