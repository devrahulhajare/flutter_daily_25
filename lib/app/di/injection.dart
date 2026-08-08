import 'package:get_it/get_it.dart';

import '../../core/network/api_client.dart';
import '../../features/home/data/datasources/user_remote_datasource.dart';
import '../../features/home/data/repositories/user_repository_impl.dart';
import '../../features/home/domain/repositories/user_repository.dart';
import '../../features/home/domain/usecases/get_users_usecase.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  if (sl.isRegistered<ApiClient>()) return;

  // Core
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // Data
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl()),
  );

  // Domain
  sl.registerLazySingleton(() => GetUsersUseCase(sl()));

  // Presentation
  sl.registerFactory(() => HomeBloc(sl()));
}
