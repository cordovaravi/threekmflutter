import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:threekm/Models/shopModel/order_details_model.dart';
import 'package:threekm/Models/shopModel/order_realtime_detail_model.dart';
import 'package:threekm/main.dart';

class OrderRealtimeDetailProvider extends ChangeNotifier {
  // final _dbReference =
  //     FirebaseDatabase(databaseURL: 'https://km-production.firebaseio.com')
  //         .reference();
  FirebaseApp secondaryApp = Firebase.app();

  String? _state;
  String? get state => _state;
  // FirebaseDatabase(databaseURL: 'https://km-production.firebaseio.com')
  //     .reference();
// test 75116  2022-02-01T04:12:34.824Z
  Stream<OrderRealtimeDetailModel?> getOrderDetail(date, orderId) {
    FirebaseDatabase db = FirebaseDatabase.instanceFor(
        app: secondaryApp, databaseURL: 'https://km-production.firebaseio.com');
    var _dbReference = db.ref();
    try {
      DateFormat formatter = DateFormat('ddMMMyyyy');
      var datedata = formatter.format(DateTime.parse(date));
      var orders = _dbReference
          .child('orders')
          .child(datedata)
          // .child('30Nov2021')
          .child(orderId.toString())
          .onValue
          .asBroadcastStream();
      // log(orders.snapshot.value.toString());
      final streamToPublish = orders.map((event) {
        if (event.snapshot.value != null) {
          log(event.snapshot.value.toString());
          return OrderRealtimeDetailModel.fromJson(
              jsonDecode(jsonEncode(event.snapshot.value)));
        } else {
          navigatorKey.currentState?.pop();
          return null;
        }
      });
      // streamToPublish.listen((event) {
      //   log(event.toString());
      // });
      return streamToPublish;
    } catch (e) {
      _state = 'error';
      return {} as Stream<OrderRealtimeDetailModel?>;
      //  hideLoading();
      // notifyListeners();
    }
  }
}
