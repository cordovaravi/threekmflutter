import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:threekm/UI/Auth/sign_in.dart';
import 'package:threekm/UI/Auth/signup/login_confirm_otp.dart';
import 'package:threekm/UI/Auth/signup/sign_up_confirm_otp.dart';
import 'package:threekm/UI/Auth/signup/sign_up_last_steps.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/commenwidgets/commenwidget.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/utils/api_paths.dart';

class SignUpProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoding => _isLoading;
  bool _wrongOTP = false;
  bool get iswrongOTP => _wrongOTP;
  final ApiProvider _apiProvider = ApiProvider();

  Future<Null> checkLogin(
      requestJson, phoneNumber, context, bool? isNavigate) async {
    _isLoading = true;
    notifyListeners();
    final response = await _apiProvider.auth(user_check, requestJson);
    //print(response);
    if (response != null) {
      _isLoading = false;
      notifyListeners();
      if (response['status'] == 'success') {
        if (response['data']['result']['exist'] == false) {
          print("new user");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SignUpConfirmOTP(
                        phoneNumber: phoneNumber,
                      )));
        } else {
          print("returning user");
          final response = await sendOTP(requestJson);
          print("this is response $response");
          if (response["status"] == "success") {
            if (isNavigate!) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginViaOtp(
                            phoneNumber: phoneNumber,
                          )));
            }
          } else {
            CustomSnackBar(
                context, Text("There is some error while sending OTP"));
          }
          // CustomSnackBar(
          //     context, Text("Looks like your alredy signed up\nPlease Login!"));

        }
        // navigate otp scren
      } else {
        Fluttertoast.showToast(msg: "Something went wrong");
      }
    }
  }

  Future<dynamic> sendOTP(requestJson) async {
    final response = await _apiProvider.auth(send_otp, requestJson);
    print(response);
    if (response != null) {
      _isLoading = false;
      notifyListeners();
    }
    return response;
  }

  Future<Null> verifyOTP(requestJson, phoneNumber, BuildContext context) async {
    try {
      showLoading();
      final response =
          await _apiProvider.auth(register_verify_otp, requestJson);
      print(response);
      if (response['status'] == 'success') {
        hideLoading();
        _wrongOTP = false;
        notifyListeners();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SignUpConfirmLastSteps(
                      phoneNumber: phoneNumber,
                    )));
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

  Future<dynamic> registerUser(requestJson, context) async {
    showLoading();
    final response = await _apiProvider.auth(register, requestJson);
    print(response);
    if (response != null) {
      hideLoading();
      if (response['status'] == 'success') {
        CustomSnackBar(context, Text("User Registeerd Successfully"));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignInScreen()));
      } else {
        CustomSnackBar(context, Text("Error Occured"));
      }
    }
  }
}
