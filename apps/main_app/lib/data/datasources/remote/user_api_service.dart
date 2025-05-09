import 'package:dio/dio.dart';

class UserApiService {
  final Dio dio;

  UserApiService(this.dio);

  Future<Map<String, dynamic>> fetchUserBalance(String userId) async {
    final response = await dio.get('/user/$userId/balance');
    return response.data;
  }

  Future<void> updateUserBalance(String userId, double newBalance) async {
    await dio
        .post('/user/$userId/update_balance', data: {"balance": newBalance});
  }
}
