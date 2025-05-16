import '../repositories/auth_repository.dart';
import '../entities/user.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<User> execute({
    required String email,
    required String password,
  }) async {
    return await repository.login(email, password);
  }
}
