import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:threekm/providers/shop/checkout/checkout_provider.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

class CheckOutSuccess extends StatefulWidget {
  const CheckOutSuccess({Key? key, this.orderId}) : super(key: key);
  final orderId;
  @override
  State<CheckOutSuccess> createState() => _CheckOutSuccessState();
}

class _CheckOutSuccessState extends State<CheckOutSuccess> {
  @override
  void initState() {
    context.read<CheckoutProvider>().getOrderDetail(widget.orderId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var data = context.watch<CheckoutProvider>().orderDetailData;
    var state = context.watch<CheckoutProvider>().state;
    var productList = data?.result.order.cart;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: height,
        color: Colors.white24,
        child: DraggableScrollableSheet(
          initialChildSize: 0.80,
          minChildSize: 0.7,
          maxChildSize: 1,
          builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  Image(
                    image: AssetImage('assets/shopImg/close.png'),
                    height: 60,
                    width: 60,
                  ),
                  Container(
                    color: Colors.white,
                    height: 900,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          child: ClipPath(
                            clipper: MyCustomShape(),
                            child: Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height / 3,
                              color: Colors.green,
                              child: Stack(
                                alignment: Alignment.topCenter,
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
                                    padding: const EdgeInsets.only(top: 20),
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
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text('Confirming With Sellers:'),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: productList?.length,
                            itemBuilder: (_, i) {
                              return ListTile(
                                dense: true,
                                horizontalTitleGap: 2,
                                contentPadding: EdgeInsets.zero,
                                // minVerticalPadding: 80,
                                title: Text(
                                  '${productList?[i].name}',
                                  style: ThreeKmTextConstants
                                      .tk14PXPoppinsBlackSemiBold,
                                ),
                                subtitle: Text(
                                  '₹${productList?[i].price}',
                                  style: ThreeKmTextConstants
                                      .tk14PXPoppinsBlueMedium,
                                ),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image(
                                    image: NetworkImage(
                                        '${productList?[i].image}'),
                                    width: 60,
                                    height: 45,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      width: 60,
                                      height: 45,
                                      color: Colors.grey[350],
                                    ),
                                    loadingBuilder:
                                        (_, widget, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return widget;
                                      }
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: Color(0xFF979EA4),
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            })
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Future CheckoutSuccess(BuildContext? context, mode, projectId) async {
//   return showModalBottomSheet(
//       isScrollControlled: true,
//       builder: (BuildContext context) {
//         return Container(
//           height: 700,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 child: ClipPath(
//                   clipper: MyCustomShape(),
//                   child: Container(
//                     width: double.infinity,
//                     height: MediaQuery.of(context).size.height / 3,
//                     color: Colors.green,
//                     child: Stack(
//                       alignment: Alignment.topCenter,
//                       children: [
//                         Center(
//                           child: Image(
//                             image: AssetImage('assets/shopImg/check_back.png'),
//                             height: 290,
//                             width: 290,
//                           ),
//                         ),
//                         Center(
//                           child: Image(
//                             image: AssetImage('assets/shopImg/check_front.png'),
//                             height: 60,
//                             width: 60,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(top: 20),
//                           child: Text(
//                             'Thank You for your order!',
//                             style: ThreeKmTextConstants.tk16PXPoppinsWhiteBold,
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Text('Confirming With Sellers:'),
//               ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: 1,
//                   itemBuilder: (_, i) {
//                     return Container(
//                       height: 60,
//                       width: double.infinity,
//                       child: Text(''),
//                     );
//                   })
//             ],
//           ),
//         );
//       },
//       context: context!);
// }

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
