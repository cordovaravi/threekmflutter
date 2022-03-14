import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/commenwidgets/commenwidget.dart';
import 'package:threekm/exceptions/custom_exception.dart';
import 'package:threekm/main.dart';
import 'package:threekm/providers/Global/logged_in_or_not.dart';
import 'package:threekm/utils/api_paths.dart';

class ApiProvider {
  String? _baseUrl = baseUrl;

  final Connectivity _connectivity = Connectivity();

  //prefs
  getToken() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return _pref.getString("token");
  }

  //save login Token and user credentials
  saveLoginCredentials(String userToken, String fname, String lname,
      String phone, String avatar) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    await _pref.setString("token", "$userToken");
    await _pref.setString("userfname", "$fname");
    await _pref.setString("userlname", "$lname");
    await _pref.setString("userphone", "$phone");
    await _pref.setString("avatar", "$avatar");
  }

  // Auth
  Future<dynamic> auth(String url, requestJson) async {
    var responseJson;
    print(_baseUrl! + url);
    print(requestJson);
    try {
      final response = await http
          .post(Uri.parse(_baseUrl! + url), body: requestJson, headers: {
        //"Authorization": token,
        'Content-Type': 'application/json',
        //'Accept': 'application/json'
      });

      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<bool> getConnectivityStatus() async {
    ConnectivityResult connectivityResult =
        await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  //future get
  Future<dynamic> get(String url) async {
    var responseJson;
    String token = await getToken() ?? '';

    try {
      //showLoading();
      final response = await http
          .get(Uri.parse(_baseUrl! + url), headers: {
            "Authorization": token,
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          })
          .timeout(Duration(seconds: 15))
          .onError((error, stackTrace) {
            CustomSnackBar(navigatorKey.currentContext!,
                Text("Your Internet Connection is weak"));
            throw error.toString();
          });
      responseJson = _response(response);
      print(_baseUrl! + url);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  //future post
  Future<dynamic> post(String url, requestJson) async {
    var responseJson;
    String token = await getToken() ?? "";
    print(_baseUrl! + url);
    print(requestJson);
    try {
      final response = await http
          .post(Uri.parse(_baseUrl! + url), body: requestJson, headers: {
        "Authorization": token,
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });

      responseJson = _response(response);
    } on SocketException {
      //Get.defaultDialog(title: 'No Internet connection',middleText: 'I guess your Internet is not availble!');
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }
   //future post
  Future<dynamic> CuisinesPost(String url, requestJson) async {
    var responseJson;
    String token = await getToken() ?? "";
   
    print(requestJson);
    try {
      final response = await http
          .post(Uri.parse('https://bulbandkey.com/gateway/${url}'), body: requestJson, headers: {
        "Authorization": token,
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });

      responseJson = _response(response);
    } on SocketException {
      //Get.defaultDialog(title: 'No Internet connection',middleText: 'I guess your Internet is not availble!');
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  //future put
  Future<dynamic> put(String url, requestJson) async {
    var responseJson;
    //String token = await getToken();
    print(_baseUrl! + url);
    try {
      final response = await http
          .put(Uri.parse(_baseUrl! + url), body: requestJson, headers: {
        //"Authorization": token,
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });

      responseJson = _response(response);
    } on SocketException {
      //Get.defaultDialog(title: 'No Internet connection',middleText: 'I guess your Internet is not availble!');
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) async {
    //BuildContext context;
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(utf8.decode(response.bodyBytes));
        //log("$responseJson");
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        if (await getAuthStatus()) {
          hideLoading();
          showMessage(response.body.toString());
        }

        break;
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 404:

      case 500:

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}

// void onError(error) {
//   return showMessage('');
// }
