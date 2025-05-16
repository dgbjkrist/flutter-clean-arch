import 'package:dio/dio.dart';

import '../../../domain/entities/user.dart';

class TransactionApiService {
  final Dio dio;

  TransactionApiService(this.dio);

  Future<double> fetchFees(double amount) async {
    await Future.delayed(Duration(seconds: 1)); // Simulation d'un délai API
    return amount * 0.02; // Exemple : 2% de frais
  }

  Future<List<User>> fetchRecipients() async {
    await Future.delayed(Duration(seconds: 1));
    return [
      User(id: "1", email: "user1@mail.com", name: "User One"),
      User(id: "2", email: "user2@mail.com", name: "User Two"),
    ];
  }

  Future<void> sendTransfer(
      String senderId, String recipientId, double amount) async {
    // try {
    //   await dio.post(
    //     "https://api.example.com/transfer",
    //     data: transferData,
    //   );
    // } catch (e) {
    //   throw Exception("Échec du transfert : ${e.toString()}");
    // }
    await Future.delayed(Duration(seconds: 2)); // Simulation API
  }
}
