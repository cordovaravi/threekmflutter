import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:threekm/Models/shopModel/cart_hive_model.dart';

class WishListProvider extends ChangeNotifier {
  WishListProvider() {
    openbox();
  }
  openbox() async {
    log('restro wishlist box open');
    _wishBox = await Hive.openBox('shopWishListBox');
  }

  String? _state;
  String? get state => _state;

  Box? _wishBox;
  Box? get wishBoxData => _wishBox;

  addToWishList(
      {image, name, price, id, variationId,variation_name, creatorId, creatorName}) async {
    _state = 'loading';
    try {
      _wishBox = await Hive.openBox('shopWishListBox');
      var wish = CartHiveModel()
        ..image = image
        ..name = name
        ..price = price
        ..id = id
        ..variation_id = variationId
        ..variation_name = variation_name
        ..creatorId = creatorId
        ..creatorName = creatorName;

      var existingItem = _wishBox?.values
          .toList()
          .firstWhere((dd) => dd.id == id, orElse: () => null);

      if (existingItem == null) {
        _wishBox?.add(wish);
        wish.save();
        notifyListeners();
      }
    } catch (e) {
      _state = 'error';
      notifyListeners();
    }
  }

  isinWishList(id) {
    var existingItem = _wishBox?.values
        .toList()
        .firstWhere((dd) => dd.id == id, orElse: () => null);
    return existingItem;
  }

  removeWish(id) {
    CartHiveModel delItem = isinWishList(id);
    try {
      if (delItem != null) {
        // delItem.delete();
        _wishBox?.delete(delItem.key);
        notifyListeners();
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
