import 'package:flutter/material.dart';
import 'package:warranty_tracker/service/shared_prefrence.dart';

class LanguageChangeNotifier extends ChangeNotifier {
  Locale? _appLang = const Locale('en');
  Locale? get appLang => _appLang;

  Future<void> ChangeLanguage(Locale type) async {
    _appLang = type;
    if (type == const Locale('en')) {
      await AppPrefHelper.setLanguage(language: 'en');
    } else {
      await AppPrefHelper.setLanguage(language: 'hi');
    }
    notifyListeners();
  }
}
