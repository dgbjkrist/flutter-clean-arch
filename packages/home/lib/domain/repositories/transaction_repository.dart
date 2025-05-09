import 'package:shared_lib/shared_lib.dart';

abstract class TransactionRepository {
  Future<double> getFees(double amount);
  Future<List<User>> getRecipients();
  Future<void> makeTransfer(String senderId, String recipientId, double amount);
}
