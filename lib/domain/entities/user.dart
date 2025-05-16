import 'stellar_account.dart';

class User {
  final String id;
  final String email;
  final String name;
  final StellarAccount? stellarAccount;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.stellarAccount,
  });

  // Check if user has a Stellar account set up
  bool get hasStellarAccount => stellarAccount != null;

  // Check if user can perform Stellar operations (has account with secret key)
  bool get canPerformStellarOperations => stellarAccount?.secretKey != null;

  // Get user's public address if available
  String? get stellarPublicAddress => stellarAccount?.publicKey;

  // Get user's current balance if available
  double get balance => stellarAccount?.balance ?? 0.0;

  // Factory for empty state (useful for initial states in UI)
  factory User.empty() => const User(
        id: '',
        email: '',
        name: '',
        stellarAccount: null,
      );

  // CopyWith for immutability
  User copyWith({
    String? id,
    String? email,
    String? name,
    StellarAccount? stellarAccount,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      stellarAccount: stellarAccount ?? this.stellarAccount,
    );
  }

  // Value equality
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          other.id == id &&
          other.email == email &&
          other.name == name &&
          other.stellarAccount == stellarAccount;

  @override
  int get hashCode => Object.hash(id, email, name, stellarAccount);

  @override
  String toString() => 'User('
      'id: $id, '
      'email: $email, '
      'name: $name, '
      'stellarAccount: $stellarAccount'
      ')';
}
