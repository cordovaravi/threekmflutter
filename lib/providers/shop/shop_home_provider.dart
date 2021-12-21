import 'package:flutter/cupertino.dart';
import 'package:threekm/Models/shopModel/restaurants_model.dart';
import 'package:threekm/Models/shopModel/shop_home_model.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/utils/api_paths.dart';

class ShopHomeProvider extends ChangeNotifier {
  final ApiProvider _apiProvider = ApiProvider();
  String? _state;
  String? get state => _state;

  // getter for shopHome Data
  ShopHomeModel? _shopHomeData;
  ShopHomeModel? get shopHomeData => _shopHomeData;

  Future<Null> getShopHome(mounted) async {
    if (mounted) {
      try {
        final response = await _apiProvider.get(shopHome);
        if (response != null) {
          // print(response);
          _shopHomeData = ShopHomeModel.fromJson(response);
          _state = 'loaded';
          notifyListeners();
        }
      } on Exception {
        _state = 'error';
        notifyListeners();
      }
    }
  }

  RestaurantsModel? _restaurantData;
  RestaurantsModel? get restaurantData => _restaurantData;
  Future<Null> getRestaurants(requestJson, mounted) async {
    if (mounted) {
      try {
        final response = await _apiProvider.post(restaurants, requestJson);
        _restaurantData = RestaurantsModel.fromJson(response);
        print(response);
        _state = 'loaded';
        notifyListeners();
      } on Exception catch (e) {
        _state = 'error';
        notifyListeners();
      }
    }
  }

  Future<void> onRefresh(requestJson, mounted) async {
    await getShopHome(mounted)
        .whenComplete(() => getRestaurants(requestJson, mounted));
  }
}
