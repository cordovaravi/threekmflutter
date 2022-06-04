import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';

import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threekm/Custom_library/Custom_bottom_bar/custom_navigation_bar.dart';
import 'package:threekm/UI/DayZero/DayZeroforTabs.dart';
import 'package:threekm/UI/main/DrawerScreen.dart';
import 'package:threekm/UI/main/News/uppartabs.dart';
import 'package:threekm/UI/main/Profile/MyProfilePost.dart';
import 'package:threekm/UI/shop/checkout/past_order.dart';
import 'package:threekm/providers/ProfileInfo/ProfileInfo_Provider.dart';

import 'package:threekm/providers/localization_Provider/appLanguage_provider.dart';
import 'package:threekm/providers/main/AthorProfile_Provider.dart';
import 'package:threekm/utils/screen_util.dart';

import 'Notification/NotificationPage.dart';

String UserName = "";
String avatar = "";

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

  bool authStatus = false;

  @override
  void initState() {
    _getConstants();
    getAuthStatus();
    Future.delayed(Duration.zero, () {
      context.read<AutthorProfileProvider>().getSelfProfile();
      context.read<AppLanguage>().fetchLocale();
      context.read<ProfileInfoProvider>().getProfileBasicData();
      //context.read<CheckLoginProvider>().getAuthStatus();
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

  getAuthStatus() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? token = _prefs.getString("token");
    if (token != null) {
      authStatus = true;
      setState(() {});
    } else {
      authStatus = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> _pageList = <Widget>[
    ThreeKMUpperTab(),
    PastOrder(),
    Notificationpage(),
    MyProfilePost(
        isFromSelfProfileNavigate: true,
        page: 1,
        authorType: "user",
        id: 39108,
        avatar: avatar,
        userName: UserName),
    DrawerScreen(
        avatar:
            "https://png.pngtree.com/png-vector/20191101/ourmid/pngtree-male-avatar-simple-cartoon-design-png-image_1934458.jpg",
        userName: "userName")
  ];

  List<Widget> _dayZeroScreens = <Widget>[
    ThreeKMUpperTab(),
    DayZeroforTabs(ScreenName: "shop"),
    Notificationpage(),
    DayZeroforTabs(ScreenName: "login"),
    DayZeroforTabs(ScreenName: "login")
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //final loginProvider = context.watch<CheckLoginProvider>();
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
            child: authStatus
                ? _pageList[_bottomIndex]
                : _dayZeroScreens[_bottomIndex]),
        bottomNavigationBar: CustomNavigationBar(
          currentIndex: _bottomIndex,
          onTap: (index) {
            setState(() {
              _bottomIndex = index;
            });
            log("bottom index is $_bottomIndex");
          },
          iconSize: 24.0,
          selectedColor: Colors.blue,
          strokeColor: Colors.white,
          unSelectedColor: Color(0xff6c788a),
          backgroundColor: Colors.white,
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
              icon: Icon(Icons.notifications_none_outlined),
              title: Text(
                "Notifications",
                style: TextStyle(fontSize: 12, color: Color(0xff7C7C7C)),
              ),
            ),
            CustomNavigationBarItem(
              icon: Icon(Icons.photo_library_rounded),
              title: Text(
                "My post",
                style: TextStyle(fontSize: 12, color: Color(0xff7C7C7C)),
              ),
            ),
            CustomNavigationBarItem(
              icon: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  context.read<ProfileInfoProvider>().Avatar ??
                      "https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/User-avatar.svg/2048px-User-avatar.svg.png",
                  color: _bottomIndex == 4 &&
                          context.read<ProfileInfoProvider>().Avatar == null
                      ? Colors.blueAccent
                      : context.read<ProfileInfoProvider>().Avatar != null
                          ? null
                          : Colors.grey,
                ),
              ),
              title: Text(
                "Profile",
                style: TextStyle(fontSize: 12, color: Color(0xff7C7C7C)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
