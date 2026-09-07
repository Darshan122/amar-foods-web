import 'translations/en.dart';
import 'translations/ar.dart';
import 'translations/ru.dart';
import 'translations/es.dart';
import 'translations/de.dart';
import 'translations/fr.dart';
import 'translations/hi.dart';
import 'translations/gu.dart';

class AppTranslations {
  AppTranslations._();

  static const Map<String, Map<String, String>> _translations = {
    'en': enTranslations,
    'ar': arTranslations,
    'ru': ruTranslations,
    'es': esTranslations,
    'de': deTranslations,
    'fr': frTranslations,
    'hi': hiTranslations,
    'gu': guTranslations,
  };

  static String tr(String code, String key) {
    final langMap = _translations[code] ?? _translations['en']!;
    return langMap[key] ?? _translations['en']![key] ?? key;
  }
}
