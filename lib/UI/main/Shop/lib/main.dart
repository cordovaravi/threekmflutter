import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:threekm_test/Models/shopModel/cart_hive_model.dart';
import 'package:threekm_test/providers/Location/locattion_Provider.dart';
import 'package:threekm_test/providers/shop/address_list_provider.dart';

import 'package:threekm_test/providers/shop/all_category_provider.dart';
import 'package:threekm_test/providers/shop/cart_provider.dart';
import 'package:threekm_test/providers/shop/checkout/checkout_provider.dart';
import 'package:threekm_test/providers/shop/product_details_provider.dart';
import 'package:threekm_test/providers/shop/product_listing_provider.dart';
import 'package:threekm_test/providers/shop/shop_home_provider.dart';
import 'package:threekm_test/providers/shop/user_review_provider.dart';
import 'package:threekm_test/providers/shop/wish_list_provide.dart';

import 'providers/shop/restaurant_menu_provider.dart';
import 'widget/shop/home_3km.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Home3KM(),
        // RestaurantMenu(),

        navigatorKey: navigatorKey,
      ),
    );
  }
}
