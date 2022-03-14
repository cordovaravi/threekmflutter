import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/src/provider.dart';
import 'package:threekm/Models/businessesModel/businesses_wishlist_model.dart';
import 'package:threekm/Models/shopModel/cart_hive_model.dart';
import 'package:threekm/UI/businesses/businesses_detail.dart';
import 'package:threekm/UI/shop/cart/cart_item_list_modal.dart';
import 'package:threekm/UI/shop/product/product_details.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/localization/localize.dart';
import 'package:threekm/providers/shop/cart_provider.dart';
import 'package:threekm/utils/screen_util.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

class WishList extends StatefulWidget {
  const WishList({Key? key}) : super(key: key);

  @override
  State<WishList> createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  String filterLabel = 'Products';

  @override
  void initState() {
    getWishBoxData();
    super.initState();
  }

  getWishBoxData() async {
    await Hive.openBox('shopWishListBox');
    await Hive.openBox('businessWishListBox');
  }

  isProductExist(box, id, {variationId}) {
    if (variationId != null && variationId != 0) {
      var existingItem = box.values.toList().firstWhere(
          (dd) => dd.variation_id == variationId,
          orElse: () => null);
      return existingItem;
    } else {
      var existingItem = box.values
          .toList()
          .firstWhere((dd) => dd.id == id, orElse: () => null);
      return existingItem;
    }
  }

  @override
  void didChangeDependencies() {
    ThreeKmScreenUtil.getInstance();
    ThreeKmScreenUtil.instance.init(context);
    super.didChangeDependencies();
  }

//businessWishListBox
  @override
  Widget build(BuildContext context) {
    getWishBoxData();
    var wishbox = Hive.box('shopWishListBox');
    var businessWishbox = Hive.box('businessWishListBox');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Text(
            'MY WISHLIST',
          ),
          titleTextStyle: const TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          actions: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                        color: Colors.grey[200], shape: BoxShape.circle),
                    child: IconButton(
                        onPressed: () {
                          viewCart(context, 'shop');
                        },
                        icon: const Icon(
                          Icons.shopping_cart_rounded,
                          size: 30,
                        ))),
                ValueListenableBuilder(
                    valueListenable: Hive.box('cartBox').listenable(),
                    builder: (context, Box box, snapshot) {
                      return Positioned(
                          top: 0,
                          right: 6,
                          child: box.length != 0
                              ? Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      '${box.length}',
                                      style: TextStyle(
                                          fontSize: 11, color: Colors.white),
                                    ),
                                  ))
                              : Container());
                    }),
              ],
            )
          ],
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/shopImg/wishlistImg.png'),
                width: 233,
                height: 181,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  'Click on the Heart Symbol on products and businesses to save them here for later.',
                  textAlign: TextAlign.center,
                  style: ThreeKmTextConstants.tk14PXPoppinsBlackSemiBold,
                ),
              ),
              FittedBox(
                child: Container(
                  width: ThreeKmScreenUtil.screenWidthDp / 1.2,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFFF4F3F8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                                onPressed: () {
                                  log('product');
                                  setState(() {
                                    filterLabel = 'Products';
                                  });
                                },
                                child: Text('Products',
                                    style: ThreeKmTextConstants
                                        .tk14PXPoppinsBlackSemiBold)),
                            TextButton(
                                onPressed: () {
                                  log('Businesses');
                                  setState(() {
                                    filterLabel = 'Businesses';
                                  });
                                },
                                child: Text('Businesses',
                                    style: ThreeKmTextConstants
                                        .tk14PXPoppinsBlackSemiBold))
                          ],
                        ),
                      ),
                      AnimatedAlign(
                        alignment: filterLabel == 'Products'
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        duration: const Duration(milliseconds: 500),
                        child: Container(
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 10,
                                    offset: Offset(0, 3),
                                    color: Color(0xFF0F0F2D33))
                              ]),
                          width: 150,
                          height: 45,
                          child: Center(
                            child: Text(
                              filterLabel,
                              style: ThreeKmTextConstants
                                  .tk14PXPoppinsBlackSemiBold
                                  .copyWith(color: Color(0xFF3E7EFF)),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              filterLabel == 'Products'
                  ? wishbox.length != 0
                      ? GridView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(
                              top: 20, bottom: 20, left: 10, right: 10),
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisExtent: 250,
                                  //childAspectRatio: 0.68,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          itemCount: wishbox.length,
                          itemBuilder: (_, i) {
                            CartHiveModel data = wishbox.getAt(i);
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                        pageBuilder: (context, animaton,
                                            secondaryAnimation) {
                                          return ProductDetails(
                                            id: data.id ?? 0,
                                          );
                                        },
                                        transitionDuration:
                                            const Duration(milliseconds: 800),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          animation = CurvedAnimation(
                                              parent: animation,
                                              curve: Curves.easeInOut);
                                          return FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          );
                                        }));
                              },
                              child: Container(
                                  height: 250,
                                  width: 100,
                                  margin: EdgeInsets.only(bottom: 20),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color(0xFF32335E26),
                                            blurRadius: 10,
                                            // spreadRadius: 5,
                                            offset: Offset(0, 6))
                                      ]),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        flex: 2,
                                        child: Stack(
                                          children: [
                                            SizedBox(
                                              height: 180.0,
                                              width: double.infinity,
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(20)),
                                                child: CachedNetworkImage(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  placeholder: (context, url) =>
                                                      Transform.scale(
                                                    scale: 0.2,
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.grey[400],
                                                    ),
                                                  ),
                                                  imageUrl: '${data.image}',
                                                  // height: ThreeKmScreenUtil.screenHeightDp / 3,
                                                  // width: ThreeKmScreenUtil.screenWidthDp,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    data.delete();
                                                    setState(() {});
                                                  },
                                                  child: Image(
                                                      image: AssetImage(
                                                          'assets/shopImg/closeRed.png'),
                                                      width: 24,
                                                      height: 24),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        // flex: 1,
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              left: 16, right: 16, top: 5),
                                          alignment: Alignment.centerLeft,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${data.name}',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: ThreeKmTextConstants
                                                    .tk14PXPoppinsBlackBold,
                                              ),
                                              if (data.variation_name != null &&
                                                  data.variation_name != "")
                                                Text(
                                                  '${data.variation_name}mm',
                                                  maxLines: 2,
                                                  style: ThreeKmTextConstants
                                                      .tk12PXPoppinsBlackSemiBold
                                                      .copyWith(
                                                          color: Colors.grey),
                                                ),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                  child: Text(
                                                    '₹${data.price}',
                                                    style: ThreeKmTextConstants
                                                        .tk14PXLatoBlackBold
                                                        .copyWith(
                                                            color: Color(
                                                                0xFFFC8338)),
                                                  )),
                                              Spacer(),
                                              // Padding(
                                              //   padding: const EdgeInsets.only(
                                              //       bottom: 10),
                                              //   child: Row(
                                              //     mainAxisAlignment:
                                              //         MainAxisAlignment
                                              //             .spaceBetween,
                                              //     children: [
                                              //       ElevatedButton(
                                              //           style: ButtonStyle(
                                              //             shape: MaterialStateProperty
                                              //                 .all(
                                              //                     StadiumBorder()),
                                              //             backgroundColor:
                                              //                 MaterialStateProperty
                                              //                     .all(Color(
                                              //                         0xFF43B978)),
                                              //             foregroundColor:
                                              //                 MaterialStateProperty
                                              //                     .all(Color(
                                              //                         0xFFFFFFFF)),
                                              //           ),
                                              //           onPressed: () {
                                              //             if (isProductExist(
                                              //                     Hive.box(
                                              //                         'cartBox'),
                                              //                     data.id,
                                              //                     variationId: data
                                              //                         .variation_id) ==
                                              //                 null) {
                                              //               context.read<CartProvider>().addItemToCart(
                                              //                   context:
                                              //                       context,
                                              //                   creatorId: data
                                              //                       .creatorId,
                                              //                   creatorName: data
                                              //                       .creatorName,
                                              //                   id: data.id,
                                              //                   image:
                                              //                       data.image,
                                              //                   name: data.name,
                                              //                   price:
                                              //                       data.price,
                                              //                   quantity: data
                                              //                       .quantity,
                                              //                   variationId: data
                                              //                       .variation_id,
                                              //                   weight:
                                              //                       data.weight,
                                              //                   manageStock: data
                                              //                       .manageStock,
                                              //                   masterStock: data
                                              //                       .masterStock,
                                              //                   variation_name:
                                              //                       data.variation_name);
                                              //               setState(() {});
                                              //             } else {
                                              //               CustomSnackBar(
                                              //                   context,
                                              //                   Text(
                                              //                       "This product is already added to your cart"));
                                              //             }
                                              //           },
                                              //           child: Text(isProductExist(
                                              //                       Hive.box(
                                              //                           'cartBox'),
                                              //                       data.id,
                                              //                       variationId:
                                              //                           data
                                              //                               .variation_id) ==
                                              //                   null
                                              //               ? AppLocalizations.of(
                                              //                           context)!
                                              //                       .translate(
                                              //                           'detail_add_cart') ??
                                              //                   'Add to Cart'
                                              //               : AppLocalizations.of(
                                              //                           context)!
                                              //                       .translate(
                                              //                           'added_to_cart') ??
                                              //                   'Added to cart')),
                                              //       InkWell(
                                              //         onTap: () {
                                              //           data.delete();
                                              //           setState(() {});
                                              //         },
                                              //         child: Image(
                                              //             image: AssetImage(
                                              //                 'assets/shopImg/closeRed.png'),
                                              //             width: 24,
                                              //             height: 24),
                                              //       )
                                              //     ],
                                              //   ),
                                              // )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            );
                          })
                      : Center(
                          child: Text(AppLocalizations.of(context)!
                                  .translate('No_Product_Found') ??
                              'No Product Found'),
                        )
                  : businessWishbox.length != 0
                      ? ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: businessWishbox.length,
                          itemBuilder: (_, i) {
                            BusinesseswishListHiveModel data =
                                businessWishbox.getAt(i);
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => BusinessDetail(
                                              id: data.creatorId,
                                            )));
                              },
                              child: Container(
                                  height: 100,
                                  width: double.infinity,
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color(0xFF0F0F2D1A),
                                            blurRadius: 20,
                                            offset: Offset(0, 3))
                                      ]),
                                  child: Stack(
                                    children: [
                                      Row(
                                        children: [
                                          Image(
                                            image: NetworkImage('${data.logo}'),
                                            width: 74,
                                            height: 74,
                                          ),
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${data.name}',
                                                    style: ThreeKmTextConstants
                                                        .tk14PXLatoBlackSemiBold
                                                        .copyWith(
                                                            color: Color(
                                                                0xFF0F0F2D)),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    '${data.address}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: InkWell(
                                          onTap: () {
                                            data.delete();
                                            setState(() {});
                                          },
                                          child: Image(
                                            image: AssetImage(
                                                'assets/shopImg/closeRed.png'),
                                            width: 24,
                                            height: 24,
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            );
                          })
                      : Center(
                          child: Text(AppLocalizations.of(context)!
                                  .translate('No_Business_Found') ??
                              'No Business Found'),
                        )
            ],
          ),
        ),
      ),
    );
  }
}
