import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  User? _currentUser = User.empty(); // Simule un utilisateur connecté

  @override
  Future<User> register(String email, String password) async {
    await Future.delayed(Duration(seconds: 2)); // Simule un délai API
    _currentUser = _currentUser!.copyWith(id: "123", email: email);
    return _currentUser!;
  }

  @override
  Future<User> login(String email, String password) async {
    await Future.delayed(Duration(seconds: 2));
    _currentUser = _currentUser!.copyWith(id: "123", email: email);
    return _currentUser!;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(Duration(seconds: 1));
    _currentUser = null;
  }
}
