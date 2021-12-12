// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:get/get.dart';
// import 'package:threekm/models/business_controller.dart';
// import 'package:threekm/pages/business/business_details.dart';
// import 'package:threekm/utils/utils.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';

// class BusinessAdSlide extends StatelessWidget {
//   final PageController pageController = PageController(viewportFraction: 0.9);

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<BusinessController>(
//       builder: (_controller) => Container(
//         // to adopt the height as per device size
//         height: 179,
//         child: PageView.builder(
//           controller: pageController,
//           itemCount: _controller.data['Result']["advertisements"].length,
//           itemBuilder: (context, index) {
//             return Container(
//               height: 179,
//               margin: EdgeInsets.only(right: 16),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15),
//                 image: DecorationImage(
//                     image: CachedNetworkImageProvider(_controller.data['Result']
//                         ["advertisements"][index]["images"][0]),
//                     fit: BoxFit.fill),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class BusinessAdSlideTwo extends StatelessWidget {
//   final PageController pageController = PageController(viewportFraction: 0.9);

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<BusinessController>(
//         builder: (_controller) => Container(
//               height: 190,
//               padding: EdgeInsets.symmetric(vertical: 20),
//               decoration: BoxDecoration(
//                 color: Color(0xFFF4F3F8),
//               ),
//               child: PageView.builder(
//                 controller: pageController,
//                 itemCount:
//                     _controller.data['Result']["slider"]['Result'].length,
//                 itemBuilder: (context, index) {
//                   return Container(
//                     height: 179,
//                     margin: EdgeInsets.only(right: 16),
//                     decoration: BoxDecoration(
//                       color: ThreeKmTextConstants.blue1,
//                       borderRadius: BorderRadius.circular(15),
//                       image: DecorationImage(
//                           image: CachedNetworkImageProvider(
//                               _controller.data['Result']["slider"]['Result']
//                                   [index]["images"][0]),
//                           fit: BoxFit.fill),
//                     ),
//                   );
//                 },
//               ),
//             ));
//   }
// }

// class BusinessAdSlideDynamic extends StatelessWidget {
//   final pageController = PageController(viewportFraction: 0.9);
//   final Map<dynamic, dynamic> items;
//   BusinessAdSlideDynamic({required this.items});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 190,
//       padding: EdgeInsets.symmetric(vertical: 20),
//       decoration: BoxDecoration(
//         color: Color(0xFFF4F3F8),
//       ),
//       child: PageView.builder(
//         controller: pageController,
//         itemCount: items['imageswcta'].length,
//         itemBuilder: (context, index) {
//           return GestureDetector(
//             onTap: () {
//               late int id;
//               if (items["imageswcta"][index]['business'] is String) {
//                 id = int.tryParse(items["imageswcta"][index]['business']) ?? 0;
//               } else {
//                 id = items["imageswcta"][index]['business'];
//               }
//               print("$id - ${id.runtimeType}");
//               Navigator.of(context).pushNamed(
//                 BusinessDetailsPage.path,
//                 arguments: id,
//               );
//             },
//             child: Container(
//               height: 179,
//               margin: EdgeInsets.only(right: 16),
//               decoration: BoxDecoration(
//                 color: ThreeKmTextConstants.blue1,
//                 borderRadius: BorderRadius.circular(15),
//                 image: DecorationImage(
//                     image: CachedNetworkImageProvider(
//                       items["imageswcta"][index]['image'],
//                     ),
//                     fit: BoxFit.fill),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
