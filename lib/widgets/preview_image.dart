// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:threekm/models/new_post_controller.dart';
// import 'package:threekm/pages/post/camera_page.dart';
// import 'package:threekm/utils/threekm_textstyles.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';

// class PreviewImageX extends StatelessWidget {
//   final File? file;
//   final int index;
//   final bool currentlySelected;
//   final Future<Uint8List?>? thumb;
//   PreviewImageX(
//       {this.file,
//       required this.index,
//       required this.currentlySelected,
//       this.thumb});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 52,
//       width: 52,
//       margin: EdgeInsets.only(right: 14),
//       child: Stack(
//         children: [
//           if (file != null) ...{
//             Container(
//               height: 40,
//               width: 40,
//               margin: EdgeInsets.only(top: 12, right: 12),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 border: currentlySelected
//                     ? Border.all(color: Color(0xFF3E7EFF), width: 1.5)
//                     : Border.all(color: Colors.transparent),
//                 image:
//                     DecorationImage(image: FileImage(file!), fit: BoxFit.fill),
//               ),
//             ),
//           } else ...{
//             FutureBuilder<Uint8List?>(
//                 future: thumb,
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     return Container(
//                       height: 40,
//                       width: 40,
//                       margin: EdgeInsets.only(top: 12, right: 12),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         border: currentlySelected
//                             ? Border.all(color: Color(0xFF3E7EFF), width: 1.5)
//                             : Border.all(color: Colors.transparent),
//                         image: DecorationImage(
//                             image: MemoryImage(snapshot.data!),
//                             fit: BoxFit.fill),
//                       ),
//                     );
//                   }
//                   return Container(
//                     height: 40,
//                     width: 40,
//                     decoration: BoxDecoration(),
//                   );
//                 }),
//           },
//           Transform.translate(
//             offset: Offset(28, 0),
//             child: Container(
//               height: 24,
//               width: 24,
//               decoration:
//                   BoxDecoration(color: Colors.white, shape: BoxShape.circle),
//               child: Center(
//                 child: Text(
//                   "$index",
//                   style:
//                       ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold.copyWith(
//                     color: Color(0xFF0F0F2D),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Transform.translate(
//             offset: Offset(-25, 15),
//             child: Center(
//               child: Icon(Icons.star_rounded, color: Colors.yellow),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class PreviewImages extends StatelessWidget {
//   final postController = Get.find<NewPostController>();
//   final void Function(int) onChangeIndex;
//   PreviewImages({required this.onChangeIndex});

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<NewPostController>(
//       builder: (controller) => Container(
//         width: MediaQuery.of(context).size.width,
//         height: 82,
//         child: ListView.builder(
//           padding: EdgeInsets.only(top: 20, left: 18, right: 18),
//           scrollDirection: Axis.horizontal,
//           itemCount: controller.images.length + 1,
//           itemBuilder: (context, _index) {
//             if (_index < controller.images.length) {
//               return InkWell(
//                 onTap: () => onChangeIndex(_index),
//                 child: PreviewImageX(
//                   index: _index + 1,
//                   currentlySelected: controller.index == _index,
//                   file: controller.images[_index].status == CameraStatus.CAMERA
//                       ? controller.images[_index].file
//                       : null,
//                   thumb: controller.images[_index].status == CameraStatus.VIDEO
//                       ? VideoThumbnail.thumbnailData(
//                           video: controller.images[_index].file.path,
//                           imageFormat: ImageFormat.JPEG,
//                         )
//                       : null,
//                 ),
//               );
//             } else {
//               return Container(
//                 height: 52,
//                 width: 52,
//                 margin: EdgeInsets.only(right: 14),
//                 padding: EdgeInsets.only(bottom: 10),
//                 child: InkWell(
//                   onTap: () => Navigator.of(context).pop(),
//                   child: Container(
//                     height: 40,
//                     width: 40,
//                     margin: EdgeInsets.only(top: 12, right: 12),
//                     decoration: BoxDecoration(
//                       color: Colors.grey.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Icon(Icons.add, size: 14, color: Colors.white),
//                   ),
//                 ),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
