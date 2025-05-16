import '../repositories/user_repository.dart';

class VerifyLockScreenUseCase {
  final UserRepository repository;

  VerifyLockScreenUseCase(this.repository);

  Future<bool> execute(String password) async {
    try {
      return await repository.verifyPassword(password);
    } catch (e) {
      return false;
    }
  }
}
