import '../entities/user.dart';

abstract class UserRepository {
  Future<bool> verifyPassword(String password);
  Future<User?> getCurrentUser();
  Future<User> getUserBalance(String userId);
  Future<void> updateBalance(String userId, double newBalance);
}
