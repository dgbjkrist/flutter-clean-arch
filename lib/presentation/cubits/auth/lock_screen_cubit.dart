import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/verify_lock_screen_usecase.dart';

abstract class LockScreenState {}

class LockScreenInitial extends LockScreenState {}

class LockScreenLoading extends LockScreenState {}

class LockScreenUnlocked extends LockScreenState {}

class LockScreenError extends LockScreenState {
  final String message;
  LockScreenError(this.message);
}

class LockScreenCubit extends Cubit<LockScreenState> {
  final VerifyLockScreenUseCase _verifyLockScreenUseCase;

  LockScreenCubit(this._verifyLockScreenUseCase) : super(LockScreenInitial());

  Future<bool> verifyPassword(String password) async {
    emit(LockScreenLoading());
    try {
      final isValid = await _verifyLockScreenUseCase.execute(password);
      if (isValid) {
        emit(LockScreenUnlocked());
      } else {
        emit(LockScreenError('Invalid password'));
      }
      return isValid;
    } catch (e) {
      emit(LockScreenError(e.toString()));
      return false;
    }
  }
}
