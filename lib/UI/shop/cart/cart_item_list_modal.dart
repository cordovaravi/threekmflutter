import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/src/provider.dart';
import 'package:threekm/Models/shopModel/cart_hive_model.dart';
import 'package:threekm/providers/shop/cart_provider.dart';
import 'package:threekm/utils/screen_util.dart';
import 'package:threekm/utils/threekm_textstyles.dart';
import '../../shop/checkout/checkout.dart';
import '../../shop/checkout/restraurant_checkout.dart';

//mode is either shop or restro
Future viewCart(BuildContext context, mode) async {
  Box? data = await Hive.openBox('cartBox');
  Box? restrodata = await Hive.openBox('restroCartBox');
  Box _creatorIDBox = await Hive.openBox('creatorID');
  Box _restroCreatorIDBox = await Hive.openBox('restrocreatorID');
  var creatorName = mode == 'shop'
      ? _creatorIDBox.get('creatorName')
      : _restroCreatorIDBox.get('creatorName') ?? '';
  return await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      builder: (BuildContext context) {
        return ValueListenableBuilder(
            valueListenable: mode == 'shop'
                ? Hive.box('cartBox').listenable()
                : Hive.box('restroCartBox').listenable(),
            builder: (context, Box box, widget) {
              //CartHiveModel cartItem = box.getAt(i);
              if (box.length == 0) {
                mode == 'shop'
                    ? _creatorIDBox.clear()
                    : _restroCreatorIDBox.clear();
              }
              return Container(
                // color: Colors.red,
                padding: const EdgeInsets.only(
                  top: 30,
                ),
                height: ThreeKmScreenUtil.screenHeightDp / 1.46,
                child: Stack(
                    alignment: Alignment.topCenter,
                    clipBehavior: Clip.none,
                    children: [
                      box.length != 0
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Cart Summary',
                                              style: ThreeKmTextConstants
                                                  .tk14PXPoppinsBlackMedium,
                                            ),
                                            SizedBox(
                                              width: 250,
                                              child: Text(
                                                'Items Provided by $creatorName',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            )
                                          ],
                                        ),
                                        Text(
                                          '₹${context.read<CartProvider>().getBoxTotal(box)}',
                                          style: ThreeKmTextConstants
                                              .tk14PXLatoGreyRegular
                                              .copyWith(color: Colors.blue),
                                        )
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    color: Color(0xFFF4F3F8),
                                    thickness: 1,
                                    height: 35,
                                  ),
                                  Container(
                                    // margin: const EdgeInsets.only(left: 20, right: 20),
                                    height:
                                        ThreeKmScreenUtil.screenHeightDp / 2.3,
                                    child: mode == 'shop'
                                        ? ListView.builder(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: box.length,
                                            padding:
                                                const EdgeInsets.only(top: 20),
                                            itemBuilder: (_, i) {
                                              CartHiveModel cartItem =
                                                  box.getAt(i);
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 15,
                                                    bottom: 15,
                                                    left: 20,
                                                    right: 20),
                                                child: ListTile(
                                                  dense: true,
                                                  horizontalTitleGap: 2,
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  // minVerticalPadding: 80,
                                                  title: Text(
                                                    '${cartItem.name}',
                                                    style: ThreeKmTextConstants
                                                        .tk14PXPoppinsBlackSemiBold,
                                                  ),
                                                  subtitle: Text(
                                                    '₹${cartItem.price}',
                                                    style: ThreeKmTextConstants
                                                        .tk14PXPoppinsBlueMedium,
                                                  ),
                                                  leading: Stack(
                                                    clipBehavior: Clip.none,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        child: Image(
                                                          image: NetworkImage(
                                                              '${cartItem.image}'),
                                                          width: 60,
                                                          height: 45,
                                                          errorBuilder: (context,
                                                                  error,
                                                                  stackTrace) =>
                                                              Container(
                                                            width: 60,
                                                            height: 45,
                                                            color: Colors
                                                                .grey[350],
                                                          ),
                                                          loadingBuilder: (_,
                                                              widget,
                                                              loadingProgress) {
                                                            if (loadingProgress ==
                                                                null) {
                                                              return widget;
                                                            }
                                                            return Center(
                                                              child: SizedBox(
                                                                width: 24,
                                                                height: 24,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color: Color(
                                                                      0xFF979EA4),
                                                                  value: loadingProgress
                                                                              .expectedTotalBytes !=
                                                                          null
                                                                      ? loadingProgress
                                                                              .cumulativeBytesLoaded /
                                                                          loadingProgress
                                                                              .expectedTotalBytes!
                                                                      : null,
                                                                ),
                                                              ),
                                                            );
                                                          },
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
                                                    padding:
                                                        const EdgeInsets.all(2),
                                                    width: 77,
                                                    height: 31,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        color: const Color(
                                                            0xFFF4F3F8)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      //mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            if (cartItem
                                                                    .quantity <
                                                                2) {
                                                              cartItem.delete();
                                                            }
                                                            cartItem.quantity =
                                                                cartItem.quantity -
                                                                    1;
                                                            if (cartItem
                                                                .isInBox) {
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
                                                                cartItem.quantity +
                                                                    1;
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
                                            })
                                        : ListView.builder(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: box.length,
                                            padding:
                                                const EdgeInsets.only(top: 20),
                                            itemBuilder: (_, i) {
                                              CartHiveModel cartItem =
                                                  box.getAt(i);
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 15,
                                                    bottom: 15,
                                                    left: 20,
                                                    right: 20),
                                                child: ListTile(
                                                  dense: true,
                                                  horizontalTitleGap: 2,
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  // minVerticalPadding: 80,
                                                  title: Text(
                                                    '${cartItem.name}',
                                                    style: ThreeKmTextConstants
                                                        .tk14PXPoppinsBlackSemiBold,
                                                  ),
                                                  // subtitle: Text(
                                                  //   '₹${cartItem.price}',
                                                  //   style: ThreeKmTextConstants
                                                  //       .tk14PXPoppinsBlueMedium,
                                                  // ),
                                                  // leading: Stack(
                                                  //   clipBehavior: Clip.none,
                                                  //   children: [
                                                  //     ClipRRect(
                                                  //       borderRadius:
                                                  //           BorderRadius.circular(
                                                  //               20),
                                                  //       child: Image(
                                                  //         image: NetworkImage(
                                                  //             '${cartItem.image}'),
                                                  //         width: 60,
                                                  //         height: 45,
                                                  //         errorBuilder: (context,
                                                  //                 error,
                                                  //                 stackTrace) =>
                                                  //             Container(
                                                  //           width: 60,
                                                  //           height: 45,
                                                  //           color: Colors.grey[350],
                                                  //         ),
                                                  //         loadingBuilder: (_,
                                                  //             widget,
                                                  //             loadingProgress) {
                                                  //           if (loadingProgress ==
                                                  //               null) {
                                                  //             return widget;
                                                  //           }
                                                  //           return Center(
                                                  //             child: SizedBox(
                                                  //               width: 24,
                                                  //               height: 24,
                                                  //               child:
                                                  //                   CircularProgressIndicator(
                                                  //                 color: Color(
                                                  //                     0xFF979EA4),
                                                  //                 value: loadingProgress
                                                  //                             .expectedTotalBytes !=
                                                  //                         null
                                                  //                     ? loadingProgress
                                                  //                             .cumulativeBytesLoaded /
                                                  //                         loadingProgress
                                                  //                             .expectedTotalBytes!
                                                  //                     : null,
                                                  //               ),
                                                  //             ),
                                                  //           );
                                                  //         },
                                                  //       ),
                                                  //     ),
                                                  //     Positioned(
                                                  //       top: -10,
                                                  //       left: -5,
                                                  //       child: InkWell(
                                                  //         onTap: () {
                                                  //           cartItem.delete();
                                                  //         },
                                                  //         child: const Image(
                                                  //           image: AssetImage(
                                                  //               'assets/shopImg/closeRed.png'),
                                                  //           width: 24,
                                                  //         ),
                                                  //       ),
                                                  //     )
                                                  //   ],
                                                  // ),
                                                  trailing: Container(
                                                    width: 130,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2),
                                                          width: 77,
                                                          height: 31,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30),
                                                              color: const Color(
                                                                  0xFFF4F3F8)),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            //mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  if (cartItem
                                                                          .quantity <
                                                                      2) {
                                                                    cartItem
                                                                        .delete();
                                                                  }
                                                                  cartItem.quantity =
                                                                      cartItem.quantity -
                                                                          1;
                                                                  if (cartItem
                                                                      .isInBox) {
                                                                    cartItem
                                                                        .save();
                                                                  }
                                                                },
                                                                child:
                                                                    const Image(
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
                                                                      cartItem.quantity +
                                                                          1;
                                                                  cartItem
                                                                      .save();
                                                                },
                                                                child:
                                                                    const Image(
                                                                  image: AssetImage(
                                                                      'assets/shopImg/add.png'),
                                                                  width: 24,
                                                                  height: 24,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Text(
                                                          '₹${cartItem.price! * cartItem.quantity}',
                                                          style: ThreeKmTextConstants
                                                              .tk14PXPoppinsBlueMedium,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, bottom: 20),
                                    child: ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => mode == 'shop'
                                                      ? CheckOutScreen()
                                                      : RestaurantsCheckOutScreen()));
                                        },
                                        style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                                const StadiumBorder()),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    const Color(0xFFFF5858)),
                                            foregroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.white),
                                            elevation:
                                                MaterialStateProperty.all(5),
                                            shadowColor:
                                                MaterialStateProperty.all(
                                                    Color(0xFFFC5E6A33)),
                                            padding: MaterialStateProperty.all(
                                                const EdgeInsets.only(
                                                    left: 30,
                                                    right: 30,
                                                    top: 15,
                                                    bottom: 15))),
                                        icon: const Icon(
                                            Icons.shopping_cart_rounded),
                                        label: Text(
                                          'Proceed to Checkout',
                                          style: ThreeKmTextConstants
                                              .tk14PXPoppinsWhiteMedium,
                                        )),
                                  ),
                                ])
                          : const Center(child: Text('No Item Found')),
                      Positioned(
                        top: -60,
                        //left: ThreeKmScreenUtil.screenWidthDp / 2,
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
            });
      },
      context: context);
}
