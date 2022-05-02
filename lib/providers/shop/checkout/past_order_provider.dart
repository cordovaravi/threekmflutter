import 'package:flutter/cupertino.dart';
import 'package:threekm/Models/shopModel/past_order_model.dart';
import 'package:threekm/commenwidgets/commenwidget.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/utils/api_paths.dart';

class PastOrderProvider extends ChangeNotifier {
  final ApiProvider _apiProvider = ApiProvider();
  String? _state;
  String? get state => _state;

  PastOrderModel _shopPastOrderList = PastOrderModel();
  PastOrderModel get shopPastOrderList => _shopPastOrderList;
  PastOrderModel _menuPastOrderList = PastOrderModel();
  PastOrderModel get MenupastOrderList => _menuPastOrderList;

  getPastShopOrderList(mounted) async {
    if (mounted) {
      _state = 'loading';
      showLoading();

      try {
        final response = await _apiProvider.get(shopPastOrder);
        if (response != null) {
          _shopPastOrderList = PastOrderModel.fromJson(response);
          getPastMenuOrderList(mounted);
          _state = 'loaded';
          hideLoading();
          notifyListeners();
        }
      } catch (e) {
        _state = 'error';
        hideLoading();
        notifyListeners();
      }
    }
  }

  getPastMenuOrderList(mounted) async {
    if (mounted) {
      _state = 'loading';
      showLoading();

      try {
        final response = await _apiProvider.get(menuPastOrder);
        if (response != null) {
          _menuPastOrderList = PastOrderModel.fromJson(response);
          _state = 'loaded';
          hideLoading();
          notifyListeners();
        }
      } catch (e) {
        _state = 'error';
        hideLoading();
        notifyListeners();
      }
    }
  }
}
