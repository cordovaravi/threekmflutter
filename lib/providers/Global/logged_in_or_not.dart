import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threekm/UI/Auth/signup/sign_up.dart';

Future<bool> getAuthStatus() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String? token = _prefs.getString("token");
  if (token != null) {
    return true;
  }
  return false;
}

NaviagateToLogin(BuildContext context) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => SignUp()));
}

class CheckLoginProvider extends ChangeNotifier {
  bool _isLogedIn = false;
  bool get isLogedIn => _isLogedIn;

  Future<Null> getAuthStatus() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? token = _prefs.getString("token");
    if (token != null) {
      _isLogedIn = true;
      notifyListeners();
    }
  }
}
