import 'package:flutter/cupertino.dart';
import 'package:threekm/Models/home1_model.dart';
import 'package:threekm/commenwidgets/commenwidget.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/utils/api_paths.dart';

class HomefirstProvider extends ChangeNotifier {
  ApiProvider _apiProvider = ApiProvider();
  NewsHomeModel? _homeModel;
  NewsHomeModel? get homeNewsFirst => _homeModel;

  Future<Null> getNewsfirst(requestJson) async {
    try {
      showLoading();
      final response = await _apiProvider.post(getHomePage, requestJson);
      if (response != null) {
        hideLoading();
        _homeModel = NewsHomeModel.fromJson(response);
        print(_homeModel);
        notifyListeners();
      }
    } on Exception catch (e) {
      hideLoading();
      // TODO
    }
  }

  Future<void> onRefresh(requestJson) async {
    await getNewsfirst(requestJson).whenComplete(() => notifyListeners());
  }
}
