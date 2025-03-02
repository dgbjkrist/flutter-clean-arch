import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../data/datasources/remote/auth_api_service.dart';
import '../../data/datasources/remote/transfer_api_service.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/transfer_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/transfer_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/transfer/transfer_bloc.dart';

final sl = GetIt.instance;

void setupLocator() {
  // Services API
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => AuthApiService(sl()));
  sl.registerLazySingleton(() => TransferApiService(sl()));

  // Repository
  sl.registerLazySingleton<TransferRepository>(
      () => TransferRepositoryImpl(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());

  // API Service
  sl.registerLazySingleton(() => TransferApiService(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LogoutUseCase(sl<AuthRepository>()));

  // Bloc
  sl.registerLazySingleton(() => TransferBloc(sl()));
  sl.registerLazySingleton(() => AuthBloc(sl(), sl(), sl()));
}
