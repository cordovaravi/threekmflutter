import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:provider/src/provider.dart';
import 'package:threekm/commenwidgets/commenwidget.dart';
import 'package:threekm/main.dart';

import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/Models/shopModel/restaurants_model.dart';
import 'package:threekm/Models/shopModel/shop_home_model.dart';
import 'package:threekm/providers/Location/locattion_Provider.dart';
import 'package:threekm/utils/api_paths.dart';

class ShopHomeProvider extends ChangeNotifier {
  final ApiProvider _apiProvider = ApiProvider();
  final LocationProvider _locationProvider = LocationProvider();
  String? _state;
  String? get state => _state;

  int _prepageno = 0;
  get prepageno => _prepageno;

  // getter for shopHome Data
  ShopHomeModel? _shopHomeData;
  ShopHomeModel? get shopHomeData => _shopHomeData;

  List<Creators>? _allCreators = [];
  List<Creators>? get allCreators => _allCreators;

  Future<Null> getShopHome(mounted) async {
    if (mounted) {
      _state = 'loading';
      showLoading();
      try {
        final response = await _apiProvider.get(shopHome);
        if (response != null) {
          // print(response);
          _shopHomeData = ShopHomeModel.fromJson(response);

          getRestaurants(mounted, 1);
          _state = 'loaded';
          hideLoading();
          notifyListeners();
        }
      } on Exception {
        _state = 'error';
        hideLoading();
        notifyListeners();
      }
    } else {
      log(' some error ');
    }
  }

  RestaurantsModel? _restaurantData;
  RestaurantsModel? get restaurantData => _restaurantData;
  Future<Null> getRestaurants(mounted, page, {query, lat, lng}) async {
    _state = 'loading';
    final _location =
        navigatorKey.currentContext!.read<LocationProvider>().getlocationData;
    // final _location = _locationProvider.getlocationData;
    var requestJson = json.encode(query != null
        ? {
            "lat": lat != null ? lat : _location?.latitude ?? '',
            "lng": lng != null ? lng : _location?.longitude ?? '',
            "page": page,
            'query': query
          }
        : {
            "lat": lat != null ? lat : _location?.latitude ?? '',
            "lng": lng != null ? lng : _location?.longitude ?? '',
            "page": page
          });
    log('${requestJson.toString()}++++++++++++++++++++++++++');
    if (mounted) {
      try {
        final response = await _apiProvider.post(restaurants, requestJson);
        if (response != null) {
          _restaurantData = RestaurantsModel.fromJson(response);
          _allCreators = page == _prepageno
              ? _allCreators
              : [...?_allCreators, ...?_restaurantData!.result.creators];
          print(response);
          _state = 'loaded';
          _prepageno = page;
          notifyListeners();
        }
      } on Exception catch (e) {
        _state = 'error';
        notifyListeners();
      }
    }
  }

  clearrestaurantListState(mounted, {bool isPagechange = true}) {
    if (mounted) {
      if (isPagechange) {
        _allCreators = [];
        _prepageno = 0;
        // notifyListeners();
      } else {
        _allCreators = [];
      }
    }
  }

  Future<void> onRefresh(requestJson, mounted) async {
    await getShopHome(mounted).whenComplete(() => getRestaurants(mounted, 1));
  }
}
