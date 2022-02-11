import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/src/provider.dart';
import 'package:threekm/Custom_library/GooleMapsWidget/src/google_map_place_picker.dart';
import 'package:threekm/UI/businesses/view_all_offering.dart';
import 'package:threekm/UI/shop/cart/cart_item_list_modal.dart';
import 'package:threekm/UI/shop/product/product_details.dart';
import 'package:threekm/UI/shop/product_card_home.dart';
import 'package:threekm/commenwidgets/creatorLocation.dart';
import 'package:threekm/providers/businesses/businesses_detail_provider.dart';
import 'package:threekm/providers/businesses/businesses_wishlist_provider.dart';
import 'package:threekm/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:visibility_detector/visibility_detector.dart';

import 'all_image.dart';

class BusinessDetail extends StatefulWidget {
  const BusinessDetail({Key? key, required this.id}) : super(key: key);
  final int? id;

  @override
  State<BusinessDetail> createState() => _BusinessDetailState();
}

class _BusinessDetailState extends State<BusinessDetail> {
  bool isvisible = false;
  int _counter = 0;
  GlobalKey<State> key = GlobalKey();
  GlobalKey appBarKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    context
        .read<BusinessDetailProvider>()
        .getBusinessesDetail(mounted, widget.id);
  }

  @override
  Widget build(BuildContext context) {
    var data = context
        .watch<BusinessDetailProvider>()
        .businessesDetailedata
        ?.data
        .result;

    var isinBusinessWishlist =
        context.watch<BusinessesWishListProvider>().isinWishList(widget.id);
    var statusData = context.watch<BusinessDetailProvider>().state;

    return Scaffold(
      key: appBarKey,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.only(left: 10),
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: const Icon(Icons.arrow_back_rounded, color: Colors.black87),
          ),
        ),
        actions: [
          Container(
            decoration: const BoxDecoration(
                color: Colors.black45, shape: BoxShape.circle),
            child: IconButton(
                icon: const Icon(
                  Icons.share_outlined,
                  size: 20,
                  color: Colors.white,
                ),
                onPressed: () {}),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 5),
            decoration: const BoxDecoration(
                color: Colors.black45, shape: BoxShape.circle),
            child: IconButton(
                icon: const Icon(
                  Icons.shopping_cart_rounded,
                  size: 20,
                  color: Colors.white,
                ),
                onPressed: () {
                  viewCart(context, 'shop');
                }),
          ),
        ],
      ),
      body: statusData == 'loaded' && data != null
          ? Container(
              decoration: BoxDecoration(
                  //color: Colors.blue,
                  borderRadius: BorderRadius.circular(20)),
              // padding: EdgeInsets.only(top: 200),
              height: ThreeKmScreenUtil.screenHeightDp,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        height: 500,
                        width: double.infinity,
                        child: PageView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            // pageSnapping: true,
                            onPageChanged: (val) {
                              print(val);
                            },
                            itemCount: data.creator.coverImages.length != 0
                                ? data.creator.coverImages.length
                                : [data.creator.image].length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => showFullImage(
                                                images: data.creator.coverImages
                                                            .length !=
                                                        0
                                                    ? data.creator.coverImages
                                                    : [data.creator.image],
                                              )));
                                },
                                child: Hero(
                                  tag: 'hero2',
                                  child: Image(
                                    image: NetworkImage(
                                      data.creator.coverImages.length != 0
                                          ? '${data.creator.coverImages[index]}'
                                          : data.creator.image,
                                    ),
                                    fit: BoxFit.fill,
                                    // width: ThreeKmScreenUtil.screenWidthDp /
                                    //     1.1888,
                                    // height: ThreeKmScreenUtil.screenHeightDp /
                                    //     4.7,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      width: 110,
                                      height: 80,
                                      color: Colors.grey[350],
                                    ),
                                    loadingBuilder:
                                        (_, widget, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return widget;
                                      }
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: Color(0xFF979EA4),
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            })
                        // : Image(
                        //     image: NetworkImage(data.creator.image),
                        //     fit: BoxFit.fill,
                        //   ),
                        ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      // margin: EdgeInsets.only(
                      //     top: ThreeKmScreenUtil.screenHeightDp / 3.5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image(
                                    image: NetworkImage('${data.creator.logo}'),
                                    width: 80,
                                    height: 90,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 15),
                                  width: 270,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${data.creator.businessName}',
                                        style: ThreeKmTextConstants
                                            .tk18PXPoppinsBlackMedium
                                            .copyWith(
                                                height: 1.2,
                                                fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text(
                                          data.creator.address,
                                          softWrap: true,
                                          style: ThreeKmTextConstants
                                              .tk12PXPoppinsBlackSemiBold,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 10, left: 20),
                            height: 50,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: data.creator.tags.length,
                                itemBuilder: (context, i) {
                                  return FittedBox(
                                    child: Container(
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color(0xFF555C64)),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '  ${data.creator.tags[i]}  ',
                                          style: ThreeKmTextConstants
                                              .tk12PXLatoGreenMedium
                                              .copyWith(
                                                  color: Color(0xFF555C64)),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 10),
                            child: HtmlWidget(
                              '${data.creator.about}',
                              textStyle: TextStyle(color: Colors.black,),
                            ),
                          ),
                          VisibilityDetector(
                            key: key,
                            onVisibilityChanged: (VisibilityInfo info) {
                              var visiblePercentage =
                                  info.visibleFraction * 100;
                              if (visiblePercentage > 60) {
                                setState(() {
                                  isvisible = true;
                                });
                              } else {
                                if (!mounted) return;
                                setState(() {
                                  isvisible = false;
                                });
                              }
                              debugPrint(
                                  'Widget ${info.key} is ${visiblePercentage}% visible');
                              log('Widget ${info.key} is ${visiblePercentage}% visible');
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Center(
                                child: Container(
                                  width: ThreeKmScreenUtil.screenWidthDp / 1.2,
                                  height: 60,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (isvisible)
                                        ElevatedButton.icon(
                                            onPressed: () {
                                              if (isinBusinessWishlist ==
                                                  null) {
                                                context
                                                    .read<
                                                        BusinessesWishListProvider>()
                                                    .addToBusinessWishList(
                                                        name: data.creator
                                                            .businessName,
                                                        address: data
                                                            .creator.address,
                                                        logo: data.creator.logo,
                                                        creatorId: data
                                                            .creator.creatorId);
                                              } else {
                                                context
                                                    .read<
                                                        BusinessesWishListProvider>()
                                                    .removeWish(
                                                        data.creator.creatorId);
                                              }
                                            },
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all(
                                                    StadiumBorder()),
                                                backgroundColor: MaterialStateProperty.all(
                                                    const Color(0xFFF4F3F8)),
                                                foregroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.black),
                                                padding: MaterialStateProperty.all(
                                                    EdgeInsets.only(
                                                        left: isinBusinessWishlist !=
                                                                null
                                                            ? 10
                                                            : 30,
                                                        right: 30,
                                                        top: isinBusinessWishlist !=
                                                                null
                                                            ? 0
                                                            : 15,
                                                        bottom:
                                                            isinBusinessWishlist !=
                                                                    null
                                                                ? 0
                                                                : 15))),
                                            icon: isinBusinessWishlist != null
                                                ? Container(
                                                    child: Lottie.asset(
                                                      "assets/kadokado-heart.json",
                                                      height: 50,
                                                      fit: BoxFit.cover,
                                                      alignment:
                                                          Alignment.center,
                                                      repeat: false,
                                                    ),
                                                  )
                                                : const Image(
                                                    image: AssetImage(
                                                        'assets/shopImg/wishlist.png'),
                                                    width: 25,
                                                    height: 25,
                                                  ),
                                            //Icon(Icons.favorite_outline_sharp),
                                            label: Text(
                                              isinBusinessWishlist != null
                                                  ? 'Remove'
                                                  : 'Wishlist',
                                              style: ThreeKmTextConstants
                                                  .tk14PXPoppinsBlackMedium,
                                            )),
                                      // if (isvisible)
                                      //   ElevatedButton.icon(
                                      //       onPressed: () async {},
                                      //       style: ButtonStyle(
                                      //           shape: MaterialStateProperty.all(
                                      //               const StadiumBorder()),
                                      //           backgroundColor: MaterialStateProperty.all(
                                      //               const Color(0xFFFF5858)),
                                      //           foregroundColor:
                                      //               MaterialStateProperty.all(
                                      //                   Colors.white),
                                      //           elevation:
                                      //               MaterialStateProperty.all(
                                      //                   5),
                                      //           shadowColor:
                                      //               MaterialStateProperty.all(
                                      //                   Color(0xFFFC5E6A33)),
                                      //           padding:
                                      //               MaterialStateProperty.all(
                                      //                   const EdgeInsets.only(
                                      //                       left: 30,
                                      //                       right: 30,
                                      //                       top: 15,
                                      //                       bottom: 15))),
                                      //       icon:
                                      //           const Icon(Icons.shopping_cart_rounded),
                                      //       label: Text(
                                      //         'Shop',
                                      //         style: ThreeKmTextConstants
                                      //             .tk14PXPoppinsWhiteMedium,
                                      //       )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(30),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color(0xFF3B4A7424),
                                      blurRadius: 9,
                                      offset: Offset(0, 3))
                                ]),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20,
                                  ),
                                  child: ListTile(
                                    onTap: () async => await launch(
                                        ('tel://${data.creator.phoneNo}')),
                                    dense: true,
                                    leading: Container(
                                      decoration: const BoxDecoration(
                                          color: Color(0xFFFBA924),
                                          shape: BoxShape.circle),
                                      width: 48,
                                      height: 48,
                                      child: const Icon(
                                        Icons.phone,
                                        color: Colors.white,
                                      ),
                                    ),
                                    title: Text(data.creator.phoneNo,
                                        style: ThreeKmTextConstants
                                            .tk16PXPoppinsBlackMedium),
                                  ),
                                ),
                                if (data.creator.whatsappNo != "")
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 20,
                                    ),
                                    child: ListTile(
                                      onTap: () async => await launch(data
                                              .creator.whatsappNo
                                              .startsWith('+91')
                                          ? "https://wa.me/${data.creator.whatsappNo}?text=Hello"
                                          : "https://wa.me/+91${data.creator.whatsappNo}?text=Hello"),
                                      dense: true,
                                      leading: const Image(
                                          image: AssetImage(
                                              'assets/BusinessesImg/whatsapp.png')),
                                      title: Text(data.creator.whatsappNo,
                                          style: ThreeKmTextConstants
                                              .tk16PXPoppinsBlackMedium),
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20,
                                  ),
                                  child: ListTile(
                                    onTap: () async => await launch(
                                        'mailto:${data.creator.email}?subject=Related To Business&body=Hello%20Sir'),
                                    dense: true,
                                    leading: Container(
                                      decoration: const BoxDecoration(
                                          color: Color(0xFFFF5858),
                                          shape: BoxShape.circle),
                                      width: 48,
                                      height: 48,
                                      child: const Icon(
                                        Icons.email,
                                        color: Colors.white,
                                      ),
                                    ),
                                    title: Text(data.creator.email,
                                        style: ThreeKmTextConstants
                                            .tk16PXPoppinsBlackMedium),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20,
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (_) {
                                        return CreatorLocation(
                                          initialTarget: LatLng(
                                              data.creator.addressObj.latitude,
                                              data.creator.addressObj
                                                  .longitude),
                                        );
                                      }));
                                    },
                                    dense: true,
                                    leading: Container(
                                      decoration: const BoxDecoration(
                                          color: Color(0xFF3E7EFF),
                                          shape: BoxShape.circle),
                                      width: 48,
                                      height: 48,
                                      child: const Icon(
                                        Icons.location_on,
                                        color: Colors.white,
                                      ),
                                    ),
                                    title: Text(data.creator.address,
                                        style: ThreeKmTextConstants
                                            .tk16PXPoppinsBlackMedium),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          data.products.length != 0
                              ? Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Wrap(children: [
                                          Text(
                                            'Offerings',
                                            style: ThreeKmTextConstants
                                                .tk16PXPoppinsWhiteBold
                                                .copyWith(
                                                    color: const Color(
                                                        0xFF0F0F2D)),
                                          ),
                                          Text(
                                            ' by ${data.creator.businessName}',
                                            style: ThreeKmTextConstants
                                                .tk16PXPoppinsBlackMedium,
                                          ),
                                        ]),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(bottom: 50),
                                        height:
                                            ThreeKmScreenUtil.screenHeightDp /
                                                1.58,
                                        color: Color(0xFFFFFFFF),
                                        child: GridView.builder(
                                            padding: const EdgeInsets.only(
                                                top: 10, left: 15, right: 15),
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              mainAxisExtent: 260,
                                              // childAspectRatio: 0.69
                                            ),
                                            itemCount: data.products.length,
                                            itemBuilder:
                                                (BuildContext ctxt, int index) {
                                              var productData =
                                                  data.products[index];
                                              return InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      PageRouteBuilder(
                                                          pageBuilder: (context,
                                                              animaton,
                                                              secondaryAnimation) {
                                                            return ProductDetails(
                                                              id: productData
                                                                  .catalogId,
                                                            );
                                                          },
                                                          transitionDuration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      800),
                                                          transitionsBuilder:
                                                              (context,
                                                                  animation,
                                                                  secondaryAnimation,
                                                                  child) {
                                                            animation =
                                                                CurvedAnimation(
                                                                    parent:
                                                                        animation,
                                                                    curve: Curves
                                                                        .easeInOut);
                                                            return FadeTransition(
                                                              opacity:
                                                                  animation,
                                                              child: child,
                                                            );
                                                          }));
                                                },
                                                child: Container(
                                                  // color: Colors.red,
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  //width: ThreeKmScreenUtil.screenWidthDp / 1.5,
                                                  //height: ThreeKmScreenUtil.screenHeightDp / 2.7,
                                                  child: BuildCard(
                                                    cardImage:
                                                        "${productData.image}",
                                                    context: context,
                                                    heading: Text(
                                                        '${productData.name}',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: ThreeKmTextConstants
                                                            .tk14PXPoppinsBlackBold),
                                                    subHeading: Text(
                                                        '₹${productData.price}',
                                                        style: ThreeKmTextConstants
                                                            .tk14PXLatoBlackBold
                                                            .copyWith(
                                                                color: const Color(
                                                                    0xFFFC8338))),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                      Center(
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              top: 0, bottom: 80),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ViewAllOffering(
                                                            creatorId: data
                                                                .creator
                                                                .creatorId,
                                                            name: data.creator
                                                                .businessName,
                                                          )));
                                            },
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all(
                                                    const StadiumBorder()),
                                                backgroundColor: MaterialStateProperty.all(
                                                    const Color(0xFF3E7EFF)),
                                                foregroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.white),
                                                elevation:
                                                    MaterialStateProperty.all(
                                                        5),
                                                shadowColor:
                                                    MaterialStateProperty.all(
                                                        Color(0xFFFC5E6A33)),
                                                padding:
                                                    MaterialStateProperty.all(
                                                        const EdgeInsets.only(
                                                            left: 30,
                                                            right: 30,
                                                            top: 15,
                                                            bottom: 15))),
                                            child: Text(
                                              'View All Offerings',
                                              style: ThreeKmTextConstants
                                                  .tk14PXPoppinsWhiteMedium,
                                            ),
                                          ),
                                          // ElevatedButton(
                                          //     onPressed: () {
                                          //       Navigator.push(
                                          //           context,
                                          //           MaterialPageRoute(
                                          //               builder: (context) =>
                                          //                   ViewAllOffering(
                                          //                     creatorId: data
                                          //                         .creator
                                          //                         .creatorId,
                                          //                     name: data.creator
                                          //                         .businessName,
                                          //                   )));
                                          //     },
                                          //     child: const Text(
                                          //         'View All Offerings')),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: !isvisible && statusData == 'loaded' && data != null
          ? Container(
              color: Colors.white,
              height: 70,
              child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: SizedBox(
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                            onPressed: () {
                              if (isinBusinessWishlist == null) {
                                context
                                    .read<BusinessesWishListProvider>()
                                    .addToBusinessWishList(
                                        name: data.creator.businessName,
                                        address: data.creator.address,
                                        logo: data.creator.logo,
                                        creatorId: data.creator.creatorId);
                              } else {
                                context
                                    .read<BusinessesWishListProvider>()
                                    .removeWish(data.creator.creatorId);
                              }
                            },
                            style: ButtonStyle(
                                shape:
                                    MaterialStateProperty.all(StadiumBorder()),
                                backgroundColor: MaterialStateProperty.all(
                                    const Color(0xFFF4F3F8)),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.black),
                                padding:
                                    MaterialStateProperty.all(
                                        EdgeInsets.only(
                                            left: isinBusinessWishlist != null
                                                ? 10
                                                : 30,
                                            right: 30,
                                            top: isinBusinessWishlist != null
                                                ? 0
                                                : 15,
                                            bottom: isinBusinessWishlist != null
                                                ? 0
                                                : 15))),
                            icon: isinBusinessWishlist != null
                                ? Container(
                                    //height: 30,
                                    child: Lottie.asset(
                                      "assets/kadokado-heart.json",
                                      height: 50,
                                      //fit: BoxFit.,
                                      alignment: Alignment.center,
                                      repeat: false,
                                    ),
                                  )
                                : const Image(
                                    image: AssetImage(
                                        'assets/shopImg/wishlist.png'),
                                    width: 25,
                                    height: 25,
                                  ),
                            // Icon(Icons.favorite_outline_sharp),
                            label: Text(
                              isinBusinessWishlist != null
                                  ? 'Remove'
                                  : 'Wishlist',
                              style:
                                  ThreeKmTextConstants.tk14PXPoppinsBlackMedium,
                            )),
                        // ElevatedButton.icon(
                        //     onPressed: () async {
                        //       print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
                        //       // context
                        //       //     .read<CartProvider>()
                        //       //     .addToCart(
                        //       //         image: product?.image,
                        //       //         name: product?.name,
                        //       //         price: product?.price,
                        //       //         quantity: 1,
                        //       //         id: product?.catalogId,
                        //       //         variationId: 0);

                        //       // context.read<CartProvider>().addItemToCart(
                        //       //       context: context,
                        //       //       creatorId: product?.creatorId,
                        //       //       image: product?.image,
                        //       //       name: product?.name,
                        //       //       price: price != 0 ? price : product?.price,
                        //       //       quantity: 1,
                        //       //       id: product?.catalogId,
                        //       //       variationId: variationid,
                        //       //       weight:
                        //       //           weight != 0 ? weight : product?.weight,
                        //       //     );
                        //     },
                        //     style: ButtonStyle(
                        //         shape: MaterialStateProperty.all(
                        //             const StadiumBorder()),
                        //         backgroundColor: MaterialStateProperty.all(
                        //             const Color(0xFFFF5858)),
                        //         foregroundColor:
                        //             MaterialStateProperty.all(Colors.white),
                        //         elevation: MaterialStateProperty.all(5),
                        //         shadowColor: MaterialStateProperty.all(
                        //             const Color(0xFFFC5E6A33)),
                        //         padding: MaterialStateProperty.all(
                        //             const EdgeInsets.only(
                        //                 left: 30,
                        //                 right: 30,
                        //                 top: 15,
                        //                 bottom: 15))),
                        //     icon: const Icon(Icons.shopping_cart_rounded),
                        //     label: Text(
                        //       'Shop',
                        //       style:
                        //           ThreeKmTextConstants.tk14PXPoppinsWhiteMedium,
                        //     )),
                      ],
                    ),
                  )),
            )
          : Container(),
    );
  }
}
