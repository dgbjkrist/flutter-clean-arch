import 'package:cleanarchi/data/repositories/transaction_repository_impl.dart';
import 'package:cleanarchi/domain/repositories/user_repository.dart';
import 'package:cleanarchi/domain/usecases/calculate_fees_usecase.dart';
import 'package:cleanarchi/domain/usecases/get_recipients_usecase.dart';
import 'package:cleanarchi/domain/usecases/make_transfer_usecase.dart';
import 'package:cleanarchi/presentation/cubits/auth/auth_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../data/datasources/remote/auth_api_service.dart';
import '../../data/datasources/remote/transaction_api_service.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/stellar/add_trustline_usecase.dart';
import '../../domain/repositories/stellar_repository.dart';
import '../../data/repositories/stellar_repository_impl.dart';
import '../../domain/usecases/stellar/create_account_usecase.dart';
import '../../domain/usecases/stellar/send_payment_usecase.dart';
import '../../domain/usecases/stellar/get_transaction_history_usecase.dart';
import '../../domain/usecases/stellar/swap_xlm_to_usdc_usecase.dart';
import '../../presentation/cubits/balance_cubit.dart';
import '../../presentation/cubits/recipients/recipients_bloc.dart';
import '../../presentation/cubits/stellar/stellar_cubit.dart';
import '../../presentation/cubits/transfer/fees_bloc.dart';
import '../../presentation/cubits/transfer/transfer_bloc.dart';
import '../../presentation/cubits/transfer_cubit.dart';

final sl = GetIt.instance;

void setupLocator() {
  // Services API
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => AuthApiService(sl()));
  sl.registerLazySingleton(() => TransactionApiService(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sl()));
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
  sl.registerLazySingleton(() => AuthCubit(sl(), sl(), sl()));
  sl.registerLazySingleton(() => FeesBloc(sl()));
  sl.registerLazySingleton(() => RecipientsBloc(sl()));

  // 📌 Cubits
  sl.registerLazySingleton(() => BalanceCubit(sl(), sl()));
  sl.registerLazySingleton(() => TransferCubit());
  sl.registerLazySingleton(() => StellarCubit(
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
      ));

  // Stellar
  sl.registerLazySingleton<StellarRepository>(() => StellarRepositoryImpl());
  sl.registerLazySingleton(() => CreateStellarAccountUseCase(sl()));
  sl.registerLazySingleton(() => SendStellarPaymentUseCase(sl()));
  sl.registerLazySingleton(() => GetTransactionHistoryUseCase(sl()));
  sl.registerLazySingleton(() => AddUSDCTrustlineUseCase(sl()));
  sl.registerLazySingleton(() => SwapXLMToUSDCUseCase(sl()));
}
