import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:threekm/commenwidgets/commenwidget.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/Models/shopModel/all_category_model.dart';
import 'package:threekm/Models/shopModel/product_listing_model.dart';
import 'package:threekm/utils/api_paths.dart';

class ProductListingProvider extends ChangeNotifier {
  final ApiProvider _apiProvider = ApiProvider();
  String? _state;
  int _prepageno = 0;
  get prepageno => _prepageno;

  String? get state => _state;
  ProductListingModel _productList = ProductListingModel();

  ProductListingModel get productListingData => _productList;
  List<Products> _allproductList = [];
  List<Products> get allproductList => _allproductList;

  Future<Null> getProductListing(mounted, page, query) async {
    if (mounted) {
      showLoading();

      try {
        final response = await _apiProvider.post(
            productList,
            jsonEncode({
              "page": page,
              "query": query,
              "lat": 18.5061068,
              "lng": 73.7598362,
            }));
        if (response != null) {
          hideLoading();
          // print(response);
          _productList = ProductListingModel.fromJson(response);
          _allproductList = page == _prepageno
              ? _allproductList
              : [..._allproductList, ..._productList.result!.products];
          _state = 'loaded';
          _prepageno = page;
          notifyListeners();
        }
      } catch (e) {
        hideLoading();
        _state = 'error';
        notifyListeners();
      }
    }
  }

  clearProductListState(mounted) {
    if (mounted) {
      _allproductList = [];
      _prepageno = 0;
      // notifyListeners();
    }
  }

  Future<void> onRefresh(mounted, page, query) async {
    await getProductListing(mounted, page, query)
        .whenComplete(() => notifyListeners());
  }
}
