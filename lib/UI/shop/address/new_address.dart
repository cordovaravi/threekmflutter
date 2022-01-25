import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/src/core.dart';
import 'package:provider/src/provider.dart';
import 'package:threekm/Custom_library/GooleMapsWidget/src/place_picker.dart';
import 'package:threekm/providers/Location/locattion_Provider.dart';
import 'package:threekm/providers/shop/address_list_provider.dart';
import 'package:threekm/utils/api_paths.dart';
import 'package:threekm/utils/screen_util.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

class NewAddress extends StatefulWidget {
  const NewAddress({Key? key}) : super(key: key);

  @override
  State<NewAddress> createState() => _NewAddressState();
}

class _NewAddressState extends State<NewAddress> {
  bool isCommercial = false;
  String? _selecetedAddress;
  TextEditingController searchedText = TextEditingController();
  TextEditingController flatNumberText = TextEditingController();
  TextEditingController societyText = TextEditingController();
  TextEditingController landmarkText = TextEditingController();
  var postalCode;
  String? city;
  String? state;
  Location? geometry;
  String? addressType = 'home';

  validate(flatData, selectedAddress) {
    if (flatData == null) {
      return 'flat no/House no is Empty';
    } else if (selectedAddress == null) {
      return 'Please Select Address';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        title: Text(
          'Add NEW ADDRESS',
          style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold
              .copyWith(letterSpacing: 2),
        ),
      ),
      body: Container(
        height: ThreeKmScreenUtil.screenHeightDp,
        color: Colors.white,
        //padding: EdgeInsets.only(top: 30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(
                    bottom: 20, left: 10, right: 10, top: 20),
                width: ThreeKmScreenUtil.screenWidthDp,
                child: InkWell(
                  onTap: () {
                    Future.delayed(Duration.zero, () {
                      context
                          .read<LocationProvider>()
                          .getLocation()
                          .whenComplete(() {
                        final _locationProvider =
                            context.read<LocationProvider>().getlocationData;
                        final kInitialPosition = LatLng(
                            _locationProvider!.latitude!,
                            _locationProvider.longitude!);
                        if (_locationProvider != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlacePicker(
                                  apiKey: GMap_Api_Key,
                                  // initialMapType: MapType.satellite,
                                  onPlacePicked: (result) {
                                    //print(result.formattedAddress);
                                    log(result.toString());
                                    log('${result.geometry?.location.lat}');

                                    setState(() {
                                      _selecetedAddress =
                                          result.formattedAddress;
                                      searchedText.text =
                                          result.formattedAddress ?? '';
                                      geometry = result.geometry?.location;
                                      for (var i = 0;
                                          i < result.addressComponents!.length;
                                          i++) {
                                        if (result.addressComponents?[i]
                                                .types[0] ==
                                            'postal_code') {
                                          postalCode = result
                                              .addressComponents![i].longName;
                                        }

                                        if (result.addressComponents?[i].types
                                                .first ==
                                            'administrative_area_level_2') {
                                          city = result
                                              .addressComponents![i].longName;
                                        }

                                        if (result.addressComponents?[i].types
                                                .first ==
                                            'administrative_area_level_1') {
                                          state = result
                                              .addressComponents![i].longName;
                                        }
                                      }

                                      print(result.geometry!.toJson());
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  initialPosition: kInitialPosition,
                                  useCurrentLocation: true,
                                  selectInitialPosition: true,
                                  usePinPointingSearch: true,
                                  usePlaceDetailSearch: true,
                                ),
                              ));
                        }
                      });
                    });
                  },
                  child: TextFormField(
                    enabled: false,
                    controller: searchedText,
                    keyboardType: TextInputType.text,
                    validator: (val) {},
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: 'Select/Search an address',
                      hintStyle: ThreeKmTextConstants.tk14PXLatoGreyRegular,
                      counterText: '',
                      filled: true,
                      prefixIcon:
                          const Icon(Icons.search, color: Color(0xFF0F0F2D)),
                      fillColor: Colors.grey[200],
                      //isDense: true,
                      contentPadding: const EdgeInsets.fromLTRB(10, 13, 10, 13),
                      // enabledBorder: OutlineInputBorder(
                      //     borderSide: BorderSide(color: Colors.grey[400])),
                      // focusedBorder: OutlineInputBorder(
                      //     borderSide: BorderSide(color: Colors.grey[400])),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide.none),
                    ),
                  ),
                ),
              ),
              const Divider(
                thickness: 10,
                color: Color(0xFFF4F3F8),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  'Fill the details Below:',
                  style: ThreeKmTextConstants.tk14PXPoppinsBlackMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 14, bottom: 14, left: 18),
                child: TextFormField(
                  controller: flatNumberText,
                  keyboardType: TextInputType.text,
                  validator: (val) {},
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'Flat No./House No.',
                    hintStyle: ThreeKmTextConstants.tk16PXPoppinsBlackMedium
                        .copyWith(color: Color(0xFF979EA4)),
                    counterText: '',
                    filled: true,

                    fillColor: Colors.white,
                    //isDense: true,
                    contentPadding: const EdgeInsets.fromLTRB(10, 13, 10, 13),

                    border:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ),
              const Divider(
                thickness: 2,
                color: Color(0xFFF4F3F8),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 14, bottom: 14, left: 18),
                child: TextFormField(
                  controller: societyText,
                  keyboardType: TextInputType.text,
                  validator: (val) {},
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'Society/Building/Street Name',
                    hintStyle: ThreeKmTextConstants.tk16PXPoppinsBlackMedium
                        .copyWith(color: const Color(0xFF979EA4)),
                    counterText: '',
                    filled: true,

                    fillColor: Colors.white,
                    //isDense: true,
                    contentPadding: const EdgeInsets.fromLTRB(10, 13, 10, 13),

                    border:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ),
              const Divider(
                thickness: 2,
                color: Color(0xFFF4F3F8),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 14, bottom: 14, left: 18),
                child: TextFormField(
                  controller: landmarkText,
                  keyboardType: TextInputType.text,
                  validator: (val) {},
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'Landmark(optional)',
                    hintStyle: ThreeKmTextConstants.tk16PXPoppinsBlackMedium
                        .copyWith(color: Color(0xFF979EA4)),
                    counterText: '',
                    filled: true,

                    fillColor: Colors.white,
                    //isDense: true,
                    contentPadding: const EdgeInsets.fromLTRB(10, 13, 10, 13),

                    border:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ),
              const Divider(
                thickness: 2,
                color: Color(0xFFF4F3F8),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 18, bottom: 25),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'This a Commercial Address? ',
                      style: ThreeKmTextConstants.tk14PXPoppinsBlackMedium,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isCommercial = isCommercial ? false : true;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 5),
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                              color: isCommercial
                                  ? Color(0xFF43B978)
                                  : Colors.transparent,
                              border: Border.all(color: Color(0xFFD5D5D5)),
                              borderRadius: BorderRadius.circular(8)),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 20,
                color: Color(0xFFF4F3F8),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, top: 20),
                child: Text(
                  'Select Address Type:',
                  style: ThreeKmTextConstants.tk14PXPoppinsBlackMedium,
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20, top: 20),
                width: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          addressType = 'home';
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                  addressType == 'home'
                                      ? Colors.green
                                      : Colors.transparent,
                                  BlendMode.color),
                              child: const Image(
                                image:
                                    AssetImage('assets/shopImg/homeIcon.png'),
                              ),
                            ),
                          ),
                          Text(
                            'Home',
                            style: ThreeKmTextConstants
                                .tk12PXPoppinsBlackSemiBold
                                .copyWith(
                              color: addressType == 'home'
                                  ? Colors.green
                                  : Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          addressType = 'work';
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                  addressType == 'work'
                                      ? Colors.green
                                      : Colors.transparent,
                                  BlendMode.color),
                              child: const Image(
                                image:
                                    AssetImage('assets/shopImg/workIcon.png'),
                              ),
                            ),
                          ),
                          Text(
                            'Office',
                            style: ThreeKmTextConstants
                                .tk12PXPoppinsBlackSemiBold
                                .copyWith(
                              color: addressType == 'work'
                                  ? Colors.green
                                  : Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          addressType = 'other';
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                  addressType == 'other'
                                      ? Colors.green
                                      : Colors.transparent,
                                  BlendMode.color),
                              child: const Image(
                                image:
                                    AssetImage('assets/shopImg/otherIcon.png'),
                              ),
                            ),
                          ),
                          Text(
                            'Other',
                            style: ThreeKmTextConstants
                                .tk12PXPoppinsBlackSemiBold
                                .copyWith(
                              color: addressType == 'other'
                                  ? Colors.green
                                  : Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Center(
                  child: ElevatedButton.icon(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(StadiumBorder()),
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xFF3E7EFF)),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.black),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.only(
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
                        "Save New Address",
                        style: ThreeKmTextConstants.tk14PXPoppinsBlackBold
                            .copyWith(color: Colors.white, letterSpacing: 0.56),
                      ),
                      onPressed: () {
                        var data = {
                          "address_type": addressType ?? 'home',
                          "area": _selecetedAddress,
                          "city": city, //administrative_area_level_2,
                          "country": "India",
                          "flat_no": flatNumberText.text,
                          "landmark": landmarkText.text != ''
                              ? landmarkText.text
                              : societyText.text,
                          "latitude": geometry?.lat,
                          "longitude": geometry?.lng,
                          //"phone_no":,
                          "pincode": postalCode, //postal_code
                          "state": state, //administrative_area_level_1
                        };
                       var error = validate(flatNumberText.text, _selecetedAddress);
                        if (flatNumberText.text == '' &&
                            _selecetedAddress!.isNotEmpty) {
                          context
                              .read<AddressListProvider>()
                              .addNewAddress(mounted, jsonEncode(data));
                          log(data.toString());
                        }
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
