import 'package:flutter/cupertino.dart';
import 'package:threekm/Models/shopModel/restaurants_menu_model.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/utils/api_paths.dart';

class RestaurantMenuProvider extends ChangeNotifier {
  final ApiProvider _apiProvider = ApiProvider();
  String? _state;
  String? get state => _state;

  RestaurentMenuModel _menuDetails = RestaurentMenuModel(StatusCode: 0);

  RestaurentMenuModel get menuDetails => _menuDetails;

  Future<void> menuDetailsData(mounted, id) async {
    if (mounted) {
      try {
        final response = await _apiProvider.get('$restaurantMenu?id=$id');
        if (response != null) {
          // hideLoading();
          // print(response);
          _menuDetails = RestaurentMenuModel.fromJson(response);
          _state = 'loaded';
          notifyListeners();
        }
      } catch (e) {
        _state = 'error';
        notifyListeners();
      }
    }
  }
}
