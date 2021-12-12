// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:threekm/models/business_controller.dart';
// import 'package:threekm/pages/business/business_details.dart';
// import 'package:threekm/pages/business_category_view.dart';
// import 'package:threekm/utils/threekm_textstyles.dart';

// class BusinessTrendingWidget extends StatelessWidget {
//   final businessController = Get.find<BusinessController>();

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               margin: const EdgeInsets.only(left: 19.0, bottom: 25),
//               child: Text(
//                 "Trending",
//                 style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold,
//               ),
//             ),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   margin: const EdgeInsets.only(right: 10),
//                   child: Text(
//                     "View All",
//                     style: ThreeKmTextConstants.tk14PXPoppinsGreenSemiBold,
//                   ),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(right: 19),
//                   child: Transform.translate(
//                     offset: Offset(0, -2),
//                     child: Icon(
//                       Icons.arrow_forward,
//                       color: ThreeKmTextConstants.green,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         Obx(
//           () => Container(
//             margin: EdgeInsets.only(left: 19),
//             height: 190,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: businessController.extractedBusinessList.length,
//               itemBuilder: (context, i) {
//                 var count = (businessController.extractedBusinessList[i]["tags"]
//                         as List<dynamic>)
//                     .length;
//                 var listOfTags = (businessController.extractedBusinessList[i]
//                         ["tags"] as List<dynamic>)
//                     .sublist(0, count > 2 ? 2 : null)
//                     .toString();
//                 var tags = listOfTags.substring(1, listOfTags.length - 1);
//                 return GestureDetector(
//                   onTap: () {
//                     print(businessController.extractedBusinessList[i]);
//                     Navigator.of(context).pushNamed(BusinessDetailsPage.path,
//                         arguments: businessController.extractedBusinessList[i]
//                             ['creator_id']);
//                   },
//                   child: Container(
//                     width: 110,
//                     margin: EdgeInsets.only(right: 52),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Color(0xFFF4F3F8),
//                             borderRadius: BorderRadius.circular(15),
//                             border: Border.all(
//                               color: Color(0xFFF4F3F8),
//                             ),
//                             image: DecorationImage(
//                                 image: CachedNetworkImageProvider(
//                                     businessController.extractedBusinessList[i]
//                                         ["image"]),
//                                 fit: BoxFit.fill),
//                           ),
//                           height: 110,
//                           width: 110,
//                         ),
//                         SizedBox(
//                           height: 8,
//                         ),
//                         Text(
//                           businessController.extractedBusinessList[i]
//                               ["business_name"],
//                           overflow: TextOverflow.ellipsis,
//                           style: GoogleFonts.poppins(
//                             color: Color(0xFF0F0F2D),
//                             fontWeight: FontWeight.w600,
//                             fontSize: 14,
//                           ),
//                         ),
//                         SizedBox(
//                           height: 4,
//                         ),
//                         Text(
//                           tags,
//                           overflow: TextOverflow.ellipsis,
//                           textAlign: TextAlign.left,
//                           style: GoogleFonts.lato(
//                             color: Color(0xFF43B978),
//                             fontWeight: FontWeight.w600,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class BusinessWidgetDymanic extends StatelessWidget {
//   final BusinessController businessController = Get.find<BusinessController>();
//   final String title;
//   final List<dynamic> items;
//   BusinessWidgetDymanic({required this.title, required this.items});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               margin: const EdgeInsets.only(left: 19.0, bottom: 25),
//               child: Text(
//                 "$title",
//                 style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold,
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 Navigator.of(context)
//                     .pushNamed(BusinessCategoryView.path, arguments: title);
//               },
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.only(right: 10),
//                     child: Text(
//                       "View All",
//                       style: ThreeKmTextConstants.tk14PXPoppinsGreenSemiBold,
//                     ),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.only(right: 19),
//                     child: Transform.translate(
//                       offset: Offset(0, -2),
//                       child: Icon(
//                         Icons.arrow_forward,
//                         color: ThreeKmTextConstants.green,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         Container(
//           margin: EdgeInsets.only(left: 19),
//           height: 190,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: items.length,
//             itemBuilder: (context, i) {
//               var tags = items[i]['tags']
//                   .toString()
//                   .substring(1, items[i]['tags'].toString().length - 1);
//               return GestureDetector(
//                 onTap: () {
//                   print(businessController.extractedBusinessList[i]);
//                   Navigator.of(context).pushNamed(BusinessDetailsPage.path,
//                       arguments: items[i]['creator_id']);
//                 },
//                 child: Container(
//                   width: 110,
//                   margin: EdgeInsets.only(right: 52),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Color(0xFFF4F3F8),
//                           borderRadius: BorderRadius.circular(15),
//                           border: Border.all(
//                             color: Color(0xFFF4F3F8),
//                           ),
//                           image: DecorationImage(
//                               image:
//                                   CachedNetworkImageProvider(items[i]["image"]),
//                               fit: BoxFit.fill),
//                         ),
//                         height: 110,
//                         width: 110,
//                       ),
//                       SizedBox(
//                         height: 8,
//                       ),
//                       Text(
//                         items[i]["business_name"],
//                         overflow: TextOverflow.ellipsis,
//                         style: GoogleFonts.poppins(
//                           color: Color(0xFF0F0F2D),
//                           fontWeight: FontWeight.w600,
//                           fontSize: 14,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 4,
//                       ),
//                       Text(
//                         tags,
//                         overflow: TextOverflow.ellipsis,
//                         textAlign: TextAlign.left,
//                         style: GoogleFonts.lato(
//                           color: Color(0xFF43B978),
//                           fontWeight: FontWeight.w600,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
