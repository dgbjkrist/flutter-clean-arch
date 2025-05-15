class User {
  final String id;
  final String email;
  final String name;
  final double balance;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.balance,
  });

  // Factory for empty state
  factory User.empty() => const User(
        id: '',
        email: '',
        name: '',
        balance: 0.0,
      );

  // Manual copyWith method
  User copyWith({
    String? id,
    String? email,
    String? name,
    double? balance,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      balance: balance ?? this.balance,
    );
  }

  // Manual equality
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          other.id == id &&
          other.email == email &&
          other.name == name &&
          other.balance == balance;

  @override
  int get hashCode => Object.hash(id, email, name, balance);

  @override
  String toString() =>
      'User(id: $id, email: $email, name: $name, balance: $balance)';
}
