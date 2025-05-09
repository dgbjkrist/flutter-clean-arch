import '../repositories/transaction_repository.dart';

class MakeTransferUseCase {
  final TransactionRepository repository;

  MakeTransferUseCase(this.repository);

  Future<void> execute(
      String senderId, String recipientId, double amount) async {
    //     final transfer = Transfer(
    //   senderId: senderId,
    //   recipientId: recipientId,
    //   amount: amount,
    //   timestamp: DateTime.now(),
    // );
    await repository.makeTransfer(senderId, recipientId, amount);
  }
}
