import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';
import 'package:threekm/Models/shopModel/order_realtime_detail_model.dart';
import 'package:threekm/main.dart';
import 'package:threekm/providers/shop/checkout/order_realtime_detail_provider.dart';

import 'checkout/order_detail.dart';

class ShowOrderStaus {
  late var order;
  ShowOrderStaus() {
    init();
  }

  formatTodayDate(dateUtc) {
    var dateFormat = DateFormat("hh:mm aa-dd/MMM/yyyy");
    var utcDate = dateFormat.format(dateUtc);
    return utcDate.split('-')[1];
  }

  formatDate(dateUtc) {
    var dateFormat =
        DateFormat("hh:mm aa-dd/MMM/yyyy"); // you can change the format here
    // DateFormat("dd-MM-yyyy hh:mm aa"); // you can change the format here
    var utcDate =
        dateFormat.format(DateTime.parse(dateUtc)); // pass the UTC time here
    var localDate = dateFormat.parse(utcDate, true).toLocal().toString();
    String createdDate = dateFormat.format(DateTime.parse(localDate));
    return createdDate.split('-')[1];
  }

  init() async {
    log('from snack bar 0');
    Box orderStatusBox = await Hive.openBox('orderStatusBox');
    var orderId = orderStatusBox.get('orderId');
    var orderDate = orderStatusBox.get('orderDate');
    if (orderDate != null &&
        formatDate(orderDate) == formatTodayDate(DateTime.now())) {
      if (orderId != null) {
        order = navigatorKey.currentContext!
            .read<OrderRealtimeDetailProvider>()
            .getOrderDetail(orderDate, orderId, home: 'home')
            .listen((event) {
          if (event != null) {
            log(event.orderStatus);
            if (event.orderStatus != 'placed' &&
                event.orderStatus != 'delivered') {
              log('from snack bar 1');
              final snackBar = SnackBar(
                  behavior: SnackBarBehavior.fixed,
                  content: SizedBox(
                    height: 66,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Image(
                              image: NetworkImage('${event.restaurantCover}'),
                              width: 34,
                              height: 45),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.orderStatus == 'created'
                                  ? ''
                                  : event.status ?? 'Food is being prepared',
                              style: TextStyle(color: Colors.black87),
                            ),
                            InkWell(
                                onTap: () {
                                  ScaffoldMessenger.of(
                                          navigatorKey.currentContext!)
                                      .removeCurrentSnackBar();
                                  Navigator.of(navigatorKey.currentContext!)
                                      .push(PageRouteBuilder(
                                          pageBuilder: (context, _, __) =>
                                              OrderDetails(
                                                orderId: orderId,
                                              ),
                                          opaque: false));
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      'View Details  ',
                                      style: TextStyle(color: Colors.red[400]),
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      size: 15,
                                      color: Colors.red[400],
                                    )
                                  ],
                                ))
                          ],
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(navigatorKey.currentContext!)
                                .removeCurrentSnackBar();
                          },
                          child: Icon(
                            Icons.close_rounded,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(22),
                          topRight: Radius.circular(22))),
                  backgroundColor: Colors.white,
                  // action: SnackBarAction(
                  //   textColor: Colors.black38,
                  //   label: "View Detail",
                  //   onPressed: () {
                  //     // Some code to undo the change.
                  //     log('Order Status Clicked');
                  //   },
                  // ),
                  duration: Duration(days: 365));
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                ScaffoldMessenger.of(navigatorKey.currentContext!)
                    .removeCurrentSnackBar();
                ScaffoldMessenger.of(navigatorKey.currentContext!)
                    .showSnackBar(snackBar);
              });
            } else {
              ScaffoldMessenger.of(navigatorKey.currentContext!)
                  .clearSnackBars();
            }
          }
        });
      }
    } else {
      // log('${formatDate(orderDate) == formatTodayDate(DateTime.now())}');
      // log('${formatDate(orderDate)}');
      // log('${formatTodayDate(DateTime.now())}');
    }
  }

  disposeFirebaseOrderListner() {
    log('delete listen to firebase');
    if (order != null) order.cancel();
  }
}