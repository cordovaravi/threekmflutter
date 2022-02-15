import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threekm/UI/main/News/PostView.dart';
import 'package:threekm/UI/main/navigation.dart';
import 'package:threekm/UI/Auth/signup/sign_up.dart';
import 'package:uni_links/uni_links.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StreamSubscription? _linkSubscription;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  //ScreenshotController screenshotController = ScreenshotController();
  @override
  void initState() {
    if (Platform.isAndroid) {
      Future.delayed(Duration.zero, () {
        InAppUpdate.checkForUpdate().then((info) async {
          if (info.updateAvailability == UpdateAvailability.updateAvailable) {
            await InAppUpdate.performImmediateUpdate()
                .catchError((e) => log(e.toString()));
          }
        }).catchError((e) {
          log(e.toString());
        });
      });
    }
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      handleDeepLink().whenComplete(() => handleNavigation());
    });
  }

  void showSnack(String text) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(SnackBar(
        content: Text(text),
      ));
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<dynamic> handleDeepLink() async {
    try {
      final initialLink = await getInitialLink();
      // Parse the link and warn the user, if it is not correct,
      // but keep in mind it could be `null`.
      print('this is deep link via console ${initialLink?.substring(30, 35)}');
      if (initialLink != null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return Postview(
              postId: initialLink
                  .substring(30, initialLink.length)
                  .replaceAll('&lang=en', ''));
        }));
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
