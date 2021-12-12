// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:threekm/models/business_controller.dart';
// import 'package:threekm/pages/business/business_details.dart';
// import 'package:threekm/pages/business_category_view.dart';
// import 'package:threekm/utils/threekm_textstyles.dart';
// import 'package:threekm/widgets/custom_button.dart';

// class BusinessNearbyWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Color(0xFFF4F3F8),
//       child: Column(
//         children: [
//           SizedBox(
//             height: 20,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(left: 19.0, bottom: 25),
//                 child: Text(
//                   "Nearby Businesses",
//                   style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold,
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.of(context)
//                       .pushNamed(BusinessCategoryView.path, arguments: "");
//                 },
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       margin: const EdgeInsets.only(right: 10),
//                       child: Text(
//                         "View All",
//                         style: ThreeKmTextConstants.tk14PXPoppinsGreenSemiBold,
//                       ),
//                     ),
//                     Container(
//                       margin: const EdgeInsets.only(right: 19),
//                       child: Transform.translate(
//                         offset: Offset(
//                           0,
//                           -2,
//                         ),
//                         child: Icon(
//                           Icons.arrow_forward,
//                           color: ThreeKmTextConstants.green,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           GetBuilder<BusinessController>(
//             builder: (_controller) => Container(
//                 margin: EdgeInsets.only(left: 19, right: 19),
//                 child: Column(
//                   children: (_controller.data2['data']['result']['creators']
//                           as List<dynamic>)
//                       .asMap()
//                       .entries
//                       .map((e) {
//                     return GestureDetector(
//                       onTap: () {
//                         Navigator.of(context).pushNamed(
//                             BusinessDetailsPage.path,
//                             arguments: e.value['creator_id']);
//                       },
//                       child: Container(
//                         height: 90,
//                         margin: EdgeInsets.only(bottom: 16),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Container(
//                               height: 74,
//                               width: 74,
//                               margin: EdgeInsets.only(left: 8, right: 12),
//                               decoration: BoxDecoration(
//                                 color: Color(0xFFF4F3F8),
//                                 border: Border.all(
//                                   color: Color(0xFFF4F3F8),
//                                 ),
//                                 borderRadius: BorderRadius.circular(15),
//                                 image: DecorationImage(
//                                   fit: BoxFit.fill,
//                                   image: CachedNetworkImageProvider(
//                                     e.value['image'],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: Container(
//                                 padding: EdgeInsets.only(right: 12),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       e.value['business_name'],
//                                       overflow: TextOverflow.ellipsis,
//                                       style: ThreeKmTextConstants
//                                           .tk14PXLatoBlackSemiBold,
//                                     ),
//                                     SizedBox(
//                                       height: 4,
//                                     ),
//                                     Text(
//                                       e.value['tags'].toString().substring(
//                                           1,
//                                           e.value['tags'].toString().length -
//                                               1),
//                                       overflow: TextOverflow.ellipsis,
//                                       style: ThreeKmTextConstants
//                                           .tk12PXLatoGreenSemiBold,
//                                     ),
//                                     SizedBox(
//                                       height: 4,
//                                     ),
//                                     Divider(
//                                       color: Colors.grey.withOpacity(0.2),
//                                       thickness: 1,
//                                     ),
//                                     SizedBox(
//                                       height: 4,
//                                     ),
//                                     Text(
//                                       "Kothrod(1.2 km)",
//                                       overflow: TextOverflow.ellipsis,
//                                       style: ThreeKmTextConstants
//                                           .tk14PXLatoBlackSemiBold,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 )

//                 // ListView.builder(
//                 //   shrinkWrap: true,
//                 //   scrollDirection: Axis.vertical,
//                 //   itemCount: businessController
//                 //       .data2['data']['result']['creators'].length,
//                 //   itemBuilder: (context, i) {
//                 //     var count = (businessController.data2['data']['result']
//                 //             ['creators'][i]["tags"] as List<dynamic>)
//                 //         .length;
//                 //     var listOfTags = (businessController.data2['data']['result']
//                 //             ['creators'][i]["tags"] as List<dynamic>)
//                 //         .sublist(0, count > 2 ? 2 : null)
//                 //         .toString();
//                 //     var tags = listOfTags.substring(1, listOfTags.length - 1);
//                 //     return Container(
//                 //       width: 110,
//                 //       margin: EdgeInsets.only(right: 52),
//                 //       child: Column(
//                 //         crossAxisAlignment: CrossAxisAlignment.start,
//                 //         children: [
//                 //           Container(
//                 //             decoration: BoxDecoration(
//                 //               color: Color(0xFFF4F3F8),
//                 //               borderRadius: BorderRadius.circular(15),
//                 //               image: DecorationImage(
//                 //                   image: NetworkImage(
//                 //                       businessController.data2['data']['result']
//                 //                           ['creators'][i]["image"]),
//                 //                   fit: BoxFit.fill),
//                 //             ),
//                 //             height: 110,
//                 //             width: 110,
//                 //           ),
//                 //           SizedBox(
//                 //             height: 8,
//                 //           ),
//                 //           Text(
//                 //             businessController.data2['data']['result']['creators']
//                 //                 [i]["business_name"],
//                 //             overflow: TextOverflow.ellipsis,
//                 //             style: ThreeKmTextConstants.tk14PXLatoGreenSemiBold,
//                 //           ),
//                 //           SizedBox(
//                 //             height: 4,
//                 //           ),
//                 //           Text(
//                 //             tags,
//                 //             overflow: TextOverflow.ellipsis,
//                 //             textAlign: TextAlign.left,
//                 //             style: ThreeKmTextConstants.tk12PXLatoGreenSemiBold,
//                 //           ),
//                 //         ],
//                 //       ),
//                 //     );
//                 //   },
//                 // ),
//                 ),
//           ),
//           Container(
//             height: 36,
//             width: 238,
//             margin: EdgeInsets.symmetric(vertical: 8),
//             child: CustomButton(
//               elevation: 0,
//               borderRadius: BorderRadius.circular(18),
//               color: ThreeKmTextConstants.green,
//               onTap: () {
//                 Navigator.of(context)
//                     .pushNamed(BusinessCategoryView.path, arguments: "");
//               },
//               child: Text(
//                 "View all Local Businesses",
//                 style: ThreeKmTextConstants.tk14PXPoppinsWhiteMedium.copyWith(
//                   letterSpacing: 1.1,
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 32)
//         ],
//       ),
//     );
//   }
// }
