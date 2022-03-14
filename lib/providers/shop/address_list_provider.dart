import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:threekm/Models/shopModel/address_list_model.dart';
import 'package:threekm/commenwidgets/commenwidget.dart';
import 'package:threekm/main.dart';
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
          // print(response);
          _addressList = AddressListModel.fromJson(response);
          _state = 'loaded';
          hideLoading();
          notifyListeners();
        }
      } catch (e) {
        hideLoading();
        _state = 'error';
        notifyListeners();
      }
    }
  }

  addNewAddress(mounted, requestJson) async {
    var selectedAddress = await Hive.openBox('selectedAddress');
    if (mounted) {
      _state = 'loading';
      showLoading();
      try {
        final response = await _apiProvider.post(address_add, requestJson);
        if (response != null) {
          hideLoading();
          if (response['status'] == 'success') {
            _state = 'loaded';
            getAddressList(mounted);
            selectedAddress.put('address', response['choosen_address']);
            navigatorKey.currentState?.pop();
            navigatorKey.currentState?.pop();
            notifyListeners();
          } else {
            showMessage(response['message']);
          }
          // print(response);
          // _addressList = AddressListModel.fromJson(response);

        }
      } catch (e) {
        hideLoading();
        _state = 'error';
        notifyListeners();
      }
    }
  }
}
