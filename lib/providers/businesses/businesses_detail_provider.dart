//businessView

import 'package:flutter/cupertino.dart';
import 'package:threekm/Models/businessesModel/businesses_detail_model.dart';
import 'package:threekm/commenwidgets/commenwidget.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/utils/api_paths.dart';

class BusinessDetailProvider extends ChangeNotifier {
  final ApiProvider _apiProvider = ApiProvider();
  String? _state;
  String? get state => _state;

  // getter for Business home data
  BusinessesDetailModel? _businessesHomedata;
  BusinessesDetailModel? get businessesDetailedata => _businessesHomedata;

  Future<Null> getBusinessesDetail(mounted, id) async {
    if (mounted) {
      _state = 'loading';
      Future.delayed(Duration.zero, () {
        showLoading();
      });
      try {
        final response = await _apiProvider.get(businessView + '?id=$id');
        if (response != null) {
          hideLoading();
          // print(response);
          _businessesHomedata = BusinessesDetailModel.fromJson(response);
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

  Future<void> onRefresh(mounted, id) async {
    await getBusinessesDetail(mounted, id)
        .whenComplete(() => notifyListeners());
  }
}
