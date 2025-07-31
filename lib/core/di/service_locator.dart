import 'package:cleanarchi/data/repositories/transaction_repository_impl.dart';
import 'package:cleanarchi/domain/repositories/user_repository.dart';
import 'package:cleanarchi/domain/usecases/calculate_fees_usecase.dart';
import 'package:cleanarchi/domain/usecases/get_recipients_usecase.dart';
import 'package:cleanarchi/domain/usecases/make_transfer_usecase.dart';
import 'package:cleanarchi/presentation/cubits/auth/auth_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/local/auth_local_data_source.dart';
import '../../data/datasources/remote/auth_api_service.dart';
import '../../data/datasources/remote/transaction_api_service.dart';
import '../../data/datasources/remote/user_api_service.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/usecases/user/get_current_user_usecase.dart';
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
import '../../domain/usecases/stellar/get_asset_balances_usecase.dart';
import '../../domain/usecases/stellar/get_account_details_usecase.dart';
import '../../domain/usecases/verify_lock_screen_usecase.dart';
import '../../presentation/cubits/auth/lock_screen_cubit.dart';
import '../../presentation/cubits/balance_cubit.dart';
import '../../presentation/cubits/recipients/recipients_bloc.dart';
import '../../presentation/cubits/stellar/stellar_cubit.dart';
import '../../presentation/cubits/transfer/fees_bloc.dart';
import '../../presentation/cubits/transfer/transfer_bloc.dart';
import '../../presentation/cubits/transfer_cubit.dart';
import '../../domain/usecases/stellar/get_xlm_to_usdc_rate_usecase.dart';
import '../../domain/usecases/stellar/get_secret_key_usecase.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  // External Dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // Local Data Sources
  sl.registerLazySingleton(() => AuthLocalDataSource(sl()));

  // Services API
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => AuthApiService(sl()));
  sl.registerLazySingleton(() => TransactionApiService(sl()));
  sl.registerLazySingleton(() => UserApiService(sl()));
  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl(), sl(), sl()),
  );
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<StellarRepository>(
    () => StellarRepositoryImpl(),
  );

  // Use Cases
  sl.registerLazySingleton(() => VerifyLockScreenUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => MakeTransferUseCase(sl()));
  sl.registerLazySingleton(() => GetRecipientsUseCase(sl()));
  sl.registerLazySingleton(() => CalculateFeesUseCase(sl()));

  // Stellar Use Cases
  sl.registerLazySingleton(() => CreateStellarAccountUseCase(sl()));
  sl.registerLazySingleton(() => SendStellarPaymentUseCase(sl()));
  sl.registerLazySingleton(() => GetTransactionHistoryUseCase(sl()));
  sl.registerLazySingleton(() => AddUSDCTrustlineUseCase(sl()));
  sl.registerLazySingleton(() => SwapXLMToUSDCUseCase(sl()));
  sl.registerLazySingleton(() => GetAssetBalancesUseCase(sl()));
  sl.registerLazySingleton(() => GetAccountDetailsUseCase(sl()));
  sl.registerLazySingleton(() => GetXLMToUSDCRateUseCase(sl()));
  sl.registerLazySingleton(() => GetSecretKeyUseCase(sl()));

  // Cubits & Blocs
  sl.registerLazySingleton(() => LockScreenCubit(sl()));
  sl.registerLazySingleton(() => AuthCubit(
        loginUseCase: sl(),
        registerUseCase: sl(),
        logoutUseCase: sl(),
        getCurrentUserUseCase: sl(),
      ));
  sl.registerLazySingleton(() => TransferBloc(sl()));
  sl.registerLazySingleton(() => FeesBloc(sl()));
  sl.registerLazySingleton(() => RecipientsBloc(sl()));
  sl.registerLazySingleton(() => BalanceCubit(sl(), sl()));
  sl.registerLazySingleton(() => TransferCubit());
  sl.registerLazySingleton(() => StellarCubit(
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
      ));
}
