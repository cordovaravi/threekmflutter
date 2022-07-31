import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threekm/Models/getUserInfoModel.dart';
import 'package:threekm/UI/userkyc/email_verification.dart';
import 'package:threekm/UI/userkyc/profile_picture.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/providers/ProfileInfo/ProfileInfo_Provider.dart';
import 'package:threekm/utils/api_paths.dart';

class VerifyKYCCredential extends ChangeNotifier {
  final ApiProvider _apiProvider = ApiProvider();
  bool _isLoading = false;
  bool get isLoding => _isLoading;
  bool _wrongOTP = false;
  bool get iswrongOTP => _wrongOTP;
  bool _trueOTP = false;
  bool get isTrueOTP => _trueOTP;
  String? _avtar = "";
  String? get avtar => _avtar;

  bool? _kycDoc = false;
  bool? get kycDoc => _kycDoc;
  GetUserInfoModel _UserProfileInfo = GetUserInfoModel();
  GetUserInfoModel get userProfileInfo => _UserProfileInfo;

  disposeAllData(mounted) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (mounted) {
        _isLoading = false;
        _trueOTP = false;
        _wrongOTP = false;
        notifyListeners();
      }
    });
  }

  getAvatar() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _avtar = _pref.getString("avatar");

    notifyListeners();
  }

  Future<Null> verifyOTPKYC(
      requestJson, phoneNumber, BuildContext context) async {
    try {
      // showLoading();
      final response =
          await _apiProvider.auth(register_verify_otp, requestJson);
      print(response);
      if (response['status'] == 'success') {
        // hideLoading();
        _wrongOTP = false;
        _trueOTP = true;
        notifyListeners();
        context
            .read<ProfileInfoProvider>()
            .updateProfileInfo(phone: phoneNumber);
        Timer(Duration(seconds: 1), () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => EmailVerification()));
        });
      } else {
        //  hideLoading();
        _wrongOTP = true;
        notifyListeners();
        Fluttertoast.showToast(msg: "Entered OTP is wrong");
      }
    } on Exception catch (e) {
      // hideLoading();
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<Null> verifyEmailOTPKYC(
      requestJson, email, BuildContext context) async {
    try {
      // showLoading();
      final response = await _apiProvider.post(verify_email_otp, requestJson);
      print(response);
      if (response['status'] == 'success') {
        // hideLoading();
        _wrongOTP = false;
        _trueOTP = true;
        notifyListeners();
        context.read<ProfileInfoProvider>().updateProfileInfo(email: email);
        Timer(Duration(seconds: 1), () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => UploadProfilePicture()));
        });
      } else {
        //  hideLoading();
        _wrongOTP = true;
        notifyListeners();
        Fluttertoast.showToast(msg: "Entered OTP is wrong");
      }
    } on Exception catch (e) {
      // hideLoading();
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<dynamic> sendOtpEmail(requestJson) async {
    _isLoading = true;
    notifyListeners();
    final response = await _apiProvider.post(send_otp_email, requestJson);
    print(response);
    if (response != null) {
      _isLoading = false;
      notifyListeners();
    }
    return response;
  }

  Future<dynamic> getUserProfileInfo() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _isLoading = true;
    try {
      final response = await _apiProvider.get(Get_User_info);
      if (response != null) {
        _UserProfileInfo = GetUserInfoModel.fromJson(response);
        _pref.setBool(
            "is_verified", _UserProfileInfo.data?.result.isVerified ?? false);
        _pref.setBool("is_document_verified",
            _UserProfileInfo.data?.result.isDocumentVerified ?? false);
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<dynamic> updateKYCDoc(requestJson) async {
//Update_kyc_doc
    try {
      final response = await _apiProvider.post(Update_kyc_doc, requestJson);
      if (response != null) {
        if (response['status'] == 'success') {
          _kycDoc = true;
          notifyListeners();
        }
      }
    } catch (e) {
      notifyListeners();
    }
  }
}
