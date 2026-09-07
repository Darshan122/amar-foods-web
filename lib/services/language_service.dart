import 'package:flutter/material.dart';

class LanguageItem {
  final String code;
  final String name;
  final String nativeName;
  final String flag;
  final String region;

  const LanguageItem({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
    required this.region,
  });
}

class LanguageService {
  LanguageService._();
  static final LanguageService instance = LanguageService._();

  static const List<LanguageItem> supportedLanguages = [
    LanguageItem(code: 'en', name: 'English', nativeName: 'English', flag: '🇺🇸', region: 'Global / US / UK'),
    LanguageItem(code: 'ar', name: 'Arabic', nativeName: 'العربية', flag: '🇦🇪', region: 'Middle East & Gulf'),
    LanguageItem(code: 'ru', name: 'Russian', nativeName: 'Русский', flag: '🇷🇺', region: 'Russia & CIS'),
    LanguageItem(code: 'es', name: 'Spanish', nativeName: 'Español', flag: '🇪🇸', region: 'Spain & Latin America'),
    LanguageItem(code: 'de', name: 'German', nativeName: 'Deutsch', flag: '🇩🇪', region: 'Germany & Europe'),
    LanguageItem(code: 'fr', name: 'French', nativeName: 'Français', flag: '🇫🇷', region: 'France & Europe'),
    LanguageItem(code: 'hi', name: 'Hindi', nativeName: 'हिन्दी', flag: '🇮🇳', region: 'India'),
    LanguageItem(code: 'gu', name: 'Gujarati', nativeName: 'ગુજરાતી', flag: '🇮🇳', region: 'Gujarat, India'),
  ];

  final ValueNotifier<LanguageItem> currentLanguage = ValueNotifier<LanguageItem>(supportedLanguages.first);

  void setLanguage(LanguageItem language) {
    currentLanguage.value = language;
  }
}
