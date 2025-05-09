import 'package:shared_lib/shared_lib.dart';

import '../repositories/user_repository.dart';

class FetchUserBalance {
  final UserRepository repository;

  FetchUserBalance(this.repository);

  Future<User> execute(String userId) async {
    return await repository.getUserBalance(userId);
  }
}
