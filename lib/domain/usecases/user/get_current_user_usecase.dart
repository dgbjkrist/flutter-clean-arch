import '../../entities/user.dart';
import '../../repositories/user_repository.dart';

class GetCurrentUserUseCase {
  final UserRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<User?> execute() async {
    return await repository.getCurrentUser();
  }
}
