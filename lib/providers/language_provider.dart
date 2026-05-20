import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('id', 'ID');

  Locale get locale => _locale;

  void setLanguage(String languageCode) {
    if (languageCode == 'en') {
      _locale = const Locale('en', 'US');
    } else {
      _locale = const Locale('id', 'ID');
    }
    notifyListeners();
  }

  String get currentLanguageCode {
    return _locale.languageCode;
  }
}