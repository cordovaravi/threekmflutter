import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/src/provider.dart';

import 'package:threekm/providers/shop/cart_provider.dart';

Future clearAndAddToCartModal(context, image, name, quantity, price, creatorId,
    id, variationId, weight, mode) async {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text('Replace cart item?'), // To display the title it is optional
          content: Text(
              'Your cart contains dishes from other sources. Do you want to discard the selection and add current dishes?'), // Message which will be pop up on the screen
          // Action widget which will provide the user to acknowledge the choice
          actions: [
            TextButton(
              // FlatButton widget is used to make a text to work like a button

              onPressed:
                  () {}, // function used to perform after pressing the button
              child: Text('NO'),
            ),
            TextButton(
              onPressed: () async {
                if (mode == 'shop') {
                  var cartProvider = context.read<CartProvider>();
                  var cartBox = await Hive.openBox('cartBox');
                  Box _creatorIDBox = await Hive.openBox('creatorID');
                  _creatorIDBox.clear().then((value) => _creatorIDBox
                      .put('id', creatorId)
                      .then((value) => cartBox
                          .clear()
                          .then((value) => cartProvider.addItemToCart(
                                context: context,
                                creatorId: creatorId,
                                image: image,
                                name: name,
                                price: price,
                                quantity: 1,
                                id: id,
                                variationId: 0,
                                weight: weight,
                              ))));

                  // await cartProvider.addToCart(
                  //     image, name, quantity, price, id, variationId, weight);

                  Navigator.pop(context);
                  log(_creatorIDBox.get('id').toString());
                } else {
                  var cartProvider = context.read<CartProvider>();
                  var restrocartBox = await Hive.openBox('restroCartBox');
                  Box _restrocreatorID = await Hive.openBox('restrocreatorID');
                  _restrocreatorID.clear().then((value) => _restrocreatorID
                      .put('id', creatorId)
                      .then((value) => restrocartBox.clear().then((value) =>
                          cartProvider.addItemToRestroCart(
                              context: context,
                              creatorId: creatorId,
                              image: image,
                              name: name,
                              price: price,
                              quantity: 1,
                              id: id,
                              variationId: 0,
                              weight: weight))));

                  // Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => RestaurantMenu(
                  //               data: creator,
                  //             )));
                  Navigator.pop(context);
                  log('${restrocartBox.length}////////');
                }
              },
              child: Text('YES'),
            ),
          ],
        );
      });
}
