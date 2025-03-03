import '../repositories/transaction_repository.dart';

class CalculateFeesUseCase {
  final TransactionRepository repository;

  CalculateFeesUseCase(this.repository);

  Future<double> execute(double amount) async {
    return await repository.getFees(amount);
  }
}
