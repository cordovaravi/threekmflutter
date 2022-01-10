import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:provider/provider.dart';
import 'package:threekm/UI/walkthrough/splash_screen.dart';
import 'package:threekm/providers/Location/locattion_Provider.dart';
import 'package:threekm/providers/auth/Forgetpassword_provider.dart';
import 'package:threekm/providers/auth/signIn_Provider.dart';
import 'package:threekm/providers/auth/signUp_Provider.dart';
import 'package:threekm/providers/auth/social_auth/facebook_provider.dart';
import 'package:threekm/providers/auth/social_auth/google_provider.dart';
import 'package:threekm/providers/main/AthorProfile_Provider.dart';
import 'package:threekm/providers/main/LikeList_Provider.dart';
import 'package:threekm/providers/main/Quiz_Provider.dart';
import 'package:threekm/providers/main/comment_Provider.dart';
import 'package:threekm/providers/main/home1_provider.dart';
import 'package:threekm/providers/main/home2_provider.dart';
import 'package:threekm/providers/main/newsList_provider.dart';
import 'package:threekm/providers/main/singlePost_provider.dart';
import 'package:threekm/theme/setup.dart';
import 'providers/main/AddPost_Provider.dart';

//late List<CameraDescription> cameras;
final navigatorKey = GlobalKey<NavigatorState>();
//Fcm code------------------------------------------------------------------------
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  // await AwesomeNotifications().createNotification(
  //     content: NotificationContent(
  //         autoDismissible: false,
  //         displayOnForeground: true,
  //         locked: true,
  //         displayOnBackground: true,
  //         id: 1,
  //         channelKey: 'key1',
  //         title: '${message.notification?.title}',
  //         body: '${message.notification?.body}',
  //         notificationLayout: NotificationLayout.BigText),
  //     actionButtons: [
  //       NotificationActionButton(key: "disableSound", label: "Stop Buzzer")
  //     ]).then((value) async {
  //   var audiofile = await AudioSource.uri(Uri.parse(
  //       "https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_700KB.mp3"));
  //   await _player.setAsset(audiofile.uri.path);
  //   await _player.play();
  // });
  // AwesomeNotifications().actionStream.listen((event) {
  //   print("top evenent");
  //   print(event);
  // });
}

//end fcm code------------------------------------------------------------

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  //// fcm code-------------
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.getToken().then((value) => print(value));

  if (!kIsWeb) {
    // channel = const AndroidNotificationChannel(
    //   'high_importance_channel', // id
    //   'High Importance Notifications', // title
    //   importance: Importance.high,
    // );

    // flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // /// Create an Android Notification Channel.
    // ///
    // /// We use this channel in the `AndroidManifest.xml` file to override the
    // /// default FCM channel to enable heads up notifications.
    // await flutterLocalNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<
    //         AndroidFlutterLocalNotificationsPlugin>()
    //     ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  //fcm code------------------------------------------------------------

  Directory directory = await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
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
            create: (context) => QuizProvider()),
        ChangeNotifierProvider<LocationProvider>(
            create: (context) => LocationProvider()),
        ChangeNotifierProvider<AddPostProvider>(
            create: (context) => AddPostProvider()),
        ChangeNotifierProvider<AutthorProfileProvider>(
            create: (context) => AutthorProfileProvider())
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
