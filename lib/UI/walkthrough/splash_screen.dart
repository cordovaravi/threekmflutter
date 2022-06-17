import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threekm/Models/shopModel/restaurants_model.dart';
import 'package:threekm/UI/businesses/businesses_detail.dart';
import 'package:threekm/UI/main/News/PostView.dart';
import 'package:threekm/UI/main/News/poll_page.dart';
import 'package:threekm/UI/main/navigation.dart';
import 'package:threekm/UI/Auth/signup/sign_up.dart';
import 'package:threekm/UI/shop/product/product_details.dart';
import 'package:threekm/UI/shop/product_listing.dart';
import 'package:threekm/UI/shop/restaurants/biryani_restro.dart';
import 'package:threekm/UI/shop/restaurants/restaurants_menu.dart';
import 'package:threekm/main.dart';
import 'package:threekm/providers/FCM/fcm_sendToken_Provider.dart';
import 'package:threekm/providers/Global/logged_in_or_not.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SplashScreen extends StatefulWidget {
  final String? fcmToken;
  SplashScreen({this.fcmToken});
  // final String? uri;
  // SplashScreen({this.uri});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  //ScreenshotController screenshotController = ScreenshotController();
  getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      await deviceInfo.androidInfo.then((value) async {
        String requestJson = json.encode({
          "uuid": value.id,
          "platform": "Android",
          "token": await FirebaseMessaging.instance.getToken(),
          "manufacturer": value.manufacturer,
          "device_model": value.model,
          "app_version": "5.0.0",
          "version": "2.1.2"
        });
        context.read<FCMProvider>().sendToken(requestJson);
      });
    } else if (Platform.isIOS) {
      await deviceInfo.iosInfo.then((value) async {
        String requestJson = json.encode({
          "uuid": "23423423423423423423",
          "platform": "iOS",
          "token": await FirebaseMessaging.instance.getToken(),
          "manufacturer": value.identifierForVendor,
          "device_model": value.model,
          "app_version": "5.0.0",
          "version": "2.1.2"
        });
        context.read<FCMProvider>().sendToken(requestJson);
      });
    }
  }

  @override
  void initState() {
    Future.microtask(() {
      getDeviceId();
      openBox();
      context.read<CheckLoginProvider>().getAuthStatus();
    });
    super.initState();
    handleDeepLink();
    handleFcm();
  }

  openBox() async {
    //if (await getAuthStatus()) {
    await Hive.openBox('restroCartBox');
    await Hive.openBox('cartBox');
    await Hive.openBox('businessWishListBox');
    await Hive.openBox('selectedAddress');
    await Hive.openBox('creatorID');
    await Hive.openBox('restrocreatorID');
    await Hive.openBox('shopWishListBox');
    await Hive.openBox('orderinfo');
    await Hive.openBox('orderStatusBox');
    await Hive.openBox('selectedAddress');
    // }
  }

  void handleFcm() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                '3kmcustom_notification_push_app_1', // id
                'noti_push_app',
                importance: Importance.high,
                icon: 'icon_light',
                largeIcon: DrawableResourceAndroidBitmap('icon_light'),
                sound: RawResourceAndroidNotificationSound('alert_tone'),
                playSound: true,
              ),
            ),
            payload: message.data["post_id"]);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('A new onMessageOpenedApp event ${message.notification?.title}');
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<dynamic> handleDeepLink() async {
    try {
      final initialLink = await getInitialLink();

      // Parse the link and warn the user, if it is not correct,
      // but keep in mind it could be `null`.
      //log('this is deep link via 2 ${initialLink?.contains('/sell/')}');
      //log('this is deep link via 2 ${initialLink?.split('?id=')[1]}');
      //log('this is deep link via console ${initialLink?.substring(30, 35)}');
      log("deep link is ${initialLink}");
      if (initialLink != null) {
        // log('${initialLink}');
        // log('this is deep link via 2 ${initialLink.contains('/sell/')}');
        // log('this is deep link via 2 ${initialLink.split('/').last}');
        // log('this is deep link via console ${initialLink.substring(30, 35)}');
        if (initialLink.contains('/sell/')) {
          await Hive.openBox('cartBox').whenComplete(() {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              var initLink = initialLink.split('/');
              log(initLink.last);
              return ProductDetails(
                id: num.parse(initLink.last),
              );
            })).then((value) => Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(builder: (_) => TabBarNavigation()), (route) => false));
          });
        } else if (initialLink.contains('/biz/')) {
          await Hive.openBox('cartBox').whenComplete(() {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return BusinessDetail(
                id: int.parse(initialLink.split('/').last),
              );
            })).then((value) => Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(builder: (_) => TabBarNavigation()), (route) => false));
          });
        } else if (initialLink.contains('/category/')) {
          await Hive.openBox('cartBox').whenComplete(() {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              var initLink = initialLink.split('/');
              return ProductListing(
                query: '${initLink.last}',
              );
            })).then((value) => Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(builder: (_) => TabBarNavigation()), (route) => false));
          });
        } else if (initialLink.contains("poll")) {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            log("${int.parse(initialLink.split('/').last)}");
            return PollPage(
              PollId: "${int.parse(initialLink.split('/').last)}",
            );
          })).then((value) => Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (_) => TabBarNavigation()), (route) => false));
        } else if (initialLink.contains("/food/restaurant/menu/")) {
          await Hive.openBox('restroCartBox').whenComplete(() {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return RestaurantMenu(
                  data: Creators(creatorId: int.parse(initialLink.split('/').last))
                  //{creatorId: "${int.parse(initialLink.split('/').last)}"},
                  );
            })).then((value) => Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(builder: (_) => TabBarNavigation()), (route) => false));
          });
        } else if (initialLink.contains("/food/restaurant/list/")) {
          await Hive.openBox('restroCartBox').whenComplete(() {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return BiryaniRestro();
            })).then((value) => Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(builder: (_) => TabBarNavigation()), (route) => false));
          });
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return PostView(postId: "${int.parse(initialLink.split('/').last)}"
                // initialLink
                //     .substring(30, initialLink.length)
                //     .replaceAll('&lang=en', '')
                );
          })).then((value) => Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (_) => TabBarNavigation()), (route) => false));
        }
      } else {
        Future.delayed(Duration(seconds: 2), () {
          handleNavigation();
        });
      }
      return initialLink;
    } on PlatformException {
      // Handle exception by warning the user their action did not succeed
      // return?
      print("error while printing deep link");
    }
  }

  handleNavigation() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? token = _prefs.getString('token');
    if (token != null) {
      //handleDeepLink();
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) => TabBarNavigation()), (route) => false);
    } else
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) => SignUp()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/icon_light.png"),
            ],
          ),
        ),
      ),
    );
  }
}
