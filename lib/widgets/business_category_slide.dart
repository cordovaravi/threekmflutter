// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:threekm/utils/utils.dart';
// import 'package:threekm/models/business_controller.dart';
// import 'package:threekm/pages/business_category_view.dart';
// import 'package:threekm/utils/threekm_textstyles.dart';

// import '../models/biz_images_data.dart';

// class BusinessCategorySlide extends StatefulWidget {
//   @override
//   _BusinessCategorySlideState createState() => _BusinessCategorySlideState();
// }

// class _BusinessCategorySlideState extends State<BusinessCategorySlide> {
//   final businessController = Get.find<BusinessController>();
//   ScrollController controller = ScrollController();

//   @override
//   void initState() {
//     controller.addListener(() {
//       if (controller.position.maxScrollExtent - 50 <= controller.offset) {
//         businessController.pageViewIndex.value =
//             (businessController.data["Result"]['categories']["Result"].length /
//                         6.0)
//                     .ceil() -
//                 1;
//       } else {
//         businessController.pageViewIndex.value =
//             (controller.offset / MediaQuery.of(context).size.width).truncate();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<BusinessController>(
//       builder: (_controller) => GridView.builder(
//         controller: controller,
//         padding: EdgeInsets.only(left: 18, right: 5),
//         itemCount: _controller.data["Result"]['categories']["Result"].length,
//         shrinkWrap: true,
//         scrollDirection: Axis.horizontal,
//         physics: AlwaysScrollableScrollPhysics(),
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 16,
//             mainAxisSpacing: 12,
//             childAspectRatio: 1.2),
//         itemBuilder: (BuildContext context, int i) {
//           return Column(
//             children: [
//               Expanded(
//                 child: Container(
//                   padding: EdgeInsets.only(top: 8, left: 8, right: 8),
//                   decoration: BoxDecoration(
//                     color: Color(0xFFF4F3F8),
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: CachedNetworkImage(
//                     imageUrl: _controller.data["Result"]['categories']["Result"]
//                         [i]['image_link'],
//                   ),
//                   height: 100,
//                   width: 100,
//                 ),
//               ),
//               SizedBox(
//                 height: 8,
//               ),
//               Text(
//                 _controller.data["Result"]['categories']["Result"][i]['name'],
//                 style: ThreeKmTextConstants.tk12PXPoppinsBlackSemiBold.copyWith(
//                   color: Color(0xFF0F0F2D),
//                 ),
//               )
//             ],
//           ).onTap(() => Navigator.of(context).pushNamed(
//               BusinessCategoryView.path,
//               arguments: _controller.data["Result"]['categories']["Result"][i]
//                       ['name']
//                   .split(" ")[0]));
//         },
//       ),
//     );
//   }
// }
