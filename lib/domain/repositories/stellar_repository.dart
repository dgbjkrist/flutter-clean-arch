import '../entities/stellar_account.dart';
import '../entities/transaction_history.dart';

abstract class StellarRepository {
  Future<StellarAccount> createAccount();
  Future<StellarAccount> getAccountDetails(String publicKey);
  Future<void> fundAccount(String publicKey);
  Future<double> getBalance(String publicKey);
  Future<String> sendPayment({
    required String sourceSecretKey,
    required String destinationPublicKey,
    required double amount,
    String? memo,
  });

  Future<void> addTrustline({
    required String secretKey,
    required String assetCode,
    required String issuer,
  });

  Future<double> getXLMToUSDCRate(double xlmAmount);

  Future<void> swapXLMToUSDC({
    required String secretKey,
    required double xlmAmount,
    required double expectedUsdcAmount,
  });

  Future<Map<String, double>> getAssetBalances(String publicKey);

  /// Fetches transaction history for a given account
  Future<List<TransactionHistory>> getTransactionHistory(String publicKey);
}
