import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/src/provider.dart';
import 'package:threekm/Models/home1_model.dart';
import 'package:threekm/Models/shopModel/order_details_model.dart';
import 'package:threekm/Models/shopModel/order_realtime_detail_model.dart';

import 'package:threekm/providers/shop/checkout/checkout_provider.dart';
import 'package:threekm/providers/shop/checkout/order_realtime_detail_provider.dart';

import 'package:threekm/utils/threekm_textstyles.dart';
import 'package:timelines/timelines.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({Key? key, this.orderId, this.showOrderDetail})
      : super(key: key);
  final orderId;
  final bool? showOrderDetail;
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  bool? _showOrderDetail = true;

  @override
  void initState() {
    context.read<CheckoutProvider>().getOrderDetail(widget.orderId);
    _showOrderDetail =
        widget.showOrderDetail == null ? true : widget.showOrderDetail;
    // context
    //     .read<OrderRealtimeDetailProvider>()
    //     .getOrderDetail('2022-02-01T04:12:34.824Z', 75116);
    super.initState();
  }

  void showAlert(BuildContext context) {
    showDialog(
        useSafeArea: true,
        context: context,
        builder: (context) => AlertDialog(
              content: Container(
                // height: 400,
                width: 500,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                        child: Text(
                      'SUPPORT',
                      style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold,
                    )),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Call our customer support representative on the following numbers!',
                          style: ThreeKmTextConstants.tk12PXLatoBlackBold,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.grey[350],
                          borderRadius: BorderRadius.circular(20)),
                      child: InkWell(
                        onTap: () {
                          launch(('tel://9765599649'));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                      color: Color(0xFFF4F3F8),
                                      shape: BoxShape.circle),
                                  child: Icon(
                                    Icons.phone,
                                    color: Color(0xFF979EA4),
                                  ),
                                  height: 32,
                                  width: 32,
                                ),
                                Text('9765599649'),
                              ],
                            ),
                            Text(
                              'CALL NOW',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.grey[350],
                          borderRadius: BorderRadius.circular(20)),
                      child: InkWell(
                        onTap: () {
                          launch(('tel://9921925125'));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                      color: Color(0xFFF4F3F8),
                                      shape: BoxShape.circle),
                                  child: Icon(
                                    Icons.phone,
                                    color: Color(0xFF979EA4),
                                  ),
                                  height: 32,
                                  width: 32,
                                ),
                                Text('9921925125'),
                              ],
                            ),
                            Text(
                              'CALL NOW',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.grey[350],
                          borderRadius: BorderRadius.circular(20)),
                      child: InkWell(
                        onTap: () {
                          launch(('tel://9370778837'));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                      color: Color(0xFFF4F3F8),
                                      shape: BoxShape.circle),
                                  child: Icon(
                                    Icons.phone,
                                    color: Color(0xFF979EA4),
                                  ),
                                  height: 32,
                                  width: 32,
                                ),
                                Text('9370778837'),
                              ],
                            ),
                            Text(
                              'CALL NOW',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Close'))
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    var data = context.watch<CheckoutProvider>().orderDetailData?.result.order;
    var state = context.watch<CheckoutProvider>().state;
    var productList = data?.cart;
    var sum = 0.0;
    productList?.forEach((e) {
      sum += e.subtotal.toDouble();
    });
    return Scaffold(
      // backgroundColor: Colors.transparent,
      backgroundColor: Colors.blue[200]!.withOpacity(0.6),
      body: data != null && state == 'loaded'
          ? DraggableScrollableSheet(
              initialChildSize: 0.80,
              minChildSize: 0.7,
              maxChildSize: 1,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Column(children: [
                  InkWell(
                    onTap: () async {
                      var orderbox = await Hive.openBox('orderinfo');
                      orderbox.clear();
                      Navigator.pop(context);
                    },
                    child: Image(
                      image: AssetImage('assets/shopImg/close.png'),
                      height: 60,
                      width: 60,
                    ),
                  ),
                  Flexible(
                      child: data.orderType != 'menu'
                          ? Container(
                              color: Colors.white,
                              //height: 900,
                              padding: EdgeInsets.only(top: 20),
                              child: SingleChildScrollView(
                                controller: scrollController,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Order Summary #${data.projectId}',
                                              style: ThreeKmTextConstants
                                                  .tk14PXPoppinsBlackMedium,
                                            ),
                                            TextButton(
                                                style: ButtonStyle(
                                                    shape: MaterialStateProperty
                                                        .all(StadiumBorder(
                                                            side: BorderSide(
                                                                color: Color(
                                                                    0xFFFF5858))))),
                                                onPressed: () =>
                                                    showAlert(context),
                                                child: Text(
                                                  ' Support ',
                                                  style: ThreeKmTextConstants
                                                      .tk14PXPoppinsBlackMedium
                                                      .copyWith(
                                                          color: Color(
                                                              0xFFFF5858)),
                                                ))
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.all(30),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey[350]!,
                                              blurRadius: 8,
                                            )
                                          ],
                                          color: Colors.white,
                                        ),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Image(
                                                image: AssetImage(
                                                    'assets/shopImg/orderStatusImg.png')),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(18.0),
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/shopImg/heart-balloon.gif'),
                                                height: 130,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        color: Color(0xFFF4F3F8),
                                        thickness: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20, left: 20, right: 20),
                                            child: Text(
                                                'Order Served by ${data.soldby}'),
                                          ),

                                          ListView.builder(
                                              padding: EdgeInsets.only(
                                                  top: 0, left: 10, right: 10),
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: productList?.length,
                                              itemBuilder: (_, i) {
                                                var productData =
                                                    productList?[i];
                                                return ListTile(
                                                  dense: true,
                                                  // leading: Image(image: NetworkImage(''),),
                                                  title: Text(
                                                    '${productData?.name}',
                                                    style: ThreeKmTextConstants
                                                        .tk14PXPoppinsBlackSemiBold,
                                                  ),
                                                  // subtitle: Text(
                                                  //   'By ${productData.}',
                                                  //   style: ThreeKmTextConstants
                                                  //       .tk12PXPoppinsBlackSemiBold
                                                  //       .copyWith(color: Color(0xFF979EA4)),
                                                  // ),
                                                  trailing: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        'X ${productData?.quantity}',
                                                        style: ThreeKmTextConstants
                                                            .tk14PXPoppinsBlackMedium
                                                            .copyWith(
                                                                color: Color(
                                                                    0xFF979EA4)),
                                                      ),
                                                      Text(
                                                        '₹${productData?.price}',
                                                        style: ThreeKmTextConstants
                                                            .tk14PXPoppinsBlackSemiBold
                                                            .copyWith(
                                                                color: Color(
                                                                    0xFF3E7EFF)),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }),
                                          Container(
                                            padding: EdgeInsets.all(23),
                                            child: Column(
                                              children: [
                                                Divider(
                                                  color: Colors.grey[350],
                                                  thickness: 1,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Taxes',
                                                      style: ThreeKmTextConstants
                                                          .tk12PXPoppinsBlackSemiBold,
                                                    ),
                                                    Text(
                                                      '₹${productList?[0].tax}',
                                                      style: ThreeKmTextConstants
                                                          .tk12PXLatoBlackBold,
                                                    )
                                                  ],
                                                ),
                                                Divider(
                                                  color: Colors.grey[350],
                                                  thickness: 1,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Delivery Charges',
                                                      style: ThreeKmTextConstants
                                                          .tk12PXPoppinsBlackSemiBold,
                                                    ),
                                                    Text(
                                                      '₹${data.delivery.cost}',
                                                      style: ThreeKmTextConstants
                                                          .tk12PXLatoBlackBold,
                                                    )
                                                  ],
                                                ),
                                                Divider(
                                                  color: Colors.grey[350],
                                                  thickness: 1,
                                                ),
                                                // Row(
                                                //   mainAxisAlignment:
                                                //       MainAxisAlignment
                                                //           .spaceBetween,
                                                //   children: [
                                                //     Text(
                                                //       'Platform Charges',
                                                //       style: ThreeKmTextConstants
                                                //           .tk12PXPoppinsBlackSemiBold,
                                                //     ),
                                                //     Text(
                                                //       '₹10',
                                                //       style: ThreeKmTextConstants
                                                //           .tk12PXLatoBlackBold,
                                                //     )
                                                //   ],
                                                // ),
                                                // Divider(
                                                //   color: Colors.grey[350],
                                                //   thickness: 1,
                                                // ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Total',
                                                      style: ThreeKmTextConstants
                                                          .tk14PXPoppinsBlackBold,
                                                    ),
                                                    Text(
                                                      '₹${sum + data.delivery.cost}',
                                                      style: ThreeKmTextConstants
                                                          .tk14PXLatoBlackBold,
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            color: Color(0xFFF4F3F8),
                                            thickness: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Text(
                                              'Delivering to:',
                                              style: ThreeKmTextConstants
                                                  .tk14PXPoppinsBlackMedium,
                                            ),
                                          ),
                                          ListTile(
                                            dense: true,
                                            leading: Image(
                                              image: AssetImage(
                                                  'assets/shopImg/homeIcon.png'),
                                              height: 32,
                                              width: 32,
                                            ),
                                            title: Text(
                                              '${data.address.addressType == "" ? 'Home' : data.address.addressType}',
                                              style: ThreeKmTextConstants
                                                  .tk14PXPoppinsBlackSemiBold,
                                            ),
                                            subtitle: Text(
                                              '${data.address.flatNo} ${data.address.area}',
                                              style: ThreeKmTextConstants
                                                  .tk12PXPoppinsBlackSemiBold
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.normal),
                                            ),
                                          ),
                                          ListTile(
                                            dense: true,
                                            leading: Container(
                                              decoration: BoxDecoration(
                                                  color: Color(0xFFF4F3F8),
                                                  shape: BoxShape.circle),
                                              child: Icon(
                                                Icons.phone,
                                                color: Color(0xFF979EA4),
                                              ),
                                              height: 32,
                                              width: 32,
                                            ),
                                            title: Text(
                                              '${data.address.firstname} ${data.address.lastname}',
                                              style: ThreeKmTextConstants
                                                  .tk14PXPoppinsBlackSemiBold,
                                            ),
                                            subtitle: Text(
                                              '${data.address.phoneNo}',
                                              style: ThreeKmTextConstants
                                                  .tk12PXPoppinsBlackSemiBold
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.normal),
                                            ),
                                          ),

                                          Divider(
                                            height: 10,
                                            color: Color(0xFFF4F3F8),
                                            thickness: 10,
                                          ),

                                          // Container(
                                          //   padding: EdgeInsets.all(20),
                                          //   child: Column(
                                          //     children: [
                                          //       TimelineTile(
                                          //         nodeAlign: TimelineNodeAlign.start,
                                          //         contents: Padding(
                                          //           padding: const EdgeInsets.all(12.0),
                                          //           child: Row(
                                          //             mainAxisAlignment:
                                          //                 MainAxisAlignment.spaceBetween,
                                          //             children: [
                                          //               Text(
                                          //                 'Order Placed',
                                          //                 style: ThreeKmTextConstants
                                          //                     .tk14PXPoppinsBlackSemiBold,
                                          //               ),
                                          //               Text('14 Jan 2020')
                                          //             ],
                                          //           ),
                                          //         ),
                                          //         node: TimelineNode(
                                          //           indicator: DotIndicator(),
                                          //           //startConnector: SolidLineConnector(),
                                          //           endConnector: SolidLineConnector(),
                                          //         ),
                                          //       ),
                                          //       TimelineTile(
                                          //         nodeAlign: TimelineNodeAlign.start,
                                          //         contents: Padding(
                                          //           padding: const EdgeInsets.all(12.0),
                                          //           child: Row(
                                          //             mainAxisAlignment:
                                          //                 MainAxisAlignment.spaceBetween,
                                          //             children: [
                                          //               Text(
                                          //                 'Order Placed',
                                          //                 style: ThreeKmTextConstants
                                          //                     .tk14PXPoppinsBlackSemiBold,
                                          //               ),
                                          //               Text('14 Jan 2020')
                                          //             ],
                                          //           ),
                                          //         ),
                                          //         node: TimelineNode(
                                          //           indicator: DotIndicator(),
                                          //           startConnector: SolidLineConnector(),
                                          //           endConnector: SolidLineConnector(),
                                          //         ),
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),
                                          SizedBox(
                                            height: 40,
                                          ),

                                          // Padding(
                                          //   padding: const EdgeInsets.all(22.0),
                                          //   child: Text(
                                          //       'Order ID: ${data.orderId}'),
                                          // ),
                                          //  Text('Transaction ID: 1234567')
                                        ],
                                      )
                                    ]),
                              ))
                          : StreamBuilder(
                              key: Key(data.projectId.toString()),
                              stream: context
                                  .read<OrderRealtimeDetailProvider>()
                                  .getOrderDetail(
                                      data.centerTime, data.projectId),
                              builder: (_, snapshot) {
                                if (snapshot.data != null) {
                                  OrderRealtimeDetailModel orderData =
                                      snapshot.data as OrderRealtimeDetailModel;

                                  return orderData.orderStatus == 'created' ||
                                          _showOrderDetail == false
                                      ? Container(
                                          height: 700,
                                          color: Colors.white,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  child: ClipPath(
                                                    clipper: MyCustomShape(),
                                                    child: Container(
                                                      width: double.infinity,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              3,
                                                      color: Colors.green,
                                                      child: Stack(
                                                        alignment:
                                                            Alignment.topCenter,
                                                        children: [
                                                          Center(
                                                            child: Image(
                                                              image: AssetImage(
                                                                  'assets/shopImg/check_back.png'),
                                                              height: 290,
                                                              width: 290,
                                                            ),
                                                          ),
                                                          Center(
                                                            child: Image(
                                                              image: AssetImage(
                                                                  'assets/shopImg/check_front.png'),
                                                              height: 60,
                                                              width: 60,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 20),
                                                            child: Text(
                                                              'Thank You for your order!',
                                                              style: ThreeKmTextConstants
                                                                  .tk16PXPoppinsWhiteBold,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Text('Confirming With restaurant:',
                                                    style: ThreeKmTextConstants
                                                        .tk14PXPoppinsBlackSemiBold),
                                                ListView.builder(
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: data.cart.length,
                                                    itemBuilder: (_, i) {
                                                      var productData =
                                                          data.cart[i];
                                                      return ListTile(
                                                        dense: true,
                                                        title: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              constraints:
                                                                  BoxConstraints(
                                                                      minWidth:
                                                                          100,
                                                                      maxWidth:
                                                                          260),
                                                              child: Text(
                                                                '${productData.name}',
                                                                maxLines: 3,
                                                                style: ThreeKmTextConstants
                                                                    .tk12PXPoppinsBlackSemiBold,
                                                              ),
                                                            ),
                                                            Text(
                                                              'X ${productData.quantity}',
                                                              style: ThreeKmTextConstants
                                                                  .tk14PXPoppinsBlackMedium
                                                                  .copyWith(
                                                                      color: Color(
                                                                          0xFF979EA4)),
                                                            ),
                                                          ],
                                                        ),
                                                        // trailing:
                                                        //     CircularProgressIndicator(),
                                                      );
                                                    }),
                                                Center(
                                                  child: Container(
                                                    padding: EdgeInsets.all(20),
                                                    width: double.infinity,
                                                    child: ElevatedButton(
                                                        onPressed: () {
                                                          log('pressed ');
                                                          setState(() {
                                                            _showOrderDetail =
                                                                true;
                                                          });
                                                        },
                                                        child: Text(
                                                          'Order Details',
                                                          style: ThreeKmTextConstants
                                                              .tk14PXPoppinsBlackBold
                                                              .copyWith(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                        style: ButtonStyle(
                                                            elevation:
                                                                MaterialStateProperty.all<
                                                                    double>(0),
                                                            foregroundColor: MaterialStateProperty.all<Color>(
                                                                Colors.white),
                                                            backgroundColor:
                                                                MaterialStateProperty.all<Color>(
                                                                    Color(
                                                                        0xFF3E7EFF)),
                                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(18.0),
                                                                    side: BorderSide.none)))),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container(
                                          color: Colors.white,
                                          //height: 900,
                                          padding: EdgeInsets.only(top: 20),
                                          child: SingleChildScrollView(
                                              controller: scrollController,
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 20, right: 20),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            'Order Summary #${data.projectId}',
                                                            style: ThreeKmTextConstants
                                                                .tk14PXPoppinsBlackMedium,
                                                          ),
                                                          TextButton(
                                                              style: ButtonStyle(
                                                                  shape: MaterialStateProperty.all(StadiumBorder(
                                                                      side: BorderSide(
                                                                          color: Color(
                                                                              0xFFFF5858))))),
                                                              onPressed: () =>
                                                                  showAlert(
                                                                      context),
                                                              child: Text(
                                                                ' Support ',
                                                                style: ThreeKmTextConstants
                                                                    .tk14PXPoppinsBlackMedium
                                                                    .copyWith(
                                                                        color: Color(
                                                                            0xFFFF5858)),
                                                              ))
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20),
                                                      child: Text(
                                                          'You placed an order on ${orderData.time} ${orderData.date}'),
                                                    ),
                                                    Container(
                                                      margin:
                                                          EdgeInsets.all(30),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors
                                                                .grey[350]!,
                                                            blurRadius: 8,
                                                          )
                                                        ],
                                                        color: Colors.white,
                                                      ),
                                                      child: Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: [
                                                          Image(
                                                              image: AssetImage(
                                                                  'assets/shopImg/orderStatusImg.png')),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(18.0),
                                                            child: Image(
                                                              image: NetworkImage(
                                                                  '${orderData.statusImage}'),
                                                              height: 130,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Center(
                                                        child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 15),
                                                      child: Text(
                                                        '${orderData.status ?? 'Food is being prepared'}',
                                                        style: ThreeKmTextConstants
                                                            .tk12PXPoppinsBlackSemiBold,
                                                      ),
                                                    )),
                                                    if (orderData
                                                            .deliveryDetails
                                                            .agentName !=
                                                        null)
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 25,
                                                            right: 25,
                                                            bottom: 25),
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .grey[350],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    'Delivery Partner'),
                                                                Container(
                                                                  constraints: BoxConstraints(
                                                                      minWidth:
                                                                          40,
                                                                      maxWidth:
                                                                          MediaQuery.of(context).size.width /
                                                                              3),
                                                                  child: Text(
                                                                      '${orderData.deliveryDetails.agentName}'),
                                                                )
                                                              ],
                                                            ),
                                                            if (orderData
                                                                    .deliveryDetails
                                                                    .trackingUrl !=
                                                                null)
                                                              Center(
                                                                child:
                                                                    ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          launch(
                                                                              '${orderData.deliveryDetails.trackingUrl}');
                                                                        },
                                                                        child: Text(
                                                                            'Track your order'),
                                                                        style: ButtonStyle(
                                                                            elevation:
                                                                                MaterialStateProperty.all<double>(0),
                                                                            foregroundColor: MaterialStateProperty.all<Color>(Colors.green),
                                                                            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), side: BorderSide.none)))),
                                                              ),
                                                            InkWell(
                                                              onTap: () async =>
                                                                  await launch(
                                                                      ('tel://${orderData.deliveryDetails.agentPhone}')),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    color: Color(
                                                                        0xFFF4F3F8),
                                                                    shape: BoxShape
                                                                        .circle),
                                                                child: Icon(
                                                                  Icons.phone,
                                                                  color: Colors
                                                                      .green,
                                                                ),
                                                                height: 32,
                                                                width: 32,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    Divider(
                                                      color: Color(0xFFF4F3F8),
                                                      thickness: 10,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 20,
                                                                  left: 20,
                                                                  right: 20),
                                                          child: Text(
                                                              'Order Served by ${data.soldby}'),
                                                        ),

                                                        ListView.builder(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 0,
                                                                    left: 10,
                                                                    right: 10),
                                                            physics:
                                                                NeverScrollableScrollPhysics(),
                                                            shrinkWrap: true,
                                                            itemCount: orderData
                                                                .products
                                                                .length,
                                                            itemBuilder:
                                                                (_, i) {
                                                              var productData =
                                                                  orderData
                                                                      .products[i];
                                                              return ListTile(
                                                                dense: true,
                                                                // leading: Image(image: NetworkImage(''),),
                                                                title: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Container(
                                                                      constraints: BoxConstraints(
                                                                          minWidth:
                                                                              100,
                                                                          maxWidth:
                                                                              260),
                                                                      child:
                                                                          Text(
                                                                        '${productData.name}',
                                                                        maxLines:
                                                                            3,
                                                                        style: ThreeKmTextConstants
                                                                            .tk14PXPoppinsBlackSemiBold,
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              20),
                                                                      child:
                                                                          Text(
                                                                        'X ${productData.quantity}',
                                                                        style: ThreeKmTextConstants
                                                                            .tk14PXPoppinsBlackMedium
                                                                            .copyWith(color: Color(0xFF979EA4)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                // subtitle: Text(
                                                                //   'By ${productData.}',
                                                                //   style: ThreeKmTextConstants
                                                                //       .tk12PXPoppinsBlackSemiBold
                                                                //       .copyWith(color: Color(0xFF979EA4)),
                                                                // ),
                                                                trailing: Text(
                                                                  '₹${productData.price}',
                                                                  style: ThreeKmTextConstants
                                                                      .tk14PXPoppinsBlackSemiBold
                                                                      .copyWith(
                                                                          color:
                                                                              Color(0xFF3E7EFF)),
                                                                ),
                                                              );
                                                            }),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  23),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    'Subtotal',
                                                                    style: ThreeKmTextConstants
                                                                        .tk12PXPoppinsBlackSemiBold,
                                                                  ),
                                                                  Text(
                                                                    '₹${orderData.subTotal}',
                                                                    style: ThreeKmTextConstants
                                                                        .tk12PXLatoBlackBold,
                                                                  )
                                                                ],
                                                              ),
                                                              Divider(
                                                                color: Colors
                                                                    .grey[350],
                                                                thickness: 1,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    'Taxes',
                                                                    style: ThreeKmTextConstants
                                                                        .tk12PXPoppinsBlackSemiBold,
                                                                  ),
                                                                  Text(
                                                                    '₹${orderData.tax ?? 0}',
                                                                    style: ThreeKmTextConstants
                                                                        .tk12PXLatoBlackBold,
                                                                  )
                                                                ],
                                                              ),
                                                              Divider(
                                                                color: Colors
                                                                    .grey[350],
                                                                thickness: 1,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    'Delivery Charges',
                                                                    style: ThreeKmTextConstants
                                                                        .tk12PXPoppinsBlackSemiBold,
                                                                  ),
                                                                  Text(
                                                                    '₹${orderData.shippingAmount}',
                                                                    style: ThreeKmTextConstants
                                                                        .tk12PXLatoBlackBold,
                                                                  )
                                                                ],
                                                              ),
                                                              Divider(
                                                                color: Colors
                                                                    .grey[350],
                                                                thickness: 1,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    'Platform Charges',
                                                                    style: ThreeKmTextConstants
                                                                        .tk12PXPoppinsBlackSemiBold,
                                                                  ),
                                                                  Text(
                                                                    '₹10',
                                                                    style: ThreeKmTextConstants
                                                                        .tk12PXLatoBlackBold,
                                                                  )
                                                                ],
                                                              ),
                                                              Divider(
                                                                color: Colors
                                                                    .grey[350],
                                                                thickness: 1,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    'Total',
                                                                    style: ThreeKmTextConstants
                                                                        .tk14PXPoppinsBlackBold,
                                                                  ),
                                                                  Text(
                                                                    '₹${orderData.total + orderData.shippingAmount}',
                                                                    style: ThreeKmTextConstants
                                                                        .tk14PXLatoBlackBold,
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Divider(
                                                          color:
                                                              Color(0xFFF4F3F8),
                                                          thickness: 10,
                                                        ),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  25),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                      child:
                                                                          Image(
                                                                        image: NetworkImage(
                                                                            '${orderData.restaurantCover}'),
                                                                        width:
                                                                            100,
                                                                        height:
                                                                            60,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    constraints: BoxConstraints(
                                                                        minWidth:
                                                                            100,
                                                                        maxWidth:
                                                                            MediaQuery.of(context).size.width /
                                                                                1.8),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                            '${orderData.restaurantName}'),
                                                                        Text(
                                                                            '${orderData.restaurantCuisine}')
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Center(
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                              top: 10),
                                                                  width: double
                                                                      .infinity,
                                                                  child:
                                                                      ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            launch(('tel://${orderData.restaurantPhone}'));
                                                                          },
                                                                          child: Text(
                                                                              'Call Restaurant'),
                                                                          style: ButtonStyle(
                                                                              elevation: MaterialStateProperty.all<double>(0),
                                                                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                                              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), side: BorderSide.none)))),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Divider(
                                                          color:
                                                              Color(0xFFF4F3F8),
                                                          thickness: 10,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(20.0),
                                                          child: Text(
                                                            'Delivering to:',
                                                            style: ThreeKmTextConstants
                                                                .tk14PXPoppinsBlackMedium,
                                                          ),
                                                        ),
                                                        ListTile(
                                                          dense: true,
                                                          leading: Image(
                                                            image: AssetImage(
                                                                'assets/shopImg/homeIcon.png'),
                                                            height: 32,
                                                            width: 32,
                                                          ),
                                                          title: Text(
                                                            '${data.address.addressType == "" ? 'Home' : data.address.addressType}',
                                                            style: ThreeKmTextConstants
                                                                .tk14PXPoppinsBlackSemiBold,
                                                          ),
                                                          subtitle: Text(
                                                            '${data.address.flatNo} ${data.address.area}',
                                                            style: ThreeKmTextConstants
                                                                .tk12PXPoppinsBlackSemiBold
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                          ),
                                                        ),
                                                        ListTile(
                                                          dense: true,
                                                          leading: Container(
                                                            decoration: BoxDecoration(
                                                                color: Color(
                                                                    0xFFF4F3F8),
                                                                shape: BoxShape
                                                                    .circle),
                                                            child: Icon(
                                                              Icons.phone,
                                                              color: Color(
                                                                  0xFF979EA4),
                                                            ),
                                                            height: 32,
                                                            width: 32,
                                                          ),
                                                          title: Text(
                                                            '${data.address.firstname} ${data.address.lastname}',
                                                            style: ThreeKmTextConstants
                                                                .tk14PXPoppinsBlackSemiBold,
                                                          ),
                                                          subtitle: Text(
                                                            '${data.address.phoneNo}',
                                                            style: ThreeKmTextConstants
                                                                .tk12PXPoppinsBlackSemiBold
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                          ),
                                                        ),

                                                        Divider(
                                                          height: 10,
                                                          color:
                                                              Color(0xFFF4F3F8),
                                                          thickness: 10,
                                                        ),

                                                        Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    20),
                                                            child: Column(
                                                              children: [
                                                                ListView
                                                                    .builder(
                                                                        physics:
                                                                            NeverScrollableScrollPhysics(),
                                                                        shrinkWrap:
                                                                            true,
                                                                        itemCount: orderData
                                                                            .deliveryLogs
                                                                            .length,
                                                                        itemBuilder:
                                                                            (_, i) {
                                                                          return TimelineTile(
                                                                            nodeAlign:
                                                                                TimelineNodeAlign.start,
                                                                            contents:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(12.0),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Text(
                                                                                    '${orderData.deliveryLogs[i].title}',
                                                                                    style: ThreeKmTextConstants.tk14PXPoppinsBlackSemiBold,
                                                                                  ),
                                                                                  Text('${orderData.deliveryLogs[i].time}')
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            node:
                                                                                TimelineNode(
                                                                              indicator: DotIndicator(
                                                                                color: Colors.green,
                                                                              ),
                                                                              startConnector: SolidLineConnector(
                                                                                color: Colors.green,
                                                                              ),
                                                                              endConnector: SolidLineConnector(
                                                                                color: Colors.green,
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }),
                                                                SizedBox(
                                                                  height: 40,
                                                                ),
                                                              ],
                                                            )),
                                                        // if (orderData
                                                        //         .deliveryDetails
                                                        //         .trackingUrl !=
                                                        //     null)
                                                        //   Divider(
                                                        //     color:
                                                        //         Color(0xFFF4F3F8),
                                                        //     thickness: 10,
                                                        //   ),
                                                        // Padding(
                                                        //   padding:
                                                        //       const EdgeInsets.all(
                                                        //           22.0),
                                                        //   child: Text(
                                                        //       'Order ID: ${data.orderId}'),
                                                        // ),
                                                        //  Text('Transaction ID: 1234567')
                                                      ],
                                                    )
                                                  ])));
                                } else {
                                  return Container();
                                }
                              }))
                ]);
              })
          : Center(),
    );
  }
}

class MyCustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path()
      ..relativeLineTo(0, 210)
      ..quadraticBezierTo(size.width / 2, 310.0, size.width, 210)
      ..relativeLineTo(0, -210)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    //throw UnimplementedError();
    return false;
  }
}
