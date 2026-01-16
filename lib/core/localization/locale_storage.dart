import 'package:shared_preferences/shared_preferences.dart';

class LocaleStorage {
  static const String _localeKey = 'selected_locale';

  // Save selected locale
  static Future<void> saveLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, languageCode);
  }

  // Load saved locale
  static Future<String?> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_localeKey);
  }

  // Clear saved locale
  static Future<void> clearLocale() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_localeKey);
  }
}
