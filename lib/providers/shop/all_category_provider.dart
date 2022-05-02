import 'package:flutter/material.dart';
import 'package:threekm/commenwidgets/commenwidget.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/Models/shopModel/all_category_model.dart';
import 'package:threekm/utils/api_paths.dart';

class AllCategoryListProvider extends ChangeNotifier {
  final ApiProvider _apiProvider = ApiProvider();
  String? _state;
  String? get state => _state;
  AllCategoryListModel _allCategoryList = AllCategoryListModel();

  AllCategoryListModel get allCategoryListData => _allCategoryList;

  Future<void> getAllCategory(mounted) async {
    if (mounted) {
      showLoading();
      try {
        final response = await _apiProvider.get(allCategoryList);
        if (response != null) {
          hideLoading();
          // print(response);
          _allCategoryList = AllCategoryListModel.fromJson(response);
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

  Future<void> onRefresh(mounted) async {
    await getAllCategory(mounted).whenComplete(() => notifyListeners());
  }

  oncleardata() {
    _allCategoryList = AllCategoryListModel();
  }
}
