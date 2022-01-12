import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:threekm_test/providers/shop/shop_home_provider.dart';
import 'package:provider/provider.dart';
import 'package:threekm_test/Models/shopModel/shop_home_model.dart';
import 'package:threekm_test/utils/api_paths.dart';
import 'package:threekm_test/utils/screen_util.dart';
import 'package:threekm_test/utils/threekm_textstyles.dart';
import 'package:threekm_test/widget/shop/cart/cart_item_list_modal.dart';
import 'package:threekm_test/widget/shop/product/product_details.dart';
import 'package:threekm_test/widget/shop/product_listing.dart';
import 'package:threekm_test/widget/shop/restaurants/restaurant_details.dart';
import 'package:threekm_test/widget/shop/restaurants/restaurants_home_card.dart';
import 'package:threekm_test/widget/shop/restaurants/restaurants_home_page.dart';
import 'package:threekm_test/widget/shop/restaurants/restaurants_menu.dart';
import 'package:threekm_test/widget/shop/restaurants/view_all_restaurant.dart';

import '../../constant.dart';
import 'category_list_home.dart';
import 'product_card_home.dart';
import 'package:url_launcher/url_launcher.dart';

class Home3KM extends StatefulWidget {
  Home3KM({Key? key}) : super(key: key);

  @override
  State<Home3KM> createState() => _Home3KMState();
}

class _Home3KMState extends State<Home3KM> {
  List imgSrg = [
    'assets/shopImg/fashion.jpg',
    'assets/shopImg/fashion1.jpg',
    'assets/shopImg/fashion2.jpg'
  ];

  @override
  void initState() {
    var initJson = json.encode({"lat": '', "lng": '', "page": 1});
    context.read<ShopHomeProvider>().getShopHome(mounted);
    context.read<ShopHomeProvider>().getRestaurants(initJson, mounted);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final shopHomeProvider = context.watch<ShopHomeProvider>();
    return Scaffold(
      body: RefreshIndicator(onRefresh: () {
        var initJson = json.encode({"lat": '', "lng": '', "page": 1});
        return context.read<ShopHomeProvider>().onRefresh(initJson, mounted);
      }, child: Builder(builder: (context) {
        if (shopHomeProvider.state == 'loading') {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (shopHomeProvider.state == "error") {
          return const Center(
            child: Text("error"),
          );
        } else if (shopHomeProvider.state == "loaded") {
          return shopHomeProvider.shopHomeData != null
              ? ShopHome(
                  imgSrg: imgSrg,
                  shopHomeProvider: shopHomeProvider,
                )
              : Text("null");
        }
        return Container();
      })),
    );
  }
}

class ShopHome extends StatefulWidget {
  const ShopHome({
    Key? key,
    required this.imgSrg,
    required this.shopHomeProvider,
  }) : super(key: key);

  final List imgSrg;
  final ShopHomeProvider shopHomeProvider;

  @override
  State<ShopHome> createState() => _ShopHomeState();
}

class _ShopHomeState extends State<ShopHome> with TickerProviderStateMixin {
  ScrollController? _scrollController;
  double? _scrollPosition = 0.0;
  late AnimationController _controller;

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController?.position.pixels;
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController(initialScrollOffset: 0);
    _scrollController?.addListener(_scrollListener);
    _controller = AnimationController(
        duration: Duration(milliseconds: 12000), vsync: this);
    openBox();
    super.initState();
  }

  openBox() async {
    await Hive.openBox('restroCartBox');
  }

  void showAlert(BuildContext context, ShopAdv? data) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Container(
                height: 200,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.account_circle),
                          label: Text('View Profile')),
                    ),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                          onPressed: () {
                            launch(('tel://${data?.imageswcta?[0].phone}'));
                          },
                          icon: Icon(Icons.phone),
                          label: Text('${data?.imageswcta?[0].phone}')),
                    ),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                          onPressed: () {
                            (data?.imageswcta?[0].website)!.startsWith('http')
                                ? launch('${data?.imageswcta?[0].website}')
                                : launch(
                                    'https://${data?.imageswcta?[0].website}');
                          },
                          icon: Icon(Icons.web),
                          label: Text('${data?.imageswcta?[0].website}')),
                    ),
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Close'))
                  ],
                ),
              ),
            ));
  }

  @override
  void didChangeDependencies() {
    ThreeKmScreenUtil.getInstance();
    ThreeKmScreenUtil.instance.init(context);
    super.didChangeDependencies();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.repeat();
    var shopAdvData = widget.shopHomeProvider.shopHomeData!.result!.shopAdv;
    var shopsData = widget.shopHomeProvider.shopHomeData?.result?.shops;

    var restaurantData =
        widget.shopHomeProvider.restaurantData?.result.creators;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        color: Color(0xFFF4F3F8),
        padding: const EdgeInsets.only(
          top: 60,
          // left: 10,
        ),
        width: ThreeKmScreenUtil.screenWidthDp,
        height: ThreeKmScreenUtil.screenHeightDp,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      // padding: const EdgeInsets.only(left: 20),
                      width: ThreeKmScreenUtil.screenWidthDp / 1.5,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        // controller: _firstName,
                        validator: (val) {},
                        //maxLength: 16,
                        autofocus: false,

                        decoration: InputDecoration(
                          hintText: 'Search for a store/item',
                          hintStyle: ThreeKmTextConstants.tk14PXLatoGreyRegular,
                          counterText: '',
                          filled: true,
                          prefixIcon: const Icon(Icons.search,
                              color: Color(0xFF0F0F2D)),
                          fillColor: Colors.grey[200],
                          //isDense: true,
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 13, 10, 13),
                          // enabledBorder: OutlineInputBorder(
                          //     borderSide: BorderSide(color: Colors.grey[400])),
                          // focusedBorder: OutlineInputBorder(
                          //     borderSide: BorderSide(color: Colors.grey[400])),
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    const Image(
                        image:
                            AssetImage('assets/shopImg/icons8-male-user-4.png'),
                        width: 40),
                    InkWell(
                      onTap: () {
                        viewCart(context, 'shop');
                      },
                      child: const Image(
                          image: AssetImage('assets/shopImg/Group 40724.png'),
                          width: 40),
                    )
                  ],
                ),
              ),
              CategoryListHome(
                category:
                    widget.shopHomeProvider.shopHomeData!.result!.trending,
              ),
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 10),
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                color: Colors.white70,
                //width: ThreeKmScreenUtil.screenWidthDp / 1.1,
                height: 200,
                child: ListView.builder(
                    padding: EdgeInsets.only(right: 20),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: shopAdvData?.length,
                    itemBuilder: (context, i) {
                      return InkWell(
                        onTap: () {
                          showAlert(context, shopAdvData?[i]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 10, bottom: 10),
                          child: Material(
                            borderRadius: BorderRadius.circular(10),
                            elevation: 1,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: shopAdvData![i].images!.first,
                                  width:
                                      ThreeKmScreenUtil.screenWidthDp / 1.1888,
                                  // height: ThreeKmScreenUtil.screenHeightDp / 19,
                                  fit: BoxFit.fill,
                                  placeholder: (context, url) =>
                                      Transform.scale(
                                    scale: 0.5,
                                    child: CircularProgressIndicator(
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                )),
                          ),
                        ),
                      );
                    }),
              ),
              Container(
                width: ThreeKmScreenUtil.screenWidthDp,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                        image: AssetImage('assets/shopImg/restaurantsBack.png'),
                        fit: BoxFit.cover)),
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 55, bottom: 45, left: 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Order Food from your',
                                  style:
                                      ThreeKmTextConstants.tk20PXPoppinsRedBold,
                                ),
                                Text(
                                  'Favourite Restaurant!',
                                  style:
                                      ThreeKmTextConstants.tk20PXPoppinsRedBold,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          right: -60,
                          child: RotationTransition(
                            //alignment: Alignment.center,
                            turns: Tween(begin: 1.0, end: 0.0)
                                .animate(_controller),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image(
                                image: const AssetImage(
                                    'assets/shopImg/biryani.png'),
                                width: ThreeKmScreenUtil.screenWidthDp / 2.2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 10, left: 25, right: 20, top: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Nearby Restaurants',
                            style:
                                ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => RestaurantsHome(
                                            data: widget.shopHomeProvider
                                                .restaurantData?.result,
                                          )));
                            },
                            child: Row(
                              children: [
                                Text(
                                  'View All ',
                                  style: ThreeKmTextConstants
                                      .tk14PXPoppinsRedSemiBold,
                                ),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Color(0xFFFF3636),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      margin: const EdgeInsets.only(bottom: 10),
                      height: 330.0,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return Container(
                            // color: Colors.red,
                            padding: const EdgeInsets.all(10),
                            width: ThreeKmScreenUtil.screenWidthDp / 1.7,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => RestaurantMenu(
                                              data: restaurantData?[index],
                                            )));
                              },
                              child: RestaurantHomeCard(
                                cardImage: "${restaurantData?[index].cover}",
                                context: context,
                                heading: Text(
                                  '${restaurantData?[index].businessName}',
                                  style:
                                      ThreeKmTextConstants.tk14PXLatoBlackBold,
                                ),
                                subHeading: Text(
                                    '${restaurantData?[index].restaurant!.cuisines?.join(", ")}',
                                    maxLines: 2,
                                    style: ThreeKmTextConstants
                                        .tk12PXLatoBlackBold),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 30,
                        top: 20,
                      ),
                      child: ElevatedButton(
                          child: const Text(
                            "View all Restaurants",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => AllRestaurantList()));
                          },
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all<double>(0),
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(Colors.red),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: const BorderSide(
                                          color: Colors.red))))),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18.0),
                  child: const Image(
                      image: AssetImage('assets/shopImg/pizzaFood.jpg')),
                ),
              ),
              Container(
                color: Color(0xFF0F0F2D),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 30),
                      child: Text(
                        'Puneri Lifestyle on 3km!',
                        style: ThreeKmTextConstants.tk16PXPoppinsWhiteBold,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 10),
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      //color: Colors.white70,
                      //width: ThreeKmScreenUtil.screenWidthDp / 1.1,
                      height: 190,
                      child: NotificationListener<ScrollEndNotification>(
                        child: ListView.builder(
                            padding: EdgeInsets.only(right: 20),
                            controller: _scrollController,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.imgSrg.length,
                            itemBuilder: (context, i) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, top: 10, bottom: 10),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image(
                                        image: AssetImage(widget.imgSrg[i]),
                                        width: ThreeKmScreenUtil.screenWidthDp /
                                            1.1888,
                                        height:
                                            ThreeKmScreenUtil.screenHeightDp /
                                                5,
                                        fit: BoxFit.fill)),
                              );
                            }),
                        onNotification: (notification) {
                          print(_scrollController?.position.pixels);
                          // print('=====${_scrollPosition? / 100 * 0.15}');
                          return true;
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 20, bottom: 20, right: 20),
                      child: LinearProgressIndicator(
                        valueColor: const AlwaysStoppedAnimation(Colors.amber),
                        minHeight: 1.5,
                        color: Colors.amber[400],
                        backgroundColor: Colors.white,
                        value: _scrollController!.hasClients
                            ? _scrollPosition! / 100 * 0.159
                            : 0.0,
                        semanticsLabel: 'Linear progress indicator',
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 8, bottom: 10),
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        //color: Colors.white70,
                        //width: ThreeKmScreenUtil.screenWidthDp / 1.1,
                        height: 190,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: shopsData?.length,
                            itemBuilder: (context, i) {
                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                              pageBuilder: (context, animaton,
                                                  secondaryAnimation) {
                                                return ProductListing(
                                                  productData:
                                                      '${shopsData?[i].name}',
                                                );
                                              },
                                              transitionDuration:
                                                  const Duration(
                                                      milliseconds: 800),
                                              transitionsBuilder: (context,
                                                  animation,
                                                  secondaryAnimation,
                                                  child) {
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
                                      width: 80,
                                      height: 80,
                                      margin: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      decoration: const BoxDecoration(
                                          color: Color(0xFFFFFFFF),
                                          shape: BoxShape.circle
                                          // borderRadius:const BorderRadius.all(Radius.circular(50))
                                          ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 10, right: 10, top: 5),
                                    child: Text(
                                      '${shopsData?[i].name}',
                                      style: ThreeKmTextConstants
                                          .tk12PXPoppinsWhiteRegular,
                                    ),
                                  ),
                                ],
                              );
                            }))
                  ],
                ),
              ),
              ...?shopsData?.map((e) {
                return Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 25, right: 20, top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${e.name}',
                              style: ThreeKmTextConstants
                                  .tk16PXPoppinsBlackSemiBold,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                        pageBuilder: (context, animaton,
                                            secondaryAnimation) {
                                          return ProductListing(
                                            productData: '${e.name}',
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
                              child: Row(
                                children: [
                                  Text('View All ',
                                      style: ThreeKmTextConstants
                                          .tk14PXPoppinsRedSemiBold),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Color(0xFFFF3636),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        //padding: const EdgeInsets.only(bottom: 10),
                        //margin: const EdgeInsets.only(bottom: 10),
                        height: ThreeKmScreenUtil.screenHeightDp / 1.58,
                        color: Color(0xFFFFFFFF),
                        // width: 300,
                        child: GridView.builder(
                            padding: const EdgeInsets.only(
                                top: 10, left: 15, right: 15),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    //crossAxisSpacing: ThreeKmSpacing.spacing_32,
                                    // mainAxisExtent: 80,
                                    //mainAxisSpacing: 0,
                                    childAspectRatio: 0.69),
                            //scrollDirection: Axis.horizontal,
                            itemCount: e.products?.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              List<Products>? data = e.products;
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                          pageBuilder: (context, animaton,
                                              secondaryAnimation) {
                                            return ProductDetails(
                                              id: data?[index].catalogId ?? 0,
                                            );
                                          },
                                          transitionDuration:
                                              const Duration(milliseconds: 800),
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
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
                                  // color: Colors.red,
                                  padding: const EdgeInsets.all(10),
                                  //width: ThreeKmScreenUtil.screenWidthDp / 1.5,
                                  //height: ThreeKmScreenUtil.screenHeightDp / 2.7,
                                  child: BuildCard(
                                    cardImage: "${data?[index].image}",
                                    context: context,
                                    heading: Text('${data?[index].name}',
                                        maxLines: 2,
                                        style: ThreeKmTextConstants
                                            .tk14PXPoppinsBlackBold),
                                    subHeading: Text(
                                        '\u{20B9} ${data?[index].price}',
                                        style: ThreeKmTextConstants
                                            .tk14PXLatoBlackBold
                                            .copyWith(
                                                color: Color(0xFFFC8338))),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                );
              }).toList()
            ],
          ),
        ),
      ),
    );
  }
}
