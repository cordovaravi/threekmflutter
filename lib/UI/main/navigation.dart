import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threekm/Custom_library/Custom_bottom_bar/custom_navigation_bar.dart';
import 'package:threekm/Custom_library/GooleMapsWidget/src/place_picker.dart';
import 'package:threekm/UI/main/AddPost/AddNewPost.dart';
import 'package:threekm/UI/main/DrawerScreen.dart';
import 'package:threekm/UI/main/News/NewsTab.dart';
import 'package:threekm/UI/main/Profile/MyProfilePost.dart';
import 'package:threekm/UI/shop/home_3km.dart';
import 'package:threekm/UI/shop/restaurants/restaurants_home_page.dart';
import 'package:threekm/providers/Location/locattion_Provider.dart';

import 'package:threekm/providers/localization_Provider/appLanguage_provider.dart';
import 'package:threekm/providers/main/AthorProfile_Provider.dart';
import 'package:threekm/utils/api_paths.dart';
import 'package:threekm/utils/screen_util.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

import 'Notification/NotificationPage.dart';
import 'Profile/Profilepage.dart';

final drawerController = ZoomDrawerController();

class TabBarNavigation extends StatefulWidget {
  final bool? redirectedFromPost;
  final bool? isPostUploaded;
  TabBarNavigation({this.redirectedFromPost, this.isPostUploaded, Key? key})
      : super(key: key);

  @override
  _TabBarNavigationState createState() => _TabBarNavigationState();
}

class _TabBarNavigationState extends State<TabBarNavigation>
    with AutomaticKeepAliveClientMixin {
  String? thisdeviceId;
  DateTime? currentBackPressTime;
  TabController? controller;
  AlignmentGeometry alignment = Alignment.topCenter;
  String? _selecetdAddress;
  //

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      //Toast.show("PRESS BACK BUTTON AGAIN TO EXIT", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      return Future.value(false);
    }
    return Future.value(true);
  }

  String UserName = "";
  String avatar = "";

  void _getConstants() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var fname = _prefs.getString("userfname");
    var lname = _prefs.getString("userlname");
    UserName = "$fname $lname";
    avatar = _prefs.getString("avatar") ?? "";
  }

  @override
  void didChangeDependencies() {
    ThreeKmScreenUtil().init(context);
    super.didChangeDependencies();
  }

  ///int index for bottom nav bar
  int _bottomIndex = 0;
  bool _reload = false;
  bool _isPostUpdated = false;
  //Locale _appLocal;

  @override
  void initState() {
    _getConstants();
    Future.delayed(Duration.zero, () {
      context.read<AutthorProfileProvider>().getSelfProfile();
      context.read<AppLanguage>().fetchLocale();
      Future.microtask(() => context.read<LocationProvider>().getLocation());
    });
    super.initState();
    _reload = widget.redirectedFromPost ?? false;
    _isPostUpdated = widget.isPostUploaded ?? false;
    //_appLocal = Locale(_languageCode);
  }

  getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      await deviceInfo.androidInfo.then((value) {
        thisdeviceId = value.androidId;
      });
    } else if (Platform.isIOS) {
      await deviceInfo.iosInfo.then((value) {
        thisdeviceId = value.identifierForVendor;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> _pageList = <Widget>[
    NewsTab(
      reload: false,
      isPostUploaded: false,
      appLanguage: Locale("en"),
    ),
    Home3KM(),
    MyProfilePost(
        isFromSelfProfileNavigate: true,
        page: 1,
        authorType: "user",
        id: 39108,
        avatar:
            "https://images.fineartamerica.com/images-medium-large-5/neytiri-from-avtar-film-roshan-patel.jpg",
        userName: "Raviraj testing"),
    Notificationpage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<AppLanguage>();
    final locationProvider = context.watch<LocationProvider>();
    super.build(context);
    return WillPopScope(
      onWillPop: onWillPop,
      child: ZoomDrawer(
        openCurve: Curves.easeIn,
        closeCurve: Curves.easeInOut,
        showShadow: true,
        angle: 0.0,
        controller: drawerController,
        menuScreen: DrawerScreen(
          avatar: avatar,
          userName: UserName,
        ),
        mainScreen: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0.0,
            titleSpacing: 0,
            bottom: PreferredSize(
                child: Container(
                  // color: Colors.pink,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        height: 50,
                        width: 50,
                        child: Image.asset("assets/icon_light.png"),
                      ),
                      Container(
                        height: 48,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextFormField(
                          // controller: searchController,
                          onChanged: (value) {
                            //  _onSearchChanged(value);
                          },
                          maxLines: 1,
                          textAlignVertical: TextAlignVertical.bottom,
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F0F2D),
                          ),
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            hintText: "Start your search here",
                            hintStyle: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F0F2D).withOpacity(0.5),
                            ),
                            filled: true,
                            fillColor: Color(0xFFF4F3F8),
                            prefixIcon: Transform.translate(
                              child: Icon(
                                Icons.search,
                                color: Color(0xFF979EA4),
                              ),
                              offset: Offset(0, 2),
                            ),
                            suffixIcon: Visibility(
                              visible: false,
                              //searchController.text.length > 0,
                              child: Transform.translate(
                                child: GestureDetector(
                                  onTap: () {
                                    // searchController.text = "";
                                    // _controller.sink("");
                                  },
                                  child: Container(
                                    child: Icon(
                                      Icons.cancel_rounded,
                                      color: Colors.red,
                                      size: 24,
                                    ),
                                  ),
                                ),
                                offset: Offset(0, 0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                preferredSize: Size.fromHeight(50)),
            title: Container(
              padding: EdgeInsets.only(top: 10),
              //color: Colors.amber,
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    color: Colors.blueAccent,
                    size: 40,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Your Location",
                          style: TextStyle(
                              color: Colors.blueAccent, fontSize: 15)),
                      Padding(
                        padding: EdgeInsets.only(left: 0, top: 5),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: GestureDetector(
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
                                              setState(() {
                                                _selecetdAddress =
                                                    result.formattedAddress;
                                                print(
                                                    result.geometry!.toJson());
                                                //  _geometry = result.geometry;
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
                                _selecetdAddress ??
                                    locationProvider.AddressFromCordinate ??
                                    "",
                                style: ThreeKmTextConstants
                                    .tk12PXPoppinsBlackSemiBold,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ),
                    ],
                  )
                  // IconButton(
                  //   padding: EdgeInsets.zero,
                  //   onPressed: () {
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
                  //                     setState(() {
                  //                       _selecetdAddress =
                  //                           result.formattedAddress;
                  //                       print(result.geometry!.toJson());
                  //                       //  _geometry = result.geometry;
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
                  //   icon: Icon(
                  //     Icons.location_on_rounded,
                  //     color: Colors.blueAccent,
                  //   ),
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.only(left: 0),
                  //   child: SizedBox(
                  //     width: MediaQuery.of(context).size.width * 0.85,
                  //     child: GestureDetector(
                  //       onTap: () {
                  //         Future.delayed(Duration.zero, () {
                  //           context
                  //               .read<LocationProvider>()
                  //               .getLocation()
                  //               .whenComplete(() {
                  //             final _locationProvider = context
                  //                 .read<LocationProvider>()
                  //                 .getlocationData;
                  //             final kInitialPosition = LatLng(
                  //                 _locationProvider!.latitude!,
                  //                 _locationProvider.longitude!);
                  //             if (_locationProvider != null) {
                  //               Navigator.push(
                  //                   context,
                  //                   MaterialPageRoute(
                  //                     builder: (context) => PlacePicker(
                  //                       apiKey: GMap_Api_Key,
                  //                       // initialMapType: MapType.satellite,
                  //                       onPlacePicked: (result) {
                  //                         //print(result.formattedAddress);
                  //                         setState(() {
                  //                           _selecetdAddress =
                  //                               result.formattedAddress;
                  //                           print(result.geometry!.toJson());
                  //                           //  _geometry = result.geometry;
                  //                         });
                  //                         Navigator.of(context).pop();
                  //                       },
                  //                       initialPosition: kInitialPosition,
                  //                       useCurrentLocation: true,
                  //                       selectInitialPosition: true,
                  //                       usePinPointingSearch: true,
                  //                       usePlaceDetailSearch: true,
                  //                     ),
                  //                   ));
                  //             }
                  //           });
                  //         });
                  //       },
                  //       child: Text(
                  //           _selecetdAddress ??
                  //               locationProvider.AddressFromCordinate ??
                  //               "",
                  //           style:
                  //               ThreeKmTextConstants.tk12PXPoppinsBlackSemiBold,
                  //           maxLines: 1,
                  //           overflow: TextOverflow.ellipsis),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          body: SafeArea(child: _pageList.elementAt(_bottomIndex)),
          bottomNavigationBar: CustomNavigationBar(
            currentIndex: _bottomIndex,
            onTap: (index) {
              setState(() {
                _bottomIndex = index;
              });
              log("bottom index is $_bottomIndex");
            },
            iconSize: 27.0,
            selectedColor: Colors.white,
            strokeColor: Colors.white,
            unSelectedColor: Color(0xff6c788a),
            backgroundColor: Color(0xff040307),
            items: [
              CustomNavigationBarItem(
                icon: Icon(Icons.home),
                // title: Text("Home"),
              ),
              CustomNavigationBarItem(
                icon: Icon(Icons.shopping_bag),
                // title: Text("Orders"),
              ),
              CustomNavigationBarItem(
                icon: Icon(Icons.post_add),
                // title: Text("My post"),
              ),
              CustomNavigationBarItem(
                icon: Icon(Icons.notifications_none_rounded),
                //title: Text("Notification"),
              ),
              CustomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                // title: Text("Profile"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
