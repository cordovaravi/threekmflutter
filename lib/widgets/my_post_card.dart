// import 'dart:developer';
// import 'dart:ui';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:threekm/api_models/response/author_profile_response.dart';
// import 'package:threekm/api_models/response/post_response.dart';
// import 'package:threekm/models/author_profile_controller.dart';
// import 'package:threekm/models/comment_controller.dart';
// import 'package:threekm/models/my_post_controller.dart';
// import 'package:threekm/models/news_controller.dart';
// import 'package:threekm/models/profile_controller.dart';
// import 'package:threekm/pages/author_profile.dart';
// import 'package:threekm/pages/home/home_page.dart';
// import 'package:threekm/pages/signup/sign_up.dart';
// import 'package:threekm/setup/setup.dart';
// import 'package:threekm/utils/constants.dart';
// import 'package:threekm/utils/threekm_textstyles.dart';
// import 'package:threekm/utils/util_methods.dart';

// import 'chewie_video.dart';
// import 'comment_widget.dart';
// import 'news_detail_popup.dart';

// class MyPostCard extends StatefulWidget {
//   final Posts data;
//   final int index;
//   final bool? elevate;
//   const MyPostCard(this.data, {Key? key, this.elevate, required this.index})
//       : super(key: key);
//   @override
//   _MyPostCardState createState() => _MyPostCardState();
// }

// class _MyPostCardState extends State<MyPostCard> {
//   late PageController controller;
//   int index = 0;
//   var _ = Get.put(MyPostController());
//   late bool carousel;
//   late bool showCarouselController;
//   late bool showVideoCarouselController;
//   var commentController = Get.find<CommentController>();
//   Color likeColour = Colors.white;

//   @override
//   void initState() {
//     super.initState();
//     runChecks();
//     // WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
//     //   newsController.checkDetailsCount(widget.index, widget.data.postId!);
//     // });
//   }

//   void showDetails(PostResponse response) async {
//     bool? openComments = await showGeneralDialog(
//       context: context,
//       barrierColor: Colors.black12.withOpacity(0.6), // background color
//       barrierDismissible:
//           false, // should dialog be dismissed when tapped outside
//       transitionDuration: Duration(milliseconds: 400),
//       useRootNavigator: false,
//       pageBuilder: (_context, anim, anim2) {
//         return Material(
//           color: Colors.black.withOpacity(0.3),
//           child: Container(
//             width: MediaQuery.of(_context).size.width,
//             height: MediaQuery.of(_context).size.height,
//             decoration: BoxDecoration(
//               color: Colors.black.withOpacity(0.3),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: 30,
//                 ),
//                 InkWell(
//                   onTap: () {
//                     Navigator.of(_context).pop(false);
//                     // setState(() => showNewsDetails = !showNewsDetails);
//                   },
//                   child: Container(
//                     height: 40,
//                     width: 40,
//                     margin: EdgeInsets.only(left: 18),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.white.withOpacity(0.8),
//                     ),
//                     child: Icon(
//                       Icons.arrow_back,
//                       color: Color(0xFF0F0F2D),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 12,
//                 ),
//                 Expanded(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(30),
//                         topRight: Radius.circular(30),
//                       ),
//                     ),
//                     child: MyNewsDetailPopup(
//                       response,
//                       index: index,
//                       onTapComment: () {
//                         // setState(() {
//                         //   showNewsDetails = false;
//                         //   showComments = true;
//                         // });
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//     if (openComments != null && openComments) {
//       // showComments();
//     }
//   }

//   // void showComments() async {
//   //   await showGeneralDialog(
//   //     context: context,
//   //     barrierColor: Colors.black12.withOpacity(0.6), // background color
//   //     barrierDismissible:
//   //         false, // should dialog be dismissed when tapped outside
//   //     transitionDuration: Duration(milliseconds: 400),
//   //     useRootNavigator: false,
//   //     pageBuilder: (_context, anim, anim2) {
//   //       return Material(
//   //         color: Colors.black.withOpacity(0.3),
//   //         child: CommentPop(
//   //           newsDetailsData: widget.data,
//   //           onTap: () => Navigator.of(_context).pop(),
//   //         ),
//   //       );
//   //     },
//   //   );
//   // }

//   void runChecks() {
//     if (widget.data.images != null) {
//       controller = PageController(viewportFraction: 1);
//       carousel = widget.data.images!.length > 0 ? true : false;
//       showCarouselController =
//           carousel && widget.data.images!.length > 1 ? true : false;
//       showVideoCarouselController =
//           carousel && widget.data.videos!.length > 1 ? true : false;
//     } else {
//       controller = PageController(viewportFraction: 1);
//       carousel = false;
//       showCarouselController = false;
//       showVideoCarouselController = false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 509,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: widget.data is PostResponse
//               ? [Colors.white, Colors.white]
//               : [
//                   Color(0xffFEDA01),
//                   Color(0xffFFCA77),
//                 ],
//         ),
//       ),
//       alignment: Alignment.topCenter,
//       margin: EdgeInsets.only(
//           left: widget.data is PostResponse &&
//                   (widget.elevate != null && widget.elevate == true)
//               ? 16
//               : 0,
//           right: widget.data is PostResponse &&
//                   (widget.elevate != null && widget.elevate == true)
//               ? 16
//               : 0,
//           bottom: 40),
//       child: GestureDetector(
//         // onLongPress: () => print("Long Pressed"),
//         // onTapCancel: () => print("Cancel"),
//         onTap: () {
//           // widget.onTapDetails(widget.data);
//           // widget.onTapForIndex(widget.index);
//           log(widget.data.toString(), name: "Like check");
//           // showDetails(widget.data);
//         },
//         child: Stack(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius:
//                     BorderRadius.circular(widget.data is PostResponse ? 10 : 0),
//                 boxShadow: [
//                   if (widget.data is PostResponse) ...{
//                     BoxShadow(
//                         color: Color(0xFF32335E26),
//                         offset: Offset(0, 0),
//                         blurRadius: 15,
//                         spreadRadius: -5),
//                   }
//                 ],
//               ),
//               child: Card(
//                 borderOnForeground: false,
//                 elevation: widget.data is PostResponse &&
//                         (widget.elevate != null && widget.elevate == true)
//                     ? 0
//                     : 0,
//                 color: widget.data is PostResponse
//                     ? Colors.white
//                     : Colors.transparent,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: 11,
//                     ),
//                     GestureDetector(
//                         onTap: () =>
//                             Navigator.of(context).pushNamed(AuthorProfile.path),
//                         child: Row(
//                           children: [
//                             SizedBox(
//                               width: 16,
//                             ),
//                             widget.data.author != null
//                                 ? CircleAvatar(
//                                     backgroundImage: CachedNetworkImageProvider(
//                                         widget.data.author!.image!),
//                                   )
//                                 : CircleAvatar(
//                                     backgroundImage:
//                                         AssetImage("assets/avatar.png"),
//                                   ),
//                             SizedBox(
//                               width: 8,
//                             ),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Expanded(
//                                         child: Text(
//                                           widget.data.author != null
//                                               ? widget.data.author!.name!
//                                               : "User",
//                                           overflow: TextOverflow.ellipsis,
//                                           style: ThreeKmTextConstants
//                                               .tk12PXPoppinsBlackSemiBold
//                                               .copyWith(
//                                                   fontSize: 13,
//                                                   fontWeight: FontWeight.w600),
//                                         ),
//                                       ),
//                                       SizedBox(width: 6),
//                                       if (widget.data.status != null
//                                       /* && widget.data.isVerified != null &&
//                                           widget.data.isVerified == true*/
//                                       ) ...{
//                                         Image.asset(
//                                           "assets/icons-guarantee.png",
//                                           width: 20,
//                                           height: 20,
//                                         ),
//                                       }
//                                     ],
//                                   ),
//                                   Row(
//                                     children: [
//                                       Text(
//                                         widget.data.authorClassification != null
//                                             ? widget.data.authorClassification!
//                                             : "User",
//                                         style: ThreeKmTextConstants
//                                             .tk11PXLatoGreyBold
//                                             .copyWith(
//                                           fontSize: 11,
//                                           fontWeight: FontWeight.normal,
//                                           color: Color(0xFF8A939B),
//                                           fontFeatures: [
//                                             FontFeature.enable('frac'),
//                                             FontFeature.enable('smcp'),
//                                           ],
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: 12,
//                                       ),
//                                       Container(
//                                         height: 5,
//                                         width: 5,
//                                         decoration: BoxDecoration(
//                                             color: Color(0XFFC4C9CD),
//                                             shape: BoxShape.circle),
//                                       ),
//                                       SizedBox(
//                                         width: 12,
//                                       ),
//                                       Text(
//                                         widget.data.createdDate ?? "",
//                                         style: textStyleLato.copyWith(
//                                             fontSize: 10,
//                                             fontWeight: FontWeight.normal,
//                                             color: Colors.grey),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               margin: EdgeInsets.only(right: 8, left: 36),
//                               child: Icon(Icons.more_vert),
//                             )
//                           ],
//                         )),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     Container(
//                       height: 254,
//                       child: PageView(
//                         controller: controller,
//                         onPageChanged: (v) => setState(() => index = v),
//                         children: carousel
//                             ? (widget.data.images as List<dynamic>)
//                                 .map((e) => CachedNetworkImage(
//                                       imageUrl: e,
//                                       fit: BoxFit.cover,
//                                       placeholder: (context, url) =>
//                                           CupertinoActivityIndicator(),
//                                     ))
//                                 .toList()
//                             : (widget.data.videos as List<dynamic>)
//                                 .map((e) =>
//                                     ChewieVideo(e['src'], index: widget.index))
//                                 .toList(),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 4,
//                     ),
//                     Container(
//                       height: 35,
//                       child: Stack(
//                         children: [
//                           Positioned(
//                             bottom: 2,
//                             left: 90,
//                             child: Container(
//                               height: 30,
//                               width: 30,
//                               padding: EdgeInsets.all(0),
//                               decoration: BoxDecoration(
//                                   color: Colors.red, shape: BoxShape.circle),
//                               child: Center(
//                                 child: GetBuilder<MyPostController>(
//                                   builder: (_controller) => Text(
//                                     _controller.posts!.data!.result!
//                                                 .posts![widget.index].likes !=
//                                             null
//                                         ? calculateComments(
//                                             _controller.posts!.data!.result!
//                                                 .posts![widget.index].likes!,
//                                           )
//                                         : calculateComments(0),
//                                     textAlign: TextAlign.center,
//                                     style: textStyle.copyWith(
//                                         color: Colors.white, fontSize: 11),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             bottom: 4,
//                             left: 12,
//                             child: Center(
//                               child: Text(
//                                 "👍❤️😩",
//                                 textAlign: TextAlign.center,
//                                 style: textStyle.copyWith(fontSize: 20),
//                               ),
//                             ),
//                           ),
//                           if (showCarouselController) ...{
//                             Container(
//                               height: 35,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: List.generate(
//                                     widget.data.images!.length, (i) {
//                                   return Container(
//                                     width: i == index ? 8 : 6,
//                                     height: i == index ? 8 : 6,
//                                     margin: EdgeInsets.only(right: 2),
//                                     decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color: i == index
//                                             ? Colors.blue
//                                             : Colors.grey.withOpacity(0.5)),
//                                   );
//                                 }),
//                               ),
//                             )
//                           }
//                           // else if (showVideoCarouselController) ...{
//                           //   Container(
//                           //     height: 35,
//                           //     child: Row(
//                           //       mainAxisAlignment: MainAxisAlignment.center,
//                           //       crossAxisAlignment: CrossAxisAlignment.center,
//                           //       children: List.generate(
//                           //           widget.data.videos!.length, (i) {
//                           //         return Container(
//                           //           width: i == index ? 8 : 6,
//                           //           height: i == index ? 8 : 6,
//                           //           margin: EdgeInsets.only(right: 2),
//                           //           decoration: BoxDecoration(
//                           //             shape: BoxShape.circle,
//                           //             color: i == index
//                           //                 ? Colors.blue
//                           //                 : Colors.grey.withOpacity(0.5),
//                           //           ),
//                           //         );
//                           //       }),
//                           //     ),
//                           //   )
//                           // }
//                           else ...{
//                             Container(height: 35)
//                           },
//                           Positioned(
//                             bottom: 4,
//                             right: 12,
//                             child: Text(
//                               "${widget.data.views ?? "0"} Views",
//                               style: ThreeKmTextConstants.tk11PXLatoGreyBold
//                                   .copyWith(
//                                       color: Colors.black,
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.w400),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Divider(
//                       color: Colors.grey.withOpacity(0.2),
//                       thickness: 1,
//                     ),
//                     Row(children: [
//                       Expanded(
//                           child: Container(
//                         // height: 40,
//                         margin: EdgeInsets.only(left: 32, right: 32, bottom: 3),
//                         child: Text(
//                           widget.data.headline != null
//                               ? widget.data.headline!
//                               : "",
//                           textAlign: TextAlign.center,
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                           style: ThreeKmTextConstants.tk14PXPoppinsBlackBold
//                               .copyWith(
//                                   fontWeight: FontWeight.w900, fontSize: 14),
//                         ),
//                       )),
//                     ]),
//                     Container(
//                       // height: 60,
//                       margin: EdgeInsets.symmetric(horizontal: 32),
//                       child: Text(
//                         widget.data.story != null &&
//                                 widget.data.story!.length > 0
//                             ? removeHtml(widget.data.story ?? "")
//                             : "",
//                         maxLines: 3,
//                         overflow: TextOverflow.ellipsis,
//                         textAlign: TextAlign.center,
//                         style: GoogleFonts.lato(
//                           fontWeight: FontWeight.w500,
//                           color: Color(0xFF0F0F2D),
//                           fontSize: 14,
//                           height: 1.3,
//                         ),
//                       ),
//                       //     WebviewFromString(
//                       //   widget.data["story"] ?? "",
//                       // ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: Transform.translate(
//                 offset: Offset(0, 22),
//                 child: GetBuilder<MyPostController>(
//                   builder: (_controller) => Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         margin: EdgeInsets.only(right: 31.48),
//                         child: PhysicalModel(
//                           elevation: 5,
//                           shadowColor: Colors.pinkAccent.withOpacity(0.2),
//                           shape: BoxShape.circle,
//                           color: Colors.transparent,
//                           child: InkWell(
//                               onTap: () async {
//                                 _controller.like(
//                                     widget.index, widget.data.postId!);
//                               },
//                               child: GetBuilder<MyPostController>(
//                                 builder: (_controller) =>
//                                     // !_controller.posts!.data!.result!.posts![widget.index].isLiked!
//                                     false
//                                         ? Container(
//                                             padding: EdgeInsets.all(6),
//                                             decoration: BoxDecoration(
//                                               shape: BoxShape.circle,
//                                               color: likeColour,
//                                             ),
//                                             child: Center(
//                                               child: Image.asset(
//                                                 "assets/thumbs-up.png",
//                                                 height: 40,
//                                                 width: 40,
//                                               ),
//                                             ),
//                                           )
//                                         : Container(
//                                             padding: EdgeInsets.all(6),
//                                             decoration: BoxDecoration(
//                                               shape: BoxShape.circle,
//                                               color: Colors.redAccent
//                                                   .withOpacity(0.9),
//                                             ),
//                                             child: Center(
//                                               child: Image.asset(
//                                                 "assets/thumbs_up_red.png",
//                                                 height: 40,
//                                                 width: 40,
//                                               ),
//                                             ),
//                                           ),
//                               )),
//                         ),
//                       ),
//                       PhysicalModel(
//                         elevation: 5,
//                         shadowColor: Colors.blue.withOpacity(0.15),
//                         shape: BoxShape.circle,
//                         color: Colors.transparent,
//                         child: InkWell(
//                           onTap: () async {
//                             print("Tapped comment");
//                             // showComments();
//                           },
//                           child: Container(
//                             padding: EdgeInsets.all(13),
//                             decoration: BoxDecoration(
//                                 shape: BoxShape.circle, color: Colors.white),
//                             child: Center(
//                               child: Image.asset(
//                                 "assets/icons-topic.png",
//                                 height: 28,
//                                 width: 28,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Container(
//                         margin: EdgeInsets.only(left: 31.48),
//                         child: PhysicalModel(
//                           elevation: 5,
//                           shadowColor: Colors.green.withOpacity(0.15),
//                           shape: BoxShape.circle,
//                           color: Colors.transparent,
//                           child: Container(
//                             padding: EdgeInsets.all(13),
//                             decoration: BoxDecoration(
//                                 shape: BoxShape.circle, color: Colors.white),
//                             child: Center(
//                               child: Image.asset(
//                                 "assets/icons-share.png",
//                                 height: 28,
//                                 width: 28,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
