import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../data/datasources/remote/transaction_api_service.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../presentation/blocs/transfer/fees_bloc.dart';
import '../../presentation/blocs/transfer/transfer_bloc.dart';
import '../../presentation/blocs/transfer_cubit.dart';

final sl = GetIt.instance;

void setupLocator() {
  // Services API
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => TransactionApiService(sl()));

  // Repository
  sl.registerLazySingleton<TransactionRepository>(
      () => TransactionRepositoryImpl(sl()));

  // 📌 Use Cases
  sl.registerLazySingleton(() => MakeTransferUseCase(sl()));
  sl.registerLazySingleton(() => GetRecipientsUseCase(sl()));
  sl.registerLazySingleton(() => CalculateFeesUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LogoutUseCase(sl<AuthRepository>()));

  // 📌 Blocs / Cubits
  sl.registerLazySingleton(() => TransferBloc(sl()));
  sl.registerLazySingleton(() => AuthBloc(sl(), sl(), sl()));
  sl.registerLazySingleton(() => FeesBloc(sl()));
  sl.registerLazySingleton(() => RecipientsBloc(sl()));

  // 📌 Cubits
  sl.registerLazySingleton(() => BalanceCubit(sl(), sl()));
  sl.registerLazySingleton(() => TransferCubit());
}
