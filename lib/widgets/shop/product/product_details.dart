import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/src/provider.dart';


import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:threekm/providers/shop/cart_provider.dart';
import 'package:threekm/providers/shop/product_details_provider.dart';
import 'package:threekm/utils/screen_util.dart';
import 'package:threekm/utils/threekm_textstyles.dart';
import 'package:threekm/widgets/shop/cart/cart_item_list_modal.dart';
import 'package:threekm/widgets/shop/product/post_review_form.dart';

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

  @override
  void initState() {
    print('${widget.id}======================');
    context.read<ProductDetailsProvider>().productDetails(mounted, widget.id);
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

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    var data = context.watch<ProductDetailsProvider>().ProductDetailsData;
    var product = data.result?.product;
    return RefreshIndicator(
      onRefresh: () {
        return context
            .read<ProductDetailsProvider>()
            .onRefresh(mounted, widget.id);
      },
      child: Builder(builder: (context) {
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
                      viewCart(context);
                    }),
              ),
            ],
          ),
          body: Stack(
            children: [
              Container(
                  width: ThreeKmScreenUtil.screenWidthDp,
                  height: ThreeKmScreenUtil.screenWidthDp / 1.1,
                  child: PageView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      pageSnapping: true,
                      onPageChanged: (val) {
                        print(val);
                      },
                      itemCount: data.result?.product.images.length,
                      itemBuilder: (context, index) {
                        return data.result?.product.images[index] != null
                            ? Image(
                                image: NetworkImage(
                                    '${data.result?.product.images[index]}'),
                                fit: BoxFit.fill,
                                width: ThreeKmScreenUtil.screenWidthDp / 1.1888,
                                height: ThreeKmScreenUtil.screenHeightDp / 4.7,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  width: 110,
                                  height: 80,
                                  color: Colors.grey[350],
                                ),
                              )
                            : Image.asset(
                                'assets/shopImg/noImage.jpg',
                                fit: BoxFit.fill,
                                alignment: Alignment.topCenter,
                              );
                      })),
              data.result != null
                  ? Container(
                      height: ThreeKmScreenUtil.screenHeightDp,
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.grey[300]!, blurRadius: 5)
                            ],
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40))),
                        height: ThreeKmScreenUtil.screenHeightDp / 1.6,
                        padding: const EdgeInsets.only(top: 20),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                    top: 30, left: 15, right: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${product?.name}',
                                      style: const TextStyle(
                                          fontSize: 25, height: 1.2),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 15),
                                      child: Row(
                                        children: [
                                          RatingBar.builder(
                                            initialRating: 3,
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
                                            onRatingUpdate: (rating) {
                                              print(rating);
                                            },
                                          ),
                                          Text("16"),
                                          Spacer(),
                                          Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  color: Color(0xFF43B978),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Text(
                                                '#${product?.catalogId}',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ))
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '\u{20B9}${product?.price}',
                                      style: const TextStyle(
                                        fontSize: 25,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 20),
                                      child:
                                          HtmlWidget('${product?.description}'),
                                    ),
                                    SizedBox(
                                      height: 50,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: product?.tags.length,
                                          itemBuilder: (context, i) {
                                            return Container(
                                              height: 35,
                                              padding: const EdgeInsets.only(
                                                  left: 15,
                                                  right: 15,
                                                  top: 5,
                                                  bottom: 5),
                                              margin: const EdgeInsets.only(
                                                  top: 7, bottom: 7, right: 7),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Color(0xFF555C64)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Text(
                                                '${product?.tags[i]}',
                                                style: ThreeKmTextConstants
                                                    .tk12PXLatoGreenMedium,
                                              ),
                                            );
                                          }),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton.icon(
                                              onPressed: () {},
                                              style: ButtonStyle(
                                                  shape:
                                                      MaterialStateProperty.all(
                                                          StadiumBorder()),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          const Color(
                                                              0xFFF4F3F8)),
                                                  foregroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.black),
                                                  padding:
                                                      MaterialStateProperty.all(
                                                          const EdgeInsets.only(
                                                              left: 30,
                                                              right: 30,
                                                              top: 15,
                                                              bottom: 15))),
                                              icon: const Icon(
                                                  Icons.favorite_outline_sharp),
                                              label: Text(
                                                'Wishlist',
                                                style: ThreeKmTextConstants
                                                    .tk14PXPoppinsBlackMedium,
                                              )),
                                          ElevatedButton.icon(
                                              onPressed: () async {
                                                // context
                                                //     .read<CartProvider>()
                                                //     .addToCart(
                                                //         image: product?.image,
                                                //         name: product?.name,
                                                //         price: product?.price,
                                                //         quantity: 1,
                                                //         id: product?.catalogId,
                                                //         variationId: 0);

                                                context
                                                    .read<CartProvider>()
                                                    .getAllCart(
                                                        context: context,
                                                        creatorId:
                                                            product?.creatorId,
                                                        image: product?.image,
                                                        name: product?.name,
                                                        price: product?.price,
                                                        quantity: 1,
                                                        id: product?.catalogId,
                                                        variationId: 0);
                                              },
                                              style: ButtonStyle(
                                                  shape:
                                                      MaterialStateProperty.all(
                                                          const StadiumBorder()),
                                                  backgroundColor: MaterialStateProperty.all(
                                                      const Color(0xFFFF5858)),
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
                                              icon: const Icon(Icons.shopping_cart_rounded),
                                              label: Text(
                                                'Add to Cart',
                                                style: ThreeKmTextConstants
                                                    .tk14PXPoppinsWhiteMedium,
                                              )),
                                        ],
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
                                      'Sold By',
                                      style: ThreeKmTextConstants
                                          .tk14PXPoppinsBlackSemiBold,
                                    ),
                                    Container(
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
                                                  '${product?.creatorDetails.businessName}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: ThreeKmTextConstants
                                                      .tk16PXPoppinsBlackSemiBold,
                                                ),
                                              ),
                                              const Text(
                                                'Food, Restaurant',
                                                style: TextStyle(
                                                    color: Color(0xFF43B978)),
                                              ),
                                              const Text(
                                                'Kothrod(1.2 km)',
                                                style: TextStyle(
                                                    fontSize: 17, height: 3),
                                              ),
                                            ],
                                          )
                                        ],
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
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Spacer(),
                                        const Text(
                                          '4.3',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700),
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
                                                    catalogId:
                                                        product!.catalogId,
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
                                              Icons.star_border_rounded),
                                          label: const Text(
                                            'Write a Review',
                                            style: TextStyle(fontSize: 18),
                                          )),
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
                                            top: 10, bottom: 10),
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
                                                        BorderRadius.circular(
                                                            30),
                                                    child: Image(
                                                      image: NetworkImage(
                                                          '${data.result?.reviews?[i].avatar}'),
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
                                                          color: Color(
                                                              0xFF232629)),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Container(
                                                    padding: EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFFF4F3F8),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    child: const Text(
                                                        'PURCHASED',
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10, bottom: 15),
                                                child: Row(
                                                  children: [
                                                    RatingBar.builder(
                                                      initialRating: data
                                                              .result
                                                              ?.reviews?[i]
                                                              .rating
                                                              .toDouble() ??
                                                          0.0,
                                                      minRating: 1,
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: true,
                                                      itemCount: 5,
                                                      itemSize: 30,
                                                      itemBuilder:
                                                          (context, _) =>
                                                              const Icon(
                                                        Icons.star_rate_rounded,
                                                        color: Colors.amber,
                                                      ),
                                                      onRatingUpdate: (rating) {
                                                        print(rating);
                                                      },
                                                    ),
                                                    Text(
                                                        "${data.result?.reviews?[i].rating}"),
                                                    Spacer(),
                                                    Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 12),
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10,
                                                    top: 5,
                                                    bottom: 15),
                                                child: Text(
                                                  '${data.result?.reviews?[i].description}',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Color(0xBF0F0F2D)),
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                    data.result?.reviews?.length != 0
                                        ? Container(
                                            padding: const EdgeInsets.only(
                                                top: 30, bottom: 30),
                                            width:
                                                ThreeKmScreenUtil.screenWidthDp,
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    readReview = readReview
                                                        ? false
                                                        : true;
                                                  });
                                                },
                                                style: ButtonStyle(
                                                    shape: MaterialStateProperty.all(
                                                        const StadiumBorder()),
                                                    backgroundColor:
                                                        MaterialStateProperty.all(
                                                            const Color(
                                                                0xFFF4F3F8)),
                                                    foregroundColor:
                                                        MaterialStateProperty.all(
                                                            Color(0xFF0F0F2D)),
                                                    elevation:
                                                        MaterialStateProperty.all(
                                                            5),
                                                    shadowColor: MaterialStateProperty.all(
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
                                                      ? 'View All Reviews'
                                                      : 'View Less Reviews',
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      letterSpacing: 3),
                                                )),
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(
                      child: const Text('Loading ..... '),
                    )
            ],
          ),
        );
      }),
    );
  }
}
