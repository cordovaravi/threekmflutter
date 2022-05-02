import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threekm/Models/home1_model.dart';
import 'package:threekm/commenwidgets/commenwidget.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/utils/api_paths.dart';

class HomefirstProvider extends ChangeNotifier {
  ApiProvider _apiProvider = ApiProvider();
  NewsHomeModel? _homeModel;
  NewsHomeModel? get homeNewsFirst => _homeModel;
  String? _state;
  String? get state => _state;

  Future<Null> getNewsfirst(requestJson) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (await _apiProvider.getConnectivityStatus()) {
      String token = await _apiProvider.getToken() ?? "";
      log("token is $token");
      try {
        //showLoading();
        _state = 'loading';
        final response = await _apiProvider.post(getHomePage, requestJson);
        if (response != null) {
          // hideLoading();
          _state = 'loaded';
          _homeModel = NewsHomeModel.fromJson(response);
          _prefs.remove("homeModel");
          String offlineStringObj = json.encode(response);
          _prefs.setString("homeModel", offlineStringObj);
          notifyListeners();
        }
      } on Exception catch (e) {
        _state = 'error';
        // hideLoading();
      }
    } else {
      Fluttertoast.showToast(msg: "No InterNet connection");
      String? rawModel = _prefs.getString("homeModel");
      if (rawModel != null) {
        _homeModel = NewsHomeModel.fromJson(json.decode(rawModel));
        _state = 'loaded';
        notifyListeners();
      }
    }
  }

  Future<void> onRefresh(requestJson) async {
    await getNewsfirst(requestJson).whenComplete(() => notifyListeners());
  }
}
