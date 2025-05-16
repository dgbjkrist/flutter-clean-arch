import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/stellar_repository.dart';
import '../datasources/local/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  final StellarRepository stellarRepository;

  AuthRepositoryImpl(this.localDataSource, this.stellarRepository);

  @override
  Future<User> register(String email, String password, String name) async {
    try {
      final stellarAccount = await stellarRepository.createAccount();
      await stellarRepository.fundAccount(stellarAccount.publicKey);

      final updatedUser = await localDataSource.saveUser(
          email: email,
          password: password,
          name: name,
          stellarAccount: stellarAccount);

      return updatedUser.toDomain();
    } catch (e) {
      throw AuthException('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final user = await localDataSource.getUser(email, password);

      if (user.stellarAccount != null) {
        final updatedStellarAccount = await stellarRepository.getAccountDetails(
          user.stellarAccount!.publicKey,
        );
        final updatedUser =
            user.copyWith(stellarAccount: updatedStellarAccount);
        await localDataSource.setCurrentUser(updatedUser);
        return updatedUser.toDomain();
      }

      await localDataSource.setCurrentUser(user);
      return user.toDomain();
    } catch (e) {
      throw AuthException('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    await localDataSource.logout();
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}
