import '../entities/transfer.dart';
import '../repositories/transfer_repository.dart';

class MakeTransfer {
  final TransferRepository repository;

  MakeTransfer(this.repository);

  Future<void> execute(
      String senderId, String recipientId, double amount) async {
    final transfer = Transfer(
      senderId: senderId,
      recipientId: recipientId,
      amount: amount,
      timestamp: DateTime.now(),
    );

    await repository.makeTransfer(transfer);
  }
}
