import '../entities/user.dart';
import '../repositories/transaction_repository.dart';

class GetRecipientsUseCase {
  final TransactionRepository repository;

  GetRecipientsUseCase(this.repository);

  Future<List<User>> execute() async {
    return await repository.getRecipients();
  }
}
