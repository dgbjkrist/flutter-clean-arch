import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';
import '../../domain/entities/stellar_account.dart';
import '../../domain/entities/transaction_history.dart';
import '../../domain/repositories/stellar_repository.dart';

class StellarRepositoryImpl implements StellarRepository {
  final StellarSDK sdk;
  final Network network;
  static const USDC_ISSUER =
      'GBBD47IF6LWK7P7MDEVSCWR7DPUWV3NY3DTQEVFL4NAT4AQH3ZLLFLA5';
  static const USDC_CODE = 'USDC';

  StellarRepositoryImpl()
      : sdk = StellarSDK.TESTNET,
        network = Network.TESTNET;

  @override
  Future<StellarAccount> createAccount() async {
    final keyPair = KeyPair.random();
    return StellarAccount(
      publicKey: keyPair.accountId,
      secretKey: keyPair.secretSeed,
      balance: 0.0,
    );
  }

  @override
  Future<void> fundAccount(String publicKey) async {
    final response = await FriendBot.fundTestAccount(publicKey);
    if (!response) {
      throw Exception('Failed to fund account: ');
    }
  }

  @override
  Future<StellarAccount> getAccountDetails(String publicKey) async {
    try {
      final account = await sdk.accounts.account(publicKey);
      final balance = _getXLMBalance(account);

      return StellarAccount(
        publicKey: publicKey,
        balance: balance,
      );
    } catch (e) {
      throw Exception('Failed to get account details: $e');
    }
  }

  @override
  Future<double> getBalance(String publicKey) async {
    try {
      final account = await sdk.accounts.account(publicKey);
      return _getXLMBalance(account);
    } catch (e) {
      throw Exception('Failed to get balance: $e');
    }
  }

  @override
  Future<String> sendPayment({
    required String sourceSecretKey,
    required String destinationPublicKey,
    required double amount,
    String? memo,
  }) async {
    try {
      final sourceKeyPair = KeyPair.fromSecretSeed(sourceSecretKey);
      final sourceAccountId = sourceKeyPair.accountId;

      // Load source account
      final sourceAccount = await sdk.accounts.account(sourceAccountId);

      // Build transaction
      final transactionBuilder = TransactionBuilder(sourceAccount)
        ..addOperation(PaymentOperationBuilder(
          destinationPublicKey,
          Asset.NATIVE,
          amount.toString(),
        ).build());

      // Add memo if provided
      if (memo != null) {
        transactionBuilder.addMemo(MemoText(memo));
      }

      // Build and sign transaction
      final transaction = transactionBuilder.build();
      transaction.sign(sourceKeyPair, network);

      // Submit transaction
      final response = await sdk.submitTransaction(transaction);
      if (!response.success) {
        throw Exception('Transaction failed: ${response.toString()}');
      }

      return response.hash ?? '';
    } catch (e) {
      throw Exception('Failed to send payment: $e');
    }
  }

  @override
  Future<void> addTrustline({
    required String secretKey,
    required String assetCode,
    required String issuer,
  }) async {
    try {
      final sourceKeypair = KeyPair.fromSecretSeed(secretKey);
      final sourceAccount = await sdk.accounts.account(sourceKeypair.accountId);

      final asset = Asset.createNonNativeAsset(assetCode, issuer);

      final transaction = TransactionBuilder(sourceAccount)
          .addOperation(
            ChangeTrustOperationBuilder(
              asset,
              "1000000",
            ).build(),
          )
          .build();

      transaction.sign(sourceKeypair, network);

      final response = await sdk.submitTransaction(transaction);

      if (!response.success) {
        throw Exception('Failed to add trustline: ${response.envelopeXdr}');
      }
    } catch (e) {
      throw Exception('Error adding trustline: $e');
    }
  }

  @override
  Future<double> getXLMToUSDCRate(double xlmAmount) async {
    try {
      final pathsRequest = sdk.strictReceivePaths; // Get the builder
      final paths = await pathsRequest
          .sourceAssets([Asset.NATIVE])
          .destinationAsset(Asset.createNonNativeAsset(USDC_CODE, USDC_ISSUER))
          .destinationAmount("1") // We request path for 1 USDC
          .execute();

      if (paths.records.isEmpty) {
        throw Exception('No path available for swap');
      }

      // Get the best path's rate
      final bestPath = paths.records.first;
      final rateForOneUSDC = double.parse(bestPath.sourceAmount);

      return rateForOneUSDC; // This is how much XLM needed for 1 USDC
    } catch (e) {
      throw Exception('Error getting exchange rate: $e');
    }
  }

  @override
  Future<void> swapXLMToUSDC({
    required String secretKey,
    required double xlmAmount,
    required double expectedUsdcAmount,
  }) async {
    try {
      final sourceKeypair = KeyPair.fromSecretSeed(secretKey);
      final sourceAccount = await sdk.accounts.account(sourceKeypair.accountId);

      final transaction = TransactionBuilder(sourceAccount)
          .addOperation(
            PathPaymentStrictReceiveOperationBuilder(
              Asset.NATIVE,
              xlmAmount.toString(), // Maximum XLM we're willing to spend
              sourceKeypair.accountId,
              Asset.createNonNativeAsset(USDC_CODE, USDC_ISSUER),
              expectedUsdcAmount
                  .toString(), // Exact USDC amount we want to receive
            ).build(),
          )
          .build();

      transaction.sign(sourceKeypair, network);
      final response = await sdk.submitTransaction(transaction);

      if (!response.success) {
        throw Exception('Swap failed: ${response.envelopeXdr}');
      }
    } catch (e) {
      throw Exception('Error during swap: $e');
    }
  }

  @override
  Future<Map<String, double>> getAssetBalances(String publicKey) async {
    try {
      final account = await sdk.accounts.account(publicKey);
      final balances = <String, double>{};

      for (var balance in account.balances) {
        if (balance.assetType == 'native') {
          balances['XLM'] = double.parse(balance.balance);
        } else {
          balances[balance.assetCode ?? ''] = double.parse(balance.balance);
        }
      }

      return balances;
    } catch (e) {
      throw Exception('Error fetching balances: $e');
    }
  }

  @override
  Future<List<TransactionHistory>> getTransactionHistory(
      String publicKey) async {
    try {
      // Get all operations instead of just payments
      final operations = await sdk.operations.forAccount(publicKey).execute();
      print("operations ==== ${operations.records.length}");
      print("operations ==== ${operations.records}");

      return operations.records.map((record) {
        if (record is PaymentOperationResponse) {
          return TransactionHistory(
            type: _getTransactionType(record),
            amount: double.parse(record.amount),
            assetCode: record.assetCode ?? 'XLM',
            timestamp: DateTime.parse(record.createdAt),
            from: record.from,
            to: record.to,
            memo: record.transactionHash,
          );
        } else if (record is CreateAccountOperationResponse) {
          return TransactionHistory(
            type: 'Account Created',
            amount: double.parse(record.startingBalance),
            assetCode: 'XLM',
            timestamp: DateTime.parse(record.createdAt),
            from: record.funder,
            to: record.account,
            memo: record.transactionHash,
          );
        } else if (record is ChangeTrustOperationResponse) {
          return TransactionHistory(
            type: 'Trustline Added',
            amount: 0.0,
            assetCode: record.assetCode ?? 'USDC',
            timestamp: DateTime.parse(record.createdAt),
            from: record.trustor ?? '',
            to: record.trustee ?? '',
            memo: record.transactionHash,
          );
        }
        // Default case for other operation types
        return TransactionHistory(
          type: record.type,
          amount: 0.0,
          assetCode: 'XLM',
          timestamp: DateTime.parse(record.createdAt),
          from: publicKey,
          to: publicKey,
          memo: record.transactionHash,
        );
      }).toList();
    } catch (e) {
      throw Exception('Error fetching transaction history: $e');
    }
  }

  double _getXLMBalance(AccountResponse account) {
    final balance = account.balances
        .firstWhere(
          (b) => b.assetType == 'native',
          orElse: () => Balance.fromJson({
            'asset_type': 'native',
            'balance': '0',
          }),
        )
        .balance;
    return double.parse(balance);
  }

  String _getTransactionType(PaymentOperationResponse record) {
    if (record.assetType == 'native') {
      return 'XLM Payment';
    } else if (record.assetCode == 'USDC') {
      return 'USDC Payment';
    }
    return 'Unknown';
  }
}
