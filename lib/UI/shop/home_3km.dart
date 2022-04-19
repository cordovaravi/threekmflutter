import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threekm/Custom_library/GooleMapsWidget/src/place_picker.dart';
import 'package:threekm/UI/Auth/signup/sign_up.dart';
import 'package:threekm/UI/Search/SearchPage.dart';
import 'package:threekm/UI/businesses/businesses_detail.dart';
import 'package:threekm/UI/businesses/businesses_home.dart';
import 'package:threekm/UI/main/navigation.dart';
import 'package:threekm/UI/shop/cart/cart_item_list_modal.dart';
import 'package:threekm/commenwidgets/commenwidget.dart';

import 'package:threekm/localization/localize.dart';

import 'package:threekm/providers/Location/locattion_Provider.dart';
import 'package:threekm/providers/ProfileInfo/ProfileInfo_Provider.dart';
import 'package:threekm/providers/shop/shop_home_provider.dart';
import 'package:provider/provider.dart';
import 'package:threekm/Models/shopModel/shop_home_model.dart';
import 'package:threekm/utils/api_paths.dart';
import 'package:threekm/utils/screen_util.dart';
import 'package:threekm/utils/threekm_textstyles.dart';
import '../shop/product/product_details.dart';
import '../shop/product_listing.dart';
import '../shop/restaurants/restaurants_home_card.dart';
import '../shop/restaurants/restaurants_home_page.dart';
import '../shop/restaurants/restaurants_menu.dart';
import '../shop/restaurants/view_all_restaurant.dart';

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
    Future.delayed(Duration.zero, () {
      context.read<ShopHomeProvider>().getShopHome(mounted);
      context.read<LocationProvider>().getLocation();
    });

    Future.microtask(() {
      openBox();
    });
    //context.read<ShopHomeProvider>().getShopHome(mounted);
    // context.read<ShopHomeProvider>().getRestaurants(initJson, mounted);
    super.initState();
  }

  openBox() async {
    await Hive.openBox('restroCartBox');
    await Hive.openBox('cartBox');
  }

  @override
  Widget build(BuildContext context) {
    final shopHomeProvider = context.watch<ShopHomeProvider>();
    final _location = context.read<LocationProvider>().getlocationData;
    return Scaffold(
      body: RefreshIndicator(onRefresh: () {
        var initJson = json.encode({
          "lat": _location?.latitude ?? '',
          "lng": _location?.longitude ?? '',
          "page": 1
        });
        return context.read<ShopHomeProvider>().onRefresh(initJson, mounted);
      }, child: Builder(builder: (context) {
        if (shopHomeProvider.state == 'loading') {
          return showLayoutLoading('shop');
        } else if (shopHomeProvider.state == "error") {
          context.read<ShopHomeProvider>().getShopHome(mounted);
          return const Center(
              //child: Text("error"),
              );
        } else if (shopHomeProvider.state == "loaded") {
          return shopHomeProvider.shopHomeData != null
              ? ShopHome(
                  imgSrg: imgSrg,
                  shopHomeProvider: shopHomeProvider,
                )
              : Center(child: Text(""));
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

class _ShopHomeState extends State<ShopHome>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  ScrollController? _scrollController;
  String? _selecetedAddress;
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

    super.initState();
  }

  @override
  dispose() {
    _controller.dispose();
    _scrollController?.dispose();

    super.dispose();
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
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => BusinessDetail(
                                          id: data?.imageswcta![0].business,
                                        )));
                          },
                          icon: Icon(Icons.account_circle),
                          label: Text(
                            AppLocalizations.of(context)!
                                    .translate('view_profile') ??
                                "View Profile",
                          )),
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
                            (data!.imageswcta![0].website)!.startsWith('http')
                                ? launch('${data.imageswcta![0].website}')
                                : launch(
                                    'https://${data.imageswcta![0].website}');
                          },
                          icon: Icon(Icons.web),
                          label: Text('${data?.imageswcta?[0].website}')),
                    ),
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          AppLocalizations.of(context)!.translate('close') ??
                              "",
                        ))
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    final profileinfo = context.watch<ProfileInfoProvider>();
    super.build(context);
    _controller.repeat();
    var shopAdvData = widget.shopHomeProvider.shopHomeData!.result!.shopAdv;
    var shopsData = widget.shopHomeProvider.shopHomeData?.result?.shops;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final locationProvider = context.watch<LocationProvider>();
    var restaurantData =
        widget.shopHomeProvider.restaurantData?.result.creators;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        color: Color(0xFFF4F3F8),
        padding: EdgeInsets.zero,
        width: width,
        height: height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  Future.delayed(Duration.zero, () {
                    context
                        .read<LocationProvider>()
                        .getLocation()
                        .whenComplete(() {
                      final _locationProvider =
                          context.read<LocationProvider>().getlocationData;
                      final kInitialPosition = LatLng(
                          _locationProvider!.latitude!,
                          _locationProvider.longitude!);
                      if (_locationProvider != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlacePicker(
                                apiKey: GMap_Api_Key,
                                // initialMapType: MapType.satellite,
                                onPlacePicked: (result) {
                                  //print(result.formattedAddress);
                                  log(result.toString());
                                  log('${result.geometry?.location.lat} ${result.geometry?.location.lng}');

                                  setState(() {
                                    _selecetedAddress = result.vicinity;
                                    context
                                        .read<ShopHomeProvider>()
                                        .getRestaurants(mounted, 1,
                                            lat: result.geometry?.location.lat,
                                            lng: result.geometry?.location.lng);
                                    print(result.geometry!.toJson());
                                  });
                                  Navigator.of(context).pop();
                                },
                                initialPosition: kInitialPosition,
                                useCurrentLocation: true,
                                selectInitialPosition: true,
                                usePinPointingSearch: true,
                                usePlaceDetailSearch: true,
                              ),
                            ));
                      }
                    });
                  });
                },
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(top: 10, left: 15, right: 20),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.location_on_outlined,
                          color: Colors.red,
                          size: 24,
                        ),
                        onPressed: () {},
                      ),
                      Container(
                        constraints: BoxConstraints(
                            minWidth: 40,
                            maxWidth: MediaQuery.of(context).size.width / 2),
                        child: Text(
                          locationProvider.AddressFromCordinate ??
                              _selecetedAddress ??
                              "",
                          style:
                              ThreeKmTextConstants.tk12PXPoppinsBlackSemiBold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchPage(
                                        tabNuber: 1,
                                      )));
                        },
                        child: Container(
                          height: 32,
                          width: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                              //color: Colors.white,
                              borderRadius: BorderRadius.circular(21),
                              border: Border.all(color: Color(0xffDFE5EE))),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Icon(
                                  Icons.search_rounded,
                                  color: Colors.grey,
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(left: 11),
                                  child: Text(
                                    AppLocalizations.of(context)!.translate(
                                            'search_hyperlocal_product') ??
                                        "Search Hyperlocal Products",
                                    //"Search Hyperlocal Products",
                                    style: ThreeKmTextConstants
                                        .tk12PXLatoBlackBold
                                        .copyWith(color: Colors.grey),
                                  ))
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => viewCart(context, 'shop')
                            .whenComplete(() => setState(() {})),
                        child: Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                  height: 32,
                                  width: 32,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/shopImg/Group 40724.png")),
                                    shape: BoxShape.circle,
                                    //color: Color(0xff7572ED)
                                  )),
                              if (Hive.box('cartBox').length != 0)
                                Positioned(
                                    top: -10,
                                    right: -8,
                                    child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            '${Hive.box('cartBox').length}',
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.white),
                                          ),
                                        )))
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          SharedPreferences _pref =
                              await SharedPreferences.getInstance();
                          var token = _pref.getString("token");
                          token != null
                              ? drawerController.open!()
                              // : Navigator.push(context,
                              //     MaterialPageRoute(builder: (_) => SignUp()));
                              : Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (_) => SignUp()),
                                  (route) => false);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Container(
                              height: 32,
                              width: 32,
                              decoration: BoxDecoration(
                                image: profileinfo.Avatar != null
                                    ? DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            profileinfo.Avatar.toString()))
                                    : DecorationImage(
                                        image:
                                            AssetImage("assets/male-user.png")),
                                shape: BoxShape.circle,
                                //color: Color(0xffFF464B)
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => BusinessesHome()));
                },
                child: Image(
                  image: AssetImage('assets/BusinessesImg/shopHomeBiz.png'),
                  width: double.infinity,
                  //height: 400,
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
                height: 300,
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
                                    // width: ThreeKmScreenUtil.screenWidthDp /
                                    //     1.1888,
                                    // height: ThreeKmScreenUtil.screenHeightDp / 19,
                                    fit: BoxFit.contain,
                                    placeholder: (context, url) => Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          color: Colors.grey[200],
                                        ))),
                          ),
                        ),
                      );
                    }),
              ),
              Container(
                width: width,
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
                                  AppLocalizations.of(context)!
                                          .translate('order_food_from_your') ??
                                      'Order Food from your',
                                  style:
                                      ThreeKmTextConstants.tk20PXPoppinsRedBold,
                                ),
                                Text(
                                  AppLocalizations.of(context)!
                                          .translate('favorite_restaurant!') ??
                                      'Favorite Restaurant!',
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
                                width: width / 2.2,
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
                            AppLocalizations.of(context)!
                                    .translate('nearby_restaurants') ??
                                'Nearby Restaurants',
                            style:
                                ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => RestaurantsHome()));
                            },
                            child: Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                          .translate('view_all_text') ??
                                      "View All ",
                                  // 'View All ',
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
                    restaurantData != null
                        ? Container(
                            padding: const EdgeInsets.only(bottom: 10),
                            margin: const EdgeInsets.only(bottom: 10),
                            height: 330.0,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: restaurantData.length,
                              itemBuilder: (BuildContext ctxt, int index) {
                                return Container(
                                  // color: Colors.red,
                                  padding: const EdgeInsets.all(10),
                                  width: width / 1.7,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => RestaurantMenu(
                                                    data: restaurantData[index],
                                                  )));
                                    },
                                    child: RestaurantHomeCard(
                                      cardImage:
                                          "${restaurantData[index].cover}",
                                      context: context,
                                      heading: Text(
                                        '${restaurantData[index].businessName}',
                                        style: ThreeKmTextConstants
                                            .tk14PXLatoBlackBold,
                                      ),
                                      subHeading: Text(
                                          '${restaurantData[index].restaurant!.cuisines?.join(", ")}',
                                          maxLines: 2,
                                          style: ThreeKmTextConstants
                                              .tk12PXLatoBlackBold
                                              .copyWith(
                                                  color: Color(0xFF555C64))),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10,
                        top: 10,
                      ),
                      child: ElevatedButton(
                          child: Text(
                            AppLocalizations.of(context)!
                                    .translate('view_all_restaurants') ??
                                "View all restaurants",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => AllRestaurantList(
                                          isSearchActive: false,
                                        )));
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
                      image: AssetImage('assets/shopImg/pizzaFood.png')),
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
                        'Lifestyle on 3km!',
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
                              return InkWell(
                                onTap: () {
                                  Navigator.push(context, PageRouteBuilder(
                                      pageBuilder: (context, animaton,
                                          secondaryAnimation) {
                                    return ProductListing(
                                      query: 'Fashion',
                                    );
                                  }));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, top: 10, bottom: 10),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image(
                                          image: AssetImage(widget.imgSrg[i]),
                                          width: width / 1.1888,
                                          height: height / 5,
                                          fit: BoxFit.fill)),
                                ),
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
                    // Container(
                    //     margin: const EdgeInsets.only(top: 8, bottom: 10),
                    //     padding: const EdgeInsets.only(top: 8, bottom: 8),
                    //     //color: Colors.white70,
                    //     //width: ThreeKmScreenUtil.screenWidthDp / 1.1,
                    //     height: 190,
                    //     child: ListView.builder(
                    //         shrinkWrap: true,
                    //         scrollDirection: Axis.horizontal,
                    //         itemCount: shopsData?.length,
                    //         itemBuilder: (context, i) {
                    //           return Column(
                    //             children: [
                    //               InkWell(
                    //                   onTap: () {
                    //                     Navigator.push(
                    //                         context,
                    //                         PageRouteBuilder(
                    //                             pageBuilder: (context, animaton,
                    //                                 secondaryAnimation) {
                    //                               return ProductListing(
                    //                                 query:
                    //                                     '${shopsData?[i].name}',
                    //                               );
                    //                             },
                    //                             transitionDuration:
                    //                                 const Duration(
                    //                                     milliseconds: 800),
                    //                             transitionsBuilder: (context,
                    //                                 animation,
                    //                                 secondaryAnimation,
                    //                                 child) {
                    //                               animation = CurvedAnimation(
                    //                                   parent: animation,
                    //                                   curve: Curves.easeInOut);
                    //                               return FadeTransition(
                    //                                 opacity: animation,
                    //                                 child: child,
                    //                               );
                    //                             }));
                    //                   },
                    //                   child: Image(
                    //                       image: NetworkImage(
                    //                           '${shopsData?[i].images?.first}'),
                    //                       width: 80,
                    //                       height: 80)),
                    //               Container(
                    //                 margin: const EdgeInsets.only(
                    //                     left: 10, right: 10, top: 5),
                    //                 child: Text(
                    //                   '${shopsData?[i].name}',
                    //                   style: ThreeKmTextConstants
                    //                       .tk12PXPoppinsWhiteRegular,
                    //                 ),
                    //               ),
                    //             ],
                    //           );
                    //         }))
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
                                            query: '${e.name}',
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
                                  Text(
                                      AppLocalizations.of(context)!
                                              .translate('view_all_text') ??
                                          "",
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
                        // height: ThreeKmScreenUtil.screenHeightDp / 1.58,
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
                              mainAxisExtent: 260,
                              //mainAxisSpacing: 0,
                              // childAspectRatio: 0.69
                            ),
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
                                  padding: const EdgeInsets.all(10),
                                  // height: 220,
                                  // width: 160,
                                  //     ThreeKmScreenUtil.screenHeightDp / 2.7,
                                  child: BuildCard(
                                    cardImage: "${data?[index].image}",
                                    context: context,
                                    heading: Text('${data?[index].name}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: ThreeKmTextConstants
                                            .tk14PXPoppinsBlackBold),
                                    subHeading: Text('₹ ${data?[index].price}',
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

  @override
  bool get wantKeepAlive => true;
}
