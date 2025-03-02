import '../entities/transfer.dart';

abstract class TransferRepository {
  Future<void> makeTransfer(Transfer transfer);
}
