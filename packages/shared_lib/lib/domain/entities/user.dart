import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  factory User({
    required String id,
    required String email,
    required String name,
    required double balance,
  }) = _User;

  factory User.empty() => User(
        id: '',
        email: '',
        name: '',
        balance: 0.0,
      );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
