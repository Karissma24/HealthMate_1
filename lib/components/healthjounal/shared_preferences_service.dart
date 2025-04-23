import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> setString(String key, String value, String userId) async {
    await _preferences?.setString('${userId}_$key', value);
  }

  static String getString(String key, String userId) {
    return _preferences?.getString('${userId}_$key') ?? '';
  }
}
