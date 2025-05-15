import '../../domain/entities/user.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final double balance;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.balance,
  });

  // From domain
  factory UserModel.fromDomain(User user) => UserModel(
        id: user.id,
        email: user.email,
        name: user.name,
        balance: user.balance,
      );

  // To domain
  User toDomain() => User(
        id: id,
        email: email,
        name: name,
        balance: balance,
      );

  // From JSON
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        email: json['email'] as String,
        name: json['name'] as String,
        balance: (json['balance'] as num).toDouble(),
      );

  // To JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'balance': balance,
      };

  // Equality and toString methods (optional but recommended)
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          other.id == id &&
          other.email == email &&
          other.name == name &&
          other.balance == balance;

  @override
  int get hashCode => Object.hash(id, email, name, balance);

  @override
  String toString() =>
      'UserModel(id: $id, email: $email, name: $name, balance: $balance)';
}
