import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageHelper {
  static const _firstLaunchKey = 'first_launch';
  static final _secureStorage = FlutterSecureStorage();

  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirst = prefs.getBool(_firstLaunchKey) ?? true;
    return isFirst;
  }

  static Future<void> markFirstLaunchDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstLaunchKey, false);
  }

  static Future<void> clearAll() async {
    // Clear secure storage
    await _secureStorage.deleteAll();

    // Clear shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // You can also clear cached files if needed
    // final dir = await getTemporaryDirectory();
    // dir.delete(recursive: true);
  }
}
