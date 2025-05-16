import '../../domain/entities/user.dart';
import '../../domain/entities/stellar_account.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String password;
  final StellarAccount? stellarAccount;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.password,
    this.stellarAccount,
  });

  // Convert to domain entity
  User toDomain() => User(
        id: id,
        email: email,
        name: name,
        stellarAccount: stellarAccount,
      );

  // Create from domain entity (used when we need to add password)
  factory UserModel.fromDomain(User user, {required String password}) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      password: password,
      stellarAccount: user.stellarAccount,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      password: json['password'],
      stellarAccount: json['stellar_account'] != null
          ? StellarAccount(
              publicKey: json['stellar_account']['public_key'],
              secretKey: json['stellar_account']['secret_key'],
              balance: (json['stellar_account']['balance'] as num).toDouble(),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'password': password,
      'stellar_account': stellarAccount != null
          ? {
              'public_key': stellarAccount!.publicKey,
              'secret_key': stellarAccount!.secretKey,
              'balance': stellarAccount!.balance,
            }
          : null,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? password,
    StellarAccount? stellarAccount,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      password: password ?? this.password,
      stellarAccount: stellarAccount ?? this.stellarAccount,
    );
  }

  // Equality and toString methods (optional but recommended)
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          other.id == id &&
          other.email == email &&
          other.name == name &&
          other.password == password &&
          other.stellarAccount == stellarAccount;

  @override
  int get hashCode => Object.hash(id, email, name, password, stellarAccount);

  @override
  String toString() =>
      'UserModel(id: $id, email: $email, name: $name, password: $password, stellarAccount: $stellarAccount)';
}
