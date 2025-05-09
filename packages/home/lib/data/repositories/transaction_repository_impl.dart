import 'package:shared_lib/domain/entities/entites.dart';

import '../../domain/repositories/transaction_repository.dart';
import '../datasources/remote/transaction_api_service.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionApiService apiService;

  TransactionRepositoryImpl(this.apiService);

  @override
  Future<double> getFees(double amount) async {
    return await apiService.fetchFees(amount);
  }

  @override
  Future<List<User>> getRecipients() async {
    return await apiService.fetchRecipients();
  }

  @override
  Future<void> makeTransfer(
      String senderId, String recipientId, double amount) async {
    await apiService.sendTransfer(senderId, recipientId, amount);
  }
}
