import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threekm/Models/shopModel/address_list_model.dart';
import 'package:threekm/Models/shopModel/order_details_model.dart'
    as OrderDetailModel;

import 'package:threekm/Models/shopModel/order_model.dart';
import 'package:threekm/Models/shopModel/shipping_rate_model.dart';
import 'package:threekm/UI/shop/checkout/checkout_success.dart';
import 'package:threekm/UI/shop/checkout/order_detail.dart';
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

  OrderDetailModel.OrderDetailModel? _orderDetail;
  OrderDetailModel.OrderDetailModel? get orderDetailData => _orderDetail;

// mode is either shop or restro
  Future<void> getShippingRate(
      mounted, context, latitude, longitude, pincode, weight, mode) async {
    Box _creatorIDBox = await Hive.openBox('creatorID');
    Box _restrocreatorID = await Hive.openBox('restrocreatorID');
    _state = 'loading';
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

      try {
        final response = await _apiProvider.post(
            mode == 'shop' ? shopShippingRate : shippingRate,
            json.encode(requestJson));
        _rate = ShippingRateModel();
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

  Future<void> createOrder(Addresses? dropLocation, productList, shippingAmount,
      shippingDistance, mode) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var fname = await _pref.getString('userfname');
    var lname = await _pref.getString('userlname');
    var phone = await _pref.getString('userphone');
    log('create order process started ');
    var creatorid = Hive.box('restrocreatorID');
    _state = 'loading';
    try {
      var requestJson = {
        "products": productList,
        "customer_firstname": fname ?? dropLocation?.firstname,
        "customer_lastname": lname ?? dropLocation?.lastname,
        "customer_phone": phone ?? dropLocation?.phoneNo,
        "distance": shippingDistance,
        "drop_location": dropLocation,
        "shipping_amount": shippingAmount,
        // "shipping_amount": creatorid.get('id') == 6232 ? 0 : shippingAmount,
        "is_barter": false
      };
      final response = await _apiProvider.post(
          mode == 'shop' ? shopCheckout : restaurantMenuCheckout,
          json.encode(requestJson));
      if (response != null) {
        _OrderRes = OrderModel.fromJson(response);
        if (_OrderRes.StatusCode != null) {
          log('create order process done ${_OrderRes.result?.projectId} ');
          var orderBox = await Hive.openBox('orderinfo');
          orderBox.put('orderId', _OrderRes.result?.projectId);
          orderBox.put('mode', mode);
          openCheckout(
              amount: shippingAmount,
              orderID: _OrderRes.result?.orderId,
              rzorderID: _OrderRes.result?.rzorderId,
              phoneNo: phone ?? dropLocation?.phoneNo);
          _state = 'loaded';
          notifyListeners();
        } else {
          navigatorKey.currentState?.pop();
          navigatorKey.currentState?.pop();
          showMessage(_OrderRes.error.toString());
        }
        //return response;
      }
    } catch (e) {
      log('$e+++++++++++++++++++++++++');
      _state = 'error';
      notifyListeners();
    }
  }

  /// razorpay_flutter handler

  void openCheckout({amount, orderID, rzorderID, phoneNo}) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var phone = await _pref.getString('userphone');
    var email = await _pref.getString('email');

    var creatorid = Hive.box('restrocreatorID');
    var options = {
      'key': 'rzp_live_xcgamtZiTgvjWA',
      //'amount': 444,
      // 'amount': creatorid.get('id') == 6232 ? 1 * 100 : amount * 100,
      'currency': 'INR',
      'order_id': rzorderID,
      'productorder_id': orderID,
      'name': 'Bulb And Key.',
      'description': 'Order Pay description',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': phone ?? phoneNo ?? "", 'email': email ?? ""},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      log('razorpay handeler');
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
      log(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    log('${response.paymentId}  ${response.orderId}sssssssssssssssssssssssssssssssssssssssssssss');
    log(response.toString());
    log('success payment ');
    var orderbox = await Hive.box('orderinfo');
    var orderId = await orderbox.get('orderId');
    var mode = await orderbox.get('mode');
    navigatorKey.currentState?.pop();
    navigatorKey.currentState?.pop();
    navigatorKey.currentState?.pop();
    deleteRestroCartData(mode);
    navigatorKey.currentState?.push(
      PageRouteBuilder(
          pageBuilder: (context, _, __) => OrderDetails(
                orderId: orderId,
                showOrderDetail: false,
              ),
          opaque: false),
    );

    // Fluttertoast.showToast(
    //     msg: "SUCCESS: " + response.paymentId!, toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    log('${response.code}, ${response.message}  eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
    var orderbox = Hive.box('orderinfo');
    orderbox.clear();
    navigatorKey.currentState?.pop();
    navigatorKey.currentState?.pop();
    var message = jsonDecode('${response.message}');
   if(message['description'] != null) showMessage('${message['description']}');
    // Fluttertoast.showToast(
    //     msg: "ERROR: " + response.code.toString() + " - " + response.message!,
    //     toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Fluttertoast.showToast(
    //     msg: "EXTERNAL_WALLET: " + response.walletName!, toastLength: Toast.LENGTH_SHORT);
  }

// after order
  getOrderDetail(projectId) async {
    _state = 'loading';
    showLoading();
    try {
      final response = await _apiProvider.get('${orderDetails}?id=$projectId');
      if (response != null) {
        // log(response.toString());
        _orderDetail = OrderDetailModel.OrderDetailModel.fromJson(response);
        _state = 'loaded';
        hideLoading();
        notifyListeners();
      }
    } catch (e) {
      _state = 'error';
      notifyListeners();
    }
  }

  deleteRestroCartData(mode) async {
    if (mode == 'shop') {
      Box _creatorIDBox = await Hive.openBox('creatorID');
      Box _cartBox = await Hive.openBox('cartBox');
      _creatorIDBox.clear();
      _cartBox.clear();
    } else {
      Box _restrocreatorIDBox = await Hive.openBox('restrocreatorID');
      Box _restroCartBox = await Hive.openBox('restroCartBox');
      _restrocreatorIDBox.clear();
      _restroCartBox.clear();
    }
  }
}
