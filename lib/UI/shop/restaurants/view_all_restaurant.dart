import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:threekm/UI/shop/cart/cart_item_list_modal.dart';
import 'package:threekm/localization/localize.dart';

import 'package:threekm/providers/shop/shop_home_provider.dart';
import 'package:threekm/utils/threekm_textstyles.dart';
import 'package:threekm/utils/utils.dart';
import '../../shop/restaurants/restaurants_menu.dart';

class AllRestaurantList extends StatefulWidget {
  const AllRestaurantList({Key? key}) : super(key: key);

  @override
  _AllRestaurantListState createState() => _AllRestaurantListState();
}

class _AllRestaurantListState extends State<AllRestaurantList> {
  int page = 1;
  bool isSearch = false;
  String SearchText = '';
  @override
  void initState() {
    // var initJson = json.encode({"lat": '', "lng": '', "page": 1});
    context.read<ShopHomeProvider>().getRestaurants(mounted, 1);
    super.initState();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate

    context.read<ShopHomeProvider>().clearrestaurantListState(mounted);
    context.read<ShopHomeProvider>().getRestaurants(mounted, 1);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    //var data = context.watch<ShopHomeProvider>().restaurantData?.result;
    var restaurantdata = context.watch<ShopHomeProvider>().allCreators;
    var state = context.watch<ShopHomeProvider>().state;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          title: isSearch
              ? TextFormField(
                  autofocus: false,
                  onChanged: (value) {
                    context
                        .read<ShopHomeProvider>()
                        .clearrestaurantListState(mounted);
                    context
                        .read<ShopHomeProvider>()
                        .getRestaurants(mounted, 1, query: value);
                    setState(() {});
                  },
                  onEditingComplete: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    setState(() {
                      isSearch = false;
                    });
                    log('onediting complete');
                  },
                )
              : Text(
                  AppLocalizations.of(context)!.translate('ALL_RESTAURANTS') ??
                      'ALL RESTAURANTS',
                  style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold,
                ),
          titleTextStyle: const TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          actions: [
            Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                    color: Colors.grey[200], shape: BoxShape.circle),
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        isSearch = isSearch == true ? false : true;
                        if (isSearch == false) {
                          context
                              .read<ShopHomeProvider>()
                              .getRestaurants(mounted, 1);
                          log('close ====================');
                        }
                      });
                      // context
                      //     .read<ShopHomeProvider>()
                      //     .clearrestaurantListState(mounted);
                    },
                    icon: Icon(
                      isSearch ? Icons.close : Icons.search_rounded,
                      size: 30,
                    ))),
            Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                    color: Colors.grey[200], shape: BoxShape.circle),
                child: IconButton(
                    onPressed: () {
                      viewCart(context, 'restro');
                    },
                    icon: const Icon(
                      Icons.shopping_cart_rounded,
                      size: 30,
                    )))
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: state == 'loaded'
            ? ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: restaurantdata?.length,
                itemBuilder: (_, i) {
                  if (i < restaurantdata!.length - 1) {
                    return InkWell(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        setState(() {
                          isSearch = false;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => RestaurantMenu(
                                      data: restaurantdata[i],
                                    )));
                      },
                      child: Container(
                        // padding: EdgeInsets.all(20),
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Color(0xFFE2E4E6))),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: ThreeKmScreenUtil.screenHeightDp / 4,
                              child: Stack(
                                fit: StackFit.loose,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20)),
                                    child: ColorFiltered(
                                      colorFilter: ColorFilter.mode(
                                          restaurantdata[i]
                                                      .restaurant
                                                      ?.status !=
                                                  false
                                              ? Colors.transparent
                                              : Colors.grey,
                                          BlendMode.color),
                                      child: CachedNetworkImage(
                                        alignment: Alignment.topCenter,
                                        // placeholder: (context, url) =>
                                        //     Transform.scale(
                                        //   scale: 0.5,
                                        //   child: CircularProgressIndicator(
                                        //     color: Colors.grey[400],
                                        //   ),
                                        // ),
                                        imageUrl: '${restaurantdata[i].cover}',
                                        //height: ThreeKmScreenUtil.screenHeightDp / 5,
                                        width: ThreeKmScreenUtil.screenWidthDp,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  // Row(
                                  //   children: [
                                  //     Container(
                                  //       padding: EdgeInsets.all(10),
                                  //       margin: EdgeInsets.all(10),
                                  //       decoration: BoxDecoration(
                                  //           borderRadius: BorderRadius.circular(15),
                                  //           color: Colors.white),
                                  //       child: Text(
                                  //         'Best Safety',
                                  //         style: ThreeKmTextConstants
                                  //             .tk14PXPoppinsBlueMedium,
                                  //       ),
                                  //     ),
                                  //     Container(
                                  //       padding: EdgeInsets.all(9),
                                  //       margin: EdgeInsets.all(10),
                                  //       decoration: BoxDecoration(
                                  //           borderRadius: BorderRadius.circular(15),
                                  //           gradient: const LinearGradient(colors: [
                                  //             Color(0xFFFF5C3D),
                                  //             Color(0xFFFF2A5F)
                                  //           ])),
                                  //       child: Text(
                                  //         '50% off',
                                  //         style: ThreeKmTextConstants
                                  //             .tk12PXPoppinsWhiteRegular,
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${restaurantdata[i].businessName}',
                                style: ThreeKmTextConstants
                                    .tk16PXPoppinsBlackSemiBold,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: ThreeKmScreenUtil.screenWidthDp / 1.9,
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    '${restaurantdata[i].restaurant!.cuisines?.join(", ")}',
                                    maxLines: 1,
                                    style: ThreeKmTextConstants
                                        .tk14PXPoppinsBlueMedium,
                                  ),
                                ),
                                if (restaurantdata[i].address?.serviceArea !=
                                    null)
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                        '${restaurantdata[i].address?.serviceArea}'),
                                  )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    context.read<ShopHomeProvider>().getRestaurants(mounted,
                        context.read<ShopHomeProvider>().prepageno + 1);
                    return const SizedBox(
                      height: 80,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                })
            : Container(),
      ),
    );
  }
}
