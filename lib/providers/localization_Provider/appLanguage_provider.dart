import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguage extends ChangeNotifier {
  Locale? _appLocale;

  Locale? get appLocal => _appLocale ?? Locale("en");
  fetchLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language_code') == null) {
      _appLocale = Locale('en');
      return Null;
    }
    log(prefs.getString("language_code") ?? "");
    _appLocale = Locale(prefs.getString('language_code').toString());
    //notifyListeners();
    return Null;
  }

  void changeLanguage(Locale type) async {
    var prefs = await SharedPreferences.getInstance();
    // if (_appLocale == type) {
    //   return;
    // }
    if (type == Locale("hi")) {
      _appLocale = Locale("hi");
      await prefs.setString('language_code', 'hi');
      await prefs.setString('countryCode', '');
    } else if (type == Locale("en")) {
      _appLocale = Locale("en");
      await prefs.setString('language_code', 'en');
      await prefs.setString('countryCode', 'US');
    } else if (type == Locale("mr")) {
      _appLocale = Locale("mr");
      await prefs.setString('language_code', 'mr');
      await prefs.setString('countryCode', '');
    }
    notifyListeners();
    log(prefs.getString('language_code') ?? "");
  }
}
