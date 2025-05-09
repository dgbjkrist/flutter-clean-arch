import '../entities/user.dart';

abstract class UserRepository {
  Future<User> getUserBalance(String userId);
  Future<void> updateBalance(String userId, double newBalance);
}
