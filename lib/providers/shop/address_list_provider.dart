import 'package:flutter/material.dart';
import 'package:threekm/Models/shopModel/address_list_model.dart';
import 'package:threekm/commenwidgets/commenwidget.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/utils/api_paths.dart';

class AddressListProvider extends ChangeNotifier {
  final ApiProvider _apiProvider = ApiProvider();
  String? _state;
  String? get state => _state;
  AddressListModel _addressList = AddressListModel();

  AddressListModel get getAddressListData => _addressList;

  Future<void> getAddressList(mounted) async {
    if (mounted) {
      _state = 'loading';
      showLoading();
      try {
        final response = await _apiProvider.get(address_list);
        if (response != null) {
          hideLoading();
          // print(response);
          _addressList = AddressListModel.fromJson(response);
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
