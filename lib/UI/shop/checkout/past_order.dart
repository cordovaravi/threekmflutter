import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/src/provider.dart';
import 'package:threekm/UI/shop/checkout/order_detail.dart';
import 'package:threekm/providers/shop/checkout/past_order_provider.dart';
import 'package:intl/intl.dart';

class PastOrder extends StatefulWidget {
  const PastOrder({Key? key}) : super(key: key);

  @override
  State<PastOrder> createState() => _PastOrderState();
}

class _PastOrderState extends State<PastOrder> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<PastOrderProvider>().getPastShopOrderList(mounted);
      // context.read<PastOrderProvider>().getPastMenuOrderList(mounted);
    });
    openBox();
  }

  openBox() async {
    await Hive.openBox('orderStatusBox');
  }

  formatDate(dateUtc) {
    var dateFormat =
        DateFormat("hh:mm aa d MMM yyyy"); // you can change the format here
    // DateFormat("dd-MM-yyyy hh:mm aa"); // you can change the format here
    var utcDate =
        dateFormat.format(DateTime.parse(dateUtc)); // pass the UTC time here
    var localDate = dateFormat.parse(utcDate, true).toLocal().toString();
    String createdDate = dateFormat.format(DateTime.parse(localDate));
    return createdDate;
  }

  @override
  Widget build(BuildContext context) {
    var state = context.watch<PastOrderProvider>().state;
    var data =
        context.read<PastOrderProvider>().shopPastOrderList.result?.orders;
    var Menudata =
        context.read<PastOrderProvider>().MenupastOrderList.result?.orders;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            title: Text('All Orders'),
            bottom: TabBar(
              labelColor: Colors.black,
              tabs: [
                Tab(
                  text: "Food",
                ),
                Tab(
                  text: "Product",
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Menudata != null && state == 'loaded'
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: Menudata.length,
                        itemBuilder: (_, i) {
                          var order = Menudata[i];
                          // var StatusColor = order.centerColor.split('rgba')[1];
                          // log(StatusColor);
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey[200]!, width: 4),
                            ),
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: order.lineItems.length,
                                    itemBuilder: (_, i) {
                                      var product = order.lineItems[i];
                                      return Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Color(0xFF32335E26),
                                                  blurRadius: 10,
                                                  offset: Offset(0, 6))
                                            ]),
                                        padding: EdgeInsets.only(
                                            top: 15, bottom: 10),
                                        margin: EdgeInsets.only(
                                            top: 15, bottom: 10),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(10),
                                              child: Image(
                                                image: NetworkImage(
                                                    '${order.sellerDp}'),
                                                width: 100,
                                                height: 50,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${product.name}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    'Sold by: ${product.soldby}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  // Text(
                                                  //     'Quantity: ${product.quantity}'),
                                                  // Text('₹${product.subtotal}'),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${order.centerStatus}',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                        Text('${formatDate(order.centerTime)}')
                                      ],
                                    ),
                                    TextButton(
                                        onPressed: () => Navigator.of(context)
                                            .push(PageRouteBuilder(
                                                pageBuilder: (context, _, __) =>
                                                    OrderDetails(
                                                      orderId: order.projectId,
                                                    ),
                                                opaque: false)),
                                        child: Text('View Details'))
                                  ],
                                )
                              ],
                            ),
                          );
                        })
                    : Container(),
              ),
              // second tab
              Container(
                margin: EdgeInsets.only(top: 30),
                child: data != null && state == 'loaded'
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (_, i) {
                          var order = data[i];
                          log('$order');

                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey[200]!, width: 4),
                            ),
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: order.lineItems.length,
                                    itemBuilder: (_, i) {
                                      var product = order.lineItems[i];
                                      return Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Color(0xFF32335E26),
                                                  blurRadius: 10,
                                                  offset: Offset(0, 6))
                                            ]),
                                        padding: EdgeInsets.only(
                                            top: 15, bottom: 10),
                                        margin: EdgeInsets.only(
                                            top: 15, bottom: 10),
                                        child: Row(
                                          children: [
                                            Image(
                                              image: NetworkImage(
                                                  '${order.sellerDp}'),
                                              width: 100,
                                              height: 50,
                                            ),
                                            SizedBox(
                                              width: 230,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${product.name}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    'Sold by: ${product.soldby}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                      'Quantity: ${product.quantity}'),
                                                  Text('₹${product.price}'),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${order.centerStatus}',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                        Text('${formatDate(order.centerTime)} '
                                            // ${DateFormat.yMMMEd().format(DateTime.parse(order.centerTime))}
                                            )
                                      ],
                                    ),
                                    TextButton(
                                        onPressed: () => Navigator.of(context)
                                            .push(PageRouteBuilder(
                                                pageBuilder: (context, _, __) =>
                                                    OrderDetails(
                                                      orderId: order.projectId,
                                                    ),
                                                opaque: false)),
                                        child: Text('View Details'))
                                  ],
                                )
                              ],
                            ),
                          );
                        })
                    : Container(),
              ),
              //second Tab
            ],
          )),
    );
  }
}
