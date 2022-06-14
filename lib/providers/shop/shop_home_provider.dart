import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threekm/Models/shopModel/biryani_restro_model.dart'
    as BiryaniModel;
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

  // getter for biryani restro Data
  BiryaniModel.BiryaniRestroModel? _biryaniRestroData;
  BiryaniModel.BiryaniRestroModel? get biryaniRestroData => _biryaniRestroData;

  List<Creators>? _allCreators = [];
  List<Creators>? get allCreators => _allCreators;

  Future<Null> getShopHome(mounted) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (await _apiProvider.getConnectivityStatus()) {
      if (mounted) {
        _state = 'loading';
        // showLoading();
        //showLayoutLoading();
        try {
          final response = await _apiProvider.get(shopHome);
          if (response != null) {
            // print(response);
            _shopHomeData = ShopHomeModel.fromJson(response);
            _prefs.remove("shopModel");
            String offlineStringObj = json.encode(response);
            _prefs.setString("shopModel", offlineStringObj);
            getRestaurants(mounted, 1);
            _state = 'loaded';
            //  hideLoading();
            notifyListeners();
          }
        } on Exception {
          _state = 'error';
          //  hideLoading();
          notifyListeners();
        }
      } else {
        log(' some error ');
      }
    } else {
      Fluttertoast.showToast(msg: "No InterNet connection");
      String? rawModel = _prefs.getString("shopModel");
      if (rawModel != null) {
        _shopHomeData = ShopHomeModel.fromJson(json.decode(rawModel));
        _state = 'loaded';
        notifyListeners();
      } else {
        _state = 'loading';
      }
    }
  }

  RestaurantsModel? _restaurantData;
  RestaurantsModel? get restaurantData => _restaurantData;
  Future<Null> getRestaurants(mounted, page, {query, lat, lng}) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (await _apiProvider.getConnectivityStatus()) {
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
          if (response != null && query == null) {
            _prefs.remove("restroModel");
            String offlineStringObj = json.encode(response);
            _prefs.setString("restroModel", offlineStringObj);
            _restaurantData = RestaurantsModel.fromJson(response);

            _allCreators = page == _prepageno
                ? _allCreators
                : [...?_allCreators, ...?_restaurantData!.result.creators];
            print(response);
            _state = 'loaded';
            _prepageno = page;
            notifyListeners();
          } else if (response != null && query != null) {
            _restaurantData = RestaurantsModel.fromJson(response);
            clearrestaurantListState(mounted, isPagechange: false);
            _allCreators = _restaurantData!.result.creators;
            log('${_allCreators?.length}');
            _state = 'loaded';
            notifyListeners();
          }
        } on Exception catch (e) {
          _state = 'error';
          notifyListeners();
        }
      }
    } else {
      Fluttertoast.showToast(msg: "No InterNet connection");
      String? rawModel = _prefs.getString("restroModel");
      if (rawModel != null) {
        _restaurantData = RestaurantsModel.fromJson(json.decode(rawModel));
        _allCreators = _restaurantData!.result.creators;
        _state = 'loaded';
        notifyListeners();
      } else {
        _state = 'loading';
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

  BiryaniRestro(mounted) async {
    if (mounted) {
      _state = 'loading';
      try {
        final response = await _apiProvider.post(biryaniRestroAPI, null);
        if (response != null && response['StatusCode'] == 200) {
          _biryaniRestroData =
              BiryaniModel.BiryaniRestroModel.fromJson(response);
          _state = 'loaded';
          notifyListeners();
        }
      } catch (e) {
        _state = 'error';
        notifyListeners();
      }
    }
  }

  Future<void> onRefresh(requestJson, mounted) async {
    await getShopHome(mounted).whenComplete(() => getRestaurants(mounted, 1));
  }
}
