import '../../entities/transaction_history.dart';
import '../../repositories/stellar_repository.dart';

class GetTransactionHistoryUseCase {
  final StellarRepository repository;

  GetTransactionHistoryUseCase(this.repository);

  Future<List<TransactionHistory>> execute(String publicKey) async {
    return await repository.getTransactionHistory(publicKey);
  }
}
