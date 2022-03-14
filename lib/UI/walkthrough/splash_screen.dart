import 'dart:async';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threekm/UI/businesses/businesses_detail.dart';
import 'package:threekm/UI/main/News/PostView.dart';
import 'package:threekm/UI/main/navigation.dart';
import 'package:threekm/UI/Auth/signup/sign_up.dart';
import 'package:threekm/UI/shop/product/product_details.dart';
import 'package:threekm/main.dart';
import 'package:threekm/providers/Global/logged_in_or_not.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SplashScreen extends StatefulWidget {
  // final String? uri;
  // SplashScreen({this.uri});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  //ScreenshotController screenshotController = ScreenshotController();
  @override
  void initState() {
    super.initState();
    handleDeepLink();
    handleFcm();
    openBox();
  }

  openBox() async {
    if (await getAuthStatus()) {
      await Hive.openBox('restroCartBox');
      await Hive.openBox('cartBox');
    }
  }

  void handleFcm() {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        log("message from firebase is $message");
      }
    });

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
                channel.id,
                channel.name,
                icon: 'launch_background',
              ),
            ));
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
      openBox();
      // Parse the link and warn the user, if it is not correct,
      // but keep in mind it could be `null`.
      log('this is deep link via 2 ${initialLink?.contains('/sell/')}');
      log('this is deep link via 2 ${initialLink?.split('?id=')[1]}');
      log('this is deep link via console ${initialLink?.substring(30, 35)}');
      if (initialLink != null) {
        if (initialLink.contains('/sell/')) {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            var initLink = initialLink.split('/');
            return ProductDetails(
              id: num.parse(initLink.last),
            );
          })).then((value) => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => TabBarNavigation()),
              (route) => false));
        } else if (initialLink.contains('/biz/')) {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return BusinessDetail(
              id: int.parse(initialLink.split('?id=')[1]),
            );
          })).then((value) => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => TabBarNavigation()),
              (route) => false));
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return Postview(
                postId: initialLink
                    .substring(30, initialLink.length)
                    .replaceAll('&lang=en', ''));
          })).then((value) => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => TabBarNavigation()),
              (route) => false));
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
          context,
          MaterialPageRoute(builder: (context) => TabBarNavigation()),
          (route) => false);
    } else
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => SignUp()), (route) => false);
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
