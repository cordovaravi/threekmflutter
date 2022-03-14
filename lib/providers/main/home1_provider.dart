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

  Future<Null> getNewsfirst(requestJson) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (await _apiProvider.getConnectivityStatus()) {
      String token = await _apiProvider.getToken() ?? "";
      log("token is $token");
      try {
        showLoading();
        final response = await _apiProvider.post(getHomePage, requestJson);
        if (response != null) {
          hideLoading();
          _homeModel = NewsHomeModel.fromJson(response);
          _prefs.remove("homeModel");
          _prefs.setString("homeModel", _homeModel.toString());
          notifyListeners();
        }
      } on Exception catch (e) {
        hideLoading();
      }
    } else {
      Fluttertoast.showToast(msg: "No InterNet connection");
      String? rawModel = _prefs.getString("homeModel");
      if (rawModel != null) {
        log(rawModel.toString());
        Map<String, dynamic> rawMap = json.decode(rawModel);
        _homeModel = NewsHomeModel.fromJson(rawMap);
        notifyListeners();
      }
    }
  }

  Future<void> onRefresh(requestJson) async {
    await getNewsfirst(requestJson).whenComplete(() => notifyListeners());
  }
}
