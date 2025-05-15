import '../../domain/repositories/user_repository.dart';
import '../../domain/entities/user.dart';
import '../datasources/remote/user_api_service.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserApiService apiService;

  UserRepositoryImpl(this.apiService);

  @override
  Future<User> getUserBalance(String userId) async {
    final userModel = await apiService.fetchUserBalance(userId);
    return UserModel.fromJson(userModel).toDomain();
  }

  @override
  Future<void> updateBalance(String userId, double newBalance) async {
    await apiService.updateUserBalance(userId, newBalance);
  }
}
