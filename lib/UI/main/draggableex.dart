// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/src/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:threekm/Custom_library/GooleMapsWidget/src/place_picker.dart';
// import 'package:threekm/Custom_library/draggable_home.dart';
// import 'package:threekm/UI/main/AddPost/ImageEdit/editImage.dart';
// import 'package:threekm/UI/main/News/NewsTab.dart';
// import 'package:threekm/UI/main/navigation.dart';
// import 'package:threekm/commenwidgets/CustomSnakBar.dart';
// import 'package:threekm/providers/Location/locattion_Provider.dart';
// import 'package:threekm/providers/main/AddPost_Provider.dart';
// import 'package:threekm/utils/api_paths.dart';
// import 'package:threekm/utils/utils.dart';
// import 'package:google_maps_webservice/directions.dart';

// import 'News/NewsList.dart';

// class DraggablePage extends StatefulWidget {
//   final bool? isredirected;
//   DraggablePage({this.isredirected});

//   @override
//   State<DraggablePage> createState() => _DraggablePageState();
// }

// class _DraggablePageState extends State<DraggablePage>
//     with AutomaticKeepAliveClientMixin {
//   final ImagePicker _imagePicker = ImagePicker();
//   String? _selecetdAddress;
//   Geometry? _geometry;

//   @override
//   void initState() {
//     Future.microtask(() => context.read<LocationProvider>().getLocation());
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return DraggableHome(
//         headerExpandedHeight: 0.0000000000001,
//         body: [NewsTab(reload: widget.isredirected)],
//         fullyStretchable: true,
//         expandedBody: Container(
//           color: //Colors.amber,
//               Color(0xff3E7EFF),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Column(
//                 children: [
//                   InkWell(
//                     onTap: () async {
//                       context.read<AddPostProvider>().deletImages();
//                       _showImageVideoBottomModalSheet(context);
//                     },
//                     child: Container(
//                       margin: EdgeInsets.only(top: 16, bottom: 16),
//                       height: 127,
//                       width: 161,
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(20)),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             height: 42,
//                             width: 42,
//                             decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                     image: AssetImage("assets/Grouppost.png"),
//                                     fit: BoxFit.cover),
//                                 shape: BoxShape.circle,
//                                 color: Color(0xffFBA924)),
//                           ),
//                           SizedBox(
//                             height: 8,
//                           ),
//                           Text(
//                             "New Post",
//                             style:
//                                 ThreeKmTextConstants.tk16PXPoppinsBlackMedium,
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                      // drawerController.open!();
//                     },
//                     child: Container(
//                       margin: EdgeInsets.only(bottom: 16, left: 16, right: 16),
//                       //height: MediaQuery.of(context).size.height * 0.1,
//                       height: 127,
//                       width: 161,
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(20)),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             height: 42,
//                             width: 42,
//                             decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                   image:
//                                       AssetImage("assets/Group 41299@2x.png"),
//                                 ),
//                                 shape: BoxShape.circle,
//                                 color: Color(0xffFC5E6A),
//                                 boxShadow: [
//                                   BoxShadow(
//                                       color: Color(0xffFC5E6A33),
//                                       blurRadius: 0.8)
//                                 ]),
//                           ),
//                           SizedBox(
//                             height: 8,
//                           ),
//                           Text(
//                             "My Profile",
//                             style:
//                                 ThreeKmTextConstants.tk16PXPoppinsBlackMedium,
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Column(
//                 children: [
//                   InkWell(
//                     child: Container(
//                       margin: EdgeInsets.only(top: 16),
//                       // margin: EdgeInsets.only(
//                       //     bottom: 16, left: 16, right: 16, top: 0),
//                       //height: MediaQuery.of(context).size.height * 0.2,
//                       height: 270,
//                       width: 161,
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(20)),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             height: 42,
//                             width: 42,
//                             decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                   image: AssetImage("assets/Grouplocation.png"),
//                                 ),
//                                 shape: BoxShape.circle,
//                                 color: Color(0xff43B978),
//                                 boxShadow: [
//                                   BoxShadow(
//                                       color: Color(0xff43B97833),
//                                       blurRadius: 0.8)
//                                 ]),
//                           ),
//                           SizedBox(
//                             height: 8,
//                           ),
//                           Text(
//                             "My Location",
//                             style:
//                                 ThreeKmTextConstants.tk16PXPoppinsBlackMedium,
//                           ),
//                           SizedBox(
//                             height: 15,
//                           ),
//                           Text(
//                             _selecetdAddress ?? "",
//                             style:
//                                 ThreeKmTextConstants.tk16PXPoppinsBlackMedium,
//                             textAlign: TextAlign.center,
//                           ),
//                           SizedBox(
//                             height: 15,
//                           ),
//                           InkWell(
//                             onTap: () {
//                               Future.delayed(Duration.zero, () {
//                                 context
//                                     .read<LocationProvider>()
//                                     .getLocation()
//                                     .whenComplete(() {
//                                   final _locationProvider = context
//                                       .read<LocationProvider>()
//                                       .getlocationData;
//                                   final kInitialPosition = LatLng(
//                                       _locationProvider!.latitude!,
//                                       _locationProvider.longitude!);
//                                   if (_locationProvider != null) {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => PlacePicker(
//                                             apiKey: GMap_Api_Key,
//                                             // initialMapType: MapType.satellite,
//                                             onPlacePicked: (result) async {
//                                               //print(result.formattedAddress);
//                                               setState(() {
//                                                 _selecetdAddress =
//                                                     result.formattedAddress;
//                                                 print(
//                                                     result.geometry!.toJson());
//                                                 _geometry = result.geometry;
//                                               });
//                                               SharedPreferences _prefs =
//                                                   await SharedPreferences
//                                                       .getInstance();
//                                               _prefs.setString("Geometry",
//                                                   _geometry.toString());
//                                               CustomSnackBar(
//                                                   context,
//                                                   Text(
//                                                       "Updating Hyperlocal contetnt in background"));
//                                               Navigator.of(context).pop();
//                                             },
//                                             initialPosition: kInitialPosition,
//                                             useCurrentLocation: true,
//                                             selectInitialPosition: true,
//                                             usePinPointingSearch: true,
//                                             usePlaceDetailSearch: true,
//                                           ),
//                                         ));
//                                   }
//                                 });
//                               });
//                             },
//                             child: Container(
//                               width: 108,
//                               height: 36,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(18),
//                                   color: Color(0xff3E7EFF)),
//                               child: Center(
//                                 child: Text(
//                                   "Change",
//                                   style: ThreeKmTextConstants
//                                       .tk16PXPoppinsWhiteBold,
//                                 ),
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               )
//             ],
//           ),
//         ));
//   }

//   Container headerBottomBarWidget() {
//     return Container(
//       child: Row(
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.end,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.settings,
//             color: Colors.white,
//           ),
//         ],
//       ),
//     );
//   }

//   ListView listView() {
//     return ListView.builder(
//       padding: EdgeInsets.only(top: 0),
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: 20,
//       shrinkWrap: true,
//       itemBuilder: (context, index) => Card(
//         color: Colors.white70,
//         child: ListTile(
//           leading: CircleAvatar(
//             child: Text("$index"),
//           ),
//           title: Text("Title"),
//           subtitle: Text("Subtitile"),
//         ),
//       ),
//     );
//   }

//   _showImageVideoBottomModalSheet(BuildContext context) {
//     showModalBottomSheet<void>(
//       backgroundColor: Colors.transparent,
//       context: context,
//       isScrollControlled: true,
//       builder: (BuildContext context) {
//         return Padding(
//           padding: MediaQuery.of(context).viewInsets,
//           child: StatefulBuilder(
//             builder: (BuildContext context, StateSetter setModalState) {
//               return ClipPath(
//                 clipper: OvalTopBorderClipper(),
//                 child: Container(
//                   color: Colors.white,
//                   height: MediaQuery.of(context).size.height / 4,
//                   padding: const EdgeInsets.all(15.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       SizedBox(
//                         height: 20,
//                       ),
//                       InkWell(
//                         onTap: () async {
//                           List<XFile>? imageFileList = [];
//                           final List<XFile>? images =
//                               await _imagePicker.pickMultiImage();
//                           if (imageFileList.isEmpty) {
//                             imageFileList.addAll(images!);
//                           }
//                           imageFileList.forEach((element) {
//                             print(element.name);
//                             print(element.path);
//                           });

//                           if (imageFileList != null) {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) =>
//                                         EditImage(images: imageFileList)));
//                           }
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                               border: Border.all(
//                                 color: Color(0xff0F0F2D),
//                               )),
//                           child: ListTile(
//                             leading: Image.asset(
//                               "assets/camera.png",
//                               color: Color(0xff0F0F2D),
//                             ),
//                             title: Text(
//                               "Upload Image via Gallery",
//                               style: ThreeKmTextConstants.tk14PXLatoBlackBold,
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       InkWell(
//                         onTap: () async {
//                           final pickedVideo = await _imagePicker.pickVideo(
//                               source: ImageSource.gallery);
//                           //final file = XFile(pickedVideo!.path);
//                           Navigator.pop(context);
//                           if (pickedVideo != null) {
//                             // context
//                             //     .read<AddPostProvider>()
//                             //     .addImages(File(pickedVideo.path));
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => EditImage(
//                                         images: [XFile(pickedVideo.path)])));
//                           }
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                               border: Border.all(
//                                 color: Color(0xff0F0F2D),
//                               )),
//                           child: ListTile(
//                             leading: Image.asset(
//                               "assets/videocam.png",
//                               color: Color(0xff0F0F2D),
//                             ),
//                             title: Text(
//                               "Upload Video via Gallery",
//                               style: ThreeKmTextConstants.tk14PXLatoBlackBold,
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   @override
//   bool get wantKeepAlive => true;
// }
