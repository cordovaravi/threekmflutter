import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/src/provider.dart';

import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:share_plus/share_plus.dart';
import 'package:threekm/UI/businesses/businesses_detail.dart';
import 'package:threekm/UI/shop/indicator.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/localization/localize.dart';
import 'package:threekm/main.dart';
import 'package:threekm/providers/shop/cart_provider.dart';
import 'package:threekm/providers/shop/product_details_provider.dart';
import 'package:threekm/providers/shop/wish_list_provide.dart';
import 'package:threekm/utils/screen_util.dart';
import 'package:threekm/utils/threekm_textstyles.dart';
import '../../shop/cart/cart_item_list_modal.dart';
import '../../shop/cart/clear_and_add_to_cart.dart';
import '../../shop/product/full_image.dart';
import '../../shop/product/post_review_form.dart';
import 'dart:ui' as ui;
import 'package:visibility_detector/visibility_detector.dart';

class ProductDetails extends StatefulWidget {
  ProductDetails({Key? key, required this.id}) : super(key: key);

  final num id;
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  String description = '';
  bool readMore = false;
  bool readReview = false;
  GlobalKey<State> key = GlobalKey();
  bool isvisible = false;
  int? price = 0;
  num weight = 0.0;
  int? variationid = 0;
  var variation;
  int? variationIndex = 0;
  int selectedindex = 0;

  List<String> wordList = [];
  bool isReadMore = true;
  String getReadMoreWord(inputString) {
    if (inputString != null) {
      wordList = inputString.split(" ");
      if (wordList.isNotEmpty) {
        return wordList.length >= 30 && isReadMore
            ? wordList.getRange(0, (wordList.length / 2.5).round()).join(' ')
            : wordList.join(' ');
      } else {
        return ' ';
      }
    }
    return '';
  }

  @override
  void initState() {
    print('${widget.id}======================');
    context.read<ProductDetailsProvider>().productDetails(mounted, widget.id);
    openBox();
    super.initState();
  }

  int listLength(l) {
    int i = 0;
    i = l == 0
        ? 0
        : l >= 2 && !readReview
            ? 2
            : l;
    return i;
  }

  openBox() async {
    Box? _cartBox = await Hive.openBox('cartBox').whenComplete(() => setState((){}));
  }

  isProductExist(box, id, {variationId}) {
    if (variationId != null) {
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

  @override
  void dispose() {
    int? price = 0;
    int? weight = 0;
    int? variationid = 0;
    int? variationIndex = 0;
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    var data = context.watch<ProductDetailsProvider>().ProductDetailsData;
    var statusData = context.watch<ProductDetailsProvider>().state;
    var product = data.result?.product;
    var isWish = context
        .watch<WishListProvider>()
        .isinWishList(data.result?.product.catalogId);

    return RefreshIndicator(onRefresh: () {
      return context
          .read<ProductDetailsProvider>()
          .onRefresh(mounted, widget.id);
    }, child: Builder(builder: (context) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: color),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle),
              child:
                  const Icon(Icons.arrow_back_rounded, color: Colors.black87),
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
                  onPressed: () {
                    log("share button ");
                    var url =
                        'https://3km.in/sell/${product?.name.replaceAll(" ", "")}/${product?.catalogId}';
                    Share.share(
                        '${Uri.parse(url)} ${product?.name} from ${product?.businessName}');
                  }),
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
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

               if(Hive.box('cartBox').isOpen) ValueListenableBuilder(
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
                // Positioned(
                //     top: 0,
                //     right: 6,
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
            ),
          ],
        ),
        body: Container(
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
                        setState(() {
                          selectedindex = val;
                        });
                      },
                      itemCount: variationid == 0
                          ? data.result?.product.images.length != 0
                              ? data.result?.product.images.length
                              : [data.result?.product.image].length
                          : data.result?.variations?[variationIndex!]
                                      .imagesLinks.length !=
                                  0
                              ? data.result?.variations![variationIndex!]
                                  .imagesLinks.length
                              : [data.result?.product.image].length,
                      itemBuilder: (context, index) {
                        return statusData == 'loaded'
                            //&&
                            // data.result?.product.images[index] != null
                            ? Container(
                                //color: Colors.black,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => FullImage(
                                                  imageurl: variationid == 0
                                                      ? data
                                                                  .result
                                                                  ?.product
                                                                  .images
                                                                  .length !=
                                                              0
                                                          ? '${data.result?.product.images[index]}'
                                                          : '${data.result?.product.image}'
                                                      : variation.imagesLinks
                                                                  .length !=
                                                              0
                                                          ? variation
                                                                  .imagesLinks[
                                                              index]
                                                          : '${data.result?.product.image}',
                                                )));
                                  },
                                  child: Hero(
                                    tag: 'hero1',
                                    child: Image(
                                      image: NetworkImage(variationid == 0
                                          ? data.result?.product.images
                                                      .length !=
                                                  0
                                              ? '${data.result?.product.images[index]}'
                                              : '${data.result?.product.image}'
                                          : variation.imagesLinks.length != 0
                                              ? variation.imagesLinks[index]
                                              : data.result?.product.image),
                                      fit: BoxFit.contain,
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
                                            color: const Color(0xFF979EA4),
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
                                ),
                              )
                            : Container();
                      }),
                ),
                //..._buildPageIndicator(data.result?.product.images),
                if (statusData == 'loaded' && data.result != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        for (int i = 0;
                            i <
                                (variationid == 0
                                    ? data.result!.product.images.length != 0
                                        ? data.result!.product.images.length
                                        : [data.result?.product.image].length
                                    : data.result?.variations?[variationIndex!]
                                                .imagesLinks.length !=
                                            0
                                        ? data
                                            .result!
                                            .variations![variationIndex!]
                                            .imagesLinks
                                            .length
                                        : [data.result?.product.image].length);
                            i++)
                          i == selectedindex
                              ? indicator(true)
                              : indicator(false),
                      ],
                    ),
                  ),

                statusData == 'loaded' && data.result != null
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.grey[300]!, blurRadius: 5)
                          ],
                          // borderRadius: const BorderRadius.only(
                          //     topLeft: Radius.circular(40),
                          //     topRight: Radius.circular(40))
                        ),
                        //height: ThreeKmScreenUtil.screenHeightDp / 1.7,
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 15, right: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.4,
                                        child: Text(
                                          '${product?.name}',
                                          style: ThreeKmTextConstants
                                              .tk16PXPoppinsBlackSemiBold,
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: Color(0xFF43B978),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Text('#${product?.catalogId}',
                                              style: ThreeKmTextConstants
                                                  .tk12PXPoppinsWhiteRegular))
                                    ],
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(
                                  //       top: 10, bottom: 15),
                                  //   child: Row(
                                  //     children: [
                                  //       // RatingBar.builder(
                                  //       //   initialRating: 3,
                                  //       //   minRating: 1,
                                  //       //   direction: Axis.horizontal,
                                  //       //   allowHalfRating: true,
                                  //       //   itemCount: 5,
                                  //       //   itemSize: 30,
                                  //       //   itemBuilder: (context, _) =>
                                  //       //       const Icon(
                                  //       //     Icons.star_rate_rounded,
                                  //       //     color: Colors.amber,
                                  //       //   ),
                                  //       //   onRatingUpdate: (rating) {
                                  //       //     print(rating);
                                  //       //   },
                                  //       // ),
                                  //       Text(""),
                                  //       Spacer(),

                                  //     ],
                                  //   ),
                                  // ),
                                  Row(
                                    children: [
                                      if (product!.hasDiscount)
                                        Text('₹${product.strikePrice}',
                                            style: ThreeKmTextConstants
                                                .tk14PXPoppinsBlackSemiBold
                                                .copyWith(
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    color: Colors.red[300])),
                                      Text(
                                        ' ₹${price != 0 ? price : product.price}',
                                        style: ThreeKmTextConstants
                                            .tk12PXPoppinsBlackSemiBold
                                            .copyWith(fontSize: 24),
                                      ),
                                      if (product.hasDiscount)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Text(
                                            '${product.discountType == 'percent' || product.discountType == 'percentage' ? "" : "₹"}${product.discountValue}${product.discountType == 'percent' || product.discountType == 'percentage' ? '%' : ''} Off',
                                            style: ThreeKmTextConstants
                                                .tk14PXPoppinsGreenSemiBold,
                                          ),
                                        )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 20),
                                    child: Wrap(
                                      children: [
                                        HtmlWidget(
                                          '${getReadMoreWord(product.description)}',
                                          textStyle:
                                              TextStyle(color: Colors.black),
                                        ),
                                        if (wordList.length >= 30 && isReadMore)
                                          TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  isReadMore = false;
                                                });
                                              },
                                              child: Text(AppLocalizations.of(
                                                          context)!
                                                      .translate('read_more') ??
                                                  'Read More'))
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: product.tags.length,
                                        itemBuilder: (context, i) {
                                          return Padding(
                                            padding: EdgeInsets.only(right: 10),
                                            child: ChoiceChip(
                                              label: Text(
                                                '${product.tags[i]}',
                                                style: ThreeKmTextConstants
                                                    .tk12PXLatoGreenMedium
                                                    .copyWith(
                                                        color: Colors.black),
                                              ),
                                              selected: true,
                                              selectedColor: Colors.grey[200],
                                              labelStyle: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          );
                                          //  Container(
                                          //   //height: 35,

                                          //   margin: const EdgeInsets.only(
                                          //       top: 7, bottom: 7, right: 7),
                                          //   decoration: BoxDecoration(
                                          //       border: Border.all(
                                          //           color: Color(0xFF555C64)),
                                          //       borderRadius:
                                          //           BorderRadius.circular(20)),
                                          //   child: Padding(
                                          //     padding:
                                          //         const EdgeInsets.all(8.0),
                                          //     child: Text(
                                          //       '  ${product.tags[i]}  ',
                                          //       style: ThreeKmTextConstants
                                          //           .tk12PXLatoGreenMedium
                                          //           .copyWith(
                                          //               color:
                                          //                   Color(0xFF555C64)),
                                          //     ),
                                          //   ),
                                          // );
                                        }),
                                  ),
                                  if (data.result!.variations!.length > 0)
                                    Text(
                                      AppLocalizations.of(context)!
                                              .translate('variants') ??
                                          'Variants',
                                      style: ThreeKmTextConstants
                                          .tk14PXPoppinsBlackBold
                                          .copyWith(height: 3),
                                    ),
                                  if (data.result!.variations!.length > 0)
                                    Container(
                                        height: 60,
                                        padding: EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                data.result!.variations!.length,
                                            itemBuilder: (_, i) {
                                              var vdata =
                                                  data.result!.variations?[i];
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                child: ChoiceChip(
                                                  label: Text(
                                                      '${vdata!.options['variation_name']}'),
                                                  selected: vdata.variationId ==
                                                          variationid
                                                      ? true
                                                      : false,
                                                  onSelected: (p) {
                                                    setState(() {
                                                      price = vdata.price;
                                                      weight = vdata.weight;
                                                      variationid =
                                                          vdata.variationId;
                                                      variationIndex = i;
                                                      variation = vdata;
                                                    });
                                                  },
                                                  selectedColor:
                                                      Colors.green[300],
                                                  labelStyle: TextStyle(
                                                      color:
                                                          vdata.variationId ==
                                                                  variationid
                                                              ? Colors.white
                                                              : Colors.black87),
                                                ),
                                              );

                                              // InkWell(
                                              //   onTap: () {
                                              //     setState(() {
                                              //       price = vdata?.price;
                                              //       weight = vdata?.weight;
                                              //       variationid =
                                              //           vdata?.variationId;
                                              //       variationIndex = i;
                                              //       variation = vdata;
                                              //     });
                                              //   },
                                              //   child: Container(
                                              //     padding:
                                              //         const EdgeInsets.only(
                                              //             right: 20, left: 20),
                                              //     margin: const EdgeInsets.only(
                                              //         right: 20),
                                              //     decoration: BoxDecoration(
                                              //         color: Color(
                                              //             vdata?.variationId ==
                                              //                     variationid
                                              //                 ? 0xFF43B97834
                                              //                 : 0xFFFFFF),
                                              //         border: Border.all(
                                              //             color: Color(
                                              //                 vdata?.variationId ==
                                              //                         variationid
                                              //                     ? 0xFF43B978
                                              //                     : 0xFF979EA4)),
                                              //         borderRadius:
                                              //             BorderRadius.circular(
                                              //                 20)),
                                              //     child: Center(
                                              //       child: Text(
                                              //         '${vdata!.options['variation_name']}',
                                              //         style: ThreeKmTextConstants
                                              //             .tk14PXPoppinsBlackMedium
                                              //             .copyWith(
                                              //                 color: Color(vdata
                                              //                             .variationId ==
                                              //                         variationid
                                              //                     ? 0xFF43B978
                                              //                     : 0xFF000000)),
                                              //       ),
                                              //     ),
                                              //   ),
                                              // );
                                            })),
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
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: ValueListenableBuilder(
                                          valueListenable:
                                              Hive.box('cartBox').listenable(),
                                          builder: (BuildContext context,
                                              Box<dynamic> box, Widget? child) {
                                            return Container(
                                                height: 60,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    if (isvisible)
                                                      ElevatedButton.icon(
                                                          onPressed: () {
                                                            if (isWish ==
                                                                null) {
                                                              context.read<WishListProvider>().addToWishList(
                                                                  image: product
                                                                      .image,
                                                                  name: product
                                                                      .name,
                                                                  price: price != 0
                                                                      ? price
                                                                      : product
                                                                          .price,
                                                                  id: product
                                                                      .catalogId,
                                                                  variationId:
                                                                      variationid,
                                                                  variation_name:
                                                                      variationid !=
                                                                              0
                                                                          ? variation.options[
                                                                              'variation_name']
                                                                          : null,
                                                                  creatorId: product
                                                                      .creatorId,
                                                                  creatorName: product
                                                                      .creatorDetails
                                                                      .businessName);
                                                            } else {
                                                              context
                                                                  .read<
                                                                      WishListProvider>()
                                                                  .removeWish(
                                                                      product
                                                                          .catalogId);
                                                            }
                                                          },
                                                          style: ButtonStyle(
                                                              shape: MaterialStateProperty.all(
                                                                  StadiumBorder()),
                                                              backgroundColor:
                                                                  MaterialStateProperty.all(
                                                                      const Color(
                                                                          0xFFF4F3F8)),
                                                              foregroundColor: MaterialStateProperty.all(
                                                                  Colors.black),
                                                              padding: MaterialStateProperty.all(EdgeInsets.only(
                                                                  left: isWish !=
                                                                          null
                                                                      ? 10
                                                                      : 30,
                                                                  right: 30,
                                                                  top: isWish !=
                                                                          null
                                                                      ? 0
                                                                      : 15,
                                                                  bottom: isWish !=
                                                                          null
                                                                      ? 0
                                                                      : 15))),
                                                          icon: isWish != null
                                                              ? Container(
                                                                  child: Lottie
                                                                      .asset(
                                                                    "assets/kadokado-heart.json",
                                                                    height: 50,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    repeat:
                                                                        false,
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
                                                            isWish != null
                                                                ? AppLocalizations.of(
                                                                            context)!
                                                                        .translate(
                                                                            'remove') ??
                                                                    'Remove'
                                                                : AppLocalizations.of(
                                                                            context)!
                                                                        .translate(
                                                                            'wishlist') ??
                                                                    'Wishlist',
                                                            style: ThreeKmTextConstants
                                                                .tk14PXPoppinsBlackMedium,
                                                          )),
                                                    if (isvisible)
                                                      ElevatedButton.icon(
                                                          onPressed: () async {
                                                            if (product
                                                                    .hasVariations ==
                                                                false) {
                                                              if (product
                                                                  .isInStock) {
                                                                if (isProductExist(
                                                                        box,
                                                                        widget
                                                                            .id) ==
                                                                    null) {
                                                                  context.read<CartProvider>().addItemToCart(
                                                                      context:
                                                                          context,
                                                                      creatorId: product
                                                                          .creatorId,
                                                                      image: product
                                                                          .image,
                                                                      name: product
                                                                          .name,
                                                                      price: price != 0
                                                                          ? price
                                                                          : product
                                                                              .price,
                                                                      quantity:
                                                                          1,
                                                                      id: product
                                                                          .catalogId,
                                                                      variationId:
                                                                          variationid,
                                                                      variation_name: variationid != 0
                                                                          ? variation.options[
                                                                              'variation_name']
                                                                          : null,
                                                                      weight: weight != 0
                                                                          ? weight
                                                                          : product
                                                                              .weight,
                                                                      masterStock: variationid != 0
                                                                          ? data
                                                                              .result
                                                                              ?.variations![
                                                                                  variationIndex!]
                                                                              .masterStock
                                                                          : product
                                                                              .masterStock,
                                                                      manageStock: product
                                                                          .manageStock,
                                                                      creatorName: product
                                                                          .creatorDetails
                                                                          .businessName);
                                                                } else {
                                                                  viewCart(
                                                                      context,
                                                                      'shop');
                                                                  // CustomToast(AppLocalizations.of(
                                                                  //             context)!
                                                                  //         .translate(
                                                                  //             'this_product_is_already_added_to_your_cart') ??
                                                                  //     "This product is already added to your cart");
                                                                  // ScaffoldMessenger.of(
                                                                  //         context)
                                                                  //     .showSnackBar(
                                                                  //         SnackBar(
                                                                  //   elevation:
                                                                  //       0,
                                                                  //   backgroundColor:
                                                                  //       Colors
                                                                  //           .transparent,
                                                                  //   content:
                                                                  //       Container(
                                                                  //     margin: EdgeInsets
                                                                  //         .all(
                                                                  //             15),
                                                                  //     padding:
                                                                  //         EdgeInsets.all(
                                                                  //             20),
                                                                  //     color:
                                                                  //         bgColor,
                                                                  //     child: Text(
                                                                  //         AppLocalizations.of(context)!.translate('this_product_is_already_added_to_your_cart') ??
                                                                  //             "This product is already added to your cart"),
                                                                  //   ),
                                                                  // ));
                                                                  //                    CustomSnackBar(
                                                                  // navigatorKey.currentContext!,
                                                                  // Text(
                                                                  //     "This product is already added to your cart"));
                                                                }
                                                              } else {
                                                                CustomToast(AppLocalizations.of(
                                                                            context)!
                                                                        .translate(
                                                                            'product_is_out_of_stock') ??
                                                                    "Product is out of stock");
                                                                // ScaffoldMessenger.of(
                                                                //         context)
                                                                //     .showSnackBar(
                                                                //         SnackBar(
                                                                //   elevation: 0,
                                                                //   backgroundColor:
                                                                //       Colors
                                                                //           .transparent,
                                                                //   content:
                                                                //       Container(
                                                                //     margin: EdgeInsets
                                                                //         .all(
                                                                //             15),
                                                                //     padding:
                                                                //         EdgeInsets.all(
                                                                //             20),
                                                                //     color:
                                                                //         bgColor,
                                                                //     child: Text(
                                                                //         AppLocalizations.of(context)!.translate('product_is_out_of_stock') ??
                                                                //             "Product is out of stock"),
                                                                //   ),
                                                                // ));
                                                              }
                                                            } else if (product
                                                                    .hasVariations &&
                                                                variationid !=
                                                                    0) {
                                                              if (variation
                                                                  .isInStock) {
                                                                if (isProductExist(
                                                                        box,
                                                                        widget
                                                                            .id,
                                                                        variationId:
                                                                            variationid) ==
                                                                    null) {
                                                                  context.read<CartProvider>().addItemToCart(
                                                                      context:
                                                                          context,
                                                                      creatorId: product
                                                                          .creatorId,
                                                                      image: product
                                                                          .image,
                                                                      name: product
                                                                          .name,
                                                                      price: price != 0
                                                                          ? price
                                                                          : product
                                                                              .price,
                                                                      quantity:
                                                                          1,
                                                                      id: product
                                                                          .catalogId,
                                                                      variationId:
                                                                          variationid,
                                                                      variation_name: variationid != 0
                                                                          ? variation.options[
                                                                              'variation_name']
                                                                          : null,
                                                                      weight: weight != 0
                                                                          ? weight
                                                                          : product
                                                                              .weight,
                                                                      masterStock: variationid != 0
                                                                          ? data
                                                                              .result
                                                                              ?.variations![
                                                                                  variationIndex!]
                                                                              .masterStock
                                                                          : product
                                                                              .masterStock,
                                                                      manageStock: product
                                                                          .manageStock,
                                                                      creatorName: product
                                                                          .creatorDetails
                                                                          .businessName);
                                                                } else {
                                                                  viewCart(
                                                                      context,
                                                                      'shop');
                                                                }
                                                              } else {
                                                                CustomToast(AppLocalizations.of(
                                                                            context)!
                                                                        .translate(
                                                                            'product_is_out_of_stock') ??
                                                                    "Product is out of stock");
                                                                // ScaffoldMessenger.of(
                                                                //         context)
                                                                //     .showSnackBar(
                                                                //         SnackBar(
                                                                //   elevation: 0,
                                                                //   backgroundColor:
                                                                //       Colors
                                                                //           .transparent,
                                                                //   content:
                                                                //       Container(
                                                                //     margin: EdgeInsets
                                                                //         .all(
                                                                //             15),
                                                                //     padding:
                                                                //         EdgeInsets.all(
                                                                //             20),
                                                                //     color:
                                                                //         bgColor,
                                                                //     child: Text(
                                                                //         AppLocalizations.of(context)!.translate('product_is_out_of_stock') ??
                                                                //             "Product is out of stock"),
                                                                //   ),
                                                                // ));
                                                              }
                                                            } else {
                                                              CustomToast(AppLocalizations.of(
                                                                          context)!
                                                                      .translate(
                                                                          'please_select_variant') ??
                                                                  "Please select variant");
                                                              // ScaffoldMessenger
                                                              //         .of(
                                                              //             context)
                                                              //     .showSnackBar(
                                                              //         SnackBar(
                                                              //   elevation: 0,
                                                              //   backgroundColor:
                                                              //       Colors
                                                              //           .transparent,
                                                              //   content:
                                                              //       Container(
                                                              //     margin:
                                                              //         EdgeInsets
                                                              //             .all(
                                                              //                 15),
                                                              //     padding:
                                                              //         EdgeInsets
                                                              //             .all(
                                                              //                 20),
                                                              //     color:
                                                              //         bgColor,
                                                              //     child: Text(AppLocalizations.of(
                                                              //                 context)!
                                                              //             .translate(
                                                              //                 'please_select_variant') ??
                                                              //         "Please select variant"),
                                                              //   ),
                                                              // ));
                                                            }

                                                            // viewCart(context,
                                                            //     'shop');
                                                          },
                                                          style: ButtonStyle(
                                                              shape: MaterialStateProperty.all(
                                                                  const StadiumBorder()),
                                                              backgroundColor:
                                                                  MaterialStateProperty.all(
                                                                      const Color(
                                                                          0xFFFF5858)),
                                                              foregroundColor: MaterialStateProperty.all(
                                                                  Colors.white),
                                                              elevation:
                                                                  MaterialStateProperty.all(
                                                                      5),
                                                              shadowColor:
                                                                  MaterialStateProperty.all(Color(
                                                                      0xFFFC5E6A33)),
                                                              padding: MaterialStateProperty.all(
                                                                  const EdgeInsets.only(
                                                                      left: 30,
                                                                      right: 30,
                                                                      top: 15,
                                                                      bottom: 15))),
                                                          icon: const Icon(Icons.shopping_cart_rounded),
                                                          label: Text(
                                                            variation != null &&
                                                                    variation
                                                                        .isInStock
                                                                ? isProductExist(
                                                                            box,
                                                                            widget
                                                                                .id,
                                                                            variationId:
                                                                                variationid) ==
                                                                        null
                                                                    ? AppLocalizations.of(context)!.translate(
                                                                            'detail_add_cart') ??
                                                                        'Add to Cart'
                                                                    : AppLocalizations.of(context)!.translate(
                                                                            'added_to_cart') ??
                                                                        'Added to cart'
                                                                : variation ==
                                                                            null &&
                                                                        product
                                                                            .isInStock
                                                                    ? isProductExist(box, widget.id) ==
                                                                            null
                                                                        ? AppLocalizations.of(context)!.translate('detail_add_cart') ??
                                                                            'Add to Cart'
                                                                        : AppLocalizations.of(context)!.translate('added_to_cart') ??
                                                                            'Added to cart'
                                                                    : AppLocalizations.of(context)!
                                                                            .translate('out_of_stock') ??
                                                                        'Out of stock',
                                                            style: ThreeKmTextConstants
                                                                .tk14PXPoppinsWhiteMedium,
                                                          ))
                                                  ],
                                                ));
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 20, bottom: 20),
                              width: ThreeKmScreenUtil.screenWidthDp,
                              height: 20,
                              color: const Color(0xFFF4F3F8),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                //mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                            .translate('sold_by') ??
                                        'Sold By',
                                    style: ThreeKmTextConstants
                                        .tk14PXPoppinsBlackSemiBold,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => BusinessDetail(
                                                    id: data.result?.product
                                                        .creatorId,
                                                  )));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 20,
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white,
                                          boxShadow: const [
                                            BoxShadow(
                                                blurRadius: 30,
                                                color: Color(0x3B4A7424))
                                          ]),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              child: Image(
                                                image: NetworkImage(
                                                    '${data.result?.product.creatorDetails.logo}'),
                                                height: ThreeKmScreenUtil
                                                        .screenHeightDp /
                                                    7,
                                                width: ThreeKmScreenUtil
                                                        .screenWidthDp /
                                                    3.3,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: ThreeKmScreenUtil
                                                        .screenWidthDp /
                                                    1.9,
                                                child: Text(
                                                  '${product.creatorDetails.businessName}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: ThreeKmTextConstants
                                                      .tk16PXPoppinsBlackSemiBold,
                                                ),
                                              ),
                                              // Text(
                                              //  // '${product?.creatorDetails}',
                                              //   '${data.result?.product.tags[0]}, ${data.result?.product.tags[1]}',
                                              //   style: ThreeKmTextConstants
                                              //       .tk12PXLatoGreenMedium,
                                              // ),

                                              // Text(
                                              //   'Kothrod(1.2 km)',
                                              //   style: ThreeKmTextConstants
                                              //       .tk12PXLatoBlackBold
                                              //       .copyWith(height: 3),
                                              // ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 20, bottom: 20),
                              width: ThreeKmScreenUtil.screenWidthDp,
                              height: 20,
                              color: const Color(0xFFF4F3F8),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Reviews (${data.result!.reviews?.length})',
                                        style: ThreeKmTextConstants
                                            .tk14PXPoppinsBlackSemiBold,
                                      ),
                                      Spacer(),
                                      Text(
                                        '0.0',
                                        style: ThreeKmTextConstants
                                            .tk14PXPoppinsBlackSemiBold,
                                      ),
                                      const Icon(
                                        Icons.star_rate_rounded,
                                        color: Color(0xFFFBA924),
                                        size: 30,
                                      )
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        top: 30, bottom: 30),
                                    width: ThreeKmScreenUtil.screenWidthDp,
                                    child: ElevatedButton.icon(
                                        onPressed: () {
                                          showModalBottomSheet(
                                              backgroundColor:
                                                  Colors.transparent,
                                              isScrollControlled: true,
                                              context: context,
                                              builder: (_) {
                                                return PostReview(
                                                  catalogId: product.catalogId,
                                                  name: product.name,
                                                );
                                              });
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
                                                MaterialStateProperty.all(0),
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
                                            Icons.star_border_rounded),
                                        label: Text(AppLocalizations.of(context)!.translate('write_a_review') ?? 'Write a Review', style: ThreeKmTextConstants.tk14PXPoppinsWhiteMedium.copyWith(letterSpacing: 1.12))),
                                  ),
                                  const Divider(
                                    color: Color(0xFFF4F6F9),
                                    height: 10,
                                    thickness: 3,
                                  ),
                                  ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 20),
                                      itemCount: listLength(
                                          data.result?.reviews?.length),
                                      shrinkWrap: true,
                                      itemBuilder: (_, i) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  child: Image(
                                                    image: NetworkImage(
                                                        '${data.result?.reviews?[i].avatar}'),
                                                    errorBuilder: (e, _, __) =>
                                                        Container(
                                                            color: Colors.grey,
                                                            width: 24,
                                                            height: 24),
                                                    width: 60,
                                                    height: 60,
                                                  ),
                                                ),
                                                Container(
                                                  //color: Colors.black,
                                                  width: ThreeKmScreenUtil
                                                          .screenWidthDp /
                                                      2,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Text(
                                                    '${data.result?.reviews?[i].user}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 17,
                                                        color:
                                                            Color(0xFF232629)),
                                                  ),
                                                ),
                                                Spacer(),
                                                Container(
                                                  padding: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFFF4F3F8),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: Text(
                                                      AppLocalizations.of(
                                                                  context)!
                                                              .translate(
                                                                  'purchased') ??
                                                          'PURCHASED',
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, bottom: 15),
                                              child: Row(
                                                children: [
                                                  RatingBar.builder(
                                                    initialRating: data.result
                                                            ?.reviews?[i].rating
                                                            .toDouble() ??
                                                        0.0,
                                                    minRating: 1,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    itemCount: 5,
                                                    itemSize: 30,
                                                    itemBuilder: (context, _) =>
                                                        const Icon(
                                                      Icons.star_rate_rounded,
                                                      color: Colors.amber,
                                                    ),
                                                    onRatingUpdate: (v) => null,
                                                  ),
                                                  Text(
                                                      "${data.result?.reviews?[i].rating}"),
                                                  Spacer(),
                                                  Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 12),
                                                      child: Text(
                                                        '${data.result?.reviews?[i].date}',
                                                        style: const TextStyle(
                                                            color: Color(
                                                                0xBF0F0F2D),
                                                            fontSize: 17),
                                                      ))
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(
                                                '${data.result?.reviews?[i].title}',
                                                style: const TextStyle(
                                                    color: Color(0xFF0F0F2D),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, top: 5, bottom: 15),
                                              child: Text(
                                                '${data.result?.reviews?[i].description}',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xBF0F0F2D)),
                                              ),
                                            ),
                                            if (data.result!.reviews![i].images
                                                    .length >
                                                0)
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 90,
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount: data
                                                        .result
                                                        ?.reviews?[i]
                                                        .images
                                                        .length,
                                                    itemBuilder: (_, index) {
                                                      return Image(
                                                          image: NetworkImage(
                                                              '${data.result?.reviews?[i].images[index]}'),
                                                          width: 80,
                                                          height: 80);
                                                    }),
                                              )
                                          ],
                                        );
                                      }),
                                  if (data.result!.reviews!.length != 0 &&
                                      data.result!.reviews!.length > 2)
                                    Container(
                                      padding: const EdgeInsets.only(
                                          top: 30, bottom: 30),
                                      margin: EdgeInsets.only(bottom: 30),
                                      width: ThreeKmScreenUtil.screenWidthDp,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              readReview =
                                                  readReview ? false : true;
                                            });
                                          },
                                          style: ButtonStyle(
                                              shape: MaterialStateProperty.all(
                                                  const StadiumBorder()),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      const Color(0xFFF4F3F8)),
                                              foregroundColor:
                                                  MaterialStateProperty.all(
                                                      Color(0xFF0F0F2D)),
                                              elevation:
                                                  MaterialStateProperty.all(0),
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
                                            !readReview
                                                ? AppLocalizations.of(context)!
                                                        .translate(
                                                            'view_all_reviews') ??
                                                    'View All Reviews'
                                                : AppLocalizations.of(context)!
                                                        .translate(
                                                            'view_less_reviews') ??
                                                    'View Less Reviews',
                                            style: const TextStyle(
                                                fontSize: 18, letterSpacing: 3),
                                          )),
                                    )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    : Container(
                        child: Text(AppLocalizations.of(context)!
                                .translate('loading') ??
                            'Loading ..... '),
                      )
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: !isvisible &&
                statusData == 'loaded' &&
                data.result != null
            ? Container(
                color: Colors.white,
                height: 70,
                child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: SizedBox(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                              onPressed: () {
                                if (isWish == null) {
                                  context
                                      .read<WishListProvider>()
                                      .addToWishList(
                                          image: product?.image,
                                          name: product?.name,
                                          price: price != 0
                                              ? price
                                              : product?.price,
                                          id: product?.catalogId,
                                          variationId: variationid,
                                          variation_name: variationid != 0
                                              ? variation
                                                  .options['variation_name']
                                              : null,
                                          weight: product?.weight,
                                          manageStock: product?.manageStock,
                                          masterStock: product?.masterStock,
                                          creatorId: product?.creatorId,
                                          creatorName: product
                                              ?.creatorDetails.businessName);
                                } else {
                                  context
                                      .read<WishListProvider>()
                                      .removeWish(product?.catalogId);
                                  setState(() {});
                                }
                              },
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      StadiumBorder()),
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color(0xFFF4F3F8)),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.black),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.only(
                                          left: isWish != null ? 10 : 30,
                                          right: 30,
                                          top: isWish != null ? 0 : 15,
                                          bottom: isWish != null ? 0 : 15))),
                              icon: isWish != null
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
                                isWish != null
                                    ? AppLocalizations.of(context)!
                                            .translate('remove') ??
                                        'Remove'
                                    : AppLocalizations.of(context)!
                                            .translate('wishlist') ??
                                        'Wishlist',
                                style: ThreeKmTextConstants
                                    .tk14PXPoppinsBlackMedium,
                              )),
                          ValueListenableBuilder(
                            valueListenable: Hive.box('cartBox').listenable(),
                            builder: (BuildContext context, Box<dynamic> box,
                                Widget? child) {
                              return ElevatedButton.icon(
                                  onPressed: () async {
                                    if (product!.hasVariations == false) {
                                      if (product.isInStock) {
                                        if (isProductExist(box, widget.id) ==
                                            null) {
                                          context
                                              .read<CartProvider>()
                                              .addItemToCart(
                                                  context: context,
                                                  creatorId: product.creatorId,
                                                  image: product.image,
                                                  name: product.name,
                                                  price: price != 0
                                                      ? price
                                                      : product.price,
                                                  quantity: 1,
                                                  id: product.catalogId,
                                                  variationId: variationid,
                                                  variation_name:
                                                      variationid != 0
                                                          ? variation.options[
                                                              'variation_name']
                                                          : null,
                                                  weight: weight != 0
                                                      ? weight
                                                      : product.weight,
                                                  masterStock: variationid != 0
                                                      ? data
                                                          .result
                                                          ?.variations![
                                                              variationIndex!]
                                                          .masterStock
                                                      : product.masterStock,
                                                  manageStock:
                                                      product.manageStock,
                                                  creatorName: product
                                                      .creatorDetails
                                                      .businessName);
                                        } else {
                                          viewCart(context, 'shop');

                                          // CustomSnackBar(
                                          //     context,
                                          //     Text(
                                          //         "This product is already added to your cart"));
                                        }
                                      } else {
                                        CustomToast("Product is out of stock");
                                        // CustomSnackBar(context,
                                        //     Text("Product is out of stock"));
                                      }
                                    } else if (product.hasVariations &&
                                        variationid != 0) {
                                      if (variation.isInStock) {
                                        if (isProductExist(box, widget.id,
                                                variationId: variationid) ==
                                            null) {
                                          context
                                              .read<CartProvider>()
                                              .addItemToCart(
                                                  context: context,
                                                  creatorId: product.creatorId,
                                                  image: product.image,
                                                  name: product.name,
                                                  price: price != 0
                                                      ? price
                                                      : product.price,
                                                  quantity: 1,
                                                  id: product.catalogId,
                                                  variationId: variationid,
                                                  variation_name:
                                                      variationid != 0
                                                          ? variation.options[
                                                              'variation_name']
                                                          : null,
                                                  weight: weight != 0
                                                      ? weight
                                                      : product.weight,
                                                  masterStock: variationid != 0
                                                      ? data
                                                          .result
                                                          ?.variations![
                                                              variationIndex!]
                                                          .masterStock
                                                      : product.masterStock,
                                                  manageStock:
                                                      product.manageStock,
                                                  creatorName: product
                                                      .creatorDetails
                                                      .businessName);
                                        } else {
                                          CustomSnackBar(
                                              context,
                                              Text(AppLocalizations.of(context)!
                                                      .translate(
                                                          'this_product_is_already_added_to_your_cart') ??
                                                  "This product is already added to your cart"));
                                        }
                                      } else {
                                        CustomSnackBar(context,
                                            Text("Product is out of stock"));
                                      }
                                    } else {
                                      CustomToast(AppLocalizations.of(context)!
                                              .translate(
                                                  'please_select_variant') ??
                                          "Please select variant");
                                      // CustomSnackBar(context,
                                      //     Text("Please select variant"));
                                    }

                                    // viewCart(context,
                                    //     'shop');
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
                                    variation != null && variation.isInStock
                                        ? isProductExist(box, widget.id,
                                                    variationId: variationid) ==
                                                null
                                            ? AppLocalizations.of(context)!
                                                    .translate(
                                                        'detail_add_cart') ??
                                                'Add to Cart'
                                            : AppLocalizations.of(context)!
                                                    .translate(
                                                        'added_to_cart') ??
                                                'Added to cart'
                                        : variation == null &&
                                                product!.isInStock
                                            ? isProductExist(box, widget.id) ==
                                                    null
                                                ? AppLocalizations.of(context)!
                                                        .translate(
                                                            'detail_add_cart') ??
                                                    'Add to Cart'
                                                : AppLocalizations.of(context)!
                                                        .translate(
                                                            'added_to_cart') ??
                                                    'Added to cart'
                                            : AppLocalizations.of(context)!
                                                    .translate('out_of_stock') ??
                                                'Out of stock',
                                    style: ThreeKmTextConstants
                                        .tk14PXPoppinsWhiteMedium,
                                  ));
                              // : Container(
                              //     decoration: BoxDecoration(
                              //         border: Border.all(),
                              //         borderRadius:
                              //             BorderRadius.circular(40)),
                              //     child: Row(
                              //       mainAxisAlignment:
                              //           MainAxisAlignment.spaceBetween,
                              //       //mainAxisSize: MainAxisSize.min,
                              //       children: [
                              //         InkWell(
                              //           onTap: () {
                              //             if (isProductExist(box, widget.id)
                              //                     .quantity <
                              //                 2) {
                              //               isProductExist(box, widget.id)
                              //                   .delete();
                              //             }
                              //             if (isProductExist(
                              //                     box, widget.id) !=
                              //                 null) {
                              //               isProductExist(box, widget.id)
                              //                   .quantity = isProductExist(
                              //                           box, widget.id)
                              //                       .quantity -
                              //                   1;

                              //               if (isProductExist(
                              //                       box, widget.id)
                              //                   .isInBox) {
                              //                 isProductExist(box, widget.id)
                              //                     .save();
                              //               }
                              //             }
                              //           },
                              //           child: const Image(
                              //             image: AssetImage(
                              //                 'assets/shopImg/del.png'),
                              //             width: 70,
                              //             height: 30,
                              //           ),
                              //         ),
                              //         Padding(
                              //           padding: const EdgeInsets.only(
                              //               top: 10, bottom: 10),
                              //           child: Text(
                              //             '${isProductExist(box, widget.id).quantity}',
                              //             style: ThreeKmTextConstants
                              //                 .tk20PXPoppinsRedBold
                              //                 .copyWith(
                              //                     color: Colors.black),
                              //           ),
                              //         ),
                              //         InkWell(
                              //           onTap: () {
                              //             isProductExist(box, widget.id)
                              //                     .quantity =
                              //                 isProductExist(box, widget.id)
                              //                         .quantity +
                              //                     1;
                              //             isProductExist(box, widget.id)
                              //                 .save();
                              //           },
                              //           child: const Image(
                              //             image: AssetImage(
                              //                 'assets/shopImg/add.png'),
                              //             width: 70,
                              //             height: 30,
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   );
                            },
                          ),
                        ],
                      ),
                    )),
              )
            : Container(),
      );
    }));
  }
}
