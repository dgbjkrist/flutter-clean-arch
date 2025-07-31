import '../../repositories/stellar_repository.dart';

class SwapXLMToUSDCUseCase {
  final StellarRepository _repository;
  static const USDC_ISSUER =
      'GBBD47IF6LWK7P7MDEVSCWR7DPUWV3NY3DTQEVFL4NAT4AQH3ZLLFLA5';
  static const USDC_CODE = 'USDC';

  SwapXLMToUSDCUseCase(this._repository);

  Future<void> execute({
    required String secretKey,
    required double xlmAmount,
    required double expectedUsdcAmount,
  }) async {
    return await _repository.swapXLMToUSDC(
      secretKey: secretKey,
      xlmAmount: xlmAmount,
      expectedUsdcAmount: expectedUsdcAmount,
    );
  }
}
