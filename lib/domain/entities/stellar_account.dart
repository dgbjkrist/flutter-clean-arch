class StellarAccount {
  final String publicKey;
  final String? secretKey;
  final double balance;
  final String? memo;

  const StellarAccount({
    required this.publicKey,
    this.secretKey,
    required this.balance,
    this.memo,
  });

  // For new accounts
  factory StellarAccount.empty() => const StellarAccount(
        publicKey: '',
        secretKey: null,
        balance: 0.0,
        memo: null,
      );
}
