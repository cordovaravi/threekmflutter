import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:threekm/Models/shopModel/address_list_model.dart';
import 'package:threekm/providers/shop/checkout/checkout_provider.dart';
import 'package:threekm/utils/screen_util.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

class PaymentConfirmingScreen extends StatefulWidget {
  PaymentConfirmingScreen(
      {Key? key,
      required this.dropLocation,
      required this.productList,
      required this.shippingAmount})
      : super(key: key);
  final Addresses? dropLocation;
  List productList = [];
  final int shippingAmount;

  @override
  State<PaymentConfirmingScreen> createState() =>
      _PaymentConfirmingScreenState();
}

class _PaymentConfirmingScreenState extends State<PaymentConfirmingScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CheckoutProvider>().createOrder(
        widget.dropLocation, widget.productList, widget.shippingAmount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(40),
        height: ThreeKmScreenUtil.screenHeightDp,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Image(image: AssetImage('assets/shopImg/gift.gif')),
              Text(
                'TICKING THINGS',
                style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                'Confirming your Payment. Please, don’t press the back button',
                textAlign: TextAlign.center,
                style: ThreeKmTextConstants.tk14PXPoppinsBlackMedium
                    .copyWith(color: const Color(0xFF979EA4)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
