class StellarAccount {
  final String publicKey;
  final String? secretKey;
  final double balance;

  const StellarAccount({
    required this.publicKey,
    this.secretKey,
    required this.balance,
  });

  // For new accounts
  factory StellarAccount.empty() => const StellarAccount(
        publicKey: '',
        secretKey: null,
        balance: 0.0,
      );
}
