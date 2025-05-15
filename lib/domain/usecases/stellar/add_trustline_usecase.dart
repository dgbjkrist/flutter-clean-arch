import '../../repositories/stellar_repository.dart';

class AddUSDCTrustlineUseCase {
  final StellarRepository repository;
  static const USDC_ISSUER =
      'GBBD47IF6LWK7P7MDEVSCWR7DPUWV3NY3DTQEVFL4NAT4AQH3ZLLFLA5';
  static const USDC_CODE = 'USDC';

  AddUSDCTrustlineUseCase(this.repository);

  Future<void> execute(String secretKey) async {
    return repository.addTrustline(
      secretKey: secretKey,
      assetCode: USDC_CODE,
      issuer: USDC_ISSUER,
    );
  }
}
