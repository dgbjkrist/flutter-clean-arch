import '../../domain/repositories/user_repository.dart';
import '../../domain/entities/user.dart';
import '../datasources/remote/user_api_service.dart';

class UserRepositoryImpl implements UserRepository {
  final UserApiService apiService;

  UserRepositoryImpl(this.apiService);

  @override
  Future<User> getUserBalance(String userId) async {
    final data = await apiService.fetchUserBalance(userId);
    return User(
        id: userId,
        name: data['name'],
        balance: data['balance'],
        email: data['email']);
  }

  @override
  Future<void> updateBalance(String userId, double newBalance) async {
    await apiService.updateUserBalance(userId, newBalance);
  }
}
