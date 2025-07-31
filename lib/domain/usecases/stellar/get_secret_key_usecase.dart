import '../../repositories/user_repository.dart';

class GetSecretKeyUseCase {
  final UserRepository _userRepository;

  GetSecretKeyUseCase(this._userRepository);

  Future<String?> execute() async {
    final secretKey = await _userRepository.getSecretKey();
    print('currentUser: ${secretKey}');

    return secretKey;
  }
}
