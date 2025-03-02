import 'package:dio/dio.dart';

class TransferApiService {
  final Dio dio;

  TransferApiService(this.dio);

  Future<void> makeTransfer(Map<String, dynamic> transferData) async {
    try {
      await dio.post(
        "https://api.example.com/transfer",
        data: transferData,
      );
    } catch (e) {
      throw Exception("Échec du transfert : ${e.toString()}");
    }
  }
}
