import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  String? _Gender;

  String? get UserName => this._userName;
  String? get Phonenumber => this._Phonenumber;
  String? get Avatar => this._avatar;
  String? get Email => this._email;
  String? get Gender => this._Gender;

  DateTime? _dob;
  DateTime? get dateOfBirth => _dob;

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

  Future<String?> _getDob() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String? dob = await _pref.getString("dob");
    log("dob is from function $dob");
    return dob;
  }

  //String get email =>  _getEmail();

  static Future<String?> getEmail() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return _pref.getString("email");
  }

  static Future<String?> getPhone() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return _pref.getString('userphone');
  }

  static Future<String?> _getGender() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return _pref.getString("gender");
  }

  Future<Null> getProfileBasicData() async {
    String? dateOfBirth = await _getDob();
    log("this is dob from getDob in basic data $dateOfBirth");
    _avatar = await _getAvatar();
    _userName = await _getName();
    _Phonenumber = await _getPhoneUmber();
    _email = await getEmail();
    _dob = dateOfBirth != null ? DateTime.parse(dateOfBirth) : null;

    _Gender = await _getGender() ?? null;
    log("dob is $_dob");

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
      String? email,
      String? phone,
      bool? is_verified,
      bool? is_document_verified,
      bool? isDocumentUploaded,
      String? bloodGroup,
      List<String>? language}) async {
    _isUpdating = true;
    notifyListeners();
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var _fname = await _pref.getString("userfname");
    var _lname = await _pref.getString("userlname");
    String requestJson = json.encode({
      "firstname": fname ?? _fname,
      "lastname": lname ?? _lname,
      "avatar": avatar ?? await _getAvatar(),
      "gender": Gender ?? await _getGender(),
      "email": email ?? await getEmail(),
      "dob": dob != null ? "${dob.year}-${dob.month}-${dob.day}" : "",
      "phone_no": phone ?? await getPhone(),
      "is_verified": is_verified ?? _pref.getBool('is_verified'),
      "is_document_verified": is_document_verified ?? null,
      "is_document_uploaded": isDocumentUploaded ?? null,
      "blood_group": bloodGroup ?? null,
      "languages": language ?? null
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
        prefs.setString("dob", data.data!.result!.user?.dob.toString() ?? "");
        prefs.setString("userphone", data.data!.result!.user?.phoneNo ?? "");

        getProfileBasicData();
        _isUpdating = false;
        notifyListeners();
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

  void resetAll() {
    _avatar = null;
    _userName = null;
    _Phonenumber = null;
    _email = null;
    _dob = null;

    _Gender = null;

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
