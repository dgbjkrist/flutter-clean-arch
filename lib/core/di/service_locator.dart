import 'package:get_it/get_it.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';

final sl = GetIt.instance;

void setupLocator() {
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());

  sl.registerFactory(() => RegisterUseCase(sl<AuthRepository>()));
  sl.registerFactory(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerFactory(() => LogoutUseCase(sl<AuthRepository>()));

  sl.registerFactory(() => AuthBloc(sl(), sl(), sl()));
}
