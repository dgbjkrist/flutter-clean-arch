import '../../domain/repositories/stellar_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/entities/user.dart';
import '../datasources/remote/user_api_service.dart';
import '../models/user_model.dart';
import '../datasources/local/auth_local_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserApiService apiService;
  final AuthLocalDataSource localDataSource;
  final StellarRepository stellarRepository;

  UserRepositoryImpl(
      this.apiService, this.localDataSource, this.stellarRepository);

  @override
  Future<bool> verifyPassword(String password) async {
    final userModel = await localDataSource.getCurrentUser();
    print("userModel ==== ${userModel.toString()}");
    return userModel?.password == password;
  }

  @override
  Future<User> getUserBalance(String userId) async {
    final userModel = await apiService.fetchUserBalance(userId);
    return UserModel.fromJson(userModel).toDomain();
  }

  @override
  Future<void> updateBalance(String userId, double newBalance) async {
    await apiService.updateUserBalance(userId, newBalance);
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final userModel = await localDataSource.getCurrentUser();
      if (userModel == null) return null;

      if (userModel.stellarAccount != null) {
        final updatedStellarAccount = await stellarRepository.getAccountDetails(
          userModel.stellarAccount!.publicKey,
        );
        return userModel
            .copyWith(stellarAccount: updatedStellarAccount)
            .toDomain();
      }

      return userModel.toDomain();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> getSecretKey() async {
    final userModel = await localDataSource.getCurrentUser();
    return userModel?.stellarAccount?.secretKey;
  }
}
