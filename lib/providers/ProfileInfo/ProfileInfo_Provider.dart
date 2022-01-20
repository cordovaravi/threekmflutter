import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threekm/Models/UserDataModel.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/utils/api_paths.dart';
import 'package:http/http.dart' as http;

//enum status { loading, hasData }

class ProfileInfoProvider extends ChangeNotifier {
  ApiProvider _apiProvider = ApiProvider();
  String? _userName;
  String? _Phonenumber;
  String? _avatar;
  String? _email;

  String? get UserName => this._userName;
  String? get Phonenumber => this._Phonenumber;
  String? get Avatar => this._avatar;
  String? get Email => this._email;

  static Future<String?> _getName() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var fname = await _pref.getString("userfname");
    var lname = await _pref.getString("userlname");
    return "$fname $lname";
  }

  static Future<String?> _getPhoneUmber() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return _pref.getString("userphone");
  }

  static Future<String?> _getAvatar() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return _pref.getString("avatar");
  }

  static Future<String?> _getDob() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return _pref.getString("dob");
  }

  //String get email =>  _getEmail();

  static Future<String?> getEmail() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return _pref.getString("email");
  }

  Future<Null> getProfileBasicData() async {
    _avatar = await _getAvatar();
    _userName = await _getName();
    _Phonenumber = await _getPhoneUmber();
    _email = await getEmail();
    notifyListeners();
  }

  bool _isUpdating = false;
  bool get isUpdating => this._isUpdating;
  Future<Null> updateProfileInfo(
      {String? fname,
      String? lname,
      String? Gender,
      String? avatar,
      DateTime? dob,
      String? email}) async {
    _isUpdating = true;
    notifyListeners();
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var _fname = await _pref.getString("userfname");
    var _lname = await _pref.getString("userlname");
    String requestJson = json.encode({
      "firstname": fname ?? _fname,
      "lastname": lname ?? _lname,
      "avatar": avatar ?? await _getAvatar(),
      "gender": Gender ?? "",
      "email": email ?? await getEmail(),
      "dob": dob != null ? "${dob.year}-${dob.month}-${dob.day}" : ""
    });
    final response = await _apiProvider.post(Update_User_Info, requestJson);
    if (response != null) {
      print(response);
      if (response != null && response["status"] == "success") {
        final data = UserModel.fromJson(response);
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("userlname", data.data!.result!.user!.lastname ?? "");
        prefs.setString("userfname", data.data!.result!.user!.firstname ?? "");
        prefs.setString("avatar", data.data!.result!.user!.avatar ?? "");
        prefs.setString("gender", data.data!.result!.user!.gender ?? "");
        prefs.setString("email", data.data!.result!.user!.email ?? "");
        getProfileBasicData();
      }
    }
  }

  bool _uploadPhoto = false;
  bool get uploadingPhoto => this._uploadPhoto;
  Future<Null> uploadPhoto(
      {required BuildContext context, required String filePath}) async {
    _uploadPhoto = true;
    notifyListeners();
    try {
      var request =
          await http.MultipartRequest('POST', Uri.parse(upload_Imagefile));
      request.headers['Authorization'] = await _apiProvider.getToken();
      request.fields['storage_url'] = "post";
      request.fields['record_id'] = "0";
      request.fields['filename'] = "post.png";
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
      var httpresponse = await request.send();
      final res = await http.Response.fromStream(httpresponse);
      final response = json.decode(res.body);
      if (httpresponse.statusCode == 200) {
        print("uploaded");
        if (response["status"] == "success") {
          log(response["photo"]["photo"]);
          // updateProfileInfo(avatar: response["photo"]["photo"]);
          SharedPreferences _prefs = await SharedPreferences.getInstance();
          await _prefs.remove("avatar");
          await _prefs.setString("avatar", response["photo"]["photo"]);
          //getProfileBasicData();
          updateProfileInfo(avatar: response["photo"]["photo"]);
          Navigator.of(context).pop();
          _uploadPhoto = false;
          notifyListeners();
        }
      }
    } on HttpException catch (e) {
      CustomSnackBar(context, Text("Something went wrong"));
      _uploadPhoto = false;
    }
  }

  void resetUpload() {
    _uploadPhoto = false;
    notifyListeners();
  }

  Future<Null> updateGender({required String gender}) async {
    updateProfileInfo(Gender: gender);
  }

  Future<Null> updateDob({required DateTime dob}) async {
    updateProfileInfo(dob: dob);
  }

  DateTime? _dob;
  DateTime? get dateOfBirth => _dob;
  void setDob({required DateTime dob}) {
    _dob = dob;
    updateProfileInfo(dob: dob);
    notifyListeners();
  }

  String gender = "";
  changeGender(String value) {
    gender = value;
    notifyListeners();
  }

  bool _genderLoading = false;
  bool get genderLoading => _genderLoading;
  saveGender(String value, context) async {
    _genderLoading = true;
    notifyListeners();
    print(value);
    var prefs = await SharedPreferences.getInstance();
    updateProfileInfo(Gender: value);
    prefs.setString("gender", value);
    _genderLoading = false;
    notifyListeners();
    Navigator.of(context).pop();
    //refresh();
    // String? setValue = await ApiCalls.updateProfile({
    //   "gender": "$value",
    // });
    // if (setValue != null) {
    //   buttonLoading = false;
    //   prefs.setString(GENDER, setValue);
    //   profile.gender = setValue;
    //   profile.gender = prefs.getString(GENDER);
    //   refresh();
    //   Navigator.of(context).pop();
    // }
  }
}
