// import 'package:flutter/material.dart';
// import 'package:threekm/api_models/response/post_response.dart';
// import 'package:threekm/widgets/news_comment_popup.dart';

// class CommentPop extends StatelessWidget {
//   PostResponse? newsDetailsData;
//   VoidCallback? onTap;
//   CommentPop({this.newsDetailsData, this.onTap});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       clipBehavior: Clip.antiAlias,
//       // width: MediaQuery.of(context).size.width,
//       // height: MediaQuery.of(context).size.height - 101,
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(0.3),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             height: 44,
//           ),
//           InkWell(
//             onTap: onTap,
//             child: Container(
//               height: 40,
//               width: 40,
//               margin: EdgeInsets.only(left: 18),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white.withOpacity(0.8),
//               ),
//               child: Icon(
//                 Icons.arrow_back,
//                 color: Color(0xFF0F0F2D),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 16,
//           ),
//           Expanded(
//             child: Container(
//               clipBehavior: Clip.antiAlias,
//               // constraints: BoxConstraints(
//               //   maxHeight: 800,
//               //   minHeight: 100,
//               // ),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(30),
//                   topRight: Radius.circular(30),
//                 ),
//               ),
//               child: NewsCommentPopup(
//                 newsDetailsData!,
//                 heightOfWebView: 400,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
