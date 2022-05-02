import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:threekm/Models/BusinessSearch/BusinessSearchModel.dart';
import 'package:threekm/Models/NewsSearch/NewsSearchModel.dart';
import 'package:threekm/Models/ShopSearch/ShopSearchModel.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/providers/localization_Provider/appLanguage_provider.dart';
import 'package:threekm/utils/api_paths.dart';

class SearchBarProvider extends ChangeNotifier {
  ApiProvider _apiProvider = ApiProvider();
  ShopSearch? _shopSearch;

  ShopSearch? get shopSearchData => this._shopSearch;

  bool _isShopLoading = false;
  bool get isShopLoading => this._isShopLoading;

  // get Shop search
  Future<ShopSearch?> getShopSearch(
      {required String query,
      required int pageNumber,
      required bool isNewCall}) async {
    var tempData = _shopSearch?.result?.products;
    if (isNewCall != false) {
      _isShopLoading = true;
    }
    notifyListeners();
    String requestJson = json.encode({
      "page": pageNumber,
      "query": "$query",
      "lat": 21.1458004,
      "lng": 79.0881546
    });
    final response = await _apiProvider.post(productList, requestJson);
    if (response != null && response["StatusCode"] == 200) {
      print(_shopSearch);
      _shopSearch = ShopSearch.fromJson(response);
      if (tempData != null && isNewCall == false) {
        tempData.addAll(_shopSearch!.result!.products!);
        _shopSearch!.result!.products = tempData;
      }
      _isShopLoading = false;
      notifyListeners();
    }
  }

  BusinessSearchModel? _businessSearchModel;

  BusinessSearchModel? get BusinessSearchData => this._businessSearchModel;

  bool _isbusinnessLoading = false;
  bool get isbusinnessLoading => this._isbusinnessLoading;

  Future<ShopSearch?> getBusinessSearch({
    required String query,
  }) async {
    _isbusinnessLoading = true;
    notifyListeners();
    String requestJson = json.encode(
        {"lat": 18.441900, "lng": 73.823631, "tags": "", "query": "$query"});
    final response = await _apiProvider.post(Search_Business, requestJson);
    if (response != null && response["status"] == "success") {
      _businessSearchModel = BusinessSearchModel.fromJson(response);
      print(_businessSearchModel);
      _isbusinnessLoading = false;
      notifyListeners();
    }
  }

  NewsSearchModel? _newsSearchModel;
  NewsSearchModel? get newsSearchData => this._newsSearchModel;

  bool _newsLoading = false;
  bool get isNewsLoading => this._newsLoading;
  Future<NewsSearchModel?> getNewsSearch({required BuildContext context,required String query}) async {
    _newsLoading = true;
    notifyListeners();
    String requestJson =
        json.encode({"lat": 21.1458004, "lng": 79.0881546, "query": "$query", "lang": context.read<AppLanguage>().appLocal == Locale("mr")
              ? "mr"
              : context.read<AppLanguage>().appLocal == Locale("en")
                  ? "en"
                  : "hi",
});

    final response = await _apiProvider.post(Search_News, requestJson);
    if (response != null && response["status"] == "success") {
      _newsSearchModel = NewsSearchModel.fromJson(response);
      _newsLoading = false;
      notifyListeners();
    }
  }
}
