import 'package:flutter/material.dart';
import 'package:threekm/Models/businessesModel/businesses_home_model.dart';
import 'package:threekm/commenwidgets/commenwidget.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/utils/api_paths.dart';

class BusinessesHomeProvider extends ChangeNotifier {
  final ApiProvider _apiProvider = ApiProvider();
  String? _state;
  String? get state => _state;

  // getter for Business home data
  BusinessesHomeModel? _businessesHomedata;
  BusinessesHomeModel? get businessesHomedata => _businessesHomedata;

  Future<Null> getBusinesses(mounted) async {
    if (mounted) {
      showLoading();
      // Future.delayed(Duration.zero, () async {
      //   showLoading();
      // });
      try {
        final response = await _apiProvider.get(businessHome);
        if (response != null) {
          // print(response);
          _businessesHomedata = BusinessesHomeModel.fromJson(response);
          hideLoading();
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

  Future<void> onRefresh(requestJson, mounted) async {
    await getBusinesses(mounted).whenComplete(() => notifyListeners());
  }
}
