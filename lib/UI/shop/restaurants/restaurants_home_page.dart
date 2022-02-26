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
import 'package:shimmer/shimmer.dart';
import 'package:threekm/Custom_library/GooleMapsWidget/src/place_picker.dart';

import 'package:threekm/Models/shopModel/restaurants_model.dart';
import 'package:threekm/UI/shop/restaurants/view_all_restaurant.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/localization/localize.dart';
import 'package:threekm/main.dart';
import 'package:threekm/providers/Location/locattion_Provider.dart';
import 'package:threekm/providers/shop/cart_provider.dart';
import 'package:threekm/providers/shop/shop_home_provider.dart';
import 'package:threekm/utils/api_paths.dart';
import 'package:threekm/utils/screen_util.dart';
import 'package:threekm/utils/threekm_textstyles.dart';
import '../../shop/cart/cart_item_list_modal.dart';
import '../../shop/restaurants/restaurants_menu.dart';
import 'package:geocoding/geocoding.dart';

class RestaurantsHome extends StatefulWidget {
  const RestaurantsHome({Key? key}) : super(key: key);

  @override
  State<RestaurantsHome> createState() => _RestaurantsHomeState();
}

class _RestaurantsHomeState extends State<RestaurantsHome> {
  //  data:  shopHomeProvider.restaurantData?.result,
  Offset position = Offset(20.0, 20.0);
  String? _selecetedAddress;
  TextEditingController SearchController = TextEditingController();
  getaddressFromCoordinates() async {
    final _locationProvider = await context.read<LocationProvider>();

    if (_locationProvider != null) {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _locationProvider.getLatitude ?? 18.5204,
          _locationProvider.getLangitude ?? 73.8567);
      setState(() {
        _selecetedAddress = placemarks.first.subLocality;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getaddressFromCoordinates();

    Future.microtask(() {
      openBox();
      context.read<LocationProvider>().getLocation();
      context.read<ShopHomeProvider>().getRestaurants(mounted, 1);
    });
  }

  openBox() async {
    await Hive.openBox('restroCartBox');
  }

  @override
  void didChangeDependencies() {
    ThreeKmScreenUtil().init(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var data = context.watch<ShopHomeProvider>().restaurantData?.result;
    var state = context.watch<ShopHomeProvider>().state;

    return Scaffold(
        backgroundColor: Color(0xFFF4F3F8),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          title: Container(
            //margin: EdgeInsets.only(right: 30),
            width: ThreeKmScreenUtil.screenWidthDp / 1.3,
            child: TextFormField(
              autocorrect: false, autofocus: false,

              keyboardType: TextInputType.text,
              controller: SearchController,
              // controller: _firstName,
              onChanged: (val) {
                context
                    .read<ShopHomeProvider>()
                    .getRestaurants(mounted, 1, query: val);
                setState(() {});
              },

              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!
                        .translate('Search_Restaurant_or_Cusines') ??
                    'Search Restaurant or Cusines',
                hintStyle: TextStyle(color: Color(0xFF0F0F2D)),
                counterText: '',
                filled: true,
                prefixIcon: Icon(Icons.search, color: Color(0xFF0F0F2D)),
                fillColor: Colors.white,
                contentPadding: EdgeInsets.fromLTRB(10, 13, 10, 13),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
        ),
        body: GestureDetector(
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
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                            minWidth: 40,
                            maxWidth: MediaQuery.of(context).size.width / 2),
                        child: Text(
                          _selecetedAddress ?? '',
                          style:
                              ThreeKmTextConstants.tk12PXPoppinsBlackSemiBold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Future.delayed(Duration.zero, () {
                            context
                                .read<LocationProvider>()
                                .getLocation()
                                .whenComplete(() {
                              final _locationProvider = context
                                  .read<LocationProvider>()
                                  .getlocationData;
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
                                                    lat: result
                                                        .geometry?.location.lat,
                                                    lng: result.geometry
                                                        ?.location.lng);
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
                        child: Text(
                          AppLocalizations.of(context)!
                                  .translate('change_location') ??
                              'Change Location',
                          style:
                              ThreeKmTextConstants.tk12PXPoppinsBlackSemiBold,
                        ),
                      )
                    ],
                  ),
                ),
                // Container(child: ListView.builder(
                //                 //controller: _scrollController,
                //                 shrinkWrap: true,
                //                 scrollDirection: Axis.horizontal,
                //                 itemCount: 2,
                //                 itemBuilder: (context, i) {
                //                   return Padding(
                //                     padding: const EdgeInsets.only(
                //                         left: 20, top: 10, bottom: 10),
                //                     child: ClipRRect(
                //                         borderRadius: BorderRadius.circular(10),
                //                         child: Image(
                //                             image: NetworkImage(data.advertisements[i].images.),
                //                             width: ThreeKmScreenUtil.screenWidthDp / 1.1888,
                //                             height: ThreeKmScreenUtil.screenHeightDp / 5,
                //                             fit: BoxFit.fill)),
                //                   );
                //                 }),,)
                // Row(
                //   children: const [
                //     Text(
                //       'Top Rated by Foodies',
                //       style: TextStyle(
                //           color: Color(0xFF0F0F2D),
                //           fontSize: 19,
                //           fontWeight: FontWeight.bold),
                //     ),
                //     Spacer(),
                //     Text(
                //       'Sponsored',
                //       style: TextStyle(color: Color(0xFF8A939B)),
                //     )
                //   ],
                // ),
                // Container(
                //   padding: const EdgeInsets.only(bottom: 10),
                //   margin: const EdgeInsets.only(bottom: 10),
                //   height: 330.0,
                //   child: ListView.builder(
                //     shrinkWrap: true,
                //     scrollDirection: Axis.horizontal,
                //     itemCount: 10,
                //     itemBuilder: (BuildContext ctxt, int i) {
                //       return Container(
                //           // color: Colors.red,
                //           padding: const EdgeInsets.all(10),
                //           width: ThreeKmScreenUtil.screenWidthDp / 1.45,
                //           child: Material(
                //             elevation: 4,
                //             borderRadius:
                //                 const BorderRadius.all(Radius.circular(20)),
                //             child: Container(
                //                 padding: const EdgeInsets.only(
                //                     left: 3, right: 3, top: 3),
                //                 margin: const EdgeInsets.all(3),
                //                 decoration: const BoxDecoration(
                //                   color: Colors.white,
                //                   borderRadius:
                //                       BorderRadius.all(Radius.circular(20)),
                //                 ),
                //                 child: Column(
                //                   crossAxisAlignment: CrossAxisAlignment.start,
                //                   children: [
                //                     Container(
                //                       height: 190.0,
                //                       child: ClipRRect(
                //                         borderRadius: const BorderRadius.all(
                //                             Radius.circular(20)),
                //                         child: CachedNetworkImage(
                //                           alignment: Alignment.topCenter,
                //                           placeholder: (context, url) =>
                //                               Transform.scale(
                //                             scale: 0.5,
                //                             child: CircularProgressIndicator(
                //                               color: Colors.grey[400],
                //                             ),
                //                           ),
                //                           imageUrl: '${data?.creators?[i].cover}',
                //                           height: ThreeKmScreenUtil.screenHeightDp / 1.8,
                //                           width: ThreeKmScreenUtil.screenWidthDp,
                //                           fit: BoxFit.fill,
                //                         ),
                //                       ),
                //                     ),
                //                     Container(
                //                       padding: const EdgeInsets.only(
                //                           left: 16, right: 16, top: 13),
                //                       alignment: Alignment.centerLeft,
                //                       child: Column(
                //                         crossAxisAlignment:
                //                             CrossAxisAlignment.start,
                //                         children: [
                //                           Text(
                //                             '${data?.creators?[i].businessName}',
                //                             style: TextStyle(fontSize: 18),
                //                             maxLines: 2,
                //                           ),
                //                           Padding(
                //                               padding:
                //                                   const EdgeInsets.only(top: 10),
                //                               child: Text(
                //                                   '${data?.creators?[i].restaurant!.cuisines?.join(", ")}'))
                //                         ],
                //                       ),
                //                     ),
                //                   ],
                //                 )),
                //           ));
                //     },
                //   ),
                // ),
                // const Text(
                //   'Its 8:30PM, Breakfast Time!',
                //   style: TextStyle(
                //       color: Color(0xFF0F0F2D),
                //       fontSize: 19,
                //       fontWeight: FontWeight.bold),
                // ),
                // Container(
                //   padding: const EdgeInsets.only(bottom: 10),
                //   margin: const EdgeInsets.only(bottom: 10),
                //   height: 330.0,
                //   child: ListView.builder(
                //     shrinkWrap: true,
                //     scrollDirection: Axis.horizontal,
                //     itemCount: 10,
                //     itemBuilder: (BuildContext ctxt, int i) {
                //       return Container(
                //           // color: Colors.red,
                //           padding: const EdgeInsets.all(10),
                //           width: ThreeKmScreenUtil.screenWidthDp / 1.45,
                //           child: Material(
                //             elevation: 4,
                //             borderRadius:
                //                 const BorderRadius.all(Radius.circular(20)),
                //             child: Container(
                //                 padding: const EdgeInsets.only(
                //                     left: 3, right: 3, top: 3),
                //                 margin: const EdgeInsets.all(3),
                //                 decoration: const BoxDecoration(
                //                   color: Colors.white,
                //                   borderRadius:
                //                       BorderRadius.all(Radius.circular(20)),
                //                 ),
                //                 child: Column(
                //                   crossAxisAlignment: CrossAxisAlignment.start,
                //                   children: [
                //                     Container(
                //                       height: 190.0,
                //                       child: ClipRRect(
                //                         borderRadius: const BorderRadius.all(
                //                             Radius.circular(20)),
                //                         child: CachedNetworkImage(
                //                           alignment: Alignment.topCenter,
                //                           placeholder: (context, url) =>
                //                               Transform.scale(
                //                             scale: 0.5,
                //                             child: CircularProgressIndicator(
                //                               color: Colors.grey[400],
                //                             ),
                //                           ),
                //                           imageUrl: '${data?.creators?[i].cover}',
                //                           height: ThreeKmScreenUtil.screenHeightDp / 1.8,
                //                           width: ThreeKmScreenUtil.screenWidthDp,
                //                           fit: BoxFit.fill,
                //                         ),
                //                       ),
                //                     ),
                //                     Container(
                //                       padding: const EdgeInsets.only(
                //                           left: 16, right: 16, top: 13),
                //                       alignment: Alignment.centerLeft,
                //                       child: Column(
                //                         crossAxisAlignment:
                //                             CrossAxisAlignment.start,
                //                         children: [
                //                           Text(
                //                             '${data?.creators?[i].businessName}',
                //                             style: TextStyle(fontSize: 18),
                //                             maxLines: 2,
                //                           ),
                //                           Padding(
                //                               padding:
                //                                   const EdgeInsets.only(top: 10),
                //                               child: Text(
                //                                   '${data?.creators?[i].restaurant!.cuisines?.join(", ")}'))
                //                         ],
                //                       ),
                //                     ),
                //                   ],
                //                 )),
                //           ));
                //     },
                //   ),
                // ),
                // category section
                // Container(
                //   padding: const EdgeInsets.all(20),
                //   color: Colors.white,
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       const Padding(
                //         padding: EdgeInsets.all(8.0),
                //         child: Text(
                //           'Categories',
                //           style: TextStyle(
                //               color: Color(0xFF0F0F2D),
                //               fontSize: 19,
                //               fontWeight: FontWeight.bold),
                //         ),
                //       ),
                //       GridView.builder(
                //           physics: const NeverScrollableScrollPhysics(),
                //           gridDelegate:
                //               const SliverGridDelegateWithFixedCrossAxisCount(
                //             crossAxisCount: 3,
                //             crossAxisSpacing: 10,
                //             mainAxisSpacing: 10,
                //           ),
                //           itemCount:  data?.trending?.length,
                //           shrinkWrap: true,
                //           itemBuilder: (_, i) {
                //             return Container(
                //               padding: EdgeInsets.only(top: 15, bottom: 10),
                //               decoration: BoxDecoration(
                //                   border: Border.all(color: Color(0xFFE2E4E6)),
                //                   borderRadius: BorderRadius.circular(15)),
                //               child: Column(
                //                 children: [
                //                   CachedNetworkImage(
                //                     alignment: Alignment.topCenter,
                //                     placeholder: (context, url) =>
                //                         Transform.scale(
                //                       scale: 0.5,
                //                       child: CircularProgressIndicator(
                //                         color: Colors.grey[400],
                //                       ),
                //                     ),
                //                     imageUrl:
                //                         '${ data?.trending?[i].image}',
                //                     height: ThreeKmScreenUtil.screenHeightDp / 15,
                //                     width: ThreeKmScreenUtil.screenWidthDp / 7,
                //                     fit: BoxFit.fill,
                //                   ),
                //                   Spacer(),
                //                   Text('${ data?.trending?[i].name}')
                //                 ],
                //               ),
                //             );
                //           }),
                //     ],
                //   ),
                // ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!
                                .translate('nearby_restaurants') ??
                            'Nearby Restaurants',
                        style: TextStyle(
                            color: Color(0xFF0F0F2D),
                            fontSize: 19,
                            fontWeight: FontWeight.bold),
                      ),
                      // Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => AllRestaurantList()));
                        },
                        child: Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                      .translate('view_all_text') ??
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
                    ? ListView.builder(
                        padding: EdgeInsets.only(bottom: 100),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data?.creators?.length,
                        itemBuilder: (_, i) {
                          return InkWell(
                            onTap: () {
                              if (data?.creators?[i].restaurant?.status ==
                                  false) {
                                CustomSnackBar(
                                    navigatorKey.currentContext!,
                                    Text(AppLocalizations.of(context)!
                                            .translate('Restaurant_offline') ??
                                        "Restaurant is Currentlly not accepting orders"));
                              }
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => RestaurantMenu(
                                            data: data?.creators?[i],
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
                                    height:
                                        ThreeKmScreenUtil.screenHeightDp / 4,
                                    child: Stack(
                                      fit: StackFit.loose,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20)),
                                          child: ColorFiltered(
                                            colorFilter: ColorFilter.mode(
                                                data?.creators?[i].restaurant
                                                            ?.status !=
                                                        false
                                                    ? Colors.transparent
                                                    : Colors.grey,
                                                BlendMode.color),
                                            child: CachedNetworkImage(
                                              alignment: Alignment.topCenter,
                                              //placeholder: (context, url) =>
                                              //     Transform.scale(
                                              //   scale: 0.5,
                                              //   child: CircularProgressIndicator(
                                              //     color: Colors.grey[400],
                                              //   ),
                                              // ),
                                              imageUrl:
                                                  '${data?.creators?[i].cover}',
                                              //height: ThreeKmScreenUtil.screenHeightDp / 5,
                                              width: ThreeKmScreenUtil
                                                  .screenWidthDp,
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
                                        //           borderRadius:
                                        //               BorderRadius.circular(15),
                                        //           color: Colors.white),
                                        //       child: const Text(
                                        //         'Best Safety',
                                        //         style: TextStyle(
                                        //             color: Color(0xFF3E7EFF)),
                                        //       ),
                                        //     ),
                                        //     Container(
                                        //       padding: EdgeInsets.all(10),
                                        //       margin: EdgeInsets.all(10),
                                        //       decoration: BoxDecoration(
                                        //           borderRadius:
                                        //               BorderRadius.circular(15),
                                        //           gradient: const LinearGradient(
                                        //               colors: [
                                        //                 Color(0xFFFF5C3D),
                                        //                 Color(0xFFFF2A5F)
                                        //               ])),
                                        //       child: const Text(
                                        //         '50% off',
                                        //         style: TextStyle(color: Colors.white),
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
                                      '${data?.creators?[i].businessName}',
                                      style: const TextStyle(
                                          fontSize: 17,
                                          color: Color(0xFF0F0F2D),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: ThreeKmScreenUtil.screenWidthDp /
                                            1.9,
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          '${data?.creators?[i].restaurant!.cuisines?.join(", ")}',
                                          maxLines: 1,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF7572ED),
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      if (data?.creators?[i].address
                                              ?.serviceArea !=
                                          null)
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                              '${data?.creators?[i].address?.serviceArea}'),
                                        )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        })
                    : Container(
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
                            Shimmer.fromColors(
                              baseColor: Colors.grey[200]!,
                              highlightColor: Colors.white38,
                              child: Container(
                                margin: EdgeInsets.only(bottom: 10),
                                height: ThreeKmScreenUtil.screenHeightDp / 4,
                                color: Colors.grey,
                              ),
                            ),
                            Shimmer.fromColors(
                              baseColor: Colors.grey[200]!,
                              highlightColor: Colors.white38,
                              child: Container(
                                margin: EdgeInsets.all(18),
                                height: 10,
                                color: Colors.grey,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Shimmer.fromColors(
                                  baseColor: Colors.grey[200]!,
                                  highlightColor: Colors.white38,
                                  child: Container(
                                      width:
                                          ThreeKmScreenUtil.screenWidthDp / 1.9,
                                      height: 15,
                                      margin: EdgeInsets.all(18.0),
                                      color: Colors.grey),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
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
                            padding: const EdgeInsets.only(
                                left: 20, top: 20, right: 20, bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${Hive.box('restroCartBox').values.length} ITEM',
                                      style: ThreeKmTextConstants
                                          .tk12PXPoppinsWhiteRegular,
                                    ),
                                    Wrap(children: [
                                      Text(
                                        '₹${context.read<CartProvider>().getBoxTotal(Hive.box('restroCartBox'))}',
                                        style: ThreeKmTextConstants
                                            .tk16PXPoppinsBlackMedium
                                            .copyWith(color: Colors.white),
                                      ),
                                      Text('  '),
                                      Text(
                                        '+ TAXES',
                                        style: ThreeKmTextConstants
                                            .tk12PXPoppinsBlackSemiBold
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
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'View Cart',
                                          style: ThreeKmTextConstants
                                              .tk16PXPoppinsBlackMedium
                                              .copyWith(color: Colors.white),
                                        ),
                                        const Image(
                                          image: AssetImage(
                                              'assets/shopImg/leftArrow.png'),
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
}
