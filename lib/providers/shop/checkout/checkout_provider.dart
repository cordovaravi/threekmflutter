import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:threekm/Models/shopModel/order_model.dart';
import 'package:threekm/Models/shopModel/shipping_rate_model.dart';
import 'package:threekm/commenwidgets/commenwidget.dart';
import 'package:threekm/main.dart';
import 'package:threekm/networkservice/Api_Provider.dart';

import 'package:threekm/utils/api_paths.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CheckoutProvider extends ChangeNotifier {
  late Razorpay _razorpay;
  CheckoutProvider() {
    log('CheckoutProvider');
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  final ApiProvider _apiProvider = ApiProvider();
  String? _state;
  String? get state => _state;
  String? _message;
  String? get message => _message;
  ShippingRateModel _rate = ShippingRateModel(status: 'false', deliveryRate: 0);
  ShippingRateModel get getShippingRateData => _rate;

// mode is either shop or restro
  Future<void> getShippingRate(
      mounted, context, latitude, longitude, pincode, weight, mode) async {
    Box _creatorIDBox = await Hive.openBox('creatorID');
    Box _restrocreatorID = await Hive.openBox('restrocreatorID');

    log(_creatorIDBox.get('id').toString());
    if (mounted) {
      showLoading();
      var requestJson = {
        "creator_id": mode == 'shop'
            ? _creatorIDBox.get('id')
            : _restrocreatorID.get('id'),
        "latitude": latitude,
        "longitude": longitude,
        "weight": weight,
        "pincode": pincode
      };
      _state = 'loading';
      try {
        final response = await _apiProvider.post(
            mode == 'shop' ? shopShippingRate : shippingRate,
            json.encode(requestJson));
        if (response != null && response['status'] != 'failure') {
          hideLoading();
          _rate = ShippingRateModel.fromJson(response);
          _state = 'loaded';
          notifyListeners();
          //return response;
        } else {
          hideLoading();
          var snackBar = SnackBar(
            content: Text('${response['message']}'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          _state = 'error';
          _message = response['message'];
          log('errorrrrrrrrrrrrrrrrrr');
        }
      } catch (e) {
        hideLoading();
        _state = 'error';
        notifyListeners();
      }
    }
  }

//  Create order
  OrderModel _OrderRes = OrderModel(StatusCode: 0, result: Result());
  OrderModel get getOrderResponseData => _OrderRes;

  Future<void> createOrder(dropLocation, productList, shippingAmount) async {
    log('create order process started ');
    _state = 'loading';
    try {
      var requestJson = {
        "products": productList,
        "customer_firstname": "Ravi",
        "customer_lastname": "Gulhane",
        "customer_phone": 8087618710,
        "distance": "9 Km",
        "drop_location": dropLocation,
        "shipping_amount": shippingAmount,
        "is_barter": false
      };
      final response =
          await _apiProvider.post(shopCheckout, json.encode(requestJson));
      if (response != null) {
        _OrderRes = OrderModel.fromJson(response);
        log('create order process done ${_OrderRes.result?.orderId} ');
        openCheckout(
            amount: shippingAmount,
            orderID: _OrderRes.result?.orderId,
            rzorderID: _OrderRes.result?.rzorderId);
        _state = 'loaded';
        notifyListeners();
        //return response;
      }
    } catch (e) {
      log('$e+++++++++++++++++++++++++');
      _state = 'error';
      notifyListeners();
    }
  }

  /// razorpay_flutter handler

  void openCheckout({amount, orderID, rzorderID}) async {
    var options = {
      'key': 'rzp_test_aHjwjcGgXECVhv',
      'amount': amount * 100,
      //'order_id': orderID,
      'rzorder_id': rzorderID,
      'name': 'Bulb And Key.',
      'description': 'Order Pay description',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      log('razorpay handeler');
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    log('${response.paymentId}sssssssssssssssssssssssssssssssssssssssssssss');
    // Fluttertoast.showToast(
    //     msg: "SUCCESS: " + response.paymentId!, toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    log('${response.code}, ${response.message}  eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
    navigatorKey.currentState?.pop();
    // Fluttertoast.showToast(
    //     msg: "ERROR: " + response.code.toString() + " - " + response.message!,
    //     toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Fluttertoast.showToast(
    //     msg: "EXTERNAL_WALLET: " + response.walletName!, toastLength: Toast.LENGTH_SHORT);
  }
}
