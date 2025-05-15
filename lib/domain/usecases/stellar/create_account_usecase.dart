import '../../entities/stellar_account.dart';
import '../../repositories/stellar_repository.dart';

class CreateStellarAccountUseCase {
  final StellarRepository repository;

  CreateStellarAccountUseCase(this.repository);

  Future<StellarAccount> execute() async {
    final account = await repository.createAccount();
    await repository.fundAccount(account.publicKey);
    return repository.getAccountDetails(account.publicKey);
  }
}
