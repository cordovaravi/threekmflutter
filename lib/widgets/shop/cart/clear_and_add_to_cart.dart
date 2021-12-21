import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/src/provider.dart';
import 'package:threekm/utils/screen_util.dart';
import 'package:threekm/utils/threekm_textstyles.dart';
import 'package:threekm/providers/shop/cart_provider.dart';

Future clearAndAddToCartModal(
    context, image, name, quantity, price, id, variationId) async {
  return await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      builder: (BuildContext context) {
        return Container(
            padding: EdgeInsets.only(top: 30, left: 20, right: 20),
            height: ThreeKmScreenUtil.screenHeightDp / 3,
            child: Column(
              children: [
                Text(
                  'Do you want to Clear Previous Item and Save this Item ?',
                  style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold,
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: ThreeKmScreenUtil.screenWidthDp / 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.red[400], shape: BoxShape.circle),
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.close),
                              color: Colors.white,
                              iconSize: 30,
                            )),
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.green[400],
                                shape: BoxShape.circle),
                            child: IconButton(
                              onPressed: () async {
                                var cartProvider = context.read<CartProvider>();
                                var cartBox = await Hive.openBox('cartBox');
                                cartBox.clear().whenComplete(() async {
                                  await cartProvider.addToCart(image, name,
                                      quantity, price, id, variationId);
                                });
                              },
                              icon: const Icon(Icons.add),
                              color: Colors.white,
                              iconSize: 30,
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ));
      },
      context: context);
}
