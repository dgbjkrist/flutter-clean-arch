import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../data/datasources/remote/auth_api_service.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../presentation/cubits/auth_cubit.dart';

final sl = GetIt.instance;

void setupLocator() {
  // Services API
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => AuthApiService(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());

  // 📌 Use Cases
  sl.registerLazySingleton(() => RegisterUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LogoutUseCase(sl<AuthRepository>()));

  // 📌 Blocs / Cubits
  sl.registerLazySingleton(() => AuthCubit(sl(), sl(), sl()));
}
