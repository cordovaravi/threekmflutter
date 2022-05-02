import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:threekm/commenwidgets/commenwidget.dart';
import 'package:threekm/main.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/Models/shopModel/all_category_model.dart';
import 'package:threekm/Models/shopModel/product_listing_model.dart';
import 'package:threekm/providers/Location/locattion_Provider.dart';
import 'package:threekm/utils/api_paths.dart';

class ProductListingProvider extends ChangeNotifier {
  final ApiProvider _apiProvider = ApiProvider();
  String? _state;
  int _prepageno = 0;
  get prepageno => _prepageno;
  bool _end = false;
  get end => _end;

  String? get state => _state;
  ProductListingModel _productList = ProductListingModel();

  ProductListingModel get productListingData => _productList;
  List<Products> _allproductList = [];
  List<Products> get allproductList => _allproductList;

  Future<Null> getProductListing({mounted, page, query, creatorId = 0}) async {
    if (mounted) {
      final _location =
        navigatorKey.currentContext!.read<LocationProvider>().getlocationData;
      showLoading();
      _state = 'loading';
      try {
        final response = await _apiProvider.post(
            productList,
            query != null
                ? jsonEncode({
                    "page": page,
                    "query": query,
                    "lat": _location?.latitude ?? 18.5061068,
                    "lng": _location?.longitude ?? 73.7598362,
                  })
                : jsonEncode({"page": page, "creator_id": creatorId}));
        if (response != null) {
          hideLoading();
          // print(response);
          _productList = ProductListingModel.fromJson(response);
          _allproductList = page == _prepageno
              ? _allproductList
              : [..._allproductList, ..._productList.result!.products];
          _prepageno = page;
          _state = 'loaded';
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
    await getProductListing(mounted: mounted, page: page, query: query)
        .whenComplete(() => notifyListeners());
  }
}
