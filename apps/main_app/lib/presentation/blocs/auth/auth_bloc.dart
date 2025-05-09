import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/user.dart';
import '../../../domain/usecases/login_usecase.dart';
import '../../../domain/usecases/logout_usecase.dart';
import '../../../domain/usecases/register_usecase.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthBloc extends Cubit<AuthState> {
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc(this.registerUseCase, this.loginUseCase, this.logoutUseCase)
      : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await loginUseCase.execute(email, password);
      emit(AuthAuthenticated(user));
    } catch (e, st) {
      print("e ==== $e");
      print("st ==== $st");
      emit(AuthError("Erreur de connexion"));
    }
  }

  Future<void> register(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await registerUseCase.execute(email, password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError("Erreur d'inscription"));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    await logoutUseCase.execute();
    emit(AuthUnauthenticated());
  }
}
