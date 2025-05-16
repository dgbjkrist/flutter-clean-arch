import '../../repositories/stellar_repository.dart';

class GetAssetBalancesUseCase {
  final StellarRepository repository;

  GetAssetBalancesUseCase(this.repository);

  Future<Map<String, double>> execute(String publicKey) async {
    return repository.getAssetBalances(publicKey);
  }
}
