// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:threekm/models/business_controller.dart';
// import 'package:threekm/utils/threekm_textstyles.dart';

// class BusinessNewWidget extends StatelessWidget {
//   final businessController = Get.find<BusinessController>();

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(
//           height: 20,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               margin: const EdgeInsets.only(left: 19.0, bottom: 25),
//               child: Text(
//                 "New on 3km",
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
//               itemCount:
//                   businessController.data2['data']['result']['creators'].length,
//               itemBuilder: (context, i) {
//                 var count = (businessController.data2['data']['result']
//                         ['creators'][i]["tags"] as List<dynamic>)
//                     .length;
//                 var listOfTags = (businessController.data2['data']['result']
//                         ['creators'][i]["tags"] as List<dynamic>)
//                     .sublist(0, count > 2 ? 2 : null)
//                     .toString();
//                 var tags = listOfTags.substring(1, listOfTags.length - 1);
//                 return Container(
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
//                               image: CachedNetworkImageProvider(
//                                   businessController.data2['data']['result']
//                                       ['creators'][i]["image"]),
//                               fit: BoxFit.fill),
//                         ),
//                         height: 110,
//                         width: 110,
//                       ),
//                       SizedBox(
//                         height: 8,
//                       ),
//                       Text(
//                         businessController.data2['data']['result']['creators']
//                             [i]["business_name"],
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
//                         style: ThreeKmTextConstants.tk12PXLatoGreenSemiBold,
//                       ),
//                     ],
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
