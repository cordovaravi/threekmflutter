import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:provider/provider.dart';
import 'package:threekm/UI/walkthrough/splash_screen.dart';
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
import 'providers/businesses/businesses_detail_provider.dart';
import 'providers/businesses/businesses_wishlist_provider.dart';
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
  Hive
    ..initFlutter()
    ..registerAdapter(CartHiveModelAdapter())
    ..registerAdapter(BusinesseswishListHiveModelAdapter());
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
            create: (context) => NotificationProvider())
      ],
      child: MaterialApp(
        // localizationsDelegates: [
        //   GlobalMaterialLocalizations.delegate,
        //   GlobalWidgetsLocalizations.delegate,
        //   GlobalCupertinoLocalizations.delegate,
        // ],
        // supportedLocales: [
        //   const Locale('en', ''), // English, no country code
        //   const Locale('mr', ''), // Marathi, no country code
        //   const Locale('hi', ''), // Hindi, no country code
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
