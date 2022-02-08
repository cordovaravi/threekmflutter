import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:threekm/Custom_library/GooleMapsWidget/src/place_picker.dart';
import 'package:threekm/UI/main/navigation.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/providers/Location/locattion_Provider.dart';
import 'package:threekm/providers/main/AddPost_Provider.dart';
import 'package:threekm/utils/api_paths.dart';
import 'package:threekm/utils/utils.dart';
import 'package:provider/provider.dart';

class AddNewPost extends StatefulWidget {
  final File imageFile;
  AddNewPost({required this.imageFile, Key? key}) : super(key: key);

  @override
  _AddNewPostState createState() => _AddNewPostState();
}

class _AddNewPostState extends State<AddNewPost> {
  TextEditingController _tagscontroller = TextEditingController();
  TextEditingController _storyController = TextEditingController();
  TextEditingController _headLineController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Geometry? _geometry;
  var padding = EdgeInsets.only(
    right: 18,
    left: 18,
  );

  int headlineCount = 0;
  int descriptionCount = 0;
  String? _selecetdAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "NEW POST",
          style: ThreeKmTextConstants.tk16PXPoppinsWhiteBold,
        ),
        actions: [
          TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (_geometry?.location.lat != null) {
                    context
                        .read<AddPostProvider>()
                        .uploadPng(
                            context,
                            _headLineController.text,
                            _storyController.text,
                            _selecetdAddress ?? "",
                            _geometry!.location.lat,
                            _geometry!.location.lng)
                        .whenComplete(() {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TabBarNavigation(
                                    redirectedFromPost: true,
                                  )),
                          (route) => false);
                    });
                  } else {
                    CustomSnackBar(context, Text("Please Select Location"));
                  }
                }
              },
              child: Text(
                "Post",
                style: ThreeKmTextConstants.tk14PXPoppinsWhiteMedium,
              ))
        ],
        backgroundColor: Color(0xff0F0F2D),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Space Top of headline
                    SizedBox(
                      height: 18,
                    ),
                    // Headline
                    buildHeadline,
                    // Space top of headline input
                    SizedBox(
                      height: 7,
                    ),
                    // Headline input
                    Container(
                      padding: padding,
                      height: 52,
                      child: TextFormField(
                        validator: (String? story) {
                          if (story == null || story == "" || story == " ") {
                            return "Please Add Headline";
                          }
                        },
                        controller: _headLineController,
                        maxLines: 1,
                        minLines: null,
                        expands: false,
                        maxLength: 50,
                        textAlignVertical: TextAlignVertical.top,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        buildCounter: (context,
                            {required currentLength,
                            required isFocused,
                            maxLength}) {
                          WidgetsBinding.instance!
                              .addPostFrameCallback((timeStamp) {
                            setState(() {
                              headlineCount = currentLength;
                            });
                          });
                          return Container(
                            height: 1,
                          );
                        },
                        style: ThreeKmTextConstants.tk16PXLatoBlackRegular
                            .copyWith(
                          color: Color(0xFF0F0F2D),
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    // Divider
                    SizedBox(
                      height: 5,
                    ),
                    Divider(
                      color: Color(0xFFD5D5D5),
                      thickness: 0.5,
                    ),
                    // Space top of description
                    SizedBox(
                      height: 24,
                    ),
                    // Description
                    buildDescription,
                    // Space top of description input
                    SizedBox(
                      height: 8,
                    ),
                    // Description input
                    Container(
                      padding: padding,
                      height: 135,
                      child: TextFormField(
                        validator: (String? story) {
                          if (story == null || story == "" || story == " ") {
                            return "Please Add Story";
                          }
                        },
                        controller: _storyController,
                        maxLines: null,
                        minLines: null,
                        expands: true,
                        maxLength: 250,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        buildCounter: (context,
                            {required currentLength,
                            required isFocused,
                            maxLength}) {
                          WidgetsBinding.instance!
                              .addPostFrameCallback((timeStamp) {
                            setState(() {
                              descriptionCount = currentLength;
                            });
                          });
                          Container(
                            height: 1,
                          );
                        },
                        style: ThreeKmTextConstants.tk16PXLatoBlackRegular
                            .copyWith(
                          color: Color(0xFF0F0F2D),
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    // Spaced before divider
                    SizedBox(
                      height: 32,
                    ),
                    // Divider
                    Divider(
                      color: Color(0xFFD5D5D5),
                      thickness: 0.5,
                    ),
                    // Spacer for tags
                    SizedBox(
                      height: 16,
                    ),
                    // Tags
                    Container(
                      padding: padding,
                      child: Text(
                        "Tags".toUpperCase(),
                        style: ThreeKmTextConstants.tk12PXPoppinsWhiteRegular
                            .copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF0F0F2D),
                        ),
                      ),
                    ),
                    // Spacer after tags
                    SizedBox(
                      height: 12,
                    ),
                    // Tag List
                    buildTags,
                    // Spacer for divider on location
                    SizedBox(
                      height: 16,
                    ),
                    // Divider
                    Divider(
                      color: Color(0xFFD5D5D5),
                      thickness: 0.5,
                    ),
                    // Location
                    Builder(
                      builder: (_controller) => Container(
                        padding: padding,
                        child: Row(
                          children: [
                            Container(
                              height: 52,
                              width: 52,
                              margin: EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFF4F3F8),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.place_rounded,
                                  size: 40,
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                                child: Text(
                                  "${_selecetdAddress ?? "Unspecified location"}"
                                      .toUpperCase(),
                                  style: ThreeKmTextConstants
                                      .tk12PXPoppinsWhiteRegular
                                      .copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF0F0F2D),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            InkWell(
                              onTap: () async {
                                Future.delayed(Duration.zero, () {
                                  context
                                      .read<LocationProvider>()
                                      .getLocation()
                                      .whenComplete(() {
                                    final _locationProvider = context
                                        .read<LocationProvider>()
                                        .getlocationData;
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
                                                setState(() {
                                                  _selecetdAddress =
                                                      result.formattedAddress;
                                                  print(result.geometry!
                                                      .toJson());
                                                  _geometry = result.geometry;
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
                                FocusScope.of(context).unfocus();
                                // await Navigator.of(context)
                                //     .pushNamed(LocationBasePage.path);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF4F3F8),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    "Change",
                                    style: ThreeKmTextConstants
                                        .tk12PXPoppinsWhiteRegular
                                        .copyWith(
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF3E7EFF)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Divider
                    Divider(
                      color: Color(0xFFD5D5D5),
                      thickness: 0.5,
                    ),
                    SizedBox(
                      height: 110,
                    ),
                  ],
                ),
              ),
            ),
            //buildFooter
          ],
        ),
      ),
    );
  }

  Widget get buildHeadline {
    return Container(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Headline".toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: headlineCount > 0 ? Color(0xFF979EA4) : Color(0xFF0F0F2D),
            ),
          ),
          Text(
            "($headlineCount/50)",
            style: ThreeKmTextConstants.tk12PXPoppinsWhiteRegular.copyWith(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF979EA4),
            ),
          ),
        ],
      ),
    );
  }

  Widget get buildDescription {
    return Container(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Description".toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color:
                  descriptionCount > 0 ? Color(0xFF979EA4) : Color(0xFF0F0F2D),
            ),
          ),
          Text(
            "($descriptionCount/250)",
            style: ThreeKmTextConstants.tk12PXPoppinsWhiteRegular.copyWith(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF979EA4),
            ),
          ),
        ],
      ),
    );
  }

  // Widget get buildFooter {
  //   return Positioned(
  //     bottom: 0,
  //     child: Container(

  //       height: 68,
  //       width: MediaQuery.of(context).size.width,
  //       child: Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Padding(
  //             padding: EdgeInsets.only(
  //               top: 12,
  //               right: 12,
  //               left: 18,
  //             ),
  //             child: Container(
  //                 height: 48,
  //                 width: 48,
  //                 child: Image.file(
  //                   widget.imageFile,
  //                   fit: BoxFit.cover,
  //                 )),
  //           ),
  //           Column(
  //             mainAxisSize: MainAxisSize.min,
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 "Uploading Post",
  //                 style: ThreeKmTextConstants.tk14PXPoppinsWhiteMedium,
  //               ),
  //               SizedBox(
  //                 height: 8,
  //               ),
  //               Container(
  //                   height: 5,
  //                   width: MediaQuery.of(context).size.width * 0.65,
  //                   alignment: Alignment.topCenter,
  //                   child: LinearProgressIndicator(
  //                     minHeight: 1,
  //                     value: 0.7,
  //                     color: Color(0xffFF5858),
  //                   ))
  //             ],
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget get buildFooter {
  //   return Positioned(
  //     bottom: 0,
  //     right: 0,
  //     left: 0,
  //     child: Container(
  //       height: 84,
  //       width: MediaQuery.of(context).size.width,
  //       padding: EdgeInsets.symmetric(vertical: 16, horizontal: 18),
  //       color: Color(0xFFF4F3F8),
  //       child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Icon(
  //             Icons.grid_view,
  //             size: 24,
  //           ),
  //           SizedBox(
  //             width: 8,
  //           ),
  //           Expanded(
  //             child: Container(
  //               margin: EdgeInsets.only(top: 2),
  //               child: Text(
  //                 "Advance".toUpperCase(),
  //                 style: ThreeKmTextConstants.tk14PXPoppinsWhiteMedium.copyWith(
  //                   color: Color(0xFF0F0F2D),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           SizedBox(
  //             width: 8,
  //           ),
  //           IconButton(
  //             icon: Icon(
  //               Icons.arrow_forward,
  //               size: 24,
  //             ),
  //             onPressed: () {
  //               FocusScope.of(context).unfocus();

  //               Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                       builder: (context) => AddmorePhotos(
  //                           //imageFile: widget.imageFile,
  //                           )));
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget get buildTags {
    return Container(
      padding: padding,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Consumer<AddPostProvider>(
          builder: (context, addpostProvider, _) {
            return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: addpostProvider.tagsList.length > 0
                    ? [
                        ...addpostProvider.tagsList.map((value) {
                          return GestureDetector(
                            onTap: () {
                              context.read<AddPostProvider>().removeTag(value);
                            },
                            child: Container(
                                margin: EdgeInsets.only(right: 12),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    //color: Colors.blue
                                    // color: e.value.active
                                    //     ? Colors.blue
                                    //     : Colors.white,
                                    border: Border.all(
                                        color: Color(0xFF979EA4), width: 1)
                                    //     : Border.all(color: Colors.transparent)
                                    ),
                                child: Row(
                                  children: [
                                    Center(
                                      child: Text(
                                        value.toString(),
                                        style: ThreeKmTextConstants
                                            .tk12PXPoppinsWhiteRegular
                                            .copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF979EA4),
                                        ),
                                      ),
                                    ),
                                    Icon(Icons.cancel_outlined)
                                  ],
                                )),
                          );
                        }).toList(),
                        InkWell(
                          onTap: () => addTag(context),
                          child: Container(
                            margin: EdgeInsets.only(right: 12),
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                border: Border.all(
                                    color: Color(0xFF979EA4), width: 1)),
                            child: Center(
                              child: Text(
                                "+ Add",
                                style: ThreeKmTextConstants
                                    .tk12PXPoppinsWhiteRegular
                                    .copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                              ),
                            ),
                          ),
                        )
                      ]
                    : [
                        InkWell(
                          onTap: () => addTag(context),
                          child: Container(
                            margin: EdgeInsets.only(right: 12),
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                border: Border.all(
                                    color: Color(0xFF979EA4), width: 1)),
                            child: Center(
                              child: Text(
                                "+ Add",
                                style: ThreeKmTextConstants
                                    .tk12PXPoppinsWhiteRegular
                                    .copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                              ),
                            ),
                          ),
                        )
                      ]);
          },
        ),
      ),
    );
  }

  addTag(BuildContext context) async {
    String? tag = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text(
            "Add Tag",
            style: ThreeKmTextConstants.tk14PXPoppinsBlackSemiBold
                .copyWith(color: Colors.black, fontWeight: FontWeight.w900),
          ),
          content: TextField(
            controller: _tagscontroller,
            decoration: InputDecoration(
                hintText: "Tag",
                hintStyle: ThreeKmTextConstants.tk14PXPoppinsBlackSemiBold
                    .copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                )),
          ),
          actions: [
            TextButton(
              child: Text(
                "Cancel",
                style: ThreeKmTextConstants.tk14PXPoppinsBlackSemiBold
                    .copyWith(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                FocusScope.of(context).unfocus();
              },
            ),
            TextButton(
              child: Text(
                "Continue",
                style: ThreeKmTextConstants.tk14PXPoppinsBlackSemiBold
                    .copyWith(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop(_tagscontroller.text);
                FocusScope.of(context).unfocus();
              },
            )
          ],
        );
      },
    );
    if (tag != null && _tagscontroller.text.isNotEmpty) {
      context
          .read<AddPostProvider>()
          .addTags(_tagscontroller.text)
          .whenComplete(() => _tagscontroller.clear());
    }
  }

  // Widget get buildFooter {
  //   return Positioned(
  //     bottom: 0,
  //     right: 0,
  //     left: 0,
  //     child: Container(
  //       height: 84,
  //       width: MediaQuery.of(context).size.width,
  //       padding: EdgeInsets.symmetric(vertical: 16, horizontal: 18),
  //       color: Color(0xFFF4F3F8),
  //       child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Icon(
  //             Icons.grid_view,
  //             size: 24,
  //           ),
  //           SizedBox(
  //             width: 8,
  //           ),
  //           Expanded(
  //             child: Container(
  //               margin: EdgeInsets.only(top: 2),
  //               child: Text(
  //                 "Advance".toUpperCase(),
  //                 style: ThreeKmTextConstants.tk14PXPoppinsWhiteMedium.copyWith(
  //                   color: Color(0xFF0F0F2D),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           SizedBox(
  //             width: 8,
  //           ),
  //           Icon(
  //             Icons.arrow_forward,
  //             size: 24,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
