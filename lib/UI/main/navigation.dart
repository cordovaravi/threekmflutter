import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:threekm/UI/main/draggableex.dart';
import 'package:threekm/UI/main/pollex.dart';
import 'package:threekm/widgets/shop/home_3km.dart';

class TabBarNavigation extends StatefulWidget {
  const TabBarNavigation({Key? key}) : super(key: key);

  @override
  _TabBarNavigationState createState() => _TabBarNavigationState();
}

class _TabBarNavigationState extends State<TabBarNavigation>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  //TabController? _tabController;
  AnimationController? _animationController;
  PageController _pageController = PageController();
  String? thisdeviceId;
  DateTime? currentBackPressTime;

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

  @override
  void initState() {
    initAnimation();
    getDeviceId();
    super.initState();
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

  initAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      value: 1,
    );
    _pageController = PageController()
      ..addListener(() {
        if (true) {
          setState(() {
            _animationController!.forward(from: 0.5);
          });
        }
      });
  }

  @override
  void dispose() {
    _animationController!.dispose();
    // _tabController!.dispose();
    super.dispose();
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScaleTransition(
          scale: _animationController!,
          child: WillPopScope(
              child: PageView(
                onPageChanged: onPageChanged,
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [DraggablePage(), Home3KM(), PollView()],
              ),
              onWillPop: onWillPop)),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: new Icon(FeatherIcons.rss), title: new Text('news')),
          BottomNavigationBarItem(
              icon: new Icon(Icons.shopping_bag), title: new Text('Shopping')),
          BottomNavigationBarItem(
              icon: new Icon(Icons.business_center), label: 'business')
        ],
        onTap: (int index) {
          _pageController.jumpToPage(index);
        },
      ),
    );
  }
}
