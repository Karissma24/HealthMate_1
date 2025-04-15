import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> setString(String key, String value) async {
    await _preferences?.setString(key, value);
  }

  static String getString(String key) {
    return _preferences?.getString(key) ?? '';
  }

  // Add other types as needed, such as getInt, setInt, etc.
}
