import 'package:flutter/material.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/Models/shopModel/product_details_model.dart';
import 'package:threekm/utils/api_paths.dart';

class ProductDetailsProvider extends ChangeNotifier {
  final ApiProvider _apiProvider = ApiProvider();
  String? _state;
  String? get state => _state;

  ProductDetailsModel _productDetails = ProductDetailsModel();

  ProductDetailsModel get ProductDetailsData => _productDetails;

  Future<void> productDetails(mounted, id) async {
    _productDetails = ProductDetailsModel();
    if (mounted) {
      // showLoading();
      _state = 'loading';
      try {
        final response = await _apiProvider.get('$shopView?id=$id');
        if (response != null) {
          // hideLoading();
          // print(response);
          _productDetails = ProductDetailsModel.fromJson(response);
          _state = 'loaded';
          notifyListeners();
        }
      } catch (e) {
        //  hideLoading();
        _state = 'error';
        notifyListeners();
      }
    }
  }

  Future<void> onRefresh(mounted, id) async {
    await productDetails(mounted, id).whenComplete(() => notifyListeners());
  }

  oncleardata() {
    _productDetails = ProductDetailsModel();
  }
}
