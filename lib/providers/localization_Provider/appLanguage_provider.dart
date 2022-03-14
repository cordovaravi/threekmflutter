import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguage extends ChangeNotifier {
  Locale? _appLocale;

  Locale? get appLocal => _appLocale;
  fetchLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language_code') == null) {
      _appLocale = Locale('en');
      return Null;
    }

    log("this is from applang class ${prefs.getString("language_code")}");
    _appLocale = Locale(prefs.getString('language_code') ?? "en");
    notifyListeners();
    return Null;
  }

  void changeLanguage(Locale type) async {
    var prefs = await SharedPreferences.getInstance();
    // if (_appLocale == type) {
    //   return;
    // }
    log(" this is change language $type");
    if (type == Locale("mr")) {
      _appLocale = Locale("mr");
      await prefs.setString('language_code', 'mr');
      await prefs.setString('countryCode', 'IN');
      log("maine set kiya marthi");
    } else if (type == Locale("hi")) {
      _appLocale = Locale("hi");
      await prefs.setString('language_code', 'hi');
      await prefs.setString('countryCode', 'IN');
    } else {
      _appLocale = Locale("en");
      await prefs.setString('language_code', 'en');
      await prefs.setString('countryCode', 'US');
    }
    notifyListeners();
    //log(prefs.getString('language_code') ?? "");
  }
}
