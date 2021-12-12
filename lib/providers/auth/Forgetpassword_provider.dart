import 'package:flutter/cupertino.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/commenwidgets/commenwidget.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/utils/api_paths.dart';

class ForgetPasswordProvider extends ChangeNotifier {
  ApiProvider _apiProvider = ApiProvider();
  bool? _isOtpwrong = false;
  bool? get isOTPWrong => _isOtpwrong;

  Future<Null> forgetPassword(requestJson) async {
    showLoading();
    final response = await _apiProvider.auth(forgetPasswordString, requestJson);
    if (response != null) {
      hideLoading();
      print(response);
    }
  }

  Future<Null> updatePassword(requestJson, context) async {
    showLoading();
    final response = await _apiProvider.auth(verifyForgetPassword, requestJson);
    if (response != null) {
      hideLoading();
      if (response['error'] == "Incorrect OTP") {
        _isOtpwrong = true;
        notifyListeners();
        CustomSnackBar(context, Text("You have entered wrong OTP"));
        Navigator.pop(context);
      } else if (response['status'] == "success") {
        CustomSnackBar(
            context, Text("Password update Successfully!\nPlease login now"));
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      }
    }
  }
}
