import 'dart:async';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:threekm/UI/main/News/PostView.dart';
import 'package:threekm/providers/FCM/fcm_sendToken_Provider.dart';
import 'package:threekm/providers/Location/locattion_Provider.dart';
import 'package:threekm/providers/Notification/Notification_Provider.dart';
import 'package:threekm/providers/ProfileInfo/ProfileInfo_Provider.dart';
import 'package:threekm/providers/Search/Search_Provider.dart';
import 'package:threekm/providers/Widgets/local_player.dart';
import 'package:threekm/providers/auth/Forgetpassword_provider.dart';
import 'package:threekm/providers/auth/signIn_Provider.dart';
import 'package:threekm/providers/auth/signUp_Provider.dart';
import 'package:threekm/providers/auth/social_auth/facebook_provider.dart';
import 'package:threekm/providers/auth/social_auth/google_provider.dart';
import 'package:threekm/providers/businesses/businesses_home_provider.dart';
import 'package:threekm/providers/main/AthorProfile_Provider.dart';
import 'package:threekm/providers/main/LikeList_Provider.dart';
import 'package:threekm/providers/main/NewsFeed_Provider.dart';
import 'package:threekm/providers/main/Quiz_Provider.dart';
import 'package:threekm/providers/main/comment_Provider.dart';
import 'package:threekm/providers/main/home1_provider.dart';
import 'package:threekm/providers/main/home2_provider.dart';
import 'package:threekm/providers/main/newsList_provider.dart';
import 'package:threekm/providers/main/singlePost_provider.dart';
import 'package:threekm/providers/shop/checkout/order_realtime_detail_provider.dart';
import 'package:threekm/providers/shop/checkout/past_order_provider.dart';
import 'package:threekm/providers/shop/shop_home_provider.dart';
import 'package:threekm/theme/setup.dart';
import 'Models/businessesModel/businesses_wishlist_model.dart';
import 'Models/shopModel/cart_hive_model.dart';

import 'UI/walkthrough/splash_screen.dart';
import 'localization/localize.dart';
import 'providers/businesses/businesses_detail_provider.dart';
import 'providers/businesses/businesses_wishlist_provider.dart';
import 'providers/localization_Provider/appLanguage_provider.dart';
import 'providers/main/AddPost_Provider.dart';
import 'providers/shop/address_list_provider.dart';
import 'providers/shop/all_category_provider.dart';
import 'providers/shop/cart_provider.dart';
import 'providers/shop/checkout/checkout_provider.dart';
import 'providers/shop/product_details_provider.dart';
import 'providers/shop/product_listing_provider.dart';
import 'providers/shop/restaurant_menu_provider.dart';
import 'providers/shop/user_review_provider.dart';
import 'providers/shop/wish_list_provide.dart';

//late List<CameraDescription> cameras;
final navigatorKey = GlobalKey<NavigatorState>();

/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
String FcmToken = "";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();

  ///changelog after 1st relase
  await Firebase.initializeApp(
      //  options: DefaultFirebaseOptions.currentPlatform,
      );
  final appDocumentDirectory = await getApplicationDocumentsDirectory();

  Hive.init(appDocumentDirectory.path);
  Hive
    ..initFlutter()
    ..registerAdapter(CartHiveModelAdapter())
    ..registerAdapter(BusinesseswishListHiveModelAdapter());

  runApp(MyApp(
    appLanguage: appLanguage,
  ));

  await FirebaseMessaging.instance.subscribeToTopic('Android');

  //fcm code--------------------
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    //update after 1st relase
    var initializationSettingsAndroid =
        AndroidInitializationSettings('icon_light');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOs);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  //end fcm code----------------------------

  // if (kReleaseMode) {
  //   if (Platform.isAndroid) {
  //     Future.delayed(Duration.zero, () {
  //       InAppUpdate.checkForUpdate().then((info) async {
  //         if (info.updateAvailability == UpdateAvailability.updateAvailable) {
  //           await InAppUpdate.performImmediateUpdate()
  //               .catchError((e) => log(e.toString()));
  //         }
  //       }).catchError((e) {
  //         log(e.toString());
  //       });
  //     });
  //   }
  // }

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  await FirebaseMessaging.instance
      .getToken()
      .then((value) => log(value.toString()));

  //end fcm code------------------------------------------------------------

  // Directory directory = await pathProvider.getApplicationDocumentsDirectory();
  // Hive.init(directory.path);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
    statusBarBrightness: Brightness.light,
  ));
}

class MyApp extends StatelessWidget {
  final AppLanguage appLanguage;

  MyApp({required this.appLanguage});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          //Applanguage
          ChangeNotifierProvider<AppLanguage>(
              create: (context) => AppLanguage()),

          //Auth
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
              create: (context) => AutthorProfileProvider()),
          ChangeNotifierProvider<LocalPlayerProvider>(
              create: (context) => LocalPlayerProvider()),

          ///shops providers
          ChangeNotifierProvider<ShopHomeProvider>(
              create: (context) => ShopHomeProvider()),
          ChangeNotifierProvider<AllCategoryListProvider>(
              create: (context) => AllCategoryListProvider()),
          ChangeNotifierProvider<ProductListingProvider>(
              create: (context) => ProductListingProvider()),
          ChangeNotifierProvider<ProductDetailsProvider>(
              create: (context) => ProductDetailsProvider()),
          ChangeNotifierProvider<UserReviewProvider>(
              create: (context) => UserReviewProvider()),
          ChangeNotifierProvider<RestaurantMenuProvider>(
              create: (context) => RestaurantMenuProvider()),
          ChangeNotifierProvider<CartProvider>(
              create: (context) => CartProvider()),
          ChangeNotifierProvider<AddressListProvider>(
              create: (context) => AddressListProvider()),
          ChangeNotifierProvider<WishListProvider>(
              create: (context) => WishListProvider()),
          ChangeNotifierProvider<LocationProvider>(
              create: (context) => LocationProvider()),
          ChangeNotifierProvider<CheckoutProvider>(
              create: (context) => CheckoutProvider()),
          ChangeNotifierProvider<PastOrderProvider>(
              create: (context) => PastOrderProvider()),
          ChangeNotifierProvider<OrderRealtimeDetailProvider>(
              create: (context) => OrderRealtimeDetailProvider()),

          // business provider
          ChangeNotifierProvider<BusinessesHomeProvider>(
              create: (context) => BusinessesHomeProvider()),
          ChangeNotifierProvider<BusinessDetailProvider>(
              create: (context) => BusinessDetailProvider()),
          ChangeNotifierProvider<BusinessesWishListProvider>(
              create: (context) => BusinessesWishListProvider()),
          ChangeNotifierProvider<ProfileInfoProvider>(
              create: (context) => ProfileInfoProvider()),

          /// Search Provider
          ChangeNotifierProvider<SearchBarProvider>(
              create: (context) => SearchBarProvider()),

          ///Notification Provider
          ChangeNotifierProvider<NotificationProvider>(
              create: (context) => NotificationProvider()),
          ChangeNotifierProvider<FCMProvider>(
              create: (context) => FCMProvider()),

          ChangeNotifierProvider<NewsFeedProvider>(
              create: (context) => NewsFeedProvider()),
        ],
        child: Consumer<AppLanguage>(
          builder: (context, controller, child) {
            log("app lang is ${controller.appLocal}");
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown,
            ]);

            return MaterialApp(
              locale: controller.appLocal ?? appLanguage.appLocal,
              //controller.appLocal,
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: [
                Locale('en', 'US'),
                Locale('mr', 'IN'),
                Locale('hi', 'IN'),
              ],
              title: '3km.in',
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              themeMode: ThemeMode.light,
              home: SplashScreen(
                fcmToken: FcmToken,
              ),
              navigatorKey: navigatorKey,
            );
          },
        ));
  }
}

onSelectNotification(String? payload) {
  Navigator.of(navigatorKey.currentContext!)
      .push(MaterialPageRoute(builder: (_) {
    return Postview(postId: payload!);
  }));
}
