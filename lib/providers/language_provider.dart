import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('id', 'ID'); // Default Indonesia

  Locale get locale => _locale;

  void setLanguage(String languageCode) {
    switch (languageCode) {
      case 'id':
        _locale = const Locale('id', 'ID');
        break;
      case 'en':
        _locale = const Locale('en', 'US');
        break;
      case 'zh':
        _locale = const Locale('zh', 'CN');
        break;
      case 'ja':
        _locale = const Locale('ja', 'JP');
        break;
      default:
        _locale = const Locale('id', 'ID');
    }
    notifyListeners();
  }
}