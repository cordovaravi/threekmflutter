import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:threekm/Models/home1_model.dart';
import 'package:threekm/commenwidgets/commenwidget.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/utils/api_paths.dart';

class HomefirstProvider extends ChangeNotifier {
  ApiProvider _apiProvider = ApiProvider();
  NewsHomeModel? _homeModel;
  NewsHomeModel? get homeNewsFirst => _homeModel;

  Future<Null> getNewsfirst(requestJson) async {
    String token = await _apiProvider.getToken() ?? "";
    log("token is $token");
    try {
      showLoading();
      final response = await _apiProvider.post(getHomePage, requestJson);
      if (response != null) {
        hideLoading();
        _homeModel = NewsHomeModel.fromJson(response);

        notifyListeners();
      }
    } on Exception catch (e) {
      hideLoading();
    }
  }

  Future<void> onRefresh(requestJson) async {
    await getNewsfirst(requestJson).whenComplete(() => notifyListeners());
  }
}
