import 'package:flutter/material.dart';
import 'locale_storage.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('id'); // Default to Bahasa Indonesia

  Locale get locale => _locale;

  LocaleProvider() {
    _loadSavedLocale();
  }

  // Load saved locale on initialization
  Future<void> _loadSavedLocale() async {
    final savedLocale = await LocaleStorage.loadLocale();
    if (savedLocale != null) {
      _locale = Locale(savedLocale);
      notifyListeners();
    }
  }

  // Set a new locale
  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;

    _locale = locale;
    await LocaleStorage.saveLocale(locale.languageCode);
    notifyListeners();
  }

  // Toggle between supported languages
  Future<void> toggleLanguage() async {
    final newLocale = _locale.languageCode == 'en'
        ? const Locale('id')
        : const Locale('en');
    await setLocale(newLocale);
  }

  // Set to English
  Future<void> setEnglish() async {
    await setLocale(const Locale('en'));
  }

  // Set to Bahasa Indonesia
  Future<void> setIndonesian() async {
    await setLocale(const Locale('id'));
  }

  // Check if current locale is English
  bool get isEnglish => _locale.languageCode == 'en';

  // Check if current locale is Indonesian
  bool get isIndonesian => _locale.languageCode == 'id';

  // Get current language name
  String get currentLanguageName {
    return _locale.languageCode == 'en'
        ? 'English'
        : 'Bahasa Indonesia';
  }
}
