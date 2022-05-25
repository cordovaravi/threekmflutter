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
import 'package:threekm/UI/main/DrawerScreen.dart';
import 'package:threekm/UI/main/News/uppartabs.dart';
import 'package:threekm/UI/main/Profile/MyProfilePost.dart';
import 'package:threekm/UI/shop/home_3km.dart';
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
    ThreeKMUpperTab(),
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
    DrawerScreen(
        avatar:
            "https://png.pngtree.com/png-vector/20191101/ourmid/pngtree-male-avatar-simple-cartoon-design-png-image_1934458.jpg",
        userName: "userName")
  ];

  @override
  Widget build(BuildContext context) {
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
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          body: SafeArea(child: _pageList[_bottomIndex]),
          bottomNavigationBar: CustomNavigationBar(
            currentIndex: _bottomIndex,
            onTap: (index) {
              setState(() {
                _bottomIndex = index;
              });
              log("bottom index is $_bottomIndex");
            },
            iconSize: 24.0,
            selectedColor: Colors.white,
            strokeColor: Colors.white,
            unSelectedColor: Color(0xff6c788a),
            backgroundColor: Color(0xff040307),
            items: [
              CustomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text(
                  "Home",
                  style: TextStyle(fontSize: 12, color: Color(0xff7C7C7C)),
                ),
              ),
              CustomNavigationBarItem(
                icon: Icon(Icons.shopping_bag),
                title: Text(
                  "Orders",
                  style: TextStyle(fontSize: 12, color: Color(0xff7C7C7C)),
                ),
              ),
              CustomNavigationBarItem(
                icon: Icon(Icons.post_add),
                title: Text(
                  "My post",
                  style: TextStyle(fontSize: 12, color: Color(0xff7C7C7C)),
                ),
              ),
              CustomNavigationBarItem(
                icon: Icon(Icons.notifications_none_rounded),
                title: Text(
                  "Notification",
                  style: TextStyle(fontSize: 12, color: Color(0xff7C7C7C)),
                ),
              ),
              CustomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                title: Text(
                  "Profile",
                  style: TextStyle(fontSize: 12, color: Color(0xff7C7C7C)),
                ),
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
