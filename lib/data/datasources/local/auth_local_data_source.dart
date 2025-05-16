import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/entities/stellar_account.dart';
import '../../models/user_model.dart';

class AuthLocalDataSource {
  static const String _usersKey = 'users';
  static const String _currentUserKey = 'current_user';

  final SharedPreferences _prefs;

  AuthLocalDataSource(this._prefs);

  Future<UserModel> saveUser({
    required String email,
    required String password,
    required String name,
    StellarAccount? stellarAccount,
  }) async {
    final users = await _getUsers();

    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name,
      password: password,
      stellarAccount: stellarAccount,
    );

    users[email] = user.toJson();
    await _prefs.setString(_usersKey, json.encode(users));

    return user;
  }

  Future<UserModel> getUser(String email, String password) async {
    final users = await _getUsers();
    final userData = users[email];

    for (var user in users.values) {
      print("user: $user");
    }

    if (userData == null) {
      throw Exception('User not found');
    }

    final user = UserModel.fromJson(userData);
    if (user.password != password) {
      throw Exception('Invalid password');
    }

    return user;
  }

  Future<UserModel> updateUserStellarAccount(
      String email, StellarAccount stellarAccount) async {
    final users = await _getUsers();
    final userData = users[email];

    if (userData == null) {
      throw Exception('User not found');
    }

    final user =
        UserModel.fromJson(userData).copyWith(stellarAccount: stellarAccount);
    users[email] = user.toJson();

    await _prefs.setString(_usersKey, json.encode(users));

    await setCurrentUser(user);

    return user;
  }

  Future<void> setCurrentUser(UserModel user) async {
    await _prefs.setString(_currentUserKey, json.encode(user.toJson()));
  }

  Future<UserModel?> getCurrentUser() async {
    final userJson = _prefs.getString(_currentUserKey);
    if (userJson == null) return null;
    return UserModel.fromJson(json.decode(userJson));
  }

  Future<void> logout() async {
    await _prefs.remove(_currentUserKey);
  }

  // Private helper method
  Future<Map<String, dynamic>> _getUsers() async {
    final usersJson = _prefs.getString(_usersKey);
    return usersJson != null ? json.decode(usersJson) : {};
  }
}
