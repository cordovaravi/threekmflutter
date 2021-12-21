import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:threekm/Models/shopModel/cart_hive_model.dart';
import 'package:threekm/widgets/shop/cart/clear_and_add_to_cart.dart';

class CartProvider extends ChangeNotifier {
  String? _state;
  String? get state => _state;

  Box? _cartBox;
  Box? get cartBoxData => _cartBox;

  addToCart(image, name, quantity, price, id, variationId) async {
    _state = 'loading';
    try {
      _cartBox = await Hive.openBox('cartBox');
      var cart = CartHiveModel()
        ..image = image
        ..name = name
        ..quantity = quantity
        ..price = price
        ..id = id
        ..variationId = variationId;

      var existingItem = _cartBox?.values
          .toList()
          .firstWhere((dd) => dd.id == id, orElse: () => null);

      if (existingItem == null) {
        _cartBox?.add(cart);
        cart.save();
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

  getAllCart(
      {context,
      creatorId,
      image,
      name,
      quantity,
      price,
      id,
      variationId}) async {
    Box _creatorIDBox = await Hive.openBox('creatorID');

    if (_creatorIDBox.isEmpty) {
      _creatorIDBox.put('id', creatorId);
      addToCart(image, name, quantity, price, id, variationId);
      print('>>>>>>>>>>>>>>>>>>>>');
    } else {
      var Cid = _creatorIDBox.get('id');
      if (creatorId == Cid) {
        addToCart(image, name, quantity, price, id, variationId);
        print('<<<<<<<<<<<<<<<<<<<<<<<<<');
      } else {
        _creatorIDBox.clear();
        clearAndAddToCartModal(
            context, image, name, quantity, price, id, variationId);
      }
    }

    notifyListeners();
  }
}
