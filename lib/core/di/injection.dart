import 'package:eisenhower_matrix/data/presentation/bloc/task_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../data/models/task.dart';
import '../../data/repositories/task_repository.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Repository
  getIt.registerLazySingleton<TaskRepository>(
    () => TaskRepository(Hive.box<Task>('tasks')),
  );

  // BLoC
  getIt.registerFactory<TaskBloc>(() => TaskBloc(getIt<TaskRepository>()));
}
