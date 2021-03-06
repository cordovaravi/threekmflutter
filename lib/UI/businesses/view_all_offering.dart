import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/src/provider.dart';
import 'package:threekm/Models/shopModel/product_listing_model.dart';
import 'package:threekm/UI/shop/cart/cart_item_list_modal.dart';
import 'package:threekm/UI/shop/product/product_details.dart';

import 'package:threekm/providers/shop/product_listing_provider.dart';
import 'package:threekm/providers/shop/wish_list_provide.dart';

import 'package:threekm/utils/threekm_textstyles.dart';

class ViewAllOffering extends StatefulWidget {
  const ViewAllOffering({Key? key, required this.creatorId, required this.name})
      : super(key: key);

  final int creatorId;
  final String name;

  @override
  State<ViewAllOffering> createState() => _ViewAllOfferingState();
}

class _ViewAllOfferingState extends State<ViewAllOffering> {
  bool end = false;
  int page = 0;

  @override
  void initState() {
    context.read<ProductListingProvider>().clearProductListState(mounted);
    context.read<ProductListingProvider>().getProductListing(
        mounted: mounted, page: 1, creatorId: widget.creatorId);
    super.initState();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    print("======================================");
    context.read<ProductListingProvider>().clearProductListState(mounted);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<ProductListingProvider>().allproductList;
    final productListingdata =
        context.watch<ProductListingProvider>().productListingData;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Text(
            'Offering by ${widget.name}',
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
                          right: 8,
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
                // Positioned(
                //     top: 0,
                //     right: -8,
                //     child: Container(
                //         decoration: BoxDecoration(
                //             shape: BoxShape.circle, color: Colors.red),
                //         child: Padding(
                //           padding: const EdgeInsets.all(4.0),
                //           child: Text(
                //             '${Hive.box('cartBox').length}',
                //             style: TextStyle(fontSize: 11, color: Colors.white),
                //           ),
                //         )))
              ],
            )
          ],
        ),
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       InkWell(
          //         onTap: () {},
          //         child: Container(
          //             height: 50,
          //             width: 120,
          //             padding: EdgeInsets.all(6),
          //             decoration: const BoxDecoration(
          //                 color: Colors.white,
          //                 // border: Border.all(),
          //                 borderRadius: BorderRadius.all(Radius.circular(50)),
          //                 boxShadow: [
          //                   BoxShadow(
          //                       blurRadius: 30, color: Color(0xFF3B4A7424))
          //                 ]),
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: const [
          //                 Text(
          //                   "FILTERS",
          //                   style: TextStyle(fontSize: 17),
          //                 ),
          //                 Icon(Icons.arrow_drop_down_outlined),
          //               ],
          //             )),
          //       ),
          //       InkWell(
          //         onTap: () {},
          //         child: Container(
          //             height: 50,
          //             width: 100,
          //             decoration: const BoxDecoration(
          //                 color: Colors.white,
          //                 // border: Border.all(),
          //                 borderRadius: BorderRadius.all(Radius.circular(50)),
          //                 boxShadow: [
          //                   BoxShadow(
          //                       blurRadius: 30, color: Color(0xFF3B4A7424))
          //                 ]),
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: const [
          //                 Text(
          //                   "SORT",
          //                   style: TextStyle(fontSize: 17),
          //                 ),
          //                 Icon(Icons.arrow_drop_down_outlined),
          //               ],
          //             )),
          //       ),
          //       Text(
          //         'CLEAR FILTERS',
          //         style: TextStyle(color: Color(0xFFFF5858), fontSize: 16),
          //       )
          //     ],
          //   ),
          // ),
          Flexible(
            child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: data.length,
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  if (i == productListingdata.result!.total - 1) {
                    return ItemBuilderWidget(
                      data: data,
                      i: i,
                    );
                  } else if (i < data.length - 1) {
                    return ItemBuilderWidget(
                      data: data,
                      i: i,
                    );
                  } else {
                    context.read<ProductListingProvider>().getProductListing(
                        mounted: mounted,
                        page: context.read<ProductListingProvider>().prepageno +
                            1,
                        creatorId: widget.creatorId);
                    return const SizedBox(
                      height: 80,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  // return ItemBuilderWidget(data: data, i: i);
                }),
          ),
        ],
      ),
    );
  }
}

class ItemBuilderWidget extends StatefulWidget {
  ItemBuilderWidget({Key? key, required this.data, required this.i})
      : super(key: key);

  final List<Products> data;
  final int i;

  @override
  State<ItemBuilderWidget> createState() => _ItemBuilderWidgetState();
}

class _ItemBuilderWidgetState extends State<ItemBuilderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      //margin: const EdgeInsets.only(left: 10, right: 10, top: 25, bottom: 10),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 5,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              PageRouteBuilder(
                  pageBuilder: (context, animaton, secondaryAnimation) {
                    return ProductDetails(
                      id: widget.data[widget.i].catalogId ?? 0,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 800),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    animation = CurvedAnimation(
                        parent: animation, curve: Curves.easeInOut);
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  })).then((value) => {setState(() {})});
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Color(0xFF32335E26),
                    blurRadius: 10,
                    offset: Offset(6, 6))
              ]),
          child: Padding(
            padding: const EdgeInsets.only(top: 1, bottom: 1, left: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Material(
                  borderRadius: BorderRadius.circular(20),
                  elevation: 0.5,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          alignment: Alignment.center,
                          placeholder: (context, url) => Transform.scale(
                            scale: 0.3,
                            child: CircularProgressIndicator(
                              color: Colors.grey[400],
                            ),
                          ),
                          imageUrl: '${widget.data[widget.i].image}',
                          height: MediaQuery.of(context).size.height / 6,
                          width: MediaQuery.of(context).size.width / 2.5,
                          fit: BoxFit.contain,
                        ),
                      ),
                      if (double.parse((widget.data[widget.i].strikePrice! -
                                  widget.data[widget.i].price!)
                              .toStringAsFixed(2)) >
                          0.00)
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Text(
                            '???${(widget.data[widget.i].strikePrice! - widget.data[widget.i].price!).toStringAsFixed(2)} Off',
                            style:
                                ThreeKmTextConstants.tk12PXPoppinsWhiteRegular,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20, left: 10),
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.data[widget.i].name}',
                        style: ThreeKmTextConstants.tk14PXPoppinsBlackBold,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'By ${widget.data[widget.i].businessName}',
                        style: ThreeKmTextConstants.tk14PXLatoBlackSemiBold
                            .copyWith(color: Color(0xFF979EA4)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        width: MediaQuery.of(context).size.width / 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (widget.data[widget.i].strikePrice !=
                                    widget.data[widget.i].price)
                                  Text(
                                      '???${widget.data[widget.i].strikePrice ?? ''}',
                                      style: ThreeKmTextConstants
                                          .tk14PXPoppinsBlackMedium
                                          .copyWith(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: Colors.red[300],
                                              fontWeight: FontWeight.bold)),
                                Text('???${widget.data[widget.i].price}',
                                    style: ThreeKmTextConstants
                                        .tk18PXPoppinsBlackMedium
                                        .copyWith(
                                            color: Color(0xFF3E7EFF),
                                            fontWeight: FontWeight.bold)),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                if (context
                                        .read<WishListProvider>()
                                        .isinWishList(
                                            widget.data[widget.i].catalogId) ==
                                    null) {
                                  context
                                      .read<WishListProvider>()
                                      .addToWishList(
                                          image: widget.data[widget.i].image,
                                          name: widget.data[widget.i].name,
                                          price: widget.data[widget.i].price,
                                          id: widget.data[widget.i].catalogId,
                                          variationId: 0,
                                          variation_name: '',
                                          weight: widget.data[widget.i].weight,
                                          // manage stock is missing here
                                          masterStock:
                                              widget.data[widget.i].masterStock,
                                          creatorId:
                                              widget.data[widget.i].creatorId,
                                          creatorName: widget
                                              .data[widget.i].businessName);
                                  setState(() {});
                                } else {
                                  context.read<WishListProvider>().removeWish(
                                      widget.data[widget.i].catalogId);
                                  setState(() {});
                                }

                                print('heart clicked ');
                              },
                              child: context
                                          .read<WishListProvider>()
                                          .isinWishList(widget
                                              .data[widget.i].catalogId) !=
                                      null
                                  ? Container(
                                      child: Lottie.asset(
                                        "assets/kadokado-heart.json",
                                        height: 50,
                                        fit: BoxFit.cover,
                                        alignment: Alignment.center,
                                        repeat: false,
                                      ),
                                    )
                                  : const Padding(
                                      padding: EdgeInsets.all(12.5),
                                      child: Image(
                                        image: AssetImage(
                                            'assets/shopImg/wishlist.png'),
                                        width: 25,
                                        height: 25,
                                      )
                                      // Icon(
                                      //   Icons.favorite_outline_sharp,
                                      //   color: Colors.grey,
                                      //   size: 25,
                                      // ),
                                      ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
