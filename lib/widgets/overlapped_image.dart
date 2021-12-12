// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';

// class OverlappedImage extends StatelessWidget {
//   final List<String> images;
//   OverlappedImage(this.images) : super(key: UniqueKey());
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: images
//           .asMap()
//           .entries
//           .map((e) => Transform.translate(
//                 offset: Offset(e.key > 0 ? -10 : 0, 0),
//                 child: Container(
//                   height: 40,
//                   width: 40,
//                   decoration: BoxDecoration(
//                       border: Border.all(color: Colors.white, width: 2),
//                       image: DecorationImage(
//                           image: CachedNetworkImageProvider(e.value), fit: BoxFit.fill),
//                       shape: BoxShape.circle),
//                 ),
//               ))
//           .toList(),
//     );
//   }
// }
