import 'package:flutter/material.dart';

import 'package:provider/src/provider.dart';

import 'package:threekm/UI/shop/address/openMap.dart';

import 'package:threekm/providers/shop/address_list_provider.dart';

import 'package:threekm/utils/threekm_textstyles.dart';

class SavedAddress extends StatefulWidget {
  const SavedAddress({Key? key}) : super(key: key);

  @override
  _SavedAddressState createState() => _SavedAddressState();
}

class _SavedAddressState extends State<SavedAddress> {
  String? _selecetedAddress;
  @override
  void initState() {
    super.initState();
    context.read<AddressListProvider>().getAddressList(mounted);
  }

  @override
  Widget build(BuildContext context) {
    var data = context.watch<AddressListProvider>().getAddressListData;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        title: Text(
          'SAVED ADDRESSES',
          style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold
              .copyWith(letterSpacing: 2),
        ),
      ),
      body: data.addresses == null
          ? Container(
              margin: const EdgeInsets.only(top: 20),
              height: size.height / 2,
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Image(
                    image: AssetImage('assets/shopImg/location.png'),
                    width: 100,
                    height: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 23, right: 23),
                    child: Text(
                      'You don’t have any saved address. Saving addresses will help you shop and checkout faster.',
                      style: ThreeKmTextConstants.tk14PXPoppinsBlackMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton.icon(
                      onPressed: () async {
                        // Future.delayed(Duration.zero, () {
                        //   context
                        //       .read<LocationProvider>()
                        //       .getLocation()
                        //       .whenComplete(() {
                        //     final _locationProvider = context
                        //         .read<LocationProvider>()
                        //         .getlocationData;
                        //     final kInitialPosition = LatLng(
                        //         _locationProvider!.latitude!,
                        //         _locationProvider.longitude!);
                        //     if (_locationProvider != null) {
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //             builder: (context) => PlacePicker(
                        //               apiKey: GMap_Api_Key,
                        //               // initialMapType: MapType.satellite,
                        //               onPlacePicked: (result) {
                        //                 //print(result.formattedAddress);
                        //                 setState(() {
                        //                   _selecetedAddress =
                        //                       result.formattedAddress;
                        //                   print(result.geometry!.toJson());
                        //                 });
                        //                 Navigator.of(context).pop();
                        //               },
                        //               initialPosition: kInitialPosition,
                        //               useCurrentLocation: true,
                        //               selectInitialPosition: true,
                        //               usePinPointingSearch: true,
                        //               usePlaceDetailSearch: true,
                        //             ),
                        //           ));
                        //     }
                        //   });
                        // });

                        FocusScope.of(context).unfocus();
                        // await Navigator.of(context)
                        //     .pushNamed(LocationBasePage.path);
                      },
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all(const StadiumBorder()),
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xFF3E7EFF)),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          elevation: MaterialStateProperty.all(5),
                          shadowColor:
                              MaterialStateProperty.all(Color(0xFFFC5E6A33)),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.only(
                                  left: 30, right: 30, top: 15, bottom: 15))),
                      icon: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(
                          Icons.add,
                          color: Color(0xFF3E7EFF),
                        ),
                      ),
                      label: Text(
                        'Add New Address',
                        style: ThreeKmTextConstants.tk14PXPoppinsWhiteMedium
                            .copyWith(letterSpacing: 0.56),
                      )),
                ],
              ),
            )
          : Container(
              height: size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () async {
                      OpenMap(context);
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (_) => NewAddress()));...
                      //FocusScope.of(context).unfocus();
                      // await Navigator.of(context)
                      //     .pushNamed(LocationBasePage.path);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                      ),
                      child: ListTile(
                        dense: true,
                        leading: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[350], shape: BoxShape.circle),
                          child: const Icon(
                            Icons.add,
                            color: Color(0xFF3E7EFF),
                          ),
                        ),
                        title: Text(
                          'Add New Address',
                          style: ThreeKmTextConstants.tk14PXPoppinsBlueMedium,
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    color: Color(0xFFF4F3F8),
                    height: 40,
                    thickness: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 10),
                    child: Text(
                      'Saved Addresses',
                      style: ThreeKmTextConstants.tk14PXPoppinsBlackMedium,
                    ),
                  ),
                  Flexible(
                    child: Container(
                      width: 350,
                      // color: Colors.green,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.addresses?.length,
                          itemBuilder: (_, i) {
                            var address = data.addresses?[i];
                            return ListTile(
                              dense: true,
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    shape: BoxShape.circle),
                                child: address?.addressType == 'home'
                                    ? Icon(Icons.home_rounded)
                                    : Icon(Icons.work_rounded),
                              ),
                              title: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  '${address?.firstname} ${address?.lastname}',
                                  style: ThreeKmTextConstants
                                      .tk14PXPoppinsBlackSemiBold
                                      .copyWith(fontSize: 18),
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${address?.flatNo}, ${address?.area}, ${address?.city}',
                                      style: ThreeKmTextConstants
                                          .tk14PXPoppinsBlackSemiBold
                                          .copyWith(
                                              fontWeight: FontWeight.normal)),
                                  // SizedBox(
                                  //   width: 200,
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     children: [
                                  //       ElevatedButton.icon(
                                  //         onPressed: () {},
                                  //         icon: Icon(
                                  //           Icons.edit,
                                  //           size: 18,
                                  //         ),
                                  //         label: Text(
                                  //           'EDIT',
                                  //           style: ThreeKmTextConstants
                                  //               .tk12PXPoppinsBlackSemiBold
                                  //               .copyWith(
                                  //                   color: Color(0xFF3E7EFF)),
                                  //         ),
                                  //         style: ButtonStyle(
                                  //           elevation:
                                  //               MaterialStateProperty.all(0),
                                  //           shape: MaterialStateProperty.all(
                                  //               StadiumBorder()),
                                  //           backgroundColor:
                                  //               MaterialStateProperty.all(
                                  //                   const Color(0x1A3E7EFF)),
                                  //           foregroundColor:
                                  //               MaterialStateProperty.all(
                                  //                   Color(0xFF3E7EFF)),
                                  //         ),
                                  //       ),
                                  //       ElevatedButton.icon(
                                  //         onPressed: () {},
                                  //         icon: Icon(
                                  //           Icons.delete,
                                  //           size: 18,
                                  //         ),
                                  //         label: Text(
                                  //           'Delete',
                                  //           style: ThreeKmTextConstants
                                  //               .tk12PXPoppinsBlackSemiBold
                                  //               .copyWith(
                                  //                   color: Color(0xFFFF5858)),
                                  //         ),
                                  //         style: ButtonStyle(
                                  //           elevation:
                                  //               MaterialStateProperty.all(0),
                                  //           shape: MaterialStateProperty.all(
                                  //               StadiumBorder()),
                                  //           backgroundColor:
                                  //               MaterialStateProperty.all(
                                  //                   const Color(0x1AFF5858)),
                                  //           foregroundColor:
                                  //               MaterialStateProperty.all(
                                  //                   Color(0xFFFF5858)),
                                  //         ),
                                  //       )
                                  //     ],
                                  //   ),
                                  // )
                                ],
                              ),
                            );
                          }),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
