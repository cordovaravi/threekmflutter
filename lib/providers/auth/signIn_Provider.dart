import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:threekm/UI/main/navigation.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/commenwidgets/commenwidget.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/utils/api_paths.dart';

class SignInProvider extends ChangeNotifier {
  ApiProvider _apiProvider = ApiProvider();

  bool _isLoading = false;
  bool get isLoding => _isLoading;
  bool _wrongOTP = false;
  bool get iswrongOTP => _wrongOTP;

  Future<Null> loginWithPassword(requestJson, context) async {
    try {
      showLoading();
      final response =
          await _apiProvider.auth(login_with_password, requestJson);
      if (response != null) {
        hideLoading();
        print(response);
        if (response['status'] == 'success') {
          // CustomSnackBar(context, Text("Login Successfull"));
          _apiProvider.saveLoginCredentials(
              response['data']['result']['token'],
              response['data']['result']['firstname'],
              response['data']['result']['lastname'],
              response['data']['result']['phone_no']);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => TabBarNavigation()),
              (route) => false);
        } else if (response['status'] == 'failed') {
          CustomSnackBar(context, Text(response['error']));
        }
      }
    } on Exception catch (e) {
      hideLoading();
    }
  }

  Future<Null> verifyOTP(requestJson, phoneNumber, BuildContext context) async {
    _wrongOTP = false;
    notifyListeners();
    try {
      showLoading();
      final response =
          await _apiProvider.auth(register_verify_otp, requestJson);
      print(response);
      if (response['status'] == 'success') {
        hideLoading();
        _wrongOTP = false;
        notifyListeners();
        _apiProvider.saveLoginCredentials(
            response['data']['result']['token'],
            response['data']['result']['firstname'],
            response['data']['result']['lastname'],
            response['data']['result']['phone_no']);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => TabBarNavigation()),
            (route) => false);
      } else {
        hideLoading();
        _wrongOTP = true;
        notifyListeners();
        Fluttertoast.showToast(msg: "Entered OTP is wrong");
      }
    } on Exception catch (e) {
      hideLoading();
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
