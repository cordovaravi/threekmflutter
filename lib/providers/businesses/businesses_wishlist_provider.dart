import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:threekm/Models/businessesModel/businesses_wishlist_model.dart';

class BusinessesWishListProvider extends ChangeNotifier {
  BusinessesWishListProvider() {
    openBox();
  }

  openBox() async {
    _businessWishBox = await Hive.openBox('businessWishListBox');
  }

  String? _state;
  String? get state => _state;

  Box? _businessWishBox;
  Box? get wishBoxData => _businessWishBox;

  addToBusinessWishList({name, address, logo, creatorId}) async {
    _state = 'loading';

    try {
      _businessWishBox = await Hive.openBox('businessWishListBox');
      var favourite = BusinesseswishListHiveModel()
        ..name = name
        ..address = address
        ..logo = logo
        ..creatorId = creatorId;

      // var existingItem = _businessWishBox?.values
      //   .toList()
      //   .firstWhere((dd) => dd.creatorId == creatorId, orElse: () => null);

      var existingItem = isinWishList(creatorId);

      if (existingItem == null) {
        _businessWishBox?.add(favourite);
        favourite.save();
        notifyListeners();
      }
    } catch (e) {
      _state = 'error';
      notifyListeners();
    }
  }

  isinWishList(creatorId) {
    var existingItem = _businessWishBox?.values.toList().firstWhere(
        (business) => business.creatorId == creatorId,
        orElse: () => null);
    return existingItem;
  }

  removeWish(id) {
    _businessWishBox?.values.toList().firstWhere((business) {
      business.delete();
      notifyListeners();
      return true;
    }, orElse: () => null);
  }
}
