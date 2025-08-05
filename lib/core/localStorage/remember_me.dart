import 'package:shared_preferences/shared_preferences.dart';

class RememberMeStorage {
  static const _rememberMeKey = 'remember_me';
  static const _savedEmailKey = 'saved_email';
  static const _savedPasswordKey = 'saved_password';

  static Future<void> saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, true);
    await prefs.setString(_savedEmailKey, email);
    await prefs.setString(_savedPasswordKey, password);
  }

  static Future<void> clearCredentials({bool resetRememberFlag = true}) async {
    final prefs = await SharedPreferences.getInstance();
    if (resetRememberFlag) {
      await prefs.setBool(_rememberMeKey, false);
    }
    await prefs.remove(_savedEmailKey);
    await prefs.remove(_savedPasswordKey);
  }

  static Future<bool> isRemembered() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberMeKey) ?? false;
  }

  static Future<(String?, String?)> loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_savedEmailKey);
    final password = prefs.getString(_savedPasswordKey);
    return (email, password);
  }
}
