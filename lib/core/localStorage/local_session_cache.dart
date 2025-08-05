import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:true_sight/features/auth/data/models/user_modal.dart';

class LocalSessionCache {
  static const _key = 'cached_user';

  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, jsonEncode(user.toJson()));
  }

  Future<UserModel?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);
    if (json == null) return null;
    final map = jsonDecode(json) as Map<String, dynamic>;
    return UserModel.fromJson(map);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_key);
  }
}
