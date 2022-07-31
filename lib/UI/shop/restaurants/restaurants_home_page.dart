import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:threekm/Custom_library/GooleMapsWidget/src/place_picker.dart';
import 'package:threekm/Models/shopModel/restaurants_model.dart';

import 'package:threekm/UI/Auth/signup/sign_up.dart';

import 'package:threekm/UI/main/navigation.dart';
import 'package:threekm/UI/shop/restaurants/creator_card.dart';
import 'package:threekm/UI/shop/restaurants/cuisinesViewAll.dart';
import 'package:threekm/UI/shop/restaurants/view_all_restaurant.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/commenwidgets/commenwidget.dart';
import 'package:threekm/localization/localize.dart';
import 'package:threekm/main.dart';
import 'package:threekm/providers/Location/locattion_Provider.dart';
import 'package:threekm/providers/ProfileInfo/ProfileInfo_Provider.dart';
import 'package:threekm/providers/shop/cart_provider.dart';
import 'package:threekm/providers/shop/restaurant_menu_provider.dart';
import 'package:threekm/providers/shop/shop_home_provider.dart';
import 'package:threekm/utils/api_paths.dart';

import 'package:threekm/utils/threekm_textstyles.dart';
import '../../shop/cart/cart_item_list_modal.dart';
import '../../shop/restaurants/restaurants_menu.dart';
import 'package:geocoding/geocoding.dart';

class RestaurantsHome extends StatefulWidget {
  const RestaurantsHome({Key? key}) : super(key: key);

  @override
  State<RestaurantsHome> createState() => _RestaurantsHomeState();
}

class _RestaurantsHomeState extends State<RestaurantsHome> with AutomaticKeepAliveClientMixin {
  //  data:  shopHomeProvider.restaurantData?.result,
  Offset position = Offset(20.0, 20.0);
  String? _selecetedAddress;
  TextEditingController SearchController = TextEditingController();
  getaddressFromCoordinates() async {
    final _locationProvider = context.read<LocationProvider>();

    if (_locationProvider != null) {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _locationProvider.getLatitude ?? 18.5204, _locationProvider.getLongitude ?? 73.8567);
      setState(() {
        _selecetedAddress = placemarks.first.subLocality;
      });
    }
  }

  @override
  void initState() {
    // Future.microtask(() {
    getaddressFromCoordinates();
    // context.read<LocationProvider>().getLocation();
    // context.read<ShopHomeProvider>().getShopHome(mounted);
    context.read<ShopHomeProvider>().getRestaurants(mounted, 1);
    context.read<RestaurantMenuProvider>().cuisinesList(mounted);
    openBox();
    //  });
    super.initState();
  }

  openBox() async {
    await Hive.openBox('restroCartBox');
    await Hive.openBox('cartBox');
  }

  @override
  void dispose() {
    SearchController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var data = context.watch<ShopHomeProvider>().restaurantData?.result;
    var state = context.watch<ShopHomeProvider>().state;
    var cuisinesState = context.watch<RestaurantMenuProvider>().state;
    var cuisinesData = context.watch<RestaurantMenuProvider>().cuisinesListdata;
    final locationProvider = context.watch<LocationProvider>();
    final profileProvider = context.watch<ProfileInfoProvider>();
    return Scaffold(
        backgroundColor: Color(0xFFF4F3F8),
        body: RefreshIndicator(
          onRefresh: () {
            return context.read<ShopHomeProvider>().getRestaurants(mounted, 1);
          },
          child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
                SearchController.text = '';
              }
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // InkWell(
                  //   onTap: () {
                  //     Future.delayed(Duration.zero, () {
                  //       context
                  //           .read<LocationProvider>()
                  //           .getLocation()
                  //           .whenComplete(() {
                  //         final _locationProvider =
                  //             context.read<LocationProvider>().getlocationData;
                  //         final kInitialPosition = LatLng(
                  //             _locationProvider!.latitude!,
                  //             _locationProvider.longitude!);
                  //         if (_locationProvider != null) {
                  //           Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                 builder: (context) => PlacePicker(
                  //                   apiKey: GMap_Api_Key,
                  //                   // initialMapType: MapType.satellite,
                  //                   onPlacePicked: (result) {
                  //                     //print(result.formattedAddress);
                  //                     log(result.toString());
                  //                     log('${result.geometry?.location.lat} ${result.geometry?.location.lng}');

                  //                     setState(() {
                  //                       _selecetedAddress =
                  //                           result.formattedAddress;
                  //                       context
                  //                           .read<ShopHomeProvider>()
                  //                           .getRestaurants(mounted, 1,
                  //                               lat: result
                  //                                   .geometry?.location.lat,
                  //                               lng: result
                  //                                   .geometry?.location.lng);
                  //                       print(result.geometry!.toJson());
                  //                     });
                  //                     Navigator.of(context).pop();
                  //                   },
                  //                   initialPosition: kInitialPosition,
                  //                   useCurrentLocation: true,
                  //                   selectInitialPosition: true,
                  //                   usePinPointingSearch: true,
                  //                   usePlaceDetailSearch: true,
                  //                 ),
                  //               ));
                  //         }
                  //       });
                  //     });
                  //   },
                  //   child: Container(
                  //     color: Colors.white,
                  //     padding:
                  //         const EdgeInsets.only(top: 10, left: 15, right: 20),
                  //     child: Row(
                  //       //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         IconButton(
                  //           icon: Icon(
                  //             Icons.location_on_outlined,
                  //             color: Colors.red,
                  //             size: 24,
                  //           ),
                  //           onPressed: () {},
                  //         ),
                  //         Container(
                  //           constraints: BoxConstraints(
                  //               minWidth: 40,
                  //               maxWidth:
                  //                   MediaQuery.of(context).size.width * 0.85),
                  //           child: Text(
                  //             locationProvider.AddressFromCordinate ??
                  //                 _selecetedAddress ??
                  //                 "",
                  //             style: ThreeKmTextConstants
                  //                 .tk12PXPoppinsBlackSemiBold,
                  //             overflow: TextOverflow.ellipsis,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // Container(
                  //   color: Colors.white,
                  //   padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                  //   child: Padding(
                  //     padding: EdgeInsets.only(
                  //         // top: 18,
                  //         ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         InkWell(
                  //           onTap: () {
                  //             Navigator.push(
                  //                 context,
                  //                 MaterialPageRoute(
                  //                     builder: (context) => AllRestaurantList(
                  //                         isSearchActive: true)));
                  //           },
                  //           child: Container(
                  //             height: 32,
                  //             width: MediaQuery.of(context).size.width * 0.7,
                  //             decoration: BoxDecoration(
                  //                 //color: Colors.white,
                  //                 borderRadius: BorderRadius.circular(21),
                  //                 border: Border.all(color: Color(0xffDFE5EE))),
                  //             child: Row(
                  //               children: [
                  //                 Padding(
                  //                   padding: EdgeInsets.only(left: 15),
                  //                   child: Icon(
                  //                     Icons.search_rounded,
                  //                     color: Colors.grey,
                  //                   ),
                  //                 ),
                  //                 Padding(
                  //                     padding: EdgeInsets.only(left: 11),
                  //                     child: Text(
                  //                       AppLocalizations.of(context)!.translate(
                  //                               'search_hyperlocal_product') ??
                  //                           "Search Hyperlocal Products",
                  //                       //"Search Hyperlocal Products",
                  //                       style: ThreeKmTextConstants
                  //                           .tk12PXLatoBlackBold
                  //                           .copyWith(color: Colors.grey),
                  //                     ))
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //         InkWell(
                  //           onTap: () => viewCart(context, 'restro')
                  //               .whenComplete(() => setState(() {})),
                  //           child: Padding(
                  //             padding: EdgeInsets.only(left: 12),
                  //             child: Stack(
                  //               clipBehavior: Clip.none,
                  //               children: [
                  //                 Container(
                  //                     height: 32,
                  //                     width: 32,
                  //                     decoration: BoxDecoration(
                  //                       image: DecorationImage(
                  //                           image: AssetImage(
                  //                               "assets/shopImg/Group 40724.png")),
                  //                       shape: BoxShape.circle,
                  //                       //color: Color(0xff7572ED)
                  //                     )),
                  //                 if (Hive.box('restroCartBox').length != 0)
                  //                   ValueListenableBuilder(
                  //                       valueListenable:
                  //                           Hive.box('restroCartBox')
                  //                               .listenable(),
                  //                       builder: (context, Box box, snapshot) {
                  //                         return Positioned(
                  //                             top: -10,
                  //                             right: -5,
                  //                             child: box.length != 0
                  //                                 ? Container(
                  //                                     decoration: BoxDecoration(
                  //                                         shape:
                  //                                             BoxShape.circle,
                  //                                         color: Colors.red),
                  //                                     child: Padding(
                  //                                       padding:
                  //                                           const EdgeInsets
                  //                                               .all(4.0),
                  //                                       child: Text(
                  //                                         '${box.length}',
                  //                                         style: TextStyle(
                  //                                             fontSize: 11,
                  //                                             color:
                  //                                                 Colors.white),
                  //                                       ),
                  //                                     ))
                  //                                 : Container());
                  //                       }),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //         InkWell(
                  //           onTap: () async {
                  //             SharedPreferences _pref =
                  //                 await SharedPreferences.getInstance();
                  //             var token = _pref.getString("token");
                  //             token != null
                  //                 ? drawerController.open!()
                  //                 // : Navigator.push(context,
                  //                 //     MaterialPageRoute(builder: (_) => SignUp()));
                  //                 : Navigator.pushAndRemoveUntil(
                  //                     context,
                  //                     MaterialPageRoute(
                  //                         builder: (_) => SignUp()),
                  //                     (route) => false);
                  //           },
                  //           child: Padding(
                  //             padding: EdgeInsets.only(left: 12),
                  //             child: Container(
                  //                 height: 32,
                  //                 width: 32,
                  //                 decoration: BoxDecoration(
                  //                   image: profileProvider.Avatar != null
                  //                       ? DecorationImage(
                  //                           image: CachedNetworkImageProvider(
                  //                               profileProvider.Avatar
                  //                                   .toString()))
                  //                       : DecorationImage(
                  //                           image: AssetImage(
                  //                               "assets/male-user.png")),
                  //                   shape: BoxShape.circle,
                  //                   //color: Color(0xffFF464B)
                  //                 )),
                  //           ),
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  cuisinesState == "loaded" &&
                          cuisinesData.data != null &&
                          cuisinesData.data!.result.data.isNotEmpty
                      ? Container(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 8, bottom: 8),
                                child: Text(
                                  'Cuisines',
                                  style: TextStyle(
                                      color: Color(0xFF0F0F2D),
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 250,
                                child: GridView.builder(
                                    //physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                    ),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: cuisinesData.data!.result.data.length,
                                    shrinkWrap: true,
                                    itemBuilder: (_, i) {
                                      var cuisinesdata = cuisinesData.data!.result.data[i];
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => CuisinesViewAll(
                                                        query: '${cuisinesdata.name}',
                                                      )));
                                        },
                                        child: Container(
                                          // width: 150,
                                          // height: 150,
                                          padding: EdgeInsets.only(
                                              top: 5, bottom: 10, left: 5, right: 5),
                                          decoration: BoxDecoration(
                                              border: Border.all(color: Color(0xFFE2E4E6)),
                                              borderRadius: BorderRadius.circular(15)),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 75,
                                                width: double.infinity,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(15),
                                                  child: CachedNetworkImage(
                                                    alignment: Alignment.center,
                                                    placeholder: (context, url) => Transform.scale(
                                                      scale: 0.3,
                                                      child: CircularProgressIndicator(
                                                        color: Colors.grey[400],
                                                      ),
                                                    ),
                                                    imageUrl: '${cuisinesdata.photo}',
                                                    // height:
                                                    //     MediaQuery.of(context).size.height /
                                                    //         13,
                                                    // width: ThreeKmScreenUtil
                                                    //         .screenWidthDp /
                                                    //     6,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Spacer(),
                                              Text('${cuisinesdata.name}')
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        )
                      : cusinesData(),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.translate('nearby_restaurants') ??
                              'Nearby Restaurants',
                          style: TextStyle(
                              color: Color(0xFF0F0F2D), fontSize: 19, fontWeight: FontWeight.bold),
                        ),
                        // Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => AllRestaurantList(
                                          isSearchActive: false,
                                        )));
                          },
                          child: Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.translate('view_all_text') ??
                                    'View all',
                                style: TextStyle(color: Color(0xFF43B978)),
                              ),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: Color(0xFF43B978),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  state == 'loaded'
                      ? CreatorCard(data: data, SearchController: SearchController)
                      : ShowRestroLoading()
                ],
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder(
                valueListenable: Hive.box('restroCartBox').listenable(),
                builder: (context, Box box, widget) {
                  return box.length > 0
                      ? Container(
                          width: double.infinity,
                          height: 90,
                          color: Color(0xFF0F0F2D),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${Hive.box('restroCartBox').values.length} ITEM',
                                      style: ThreeKmTextConstants.tk12PXPoppinsWhiteRegular,
                                    ),
                                    Wrap(children: [
                                      Text(
                                        '₹${context.read<CartProvider>().getBoxTotal(Hive.box('restroCartBox'))}',
                                        style: ThreeKmTextConstants.tk16PXPoppinsBlackMedium
                                            .copyWith(color: Colors.white),
                                      ),
                                      Text('  '),
                                      Text(
                                        '+ TAXES',
                                        style: ThreeKmTextConstants.tk12PXPoppinsBlackSemiBold
                                            .copyWith(
                                          color: Color(0xFF979EA4),
                                        ),
                                      )
                                    ])
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    viewCart(context, 'restro');
                                    log('cart click');
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Color(0xFF3E7EFF),
                                        borderRadius: BorderRadius.circular(30)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'View Cart',
                                          style: ThreeKmTextConstants.tk16PXPoppinsBlackMedium
                                              .copyWith(color: Colors.white),
                                        ),
                                        const Image(
                                          image: AssetImage('assets/shopImg/leftArrow.png'),
                                          width: 30,
                                          height: 30,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : Container();
                }),
          ],
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
