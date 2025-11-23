import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get prefs => _prefs;

  static Future<String?> getString(String key) async => _prefs.getString(key);

  static Future<bool> setString(String key, String value) async => await _prefs.setString(key, value);

  static Future<bool> remove(String key) async => await _prefs.remove(key);

  static Future<bool> containsKey(String key) async => _prefs.containsKey(key);
}
