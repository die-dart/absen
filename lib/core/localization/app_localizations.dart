import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  late Map<String, dynamic> _localizedStrings;

  AppLocalizations(this.locale);

  // Helper method to access from context
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // Load the language JSON file
  Future<bool> load() async {
    String jsonString =
        await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap;
    return true;
  }

  // Get translated value by key
  String translate(String key) {
    return _getNestedValue(key) ?? key;
  }

  // Get nested value from JSON using dot notation (e.g., "login.email")
  String? _getNestedValue(String key) {
    List<String> keys = key.split('.');
    dynamic value = _localizedStrings;

    for (String k in keys) {
      if (value is Map<String, dynamic> && value.containsKey(k)) {
        value = value[k];
      } else {
        return null;
      }
    }

    return value?.toString();
  }

  // Replace placeholders in translation (e.g., {name}, {count})
  String translateWithParams(String key, Map<String, String> params) {
    String translation = translate(key);
    params.forEach((placeholder, value) {
      translation = translation.replaceAll('{$placeholder}', value);
    });
    return translation;
  }

  // Static method for delegate
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
}

// Localizations delegate to load localization
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'id'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

// Extension for easier access to translations
extension LocalizationExtension on BuildContext {
  String tr(String key) {
    return AppLocalizations.of(this).translate(key);
  }

  String trParams(String key, Map<String, String> params) {
    return AppLocalizations.of(this).translateWithParams(key, params);
  }
}
