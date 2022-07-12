import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';

String HOME_PAGE_DATA = "home_page_data";
String ADDRESS = "address";
String CURRENT_LOCATION = "current_location";

String AUTH_TOKEN = "Auth_token";
String FIRSTNAME = "firstname";
String LASTNAME = "lastname";
String AVATAR = "avatar";
String PHONE_NUMBER = "phone_no";
String otp = "otp";
String EMAIL = "user_gender";
String GENDER = "gender";
String DATEOFBIRTH = "date_of_birth";

String USERID = "user_id";
Size size(context) => MediaQuery.of(context).size;

getDeviceId() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    await deviceInfo.androidInfo.then((value) {
      return value.androidId;
    });
  } else if (Platform.isIOS) {
    await deviceInfo.iosInfo.then((value) {
      return value.identifierForVendor;
    });
  }
}
// Future<bool> getAuthStatus() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   if (prefs.containsKey(AUTH_TOKEN)) {
//     return true;
//   }
//   return false;
// }
