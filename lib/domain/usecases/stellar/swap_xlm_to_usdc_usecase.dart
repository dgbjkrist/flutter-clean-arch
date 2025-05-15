import '../../repositories/stellar_repository.dart';

class SwapXLMToUSDCUseCase {
  final StellarRepository repository;
  static const USDC_ISSUER =
      'GBBD47IF6LWK7P7MDEVSCWR7DPUWV3NY3DTQEVFL4NAT4AQH3ZLLFLA5';
  static const USDC_CODE = 'USDC';

  SwapXLMToUSDCUseCase(this.repository);

  Future<double> execute({
    required String secretKey,
    required double xlmAmount,
  }) async {
    await repository.swapXLMToUSDC(
      secretKey: secretKey,
      xlmAmount: xlmAmount,
      usdcAssetCode: USDC_CODE,
      usdcIssuer: USDC_ISSUER,
    );

    // Get updated USDC balance
    final balances = await repository.getAssetBalances(secretKey);
    return balances[USDC_CODE] ?? 0.0;
  }
}
