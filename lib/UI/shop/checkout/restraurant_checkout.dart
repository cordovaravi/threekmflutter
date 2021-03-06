import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/src/provider.dart';
import 'package:threekm/Custom_library/location2.0/lib/place_picker.dart';
import 'package:threekm/Models/shopModel/address_list_model.dart';
import 'package:threekm/Models/shopModel/cart_hive_model.dart';
import 'package:threekm/Models/shopModel/shipping_rate_model.dart';
import 'package:threekm/UI/shop/address/new_address.dart';
import 'package:threekm/UI/shop/address/openMap.dart';

import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/localization/localize.dart';
import 'package:threekm/providers/Location/locattion_Provider.dart';
import 'package:threekm/providers/shop/address_list_provider.dart';
import 'package:threekm/providers/shop/cart_provider.dart';
import 'package:threekm/providers/shop/checkout/checkout_provider.dart';
import 'package:threekm/utils/api_paths.dart';
// import 'package:threekm/utils/screen_util.dart';
import 'package:threekm/utils/threekm_textstyles.dart';
import '../../shop/checkout/payment_confirming_screen.dart';
import 'package:threekm/utils/constants.dart';

class RestaurantsCheckOutScreen extends StatefulWidget {
  const RestaurantsCheckOutScreen({Key? key}) : super(key: key);

  @override
  State<RestaurantsCheckOutScreen> createState() =>
      _RestaurantsCheckOutScreenState();
}

class _RestaurantsCheckOutScreenState extends State<RestaurantsCheckOutScreen> {
  Addresses? deliveryAddressdata;
  int selsectedId = 0;
  int currentPage = 0;
  Box? restrobox;
  ShippingRateModel rate = ShippingRateModel();
  double padValue = 3;

  final PageController _pageController = PageController();
  Timer? timer;
  @override
  void initState() {
    openBox();
    super.initState();
    context.read<AddressListProvider>().getAddressList(mounted);
    timer = Timer.periodic(new Duration(seconds: 5), (timer) {
      //debugPrint(timer.tick.toString());
      if (mounted) {
        setState(() {
          padValue = padValue == 3 ? 8 : 3;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    timer?.cancel();
    super.dispose();
  }

  openBox() async {
    restrobox = await Hive.openBox('restroCartBox');
  }

  deliveryAddress() async {
    var addressdata = context.read<AddressListProvider>().getAddressListData;
    var selectedAddress = await Hive.openBox('selectedAddress');
    var id = selectedAddress.get('address');
    if (context.read<CheckoutProvider>().state == 'error' &&
        context.read<CheckoutProvider>().getShippingRateData.deliveryRate ==
            null) {
      _pageController.jumpToPage(0);
    }
    var deliver = addressdata.addresses?.firstWhere(
        (element) => element.addressId == id,
        orElse: () => Addresses(
            addressId: 0,
            flatNo: '',
            firstname: '',
            lastname: '',
            street: '',
            area: '',
            city: '',
            state: '',
            landmark: '',
            country: '',
            phoneNo: 0,
            pincode: 0,
            latitude: 0.0,
            longitude: 0.0,
            addressType: ''));
    setState(() {
      deliveryAddressdata = deliver;
      selsectedId = id ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    deliveryAddress();
    var data = context.read<AddressListProvider>().getAddressListData;
    var state = context.watch<AddressListProvider>().state;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          title: Text(
            AppLocalizations.of(context)!.translate('RESTAURANTS_CHECKOUT') ??
                'RESTAURANTS CHECKOUT',
            style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold
                .copyWith(letterSpacing: 2),
          ),
        ),
        body: state == 'loaded'
            ? Container(
                color: Colors.white,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: size(context).width / 1.15,
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    _pageController.jumpToPage(0);
                                  },
                                  child: Column(
                                    children: [
                                      Image(
                                        image: AssetImage(currentPage >= 0
                                            ? 'assets/shopImg/location_blue.png'
                                            : 'assets/shopImg/location_grey.png'),
                                        width: 40,
                                        height: 40,
                                      ),
                                      Text('Address'),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: CustomPaint(
                                    painter: PointPainter(
                                        color: currentPage >= 1
                                            ? Colors.blue
                                            : Colors.grey),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (deliveryAddressdata?.addressId != 0) {
                                      _pageController.jumpToPage(1);
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      Image(
                                        image: AssetImage(currentPage >= 1
                                            ? 'assets/shopImg/box_blue.png'
                                            : 'assets/shopImg/box_grey.png'),
                                        width: 40,
                                        height: 40,
                                      ),
                                      Text('Items'),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: CustomPaint(
                                    painter: PointPainter(
                                        color: currentPage == 2
                                            ? Colors.blue
                                            : Colors.grey),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    //  restrobox?.length == 0
                                    //      ? null
                                    //      : _pageController.jumpToPage(2);
                                  },
                                  child: Column(
                                    children: const [
                                      Image(
                                        image: AssetImage(
                                            'assets/shopImg/rupees.png'),
                                        width: 40,
                                        height: 40,
                                      ),
                                      Text('Payment'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            height: 50,
                            color: Color(0xFFD5D5D5),
                            thickness: 1,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            height: size(context).height - 241,
                            child: PageView(
                              physics: const NeverScrollableScrollPhysics(),
                              controller: _pageController,
                              onPageChanged: (i) {
                                log('==${i}');
                                if (i == 1) {
                                  context
                                      .read<CheckoutProvider>()
                                      .getShippingRate(
                                          mounted,
                                          context,
                                          deliveryAddressdata?.latitude,
                                          deliveryAddressdata?.longitude,
                                          deliveryAddressdata?.pincode,
                                          context
                                              .read<CartProvider>()
                                              .getBoxWeightTotal(
                                                  Hive.box('restroCartBox')),
                                          'restro')
                                      .then((value) {
                                    setState(() {});
                                    // if (context
                                    //         .read<CheckoutProvider>()
                                    //         .getShippingRateData
                                    //         .deliveryRate !=
                                    //     null) {
                                    //   _pageController.jumpToPage(0);
                                    // }
                                  });
                                }
                                if (i == 2 &&
                                    context
                                            .read<CheckoutProvider>()
                                            .getShippingRateData
                                            .deliveryRate! !=
                                        0) {
                                  //_pageController.jumpToPage(2);
                                  var box =
                                      Hive.box('restroCartBox').values.toList();

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              PaymentConfirmingScreen(
                                                dropLocation:
                                                    deliveryAddressdata,
                                                productList: box,
                                                shippingAmount:
                                                    // context
                                                    //         .read<CartProvider>()
                                                    //         .getBoxTotal(Hive.box(
                                                    //             'restroCartBox')) +
                                                    context
                                                        .read<
                                                            CheckoutProvider>()
                                                        .getShippingRateData
                                                        .deliveryRate!,
                                                shippingDistance: context
                                                    .read<CheckoutProvider>()
                                                    .getShippingRateData
                                                    .distance!,
                                                mode: 'restro',
                                              )));
                                }
                                setState(() {
                                  currentPage = i;
                                });
                              },
                              children: [
                                SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 17, bottom: 10),
                                        child: TextButton.icon(
                                            onPressed: () {
                                              context
                                                  .read<LocationProvider>()
                                                  .getLocation()
                                                  .whenComplete(() async {
                                                final _locationProvider =
                                                    context
                                                        .read<
                                                            LocationProvider>()
                                                        .getlocationData;
                                                final kInitialPosition = LatLng(
                                                    _locationProvider
                                                            ?.latitude ??
                                                        5.6037,
                                                    _locationProvider
                                                            ?.longitude ??
                                                        0.1870);
                                                // OpenMap(context);
                                                LocationResult? result = await Navigator
                                                        .of(context)
                                                    .push(MaterialPageRoute(
                                                        builder: (context) =>
                                                            PlacePicker(
                                                                GMap_Api_Key,
                                                                displayLocation:
                                                                    kInitialPosition)));
                                                log("Addres name :${result?.name}");
                                                log("Addres admin level1 :${result?.administrativeAreaLevel1?.name}");
                                                log("Addres admin leve2 :${result?.administrativeAreaLevel2?.name}");
                                                log("Addres locality :${result?.locality}");
                                                log("Addres sublocality :${result?.subLocalityLevel1?.name}");
                                                log("Addres sublocality level2 :${result?.subLocalityLevel2?.name}");
                                                log("Addres from new Plugin is :${result?.formattedAddress}");
                                                print(result);
                                                if (result != null) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              NewAddress(
                                                                locationResult:
                                                                    result,
                                                              )));
                                                }
                                              });
                                            },
                                            icon: const Icon(Icons.add,
                                                color: Color(0xFF3E7EFF)),
                                            label: Text(
                                                AppLocalizations.of(context)!
                                                        .translate(
                                                            'Add_New_Address') ??
                                                    'Add New Address',
                                                style: ThreeKmTextConstants
                                                    .tk14PXPoppinsBlackSemiBold
                                                    .copyWith(
                                                  color: Color(0xFF3E7EFF),
                                                ))),
                                      ),
                                      if (deliveryAddressdata?.addressId != 0)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, left: 20),
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                        .translate(
                                                            'Delivering_to') ??
                                                    'Delivering to:',
                                                style: ThreeKmTextConstants
                                                    .tk14PXPoppinsBlackMedium,
                                              ),
                                            ),
                                            ListTile(
                                              dense: true,
                                              leading: Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    shape: BoxShape.circle),
                                                child: deliveryAddressdata
                                                            ?.addressType ==
                                                        'home'
                                                    ? Icon(Icons.home_rounded)
                                                    : Icon(Icons.work_rounded),
                                              ),
                                              title: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: Text(
                                                  '${deliveryAddressdata?.firstname} ${deliveryAddressdata?.lastname}',
                                                  style: ThreeKmTextConstants
                                                      .tk14PXPoppinsBlackSemiBold
                                                      .copyWith(fontSize: 18),
                                                ),
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      '${deliveryAddressdata?.flatNo}, ${deliveryAddressdata?.area}, ${deliveryAddressdata?.city?.split("Instance").first}',
                                                      style: ThreeKmTextConstants
                                                          .tk14PXPoppinsBlackSemiBold
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal)),
                                                ],
                                              ),
                                              trailing: InkWell(
                                                onTap: () async {
                                                  var selectedAddress =
                                                      await Hive.openBox(
                                                          'selectedAddress');
                                                  selectedAddress
                                                      .delete('address');
                                                  setState(() {});
                                                },
                                                child: Container(
                                                  margin:
                                                      EdgeInsets.only(top: 5),
                                                  width: 28,
                                                  height: 28,
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFF43B978),
                                                      border: Border.all(
                                                          color: Color(
                                                              0xFFD5D5D5)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  child: const Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 30, left: 20, bottom: 10),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                                  .translate(
                                                      'Saved_Addresses') ??
                                              'Saved Addresses:',
                                          style: ThreeKmTextConstants
                                              .tk14PXPoppinsBlackMedium,
                                        ),
                                      ),
                                      Flexible(
                                        child: ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: data.addresses?.length,
                                            itemBuilder: (_, i) {
                                              var address = data.addresses?[i]
                                                          .addressId ==
                                                      selsectedId
                                                  ? null
                                                  : data.addresses?[i];
                                              return address != null
                                                  ? ListTile(
                                                      dense: true,
                                                      leading: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .grey[200],
                                                                shape: BoxShape
                                                                    .circle),
                                                        child: address
                                                                    .addressType ==
                                                                'home'
                                                            ? const Icon(Icons
                                                                .home_rounded)
                                                            : const Icon(Icons
                                                                .work_rounded),
                                                      ),
                                                      title: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 10),
                                                        child: Text(
                                                          '${address.firstname} ${address.lastname}',
                                                          style: ThreeKmTextConstants
                                                              .tk14PXPoppinsBlackSemiBold
                                                              .copyWith(
                                                                  fontSize: 18),
                                                        ),
                                                      ),
                                                      subtitle: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              '${address.flatNo}, ${address.area}, ${address.city?.split("Instance").first}',
                                                              style: ThreeKmTextConstants
                                                                  .tk14PXPoppinsBlackSemiBold
                                                                  .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal)),
                                                        ],
                                                      ),
                                                      trailing: InkWell(
                                                        onTap: () async {
                                                          var selectedAddress =
                                                              await Hive.openBox(
                                                                  'selectedAddress');
                                                          selectedAddress.get(
                                                                      'address') ==
                                                                  address
                                                                      .addressId
                                                              ? selectedAddress
                                                                  .put(
                                                                      'address',
                                                                      null)
                                                              : selectedAddress.put(
                                                                  'address',
                                                                  address
                                                                      .addressId);
                                                          setState(() {});
                                                        },
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(top: 5),
                                                          width: 28,
                                                          height: 28,
                                                          decoration:
                                                              BoxDecoration(
                                                                  // color: Color(0xFF43B978),
                                                                  border: Border.all(
                                                                      color: const Color(
                                                                          0xFFD5D5D5)),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8)),
                                                          // child: const Icon(
                                                          //   Icons.check,
                                                          //   color: Colors.white,
                                                          // ),
                                                        ),
                                                      ),
                                                    )
                                                  : Container();
                                            }),
                                      ),
                                      SizedBox(
                                        height: 60,
                                      )
                                    ],
                                  ),
                                ),
                                ValueListenableBuilder(
                                    valueListenable:
                                        Hive.box('restroCartBox').listenable(),
                                    builder: (context, Box box, widget) {
                                      //CartHiveModel cartItem = box.getAt(i);
                                      var taxes = context
                                                  .read<CheckoutProvider>()
                                                  .getShippingRateData
                                                  .taxPercent !=
                                              null
                                          ? double.parse(((context
                                                          .read<
                                                              CheckoutProvider>()
                                                          .getShippingRateData
                                                          .taxPercent /
                                                      100) *
                                                  context
                                                      .read<CartProvider>()
                                                      .getBoxTotal(box))
                                              .toStringAsFixed(2))
                                          : 0.0;
                                      var totalRate = context
                                                  .read<CheckoutProvider>()
                                                  .getShippingRateData
                                                  .deliveryRate !=
                                              null
                                          ? context
                                                  .read<CartProvider>()
                                                  .getBoxTotal(box) +
                                              context
                                                  .read<CheckoutProvider>()
                                                  .getShippingRateData
                                                  .deliveryRate
                                                  ?.toInt() +
                                              taxes +
                                              10
                                          : 0;
                                      return box.length == 0
                                          ? Container(
                                              child: Center(
                                                child: Text(
                                                    'Please add Some Item in Cart'),
                                              ),
                                            )
                                          : Container(
                                              //color: Colors.red,

                                              height:
                                                  size(context).height / 1.5,
                                              child: SingleChildScrollView(
                                                child: Column(children: [
                                                  ListView.builder(
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount: box.length,
                                                      padding: const EdgeInsets
                                                          .only(),
                                                      itemBuilder: (_, i) {
                                                        CartHiveModel cartItem =
                                                            box.getAt(i);
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 15,
                                                                  left: 10,
                                                                  bottom: 15),
                                                          child: ListTile(
                                                            dense: true,
                                                            horizontalTitleGap:
                                                                2,
                                                            contentPadding:
                                                                EdgeInsets.zero,
                                                            // minVerticalPadding: 80,
                                                            title: Text(
                                                              '${cartItem.name}',
                                                              style: ThreeKmTextConstants
                                                                  .tk14PXPoppinsBlackSemiBold,
                                                            ),
                                                            // subtitle: Text(
                                                            //   '???${cartItem.price}',
                                                            //   style: ThreeKmTextConstants
                                                            //       .tk14PXPoppinsBlueMedium,
                                                            // ),
                                                            // leading: Stack(
                                                            //   clipBehavior: Clip.none,
                                                            //   children: [
                                                            //     ClipRRect(
                                                            //       borderRadius:
                                                            //           BorderRadius
                                                            //               .circular(
                                                            //                   20),
                                                            //       child: Image(
                                                            //         image: NetworkImage(
                                                            //             '${cartItem.image}'),
                                                            //         width: 60,
                                                            //         height: 45,
                                                            //         errorBuilder:
                                                            //             (context,
                                                            //                     error,
                                                            //                     stackTrace) =>
                                                            //                 Container(
                                                            //           width: 60,
                                                            //           height: 45,
                                                            //           color: Colors
                                                            //               .grey[350],
                                                            //         ),
                                                            //       ),
                                                            //     ),
                                                            //     Positioned(
                                                            //       top: -10,
                                                            //       left: -5,
                                                            //       child: InkWell(
                                                            //         onTap: () {
                                                            //           cartItem
                                                            //               .delete();
                                                            //         },
                                                            //         child:
                                                            //             const Image(
                                                            //           image: AssetImage(
                                                            //               'assets/shopImg/closeRed.png'),
                                                            //           width: 24,
                                                            //         ),
                                                            //       ),
                                                            //     )
                                                            //   ],
                                                            // ),
                                                            trailing: Container(
                                                              width: 130,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(2),
                                                                    width: 77,
                                                                    height: 31,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                30),
                                                                        color: const Color(
                                                                            0xFFF4F3F8)),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      //mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            if (cartItem.quantity <
                                                                                2) {
                                                                              cartItem.delete();
                                                                            }
                                                                            cartItem.quantity =
                                                                                cartItem.quantity - 1;
                                                                            if (cartItem.isInBox) {
                                                                              cartItem.save();
                                                                            }
                                                                            context.read<CheckoutProvider>().getShippingRate(
                                                                                mounted,
                                                                                context,
                                                                                deliveryAddressdata?.latitude,
                                                                                deliveryAddressdata?.longitude,
                                                                                deliveryAddressdata?.pincode,
                                                                                context.read<CartProvider>().getBoxWeightTotal(Hive.box('restroCartBox')),
                                                                                'restro');
                                                                          },
                                                                          child:
                                                                              const Image(
                                                                            image:
                                                                                AssetImage('assets/shopImg/del.png'),
                                                                            width:
                                                                                24,
                                                                            height:
                                                                                24,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          '${cartItem.quantity}',
                                                                          style:
                                                                              ThreeKmTextConstants.tk14PXPoppinsBlackSemiBold,
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            cartItem.quantity =
                                                                                cartItem.quantity + 1;
                                                                            cartItem.save();
                                                                            context.read<CheckoutProvider>().getShippingRate(
                                                                                mounted,
                                                                                context,
                                                                                deliveryAddressdata?.latitude,
                                                                                deliveryAddressdata?.longitude,
                                                                                deliveryAddressdata?.pincode,
                                                                                context.read<CartProvider>().getBoxWeightTotal(Hive.box('restroCartBox')),
                                                                                'restro');
                                                                          },
                                                                          child:
                                                                              const Image(
                                                                            image:
                                                                                AssetImage('assets/shopImg/add.png'),
                                                                            width:
                                                                                24,
                                                                            height:
                                                                                24,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    '???${cartItem.price! * cartItem.quantity}',
                                                                    style: ThreeKmTextConstants
                                                                        .tk14PXPoppinsBlueMedium,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                  const Divider(
                                                    color: Color(0xFFF4F3F8),
                                                    thickness: 1,
                                                    height: 35,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        AppLocalizations.of(
                                                                    context)!
                                                                .translate(
                                                                    'Subtotal') ??
                                                            'Subtotal',
                                                        style: ThreeKmTextConstants
                                                            .tk12PXPoppinsBlackSemiBold
                                                            .copyWith(
                                                                color: const Color(
                                                                    0xFF979EA4)),
                                                      ),
                                                      Text(
                                                        '???${context.read<CartProvider>().getBoxTotal(box)}',
                                                        style: ThreeKmTextConstants
                                                            .tk14PXLatoGreyRegular
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    ],
                                                  ),
                                                  const Divider(
                                                    color: Color(0xFFF4F3F8),
                                                    thickness: 1,
                                                    height: 35,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        AppLocalizations.of(
                                                                    context)!
                                                                .translate(
                                                                    'Taxes') ??
                                                            'Taxes',
                                                        style: ThreeKmTextConstants
                                                            .tk12PXPoppinsBlackSemiBold
                                                            .copyWith(
                                                                color: const Color(
                                                                    0xFF979EA4)),
                                                      ),
                                                      Text(
                                                        '???$taxes',
                                                        style: ThreeKmTextConstants
                                                            .tk14PXLatoGreyRegular
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    ],
                                                  ),
                                                  const Divider(
                                                    color: Color(0xFFF4F3F8),
                                                    thickness: 1,
                                                    height: 35,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        AppLocalizations.of(
                                                                    context)!
                                                                .translate(
                                                                    'Delivery_Charges') ??
                                                            'Delivery Charges',
                                                        style: ThreeKmTextConstants
                                                            .tk12PXPoppinsBlackSemiBold
                                                            .copyWith(
                                                                color: const Color(
                                                                    0xFF979EA4)),
                                                      ),
                                                      Text(
                                                        '???${context.read<CheckoutProvider>().getShippingRateData.deliveryRate}',
                                                        style: ThreeKmTextConstants
                                                            .tk14PXLatoGreyRegular
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    ],
                                                  ),
                                                  const Divider(
                                                    color: Color(0xFFF4F3F8),
                                                    thickness: 1,
                                                    height: 35,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        AppLocalizations.of(
                                                                    context)!
                                                                .translate(
                                                                    'Platform_Charges') ??
                                                            'Platform Charges',
                                                        style: ThreeKmTextConstants
                                                            .tk12PXPoppinsBlackSemiBold
                                                            .copyWith(
                                                                color: const Color(
                                                                    0xFF979EA4)),
                                                      ),
                                                      Text(
                                                        '???10',
                                                        style: ThreeKmTextConstants
                                                            .tk14PXLatoGreyRegular
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    ],
                                                  ),
                                                  const Divider(
                                                    color: Color(0xFFF4F3F8),
                                                    thickness: 1,
                                                    height: 35,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 50),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          AppLocalizations.of(
                                                                      context)!
                                                                  .translate(
                                                                      'Cart_Total') ??
                                                              'Cart Total',
                                                          style: ThreeKmTextConstants
                                                              .tk18PXPoppinsBlackMedium
                                                              .copyWith(
                                                                  color: const Color(
                                                                      0xFF979EA4)),
                                                        ),
                                                        Text(
                                                          '???${totalRate}',
                                                          style: ThreeKmTextConstants
                                                              .tk18PXLatoBlackMedium
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                            );
                                    }),
                                Container(
                                  child: Text('Payment Here '),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ))
                ]))
            : Container(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: restrobox?.length == 0
            ? Container(height: 50)
            : Container(
                margin: EdgeInsets.only(bottom: 20),
                height: 50,
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(StadiumBorder()),
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xFF3E7EFF)),
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                      padding: MaterialStateProperty.all(const EdgeInsets.only(
                          left: 30, right: 30, top: 15, bottom: 15))),
                  icon: Container(
                    decoration: const BoxDecoration(
                        color: Color(0x80FFFFFF), shape: BoxShape.circle),
                    child: AnimatedPadding(
                      padding: EdgeInsets.all(padValue),
                      duration: Duration(seconds: 5),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                            color: Color(0xFFFFFFFF), shape: BoxShape.circle),
                      ),
                    ),
                  ),
                  label: Text(
                    currentPage == 0
                        ? AppLocalizations.of(context)!.translate('Continue') ??
                            'Continue'
                        : AppLocalizations.of(context)!.translate('Pay_Now') ??
                            "Pay Now",
                    style: ThreeKmTextConstants.tk14PXPoppinsBlackBold
                        .copyWith(color: Colors.white, letterSpacing: 0.56),
                  ),
                  onPressed: () {
                    if (currentPage == 0 &&
                        deliveryAddressdata?.addressId != 0) {
                      _pageController.jumpToPage(1);
                    } else if (currentPage == 1) {
                      _pageController.jumpToPage(2);
                    } else if (currentPage == 2 &&
                        context
                                .read<CheckoutProvider>()
                                .getShippingRateData
                                .deliveryRate !=
                            0) {
                      _pageController.jumpToPage(3);
                      var box = Hive.box<List<CartHiveModel>>('restroCartBox')
                          .values
                          .toList();
                      var totalPrice =
                          // context
                          //         .read<CartProvider>()
                          //         .getBoxTotal(Hive.box('restroCartBox')) +
                          context
                              .read<CheckoutProvider>()
                              .getShippingRateData
                              .deliveryRate!;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => PaymentConfirmingScreen(
                                    dropLocation: deliveryAddressdata,
                                    productList: box,
                                    shippingAmount: totalPrice,
                                    shippingDistance: context
                                        .read<CheckoutProvider>()
                                        .getShippingRateData
                                        .distance!,
                                    mode: 'restro',
                                  )));
                    } else {
                      _pageController.jumpToPage(1);
                    }
                    if (deliveryAddressdata?.addressId == 0) {
                      CustomToast(AppLocalizations.of(context)!
                              .translate('Please_select_address') ??
                          "Please select address");
                      // CustomSnackBar(
                      //     context,
                      //     Text(AppLocalizations.of(context)!
                      //             .translate('Please_select_address') ??
                      //         "Please select address"));
                    }
                  },
                ),
              ));
  }
}

class PointPainter extends CustomPainter {
  PointPainter({required this.color});
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final point = TextPainter(
        text: TextSpan(
            text: ".",
            style: TextStyle(color: color, height: -0.5, fontSize: 20)),
        textDirection: TextDirection.ltr);
    point.layout(maxWidth: size.width);

    for (double i = 0; i < size.width; i += point.width) {
      point.paint(canvas, Offset(i, .0));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
