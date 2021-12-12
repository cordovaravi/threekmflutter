import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:threekm/UI/walkthrough/splash_screen.dart';
import 'package:threekm/providers/auth/Forgetpassword_provider.dart';
import 'package:threekm/providers/auth/signIn_Provider.dart';
import 'package:threekm/providers/auth/signUp_Provider.dart';
import 'package:threekm/providers/auth/social_auth/facebook_provider.dart';
import 'package:threekm/providers/auth/social_auth/google_provider.dart';
import 'package:threekm/providers/main/LikeList_Provider.dart';
import 'package:threekm/providers/main/Quiz_Provider.dart';
import 'package:threekm/providers/main/comment_Provider.dart';
import 'package:threekm/providers/main/home1_provider.dart';
import 'package:threekm/providers/main/home2_provider.dart';
import 'package:threekm/providers/main/newsList_provider.dart';
import 'package:threekm/providers/main/singlePost_provider.dart';
import 'package:threekm/theme/setup.dart';

//late List<CameraDescription> cameras;
final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);

    var swAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
    var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

    if (swAvailable && swInterceptAvailable) {
      AndroidServiceWorkerController serviceWorkerController =
          AndroidServiceWorkerController.instance();

      serviceWorkerController.serviceWorkerClient = AndroidServiceWorkerClient(
        shouldInterceptRequest: (request) async {
          print(request);
          return null;
        },
      );
    }
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SignUpProvider>(
            create: (context) => SignUpProvider()),
        ChangeNotifierProvider<GoogleSignInprovider>(
            create: (context) => GoogleSignInprovider()),
        ChangeNotifierProvider<SignInProvider>(
            create: (context) => SignInProvider()),
        ChangeNotifierProvider<FaceAuthProvider>(
            create: (context) => FaceAuthProvider()),
        ChangeNotifierProvider<ForgetPasswordProvider>(
            create: (context) => ForgetPasswordProvider()),
        ChangeNotifierProvider<HomefirstProvider>(
            create: (context) => HomefirstProvider()),
        ChangeNotifierProvider<HomeSecondProvider>(
            create: (context) => HomeSecondProvider()),
        ChangeNotifierProvider<NewsListProvider>(
            create: (context) => NewsListProvider()),
        ChangeNotifierProvider(create: (context) => SinglePostProvider()),
        ChangeNotifierProvider<CommentProvider>(
            create: (context) => CommentProvider()),
        ChangeNotifierProvider<LikeListProvider>(
            create: (context) => LikeListProvider()),
        ChangeNotifierProvider<QuizProvider>(
            create: (context) => QuizProvider())
      ],
      child: MaterialApp(
        // localizationsDelegates: [
        //   GlobalMaterialLocalizations.delegate,
        //   GlobalWidgetsLocalizations.delegate,
        //   GlobalCupertinoLocalizations.delegate,
        // ],
        // supportedLocales: [
        //   const Locale('en', ''), // English, no country code
        //   const Locale('mr', ''), // Arabic, no country code
        //   const Locale('hi', ''), // Arabic, no country code
        //   // ... other locales the app supports
        // ],
        title: '3km.in',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        restorationScopeId: 'app',
        themeMode: ThemeMode.system,
        darkTheme: darkTheme,
        home: SplashScreen(),
        navigatorKey: navigatorKey,
        onGenerateRoute: (routeName) {
          print('this is generated route $routeName');
        },
      ),
    );
  }
}

Future _ringAlarm() async {
  AwesomeNotifications().initialize('resource://drawable/ic_launcher', [
    NotificationChannel(
        channelKey: 'basic_channel',
        groupKey: 'basic_tests',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white)
  ]);

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 10,
          channelKey: 'basic_channel',
          title: 'Simple Notification',
          body: 'Simple body'));
}
