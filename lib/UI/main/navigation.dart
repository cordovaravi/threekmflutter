import 'dart:developer';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:hive/hive.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threekm/UI/businesses/businesses_home.dart';
import 'package:threekm/UI/main/DrawerScreen.dart';
import 'package:threekm/UI/main/News/NewsTab.dart';
import 'package:threekm/UI/main/draggableex.dart';
import 'package:threekm/UI/shop/home_3km.dart';
import 'package:threekm/UI/shop/restaurants/restaurants_home_page.dart';
import 'package:threekm/UI/shop/showOrderStatus.dart';
import 'package:threekm/main.dart';
import 'package:threekm/providers/main/AthorProfile_Provider.dart';
import 'package:threekm/providers/shop/checkout/order_realtime_detail_provider.dart';
import 'package:threekm/utils/screen_util.dart';
import 'package:threekm/utils/spacings.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AnimationController? _animationController1;
  AnimationController? _animationController2;

  int _currentIndex = 0;
  //TabController? _tabController;
  AnimationController? _animationController;
  PageController _pageController = PageController();
  String? thisdeviceId;
  DateTime? currentBackPressTime;
  TabController? controller;
  AlignmentGeometry alignment = Alignment.topCenter;
  //
  Color _color = Color(0xff3E7EFF);
  Color _animatingColor = Color(0xff43B978);
  double drawerdragOffset = 0;

  void startAnimation() async {
    if (!_animationController2!.isAnimating) {
      // bool status = await getAuthStatus();
      // if (status) {
      //   _animationController2!.forward();
      // }
      _animationController2!.forward();
    }
  }

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

  @override
  void initState() {
    _getConstants();
    Future.delayed(Duration.zero, () {
      context.read<AutthorProfileProvider>().getSelfProfile();
    });
    //initAnimation();
    //getDeviceId();
    _animationController1 =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    controller = TabController(vsync: this, length: 3);
    controller!.addListener(() {
      int i = controller!.index;
      setState(() {
        if (i == 0) {
          alignment = Alignment.topLeft;
          _animatingColor = Color(0xff3E7EFF);
        } else if (i == 2) {
          alignment = Alignment.topRight;
          _animatingColor = Color(0xff43B978);
        } else {
          alignment = Alignment.topCenter;
          _animatingColor = Color(0xFFFF5858);
        }
      });
      _animationController1!.forward().then((value) {
        setState(() {
          if (i == 0) {
            _color = Color(0xFF3E7EFF);
          } else if (i == 2) {
            _color = Color(0xFF43B978);
          } else {
            _color = Color(0xFFFF5858);
          }
          _animationController1!.reverse();
        });
      });
    });
    ShowOrderStaus();

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
    // _animationController!.dispose();
    // _tabController!.dispose();
    _animationController2!.dispose();
    _animationController1!.dispose();
    super.dispose();
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

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
          body: Stack(
            children: [
              //buildDrawer,
              AnimatedBuilder(
                animation: _animationController2!,
                builder: (context, child) => Transform.translate(
                  offset: Offset(
                      (MediaQuery.of(context).size.width * 0.8) *
                          _animationController2!.value,
                      0),
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: (MediaQuery.of(context).size.width * 0.2) *
                          _animationController2!.value,
                    ),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 30,
                          offset: Offset(-30, 0),
                        )
                      ],
                    ),
                    child: Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                            color: _color,
                            borderRadius: BorderRadius.circular(
                              30 * _animationController2!.value,
                            ),
                          ),
                        ),
                        AnimatedBuilder(
                            animation: _animationController1!,
                            builder: (context, child) {
                              return Align(
                                alignment: alignment,
                                child: Container(
                                  width: MediaQuery.of(context).size.width *
                                      _animationController1!.value,
                                  height: MediaQuery.of(context).size.width *
                                      _animationController1!.value,
                                  margin: EdgeInsets.only(
                                      right: 40 -
                                          (40 * _animationController1!.value),
                                      left: 40 -
                                          (40 * _animationController1!.value),
                                      top: 30 -
                                          (30 * _animationController1!.value)),
                                  decoration: BoxDecoration(
                                      color: _animatingColor,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(80),
                                        topRight: Radius.circular(80),
                                        bottomLeft: Radius.circular(40 +
                                            ((MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2 *
                                                    _animationController1!
                                                        .value) -
                                                40)),
                                        bottomRight: Radius.circular(40 +
                                            ((MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2 *
                                                    _animationController1!
                                                        .value) -
                                                40)),
                                      )),
                                ),
                              );
                            }),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(
                                30 * _animationController2!.value),
                          ),
                          child: Stack(
                            children: [
                              Stack(
                                children: [
                                  buildTabs,
                                  buildTabViews,
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // return Scaffold(
    //   body: ScaleTransition(
    //       scale: _animationController!,
    //       child: WillPopScope(
    //           child: PageView(
    //             onPageChanged: onPageChanged,
    //             controller: _pageController,
    //             physics: NeverScrollableScrollPhysics(),
    //             children: [
    //               Container(
    //                 height: MediaQuery.of(context).size.height,
    //                 width: MediaQuery.of(context).size.width,
    //                 child: ZoomDrawer(
    //                   controller: drawerController,
    //                   menuScreen: DrawerScreen(),
    //                   mainScreen: DraggablePage(
    //                     isredirected: widget.redirectedFromPost,
    //                   ),
    //                 ),
    //               ),
    //               DraggablePage(),
    //               PollView()
    //             ],
    //           ),
    //           onWillPop: onWillPop)),
    //   // bottomNavigationBar: BottomNavigationBar(
    //   //   currentIndex: _currentIndex,
    //   //   items: [
    //   //     BottomNavigationBarItem(
    //   //         icon: new Icon(FeatherIcons.rss), title: new Text('news')),
    //   //     BottomNavigationBarItem(
    //   //         icon: new Icon(Icons.shopping_bag), title: new Text('Shopping')),
    //   //     BottomNavigationBarItem(
    //   //         icon: new Icon(Icons.business_center),
    //   //         title: new Text('business'))
    //   //   ],
    //   //   onTap: (int index) {
    //   //     _pageController.jumpToPage(index);
    //   //   },
    //   // ),
    // );
  }

  Widget get buildTabViews {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20 * _animationController2!.value),
      ),
      margin: EdgeInsets.only(top: 100),
      child: Stack(
        children: [
          TabBarView(
            controller: controller,
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              TabsWrapper(
                animation: _animationController2!,
                bodyWidget: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: NewsTab(
                      reload: widget.redirectedFromPost,
                      isPostUploaded: widget.isPostUploaded,
                    )
                    // DraggablePage(
                    //   isredirected: widget.redirectedFromPost,
                    // ),
                    ),
              ),
              TabsWrapper(
                animation: _animationController2!,
                bodyWidget: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: RestaurantsHome()),
              ),
              TabsWrapper(
                animation: _animationController2!,
                bodyWidget: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Home3KM()),
              ),

              // NewsTab1(animation: _animationController2!),
              // ShopTab(animation: _animationController2!),
              // BizTab(animation: _animationController2!)
            ],
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: GestureDetector(
              onHorizontalDragStart: (details) {
                print(details.globalPosition.dx);
                drawerdragOffset = details.globalPosition.dx;
              },
              onHorizontalDragUpdate: (details) {
                if (details.globalPosition.dx > drawerdragOffset + 80) {
                  startAnimation();
                } else {
                  // print("drawer not opening");
                }
              },
              child: Container(
                width: 15,
                height: MediaQuery.of(context).size.height - 120,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.only(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget get buildTabs {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 40, bottom: 24),
      height: 40,
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
            color: Color(0xff0F0F2D).withOpacity(0.25),
            borderRadius: BorderRadius.circular(20)),
        indicatorSize: TabBarIndicatorSize.label,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Image.asset(
                    "assets/newspaper.png",
                    height: 24,
                    width: 24,
                  ),
                ),
                horizontalSpacing(width: 8),
                Text("News"),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Image.asset(
                    "assets/restaurant_menu.png",
                    height: 24,
                    width: 24,
                  ),
                ),
                horizontalSpacing(width: 8),
                Text("Food"),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Image.asset(
                    "assets/shopping_bag.png",
                    height: 24,
                    width: 24,
                  ),
                ),
                horizontalSpacing(width: 8),
                Text(
                  "Shop",
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class TabsWrapper extends StatefulWidget {
  final AnimationController animation;
  final Widget bodyWidget;
  TabsWrapper({Key? key, required this.animation, required this.bodyWidget})
      : super(key: key);

  @override
  State<TabsWrapper> createState() => _TabsWrapperState();
}

class _TabsWrapperState extends State<TabsWrapper>
    with TickerProviderStateMixin {
  AnimationController? _animationController2;
  Animation<double>? tween;
  late double marginTop;
  @override
  void initState() {
    _animationController2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    tween = Tween<double>(begin: 0, end: 1).animate(_animationController2!);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      marginTop = MediaQuery.of(context).size.height * 0.13;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
            animation: _animationController2!,
            builder: (context, snapshot) {
              return Container(
                child: Container(
                  margin: EdgeInsets.only(
                    top: 365 * tween!.value,
                    left: 16 * tween!.value,
                    right: 16 * tween!.value,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      // if (shadow) ...{
                      //   BoxShadow(
                      //       offset: Offset(0, -20),
                      //       color: Colors.black.withOpacity(0.22),
                      //       blurRadius: 40,
                      //       spreadRadius: 20)
                      // },
                    ],
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    ),
                  ),
                  child: widget.bodyWidget,
                ),
              );
            })
      ],
    );
  }
}
