import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/src/provider.dart';
import 'package:threekm/Models/shopModel/address_list_model.dart';
import 'package:threekm/Models/shopModel/cart_hive_model.dart';
import 'package:threekm/Models/shopModel/shipping_rate_model.dart';
import 'package:threekm/UI/shop/address/new_address.dart';
import 'package:threekm/UI/shop/checkout/payment_confirming_screen.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/localization/localize.dart';
import 'package:threekm/providers/shop/address_list_provider.dart';
import 'package:threekm/providers/shop/cart_provider.dart';
import 'package:threekm/providers/shop/checkout/checkout_provider.dart';
import 'package:threekm/utils/screen_util.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({Key? key}) : super(key: key);

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  late Addresses? deliveryAddressdata;
  int selsectedId = 0;
  int currentPage = 0;
  bool isReadyForPay = true;
  ShippingRateModel rate = ShippingRateModel();

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    context.read<AddressListProvider>().getAddressList(mounted);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  deliveryAddress() async {
    var addressdata = context.read<AddressListProvider>().getAddressListData;
    var selectedAddress = await Hive.openBox('selectedAddress');
    var id = selectedAddress.get('address');
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
            AppLocalizations.of(context)!.translate('checkout') ?? 'CHECKOUT',
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
                            width: ThreeKmScreenUtil.screenWidthDp / 1.15,
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
                                  onTap:
                                      context.read<CheckoutProvider>().state !=
                                                  'error' &&
                                              isReadyForPay
                                          ? () {
                                              _pageController.jumpToPage(2);
                                            }
                                          : null,
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
                          SizedBox(
                            height: ThreeKmScreenUtil.screenHeightDp - 241,
                            child: PageView(
                              physics: const NeverScrollableScrollPhysics(),
                              controller: _pageController,
                              onPageChanged: (i) async {
                                if (deliveryAddressdata?.addressId == 0) {
                                  setState(() {
                                    currentPage = 0;
                                  });
                                  _pageController.jumpToPage(0);
                                }
                                setState(() {
                                  currentPage = i;
                                });
                                if (currentPage == 1) {
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
                                                  Hive.box('cartBox')),
                                          'shop');
                                }
                                if (currentPage == 2 &&
                                    context
                                            .read<CheckoutProvider>()
                                            .getShippingRateData
                                            .deliveryRate! !=
                                        0) {
                                  _pageController.jumpToPage(1);
                                  var box = Hive.box('cartBox').values.toList();

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
                                                    //             'cartBox')) +
                                                    context
                                                        .read<
                                                            CheckoutProvider>()
                                                        .getShippingRateData
                                                        .deliveryRate!,
                                                mode: 'shop',
                                              )));
                                }
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
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          NewAddress()));
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
                                                      '${deliveryAddressdata?.flatNo}, ${deliveryAddressdata?.area}, ${deliveryAddressdata?.city}',
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
                                                          // '${address.addressType}',
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
                                                              '${address.flatNo}, ${address.area}, ${address.city}',
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
                                      const SizedBox(
                                        height: 40,
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  child: ValueListenableBuilder(
                                      valueListenable:
                                          Hive.box('cartBox').listenable(),
                                      builder: (context, Box box, widget) {
                                        //CartHiveModel cartItem = box.getAt(i);
                                        if (box.length == 0) {
                                          WidgetsBinding.instance!
                                              .addPostFrameCallback((_) {
                                            setState(() {
                                              isReadyForPay = false;
                                            });
                                          });
                                        }
                                        return box.length != 0
                                            ? Container(
                                                // color: Colors.red,
                                                padding: const EdgeInsets.only(
                                                    top: 10,
                                                    left: 20,
                                                    right: 20),
                                                height: ThreeKmScreenUtil
                                                        .screenHeightDp /
                                                    1.5,
                                                child: SingleChildScrollView(
                                                  clipBehavior: Clip.none,
                                                  child: Column(children: [
                                                    ListView.builder(
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount: box.length,
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 0),
                                                        itemBuilder: (_, i) {
                                                          CartHiveModel
                                                              cartItem =
                                                              box.getAt(i);
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 15,
                                                                    bottom: 15),
                                                            child: ListTile(
                                                              dense: true,
                                                              horizontalTitleGap:
                                                                  2,
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              // minVerticalPadding: 80,
                                                              title: Text(
                                                                '${cartItem.name}',
                                                                style: ThreeKmTextConstants
                                                                    .tk14PXPoppinsBlackSemiBold,
                                                              ),
                                                              subtitle: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  if (cartItem
                                                                          .variation_name !=
                                                                      null)
                                                                    Text(
                                                                        '${cartItem.variation_name}'),
                                                                  Text(
                                                                    '₹${cartItem.price}',
                                                                    style: ThreeKmTextConstants
                                                                        .tk14PXPoppinsBlueMedium,
                                                                  ),
                                                                ],
                                                              ),
                                                              leading: Stack(
                                                                clipBehavior:
                                                                    Clip.none,
                                                                children: [
                                                                  ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                    child:
                                                                        Image(
                                                                      image: NetworkImage(
                                                                          '${cartItem.image}'),
                                                                      width: 60,
                                                                      height:
                                                                          45,
                                                                      errorBuilder: (context,
                                                                              error,
                                                                              stackTrace) =>
                                                                          Container(
                                                                        width:
                                                                            60,
                                                                        height:
                                                                            45,
                                                                        color: Colors
                                                                            .grey[350],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    top: -10,
                                                                    left: -5,
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        cartItem
                                                                            .delete();
                                                                      },
                                                                      child:
                                                                          const Image(
                                                                        image: AssetImage(
                                                                            'assets/shopImg/closeRed.png'),
                                                                        width:
                                                                            24,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              trailing:
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
                                                                        context.read<CheckoutProvider>().getShippingRate(
                                                                            mounted,
                                                                            context,
                                                                            deliveryAddressdata?.latitude,
                                                                            deliveryAddressdata?.longitude,
                                                                            deliveryAddressdata?.pincode,
                                                                            context.read<CartProvider>().getBoxWeightTotal(Hive.box('cartBox')),
                                                                            'shop');
                                                                        if (cartItem.quantity <
                                                                            2) {
                                                                          return;
                                                                        }
                                                                        cartItem
                                                                            .quantity = cartItem
                                                                                .quantity -
                                                                            1;
                                                                        if (cartItem
                                                                            .isInBox) {
                                                                          cartItem
                                                                              .save();
                                                                        }
                                                                      },
                                                                      child:
                                                                          const Image(
                                                                        image: AssetImage(
                                                                            'assets/shopImg/del.png'),
                                                                        width:
                                                                            24,
                                                                        height:
                                                                            24,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      '${cartItem.quantity}',
                                                                      style: ThreeKmTextConstants
                                                                          .tk14PXPoppinsBlackSemiBold,
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        context.read<CheckoutProvider>().getShippingRate(
                                                                            mounted,
                                                                            context,
                                                                            deliveryAddressdata?.latitude,
                                                                            deliveryAddressdata?.longitude,
                                                                            deliveryAddressdata?.pincode,
                                                                            context.read<CartProvider>().getBoxWeightTotal(Hive.box('cartBox')),
                                                                            'shop');
                                                                        cartItem
                                                                            .quantity = cartItem
                                                                                .quantity +
                                                                            1;
                                                                        cartItem
                                                                            .save();
                                                                      },
                                                                      child:
                                                                          const Image(
                                                                        image: AssetImage(
                                                                            'assets/shopImg/add.png'),
                                                                        width:
                                                                            24,
                                                                        height:
                                                                            24,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }),
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
                                                          '₹${context.read<CartProvider>().getBoxTotal(box)}',
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
                                                          '₹${context.read<CheckoutProvider>().getShippingRateData.deliveryRate}',
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
                                                    // Row(
                                                    //   mainAxisAlignment:
                                                    //       MainAxisAlignment
                                                    //           .spaceBetween,
                                                    //   children: [
                                                    //     Text(
                                                    //       'Platform charges',
                                                    //       style: ThreeKmTextConstants
                                                    //           .tk12PXPoppinsBlackSemiBold
                                                    //           .copyWith(
                                                    //               color: const Color(
                                                    //                   0xFF979EA4)),
                                                    //     ),
                                                    //     Text(
                                                    //       '₹10',
                                                    //       style: ThreeKmTextConstants
                                                    //           .tk14PXLatoGreyRegular
                                                    //           .copyWith(
                                                    //               fontWeight:
                                                    //                   FontWeight
                                                    //                       .bold),
                                                    //     ),
                                                    //   ],
                                                    // ),
                                                    // const Divider(
                                                    //   color: Color(0xFFF4F3F8),
                                                    //   thickness: 1,
                                                    //   height: 35,
                                                    // ),
                                                    Row(
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
                                                        context
                                                                    .read<
                                                                        CheckoutProvider>()
                                                                    .state !=
                                                                'error'
                                                            ? Text(
                                                                '₹${context.read<CartProvider>().getBoxTotal(box) + context.read<CheckoutProvider>().getShippingRateData.deliveryRate?.toInt()}',
                                                                style: ThreeKmTextConstants
                                                                    .tk18PXLatoBlackMedium
                                                                    .copyWith(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                              )
                                                            : Text(''),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 35,
                                                    )
                                                  ]),
                                                ),
                                              )
                                            : Center(
                                                child: Text(
                                                     AppLocalizations.of(context)!.translate('blank_cart_text') ?? 'There is no items in your cart.'),
                                              );
                                      }),
                                ),
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
        floatingActionButton: isReadyForPay
            ? Container(
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
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        color: Color(0x80FFFFFF), shape: BoxShape.circle),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                          color: Color(0xFFFFFFFF), shape: BoxShape.circle),
                    ),
                  ),
                  label: Text(
                    currentPage == 0 ?  AppLocalizations.of(context)!.translate('Continue') ?? 'Continue' :  AppLocalizations.of(context)!.translate('Pay_Now') ?? "Pay Now",
                    style: ThreeKmTextConstants.tk14PXPoppinsBlackBold
                        .copyWith(color: Colors.white, letterSpacing: 0.56),
                  ),
                  onPressed: context.read<CheckoutProvider>().state != 'error'
                      ? () {
                          if (currentPage == 0 &&
                              deliveryAddressdata?.addressId != 0) {
                            _pageController.jumpToPage(1);
                          } else if (currentPage == 1) {
                            _pageController.jumpToPage(2);
                          } else if (currentPage == 2 &&
                              context
                                      .read<CheckoutProvider>()
                                      .getShippingRateData
                                      .deliveryRate! !=
                                  0) {
                            _pageController.jumpToPage(3);
                            var box = Hive.box<List<CartHiveModel>>('cartBox')
                                .values
                                .toList();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => PaymentConfirmingScreen(
                                          dropLocation: deliveryAddressdata,
                                          productList: box,
                                          shippingAmount:
                                              //  context
                                              //         .read<CartProvider>()
                                              //         .getBoxTotal(Hive.box('cartBox')) +
                                              context
                                                  .read<CheckoutProvider>()
                                                  .getShippingRateData
                                                  .deliveryRate!,
                                          mode: 'shop',
                                        )));
                          }
                          if (deliveryAddressdata?.addressId == 0) {
                            CustomSnackBar(
                                context, Text( AppLocalizations.of(context)!.translate('Please_select_address') ?? "Please select address"));
                          }
                        }
                      : () {
                          var snackBar = SnackBar(
                            content: Text(
                                '${context.read<CheckoutProvider>().message}'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                ),
              )
            : Container());
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
