import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threekm/Models/shopModel/cuisinesListModel.dart';
import 'package:threekm/Models/shopModel/cuisines_restaurants_list_model.dart';
import 'package:threekm/Models/shopModel/restaurants_menu_model.dart';
import 'package:threekm/commenwidgets/commenwidget.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/utils/api_paths.dart';
import 'package:http/http.dart' as http;

class RestaurantMenuProvider extends ChangeNotifier {
  final ApiProvider _apiProvider = ApiProvider();
  String? _state;
  String? get state => _state;

  RestaurantMenuModel _menuDetails = RestaurantMenuModel(StatusCode: 0);
  CuisinesListModel _cuisinesListdata = CuisinesListModel();
  CuisinesRestroList _cuisinesRestroListData = CuisinesRestroList();

  RestaurantMenuModel get menuDetails => _menuDetails;
  CuisinesListModel get cuisinesListdata => _cuisinesListdata;
  CuisinesRestroList get cuisinesRestroListData => _cuisinesRestroListData;

  Future<void> menuDetailsData(mounted, id) async {
    if (mounted) {
      showLoading();
      _state = 'loading';
      _menuDetails = RestaurantMenuModel(StatusCode: 0);
      try {
        final response = await _apiProvider.get('$restaurantMenu?id=$id');
        if (response != null) {
          hideLoading();
          // print(response);
          _menuDetails = RestaurantMenuModel.fromJson(response);
          _state = 'loaded';
          notifyListeners();
        }
      } catch (e) {
        log('======1111${e}');
        hideLoading();
        _state = 'error';
        notifyListeners();
      }
    }
  }

  Future<void> cuisinesList(mounted) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (await _apiProvider.getConnectivityStatus()) {
      if (mounted) {
        // showLoading();
        _state = 'loading';
        try {
          final response =
              await _apiProvider.post(cuisinesListAPI, jsonEncode({}));

          if (response != null) {
            //  hideLoading();
            // print(response);
            _cuisinesListdata = CuisinesListModel.fromJson(response);
            _state = 'loaded';
            notifyListeners();
          }
        } catch (e) {
          // hideLoading();
          _state = 'error';
          notifyListeners();
        }
      }
    } else {
      Fluttertoast.showToast(msg: "No InterNet connection");
      String? rawModel = _prefs.getString("cuisinesModel");
      if (rawModel != null) {
        _cuisinesListdata = CuisinesListModel.fromJson(json.decode(rawModel));
        _state = 'loaded';
        notifyListeners();
      }
    }
  }

  Future<void> cuisinesClick(mounted, query) async {
    if (mounted) {
      showLoading();
      _state = 'loading';
      try {
        final response = await _apiProvider.post(
            cuisinesOnClickAPI,
            jsonEncode({
              "cuisines": [query]
            }));

        if (response != null) {
          hideLoading();
          // print(response);
          _cuisinesRestroListData = CuisinesRestroList.fromJson(response);
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
}
