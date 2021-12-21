import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:threekm/Models/shopModel/cart_hive_model.dart';
import 'package:threekm/utils/screen_util.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

Future viewCart(BuildContext context) async {
  Box? data = await Hive.openBox('cartBox');
  int totalPrice = 0;

  getBoxTotal(Box data) {
    totalPrice = 0;
    for (var i = 0; i < data.length; i++) {
      CartHiveModel d = data.getAt(i);
      totalPrice = totalPrice + d.price! * d.quantity!;
    }
    return totalPrice;
  }

  return await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: ValueListenableBuilder(
              valueListenable: Hive.box('cartBox').listenable(),
              builder: (context, Box box, widget) {
                //CartHiveModel cartItem = box.getAt(i);

                return Container(
                  // color: Colors.red,
                  padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                  height: ThreeKmScreenUtil.screenHeightDp / 1.5,
                  child: Stack(clipBehavior: Clip.none, children: [
                    data.length != 0
                        ? Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Cart Summary',
                                  style: ThreeKmTextConstants
                                      .tk14PXPoppinsBlackMedium,
                                ),
                                Text(
                                  '\u{20B9}${getBoxTotal(box)}',
                                  style: ThreeKmTextConstants
                                      .tk14PXLatoGreyRegular,
                                )
                              ],
                            ),
                            const Divider(
                              color: Color(0xFFF4F3F8),
                              thickness: 1,
                              height: 35,
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: box.length,
                                padding: const EdgeInsets.only(top: 20),
                                itemBuilder: (_, i) {
                                  CartHiveModel cartItem = box.getAt(i);
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15, bottom: 15),
                                    child: ListTile(
                                      dense: true,
                                      horizontalTitleGap: 2,
                                      contentPadding: EdgeInsets.zero,
                                      // minVerticalPadding: 80,
                                      title: Text(
                                        '${cartItem.name}',
                                        style: ThreeKmTextConstants
                                            .tk14PXPoppinsBlackSemiBold,
                                      ),
                                      subtitle: Text(
                                        '\u{20B9}${cartItem.price}',
                                        style: ThreeKmTextConstants
                                            .tk14PXPoppinsBlueMedium,
                                      ),
                                      leading: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Image(
                                              image: NetworkImage(
                                                  '${cartItem.image}'),
                                              width: 60,
                                              height: 45,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  Container(
                                                width: 60,
                                                height: 45,
                                                color: Colors.grey[350],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: -10,
                                            left: -5,
                                            child: InkWell(
                                              onTap: () {
                                                cartItem.delete();
                                              },
                                              child: const Image(
                                                image: AssetImage(
                                                    'assets/shopImg/closeRed.png'),
                                                width: 24,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      trailing: Container(
                                        padding: const EdgeInsets.all(2),
                                        width: 77,
                                        height: 31,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: const Color(0xFFF4F3F8)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          //mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                if (cartItem.quantity! < 2) {
                                                  cartItem.delete();
                                                }
                                                cartItem.quantity =
                                                    cartItem.quantity! - 1;
                                                if (cartItem.isInBox) {
                                                  cartItem.save();
                                                }
                                              },
                                              child: const Image(
                                                image: AssetImage(
                                                    'assets/shopImg/del.png'),
                                                width: 24,
                                                height: 24,
                                              ),
                                            ),
                                            Text(
                                              '${cartItem.quantity}',
                                              style: ThreeKmTextConstants
                                                  .tk14PXPoppinsBlackSemiBold,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                cartItem.quantity =
                                                    cartItem.quantity! + 1;
                                                cartItem.save();
                                              },
                                              child: const Image(
                                                image: AssetImage(
                                                    'assets/shopImg/add.png'),
                                                width: 24,
                                                height: 24,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                            ElevatedButton.icon(
                                onPressed: () async {},
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                        const StadiumBorder()),
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xFFFF5858)),
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    elevation: MaterialStateProperty.all(5),
                                    shadowColor: MaterialStateProperty.all(
                                        Color(0xFFFC5E6A33)),
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.only(
                                            left: 30,
                                            right: 30,
                                            top: 15,
                                            bottom: 15))),
                                icon: const Icon(Icons.shopping_cart_rounded),
                                label: Text(
                                  'Proceed to Checkout',
                                  style: ThreeKmTextConstants
                                      .tk14PXPoppinsWhiteMedium,
                                )),
                          ])
                        : const Center(child: Text('No Item Found')),
                    Positioned(
                      top: -60,
                      left: ThreeKmScreenUtil.screenWidthDp / 2.5,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white,
                          ),
                          child: const Image(
                            image: AssetImage('assets/shopImg/close.png'),
                            width: 40,
                          ),
                        ),
                      ),
                    )
                  ]),
                );
              }),
        );
      },
      context: context);
}
