import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:threekm/Models/BusinessSearch/BusinessSearchModel.dart';
import 'package:threekm/Models/ShopSearch/ShopSearchModel.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/utils/api_paths.dart';

class SearchBarProvider extends ChangeNotifier {
  ApiProvider _apiProvider = ApiProvider();
  ShopSearch? _shopSearch;

  ShopSearch? get shopSearchData => this._shopSearch;

  Future<ShopSearch?> getShopSearch(
      {required String query,
      required int pageNumber,
      required bool isNewCall}) async {
    var tempData = _shopSearch?.result?.products;
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

      notifyListeners();
    }
  }

  BusinessSearchModel? _businessSearchModel;

  BusinessSearchModel? get BusinessSearchData => this._businessSearchModel;

  Future<ShopSearch?> getBusinessSearch({
    required String query,
  }) async {
    String requestJson = json.encode(
        {"lat": 18.441900, "lng": 73.823631, "tags": "", "query": "$query"});
    final response = await _apiProvider.post(Search_Business, requestJson);
    if (response != null && response["status"] == "success") {
      _businessSearchModel = BusinessSearchModel.fromJson(response);

      notifyListeners();
    }
  }
}
