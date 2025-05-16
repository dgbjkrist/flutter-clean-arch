import '../../entities/stellar_account.dart';
import '../../repositories/stellar_repository.dart';

class GetAccountDetailsUseCase {
  final StellarRepository repository;

  GetAccountDetailsUseCase(this.repository);

  Future<StellarAccount> execute(String publicKey) async {
    return repository.getAccountDetails(publicKey);
  }
}
