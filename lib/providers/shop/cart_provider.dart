import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:threekm/Models/shopModel/cart_hive_model.dart';
import 'package:threekm/UI/shop/cart/clear_and_add_to_cart.dart';

class CartProvider extends ChangeNotifier {
  String? _state;
  String? get state => _state;

  Box? _cartBox;
  Box? get cartBoxData => _cartBox;
  Box? _restroCartBox;
  Box? get restroCartBoxData => _restroCartBox;

  addToCart(image, name, quantity, price, id, variationId, variation_name, weight, creatorId,
      creatorName) async {
    _state = 'loading';
    Box _creatorIDBox = await Hive.openBox('creatorID');
    _creatorIDBox.put('creatorName', creatorName);
    try {
      _cartBox = await Hive.openBox('cartBox');
      var cart = CartHiveModel()
        ..image = image
        ..name = name
        ..quantity = quantity ?? 1
        ..price = price ?? 0
        ..id = id
        ..variation_id = variationId
        ..variation_name = variation_name
        ..weight = weight
        ..creatorId = creatorId
        ..creatorName = creatorName;

      if (variationId != null && variationId != 0) {
        var existingItem = _cartBox?.values.toList().firstWhere(
            (dd) => dd.variation_id == variationId,
            orElse: () => null);
        if (existingItem == null) {
          _cartBox?.add(cart);
          print('>>>>>>>>>>>>>>>>>>>>>>');
          cart.save();
        } else {
          print('not added');
        }
      } else {
        var existingItem = _cartBox?.values
            .toList()
            .firstWhere((dd) => dd.id == id, orElse: () => null);
        if (existingItem == null) {
          _cartBox?.add(cart);
          print('>>>>>>>>>>>>>>>>>>>>>>');
          cart.save();
        } else {
          print('not added');
        }
      }

      _state = 'loaded';
      notifyListeners();
    } catch (e) {
      _state = 'error';
      notifyListeners();
    }
  }

  addItemToCart(
      {context,
      creatorId,
      image,
      name,
      quantity,
      price,
      id,
      variationId,
      variation_name,
      weight,
      creatorName}) async {
    Box _creatorIDBox = await Hive.openBox('creatorID');
    _cartBox = await Hive.openBox('cartBox');
    if (_cartBox!.length < 0) {
      _creatorIDBox.clear();
    }
    if (_creatorIDBox.isEmpty) {
      _creatorIDBox.put('id', creatorId);
      _creatorIDBox.put('creatorName', creatorName);
      addToCart(image, name, quantity, price, id, variationId,variation_name, weight,
          creatorId, creatorName);
    } else {
      var Cid = _creatorIDBox.get('id');
      if (creatorId == Cid) {
        addToCart(image, name, quantity, price, id, variationId,variation_name, weight,
            creatorId, creatorName);
      } else {
        clearAndAddToCartModal(context, image, name, quantity, price, creatorId,
            id, variationId, weight, creatorName, 'shop');
      }
    }

    notifyListeners();
  }

// restaurants
  addToRestaurantCart(
      image, name, quantity, price, id, variationId, weight) async {
    _state = 'loading';
    try {
      _restroCartBox = await Hive.openBox('restroCartBox');
      var cart = CartHiveModel()
        ..image = image
        ..name = name
        ..quantity = quantity ?? 1
        ..price = price ?? 0
        ..id = id
        ..variation_id = variationId
        ..weight = weight;

      var existingItem = _restroCartBox?.values
          .toList()
          .firstWhere((dd) => dd.id == id, orElse: () => null);

      if (existingItem == null) {
        _restroCartBox?.add(cart).catchError((e) {
          log(e);
        });
        print('>>>>>>>>>>>>>>>>>>>>>>');
        cart.save();

        log('${_restroCartBox?.length.toString()}');
      } else {
        print('not added');
      }

      _state = 'loaded';
      notifyListeners();
    } catch (e) {
      _state = 'error';
      notifyListeners();
    }
  }

  addItemToRestroCart(
      {context,
      creatorId,
      image,
      name,
      quantity,
      price,
      id,
      variationId,
      weight,
      creatorName,
      refresh}) async {
    Box _restrocreatorIDBox = await Hive.openBox('restrocreatorID');

    if (_restrocreatorIDBox.isEmpty) {
      _restrocreatorIDBox.put('id', creatorId);
      _restrocreatorIDBox.put('creatorName', creatorName);
      addToRestaurantCart(
          image, name, quantity, price, id, variationId, weight);
    } else {
      var Cid = _restrocreatorIDBox.get('id');
      if (creatorId == Cid) {
        addToRestaurantCart(
            image, name, quantity, price, id, variationId, weight);
      } else {
        clearAndAddToCartModal(context, image, name, quantity, price, creatorId,
            id, variationId, weight, creatorName, 'restro');
      }
    }

    notifyListeners();
  }

  getBoxTotal(Box data) {
    num totalPrice = 0;
    for (var i = 0; i < data.length; i++) {
      CartHiveModel d = data.getAt(i);
      totalPrice = totalPrice + d.price! * d.quantity;
    }
    return totalPrice;
  }

  getBoxWeightTotal(Box data) {
    var totalWeight = 0.0;
    for (var i = 0; i < data.length; i++) {
      CartHiveModel d = data.getAt(i);
      totalWeight = totalWeight.toDouble() +
          (d.weight ?? 0).toDouble() * d.quantity.toDouble();
    }
    return totalWeight;
  }
}
