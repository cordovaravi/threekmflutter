// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:threekm/models/new_post_controller.dart';
// import 'package:threekm/utils/threekm_textstyles.dart';

// class Controls extends StatefulWidget {
//   final VoidCallback callback;
//   Controls({required this.callback});
//   @override
//   _ControlsState createState() => _ControlsState();
// }

// class _ControlsState extends State<Controls> {
//   final postController = Get.find<NewPostController>();
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             InkWell(
//               onTap: () {
//                 print("0");
//                 // setState(() => postController
//                 //     .images[postController.index].selectedTab = 0);
//                 postController.crop(context);
//                 // widget.callback();
//               },
//               child: Control(
//                   icon: Icon(Icons.crop, size: 16, color: Colors.white),
//                   text: "Crop",
//                   isSet: true),
//             ),
//             Container(),
//             // InkWell(
//             //   onTap: () {
//             //     print("1");
//             //     // postController.images[postController.index].selectedTab =
//             //     //     1;
//             //     setState(() => postController
//             //         .images[postController.index].selectedTab = 1);
//             //     widget.callback();
//             //   },
//             //   child: Control(
//             //       icon: Icon(Icons.tune, size: 16, color: Colors.white),
//             //       text: "Adjust",
//             //       isSet: true),
//             // ),
//             InkWell(
//               onTap: () {
//                 print("2");
//                 postController.filter(context);
//               },
//               child: Control(
//                   icon: Icon(Icons.photo_filter, size: 16, color: Colors.white),
//                   text: "Filters",
//                   isSet: true),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// class Control extends StatelessWidget {
//   final Icon icon;
//   final String text;
//   final bool isSet;
//   Control({required this.icon, required this.text, required this.isSet});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(top: 11, bottom: 11, left: 12, right: 19),
//       decoration: BoxDecoration(
//         color: isSet ? Colors.grey.withOpacity(0.1) : Colors.transparent,
//         borderRadius: BorderRadius.circular(21),
//       ),
//       child: Row(
//         children: [
//           icon,
//           SizedBox(width: 14),
//           Text(
//             "$text",
//             style: ThreeKmTextConstants.tk14PXPoppinsWhiteMedium,
//           )
//         ],
//       ),
//     );
//   }
// }
