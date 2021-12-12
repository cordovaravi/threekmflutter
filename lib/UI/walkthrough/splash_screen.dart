import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threekm/UI/main/News/PostView.dart';
import 'package:threekm/UI/main/navigation.dart';
import 'package:threekm/UI/Auth/signup/sign_up.dart';

import 'package:uni_links/uni_links.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late Tween tween;
  late AnimationController controller;
  StreamSubscription? _linkSubscription;
  ScreenshotController screenshotController = ScreenshotController();
  @override
  void initState() {
    handleDeepLink();
    super.initState();
    tween = Tween<double>(begin: 0, end: 1);
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    controller.drive(tween);
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    _linkSubscription?.cancel();
    super.dispose();
  }

  handleDeepLink() async {
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
    controller.addStatusListener((AnimationStatus status) async {
      if (status == AnimationStatus.completed) {
        print("animation completed");
        handleNavigation();
        // Box languageSelectedBox = await Hive.openBox("language_selected");
        // if (languageSelectedBox.isNotEmpty) {
        //   LanguageSelected selected = languageSelectedBox.getAt(0);
        //   if (selected.selected!) {
        //     context.toBaseNamed(HomePage.path);
        //   } else {
        //     context.toBaseNamed(SelectLanguage.path);
        //   }
        // } else {
        //   context.toBaseNamed(SelectLanguage.path);
        // }
      }
    });
    return Scaffold(
      backgroundColor: Colors.white,
      key: UniqueKey(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/icon_light.png"),
              SizedBox(
                height: 95,
              ),
              AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: LinearProgressIndicator(
                        value: controller.value,
                        backgroundColor: Colors.grey.withOpacity(0.4),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
