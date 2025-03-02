import '../repositories/user_repository.dart';
import '../entities/user.dart';

class FetchUserBalance {
  final UserRepository repository;

  FetchUserBalance(this.repository);

  Future<User> execute(String userId) async {
    return await repository.getUserBalance(userId);
  }
}
