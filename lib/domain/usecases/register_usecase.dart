import '../repositories/auth_repository.dart';
import '../entities/user.dart';

class RegisterUseCase {
  final AuthRepository repository;
  RegisterUseCase(this.repository);

  Future<User> execute({
    required String email,
    required String password,
    required String name,
  }) async {
    return await repository.register(email, password, name);
  }
}
