// import 'dart:developer';
// import 'dart:math' as math;
// import 'dart:ui';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:threekm/api_models/request/all_comments_request/all_comments_request.dart';
// import 'package:threekm/api_models/response/advert_response.dart';
// import 'package:threekm/api_models/response/post_response.dart';
// import 'package:threekm/api_models/response/post_response_base.dart';
// import 'package:threekm/models/comment_controller.dart';
// import 'package:threekm/models/news_category_controller.dart';
// import 'package:threekm/models/news_controller.dart';
// import 'package:threekm/pages/author_profile.dart';
// import 'package:threekm/pages/business/business_details.dart';
// import 'package:threekm/pages/home/home_page.dart';
// import 'package:threekm/pages/news_category_page.dart';
// import 'package:threekm/pages/signup/sign_up.dart';
// import 'package:threekm/repository/home_repository.dart';
// import 'package:threekm/setup/setup.dart';
// import 'package:threekm/utils/constants.dart';
// import 'package:threekm/utils/threekm_textstyles.dart';
// import 'package:threekm/utils/util_methods.dart';
// import 'package:threekm/widgets/news_details_popup_generic.dart';

// import 'chewie_video.dart';
// import 'comment_widget.dart';
// import 'news_detail_popup.dart';

// class NewsCard extends StatefulWidget {
//   final PostResponseBase data;
//   final int index;
//   final bool? elevate;
//   const NewsCard(this.data, {Key? key, this.elevate, required this.index})
//       : super(key: key);
//   @override
//   _NewsCardState createState() => _NewsCardState();
// }

// class _NewsCardState extends State<NewsCard> {
//   late PageController controller;
//   int index = 0;
//   var newsController = Get.find<NewsController>();
//   late bool carousel;
//   late bool showCarouselController;
//   late bool showVideoCarouselController;
//   var commentController = Get.find<CommentController>();
//   Color likeColour = Colors.white;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.data is PostResponse) {
//       runChecks();
//     } else if (widget.data is AdvertResponse) {
//       controller = PageController(
//           viewportFraction:
//               (widget.data as AdvertResponse).images!.length > 1 ? 0.9 : 1);
//       carousel =
//           (widget.data as AdvertResponse).images!.length > 0 ? true : false;
//       showVideoCarouselController =
//           carousel && (widget.data as AdvertResponse).videos!.length > 1
//               ? true
//               : false;
//       showCarouselController =
//           carousel && (widget.data as AdvertResponse).images!.length > 1
//               ? true
//               : false;
//     }
//   }

//   void showDetails() async {
//     print(
//         "${(newsController.filteredGeoPageList![index] as PostResponse).postId}");
//     bool? openComments = await showGeneralDialog(
//       context: context,
//       barrierColor: Colors.black12.withOpacity(0.6), // background color
//       barrierDismissible:
//           false, // should dialog be dismissed when tapped outside
//       routeSettings: RouteSettings(name: "details"),
//       transitionDuration: Duration(milliseconds: 400),
//       useRootNavigator: false,
//       pageBuilder: (_context, anim, anim2) {
//         return Material(
//           color: Colors.black.withOpacity(0.1),
//           child: Container(
//             width: MediaQuery.of(_context).size.width,
//             height: MediaQuery.of(_context).size.height,
//             decoration: BoxDecoration(
//               color: Colors.black.withOpacity(0.1),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: 44,
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
//                   height: 16,
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
//                     child: NewsDetailPopup(
//                       (newsController.filteredGeoPageList![widget.index]
//                           as PostResponse),
//                       index: widget.index,
//                       onTapComment: () {},
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
//       showComments();
//     }
//   }

//   void showComments() async {
//     await showGeneralDialog(
//       context: context,
//       barrierColor: Colors.black.withOpacity(0.1), // background color
//       barrierDismissible:
//           false, // should dialog be dismissed when tapped outside
//       transitionDuration: Duration(milliseconds: 400),
//       routeSettings: RouteSettings(name: "comments"),
//       useRootNavigator: false,
//       pageBuilder: (_context, anim, anim2) {
//         return Material(
//           color: Colors.black.withOpacity(0.3),
//           child: CommentPop(
//             newsDetailsData: widget.data as PostResponse,
//             onTap: () => Navigator.of(_context).pop(),
//           ),
//         );
//       },
//     );
//   }

//   void runChecks() {
//     if ((widget.data as PostResponse).images != null) {
//       controller = PageController(viewportFraction: 1);
//       carousel =
//           (widget.data as PostResponse).images!.length > 0 ? true : false;
//       showCarouselController =
//           carousel && (widget.data as PostResponse).images!.length > 1
//               ? true
//               : false;
//     } else {
//       controller = PageController(viewportFraction: 1);
//       carousel = false;
//       showCarouselController = false;
//     }
//     if ((widget.data as PostResponse).videos != null) {
//       showVideoCarouselController =
//           carousel && (widget.data as PostResponse).videos!.length > 1
//               ? true
//               : false;
//       controller = PageController(
//           viewportFraction:
//               (widget.data as PostResponse).videos!.length > 1 ? 1 : 1);
//     } else {
//       showVideoCarouselController = false;
//       controller = PageController(viewportFraction: 1);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 580,
//       alignment: Alignment.topCenter,
//       margin: EdgeInsets.only(
//           left: widget.data is PostResponse &&
//                   (widget.elevate != null && widget.elevate == true)
//               ? 16
//               : 0,
//           right: widget.data is PostResponse &&
//                   (widget.elevate != null && widget.elevate == true)
//               ? 16
//               : 0),
//       child: InkWell(
//         onFocusChange: (v) => print("Focus Changed $v"),
//         onTap: () {
//           if (widget.data is PostResponse) {
//             // widget.onTapDetails(widget.data);
//             // widget.onTapForIndex(widget.index);
//             log(widget.data.toString(), name: "Like check");
//             log((widget.data as PostResponse).isLiked.toString(),
//                 name: "Like check");
//             showDetails();
//           } else {
//             print(widget.data.toString());
//           }
//           print("tapped");
//         },
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(
//                       widget.data is PostResponse ? 10 : 0,
//                     ),
//                     boxShadow: [
//                       if (widget.data is PostResponse) ...{
//                         BoxShadow(
//                           color: Color(0xFF32335E26),
//                           offset: Offset(0, 0),
//                           blurRadius: 10,
//                           spreadRadius: -5,
//                         ),
//                       }
//                     ],
//                   ),
//                   child: Card(
//                     borderOnForeground: false,
//                     elevation: widget.data is PostResponse &&
//                             (widget.elevate != null && widget.elevate == true)
//                         ? 0
//                         : 0,
//                     color: widget.data is PostResponse
//                         ? Colors.white
//                         : Colors.transparent,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(
//                             widget.data is PostResponse ? 10 : 0)),
//                     child: Column(
//                       children: [
//                         if (widget.data is PostResponse) ...{
//                           SizedBox(
//                             height: 10,
//                           ),
//                           GestureDetector(
//                               onTap: () => Navigator.of(context).pushNamed(
//                                     AuthorProfile.path,
//                                     arguments: {
//                                       "id": (widget.data as PostResponse)
//                                           .author!
//                                           .id,
//                                       "avatar": (widget.data as PostResponse)
//                                           .author!
//                                           .image,
//                                       "user_name": (widget.data as PostResponse)
//                                           .author!
//                                           .name,
//                                     },
//                                   ),
//                               child: Row(
//                                 children: [
//                                   SizedBox(
//                                     width: 13,
//                                   ),
//                                   (widget.data as PostResponse).author != null
//                                       ? CircleAvatar(
//                                           radius: 18,
//                                           backgroundImage:
//                                               CachedNetworkImageProvider(
//                                                   (widget.data as PostResponse)
//                                                       .author!
//                                                       .image!),
//                                         )
//                                       : CircleAvatar(
//                                           backgroundImage:
//                                               AssetImage("assets/avatar.png"),
//                                         ),
//                                   SizedBox(
//                                     width: 7,
//                                   ),
//                                   Expanded(
//                                     child: Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Container(
//                                               constraints: BoxConstraints(
//                                                 minWidth: 50,
//                                                 maxWidth: 164,
//                                               ),
//                                               child: Container(
//                                                 child: Text(
//                                                   (widget.data as PostResponse)
//                                                               .author !=
//                                                           null
//                                                       ? (widget.data
//                                                               as PostResponse)
//                                                           .author!
//                                                           .name!
//                                                       : "User",
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                   style: ThreeKmTextConstants
//                                                       .tk12PXPoppinsBlackSemiBold
//                                                       .copyWith(
//                                                     fontSize: 12,
//                                                     color: Color(0xFF232629),
//                                                     fontWeight: FontWeight.w500,
//                                                   ),
//                                                   maxLines: 1,
//                                                 ),
//                                               ),
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   (widget.data as PostResponse)
//                                                               .authorClassification !=
//                                                           null
//                                                       ? (widget.data
//                                                               as PostResponse)
//                                                           .authorClassification!
//                                                       : "User",
//                                                   style: ThreeKmTextConstants
//                                                       .tk11PXLatoGreyBold
//                                                       .copyWith(
//                                                     fontSize: 10,
//                                                     fontWeight:
//                                                         FontWeight.normal,
//                                                     color: Color(0xFF8A939B),
//                                                     fontFeatures: [
//                                                       FontFeature.enable(
//                                                           'frac'),
//                                                       FontFeature.enable(
//                                                           'smcp'),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 17,
//                                                 ),
//                                                 Container(
//                                                   height: 5,
//                                                   width: 5,
//                                                   decoration: BoxDecoration(
//                                                       color: Color(0XFFC4C9CD),
//                                                       shape: BoxShape.circle),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 10,
//                                                 ),
//                                                 Text(
//                                                   (widget.data as PostResponse)
//                                                           .createdDate ??
//                                                       "",
//                                                   style: textStyleLato.copyWith(
//                                                     fontSize: 8,
//                                                     fontWeight: FontWeight.w700,
//                                                     color: Color(0xFFA7AEB4),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                         space(width: 19),
//                                         if ((widget.data as PostResponse)
//                                                     .status !=
//                                                 null &&
//                                             (widget.data as PostResponse)
//                                                     .isVerified ==
//                                                 true) ...{
//                                           Image.asset(
//                                             "assets/icons-guarantee.png",
//                                             width: 20,
//                                             height: 20,
//                                           ),
//                                         }
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     margin: EdgeInsets.only(right: 8, left: 36),
//                                     child: Icon(
//                                       Icons.more_vert,
//                                       color: Color(0xFF979EA4),
//                                     ),
//                                   )
//                                 ],
//                               )),
//                           SizedBox(
//                             height: 12,
//                           ),
//                           Container(
//                             height: 254,
//                             child: PageView(
//                               controller: controller,
//                               onPageChanged: (v) => setState(() => index = v),
//                               children: carousel
//                                   ? ((widget.data as PostResponse).images
//                                           as List<dynamic>)
//                                       .map((e) => CachedNetworkImage(
//                                             imageUrl: e,
//                                             fit: BoxFit.contain,
//                                             placeholder: (context, url) =>
//                                                 CupertinoActivityIndicator(),
//                                           ))
//                                       .toList()
//                                   : ((widget.data as PostResponse).videos
//                                           as List<dynamic>)
//                                       .map((e) => ChewieVideo(e['src'],
//                                           index: widget.index))
//                                       .toList(),
//                             ),
//                           ),
//                         },
//                         if (widget.data is AdvertResponse) ...{
//                           Container(
//                             decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                               colors: widget.data is PostResponse
//                                   ? [Colors.white, Colors.white]
//                                   : [
//                                       Color(0xffFEDA01),
//                                       Color(0xffFFCA77),
//                                     ],
//                             )),
//                             child: Column(
//                               children: [
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 Container(
//                                   height: 460,
//                                   child: PageView(
//                                     controller: controller,
//                                     onPageChanged: (v) =>
//                                         setState(() => index = v),
//                                     children: carousel &&
//                                             (widget.data as AdvertResponse)
//                                                     .images !=
//                                                 null
//                                         ? (widget.data as AdvertResponse)
//                                             .images!
//                                             .map((e) {
//                                             if (e
//                                                     .substring(
//                                                         e.lastIndexOf("."))
//                                                     .toLowerCase()
//                                                     .contains("gif") ||
//                                                 e
//                                                     .substring(
//                                                         e.lastIndexOf("."))
//                                                     .toLowerCase()
//                                                     .contains("jfif")) {
//                                               return Container(
//                                                 height: 450,
//                                                 margin:
//                                                     EdgeInsets.only(right: 10),
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(40),
//                                                   image: DecorationImage(
//                                                       image:
//                                                           CachedNetworkImageProvider(
//                                                               e),
//                                                       fit: BoxFit.fill),
//                                                 ),
//                                               );
//                                             }
//                                             return Container(
//                                               height: 450,
//                                               margin:
//                                                   EdgeInsets.only(right: 10),
//                                               decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(40),
//                                                 image: DecorationImage(
//                                                     image:
//                                                         CachedNetworkImageProvider(
//                                                             e),
//                                                     fit: BoxFit.fill),
//                                               ),
//                                             );
//                                           }).toList()
//                                         : (widget.data as AdvertResponse)
//                                                     .videos !=
//                                                 null
//                                             ? (widget.data as AdvertResponse)
//                                                 .videos!
//                                                 .map(
//                                                   (e) => Container(
//                                                     height: 450,
//                                                     margin: EdgeInsets.only(
//                                                         right: 10),
//                                                     decoration: BoxDecoration(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               40),
//                                                     ),
//                                                     child: ChewieVideo(e['src'],
//                                                         index: widget.index),
//                                                   ),
//                                                 )
//                                                 .toList()
//                                             : [
//                                                 Container(
//                                                   height: 450,
//                                                 )
//                                               ],
//                                   ),
//                                 ),
//                                 if (showCarouselController) ...{
//                                   Container(
//                                     height: 20,
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.end,
//                                       children: List.generate(
//                                           (widget.data as AdvertResponse)
//                                               .images!
//                                               .length, (i) {
//                                         return Container(
//                                           width: 24,
//                                           height: 8,
//                                           margin: EdgeInsets.only(right: 6),
//                                           decoration: BoxDecoration(
//                                               shape: BoxShape.rectangle,
//                                               borderRadius:
//                                                   BorderRadius.circular(8),
//                                               color: i == index
//                                                   ? Colors.white
//                                                   : Colors.white54),
//                                         );
//                                       }),
//                                     ),
//                                   )
//                                 } else if (showVideoCarouselController) ...{
//                                   Container(
//                                     height: 20,
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       children: List.generate(
//                                           (widget.data as AdvertResponse)
//                                               .videos!
//                                               .length, (i) {
//                                         return Container(
//                                           width: 16,
//                                           height: 8,
//                                           margin: EdgeInsets.only(right: 2),
//                                           decoration: BoxDecoration(
//                                               shape: BoxShape.circle,
//                                               color: i == index
//                                                   ? Colors.white
//                                                   : Colors.white54),
//                                         );
//                                       }),
//                                     ),
//                                   )
//                                 } else ...{
//                                   Container(height: 20)
//                                 },
//                                 Container(height: 20)
//                               ],
//                             ),
//                           ),
//                         },
//                         if (widget.data is PostResponse) ...{
//                           SizedBox(
//                             height: 3,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Row(
//                                 children: [
//                                   space(width: 7),
//                                   Text(
//                                     "👍❤️😩",
//                                     textAlign: TextAlign.center,
//                                     style: textStyle.copyWith(fontSize: 20),
//                                   ),
//                                   space(width: 10),
//                                   Container(
//                                     padding: EdgeInsets.all(8),
//                                     decoration: BoxDecoration(
//                                       color: Colors.red,
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: Center(
//                                       child: GetBuilder<NewsController>(
//                                         builder: (_controller) => Text(
//                                           calculateComments(
//                                               (_controller.filteredGeoPageList![
//                                                               widget.index]
//                                                           as PostResponse)
//                                                       .likes ??
//                                                   0),
//                                           textAlign: TextAlign.center,
//                                           style: textStyle.copyWith(
//                                               color: Colors.white,
//                                               fontSize: 11),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               if (showCarouselController) ...{
//                                 Container(
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: List.generate(
//                                         (widget.data as PostResponse)
//                                             .images!
//                                             .length, (i) {
//                                       return Container(
//                                         width: i == index ? 8 : 6,
//                                         height: i == index ? 8 : 6,
//                                         margin: EdgeInsets.only(right: 2),
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           color: i == index
//                                               ? Colors.blue
//                                               : Colors.grey.withOpacity(0.5),
//                                         ),
//                                       );
//                                     }),
//                                   ),
//                                 )
//                               } else if (showVideoCarouselController) ...{
//                                 Container(
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: List.generate(
//                                         (widget.data as PostResponse)
//                                             .videos!
//                                             .length, (i) {
//                                       return Container(
//                                         width: i == index ? 8 : 6,
//                                         height: i == index ? 8 : 6,
//                                         margin: EdgeInsets.only(right: 2),
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           color: i == index
//                                               ? Colors.blue
//                                               : Colors.grey.withOpacity(0.5),
//                                         ),
//                                       );
//                                     }),
//                                   ),
//                                 )
//                               } else ...{
//                                 Container()
//                               },
//                               Row(
//                                 children: [
//                                   Text(
//                                     "${(widget.data as PostResponse).views ?? "0"} Views",
//                                     style: ThreeKmTextConstants
//                                         .tk11PXLatoGreyBold
//                                         .copyWith(
//                                             color: Colors.black,
//                                             fontSize: 10,
//                                             fontWeight: FontWeight.w400),
//                                   ),
//                                   space(width: 15),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           Divider(
//                             color: Colors.grey.withOpacity(0.2),
//                             thickness: 0.5,
//                           ),
//                           Row(children: [
//                             if ((widget.data as PostResponse).headline ==
//                                     null ||
//                                 (widget.data as PostResponse)
//                                     .headline!
//                                     .isNotEmpty) ...{
//                               Expanded(
//                                   child: Container(
//                                 width: 285,
//                                 margin: EdgeInsets.only(
//                                   left: 32,
//                                   right: 32,
//                                   top: 8,
//                                 ),
//                                 child: Text(
//                                   (widget.data as PostResponse).headline != null
//                                       ? (widget.data as PostResponse).headline!
//                                       : "",
//                                   textAlign: TextAlign.center,
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: ThreeKmTextConstants
//                                       .tk14PXPoppinsBlackBold
//                                       .copyWith(
//                                     fontWeight: FontWeight.w700,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                               )),
//                             },
//                           ]),
//                           Container(
//                             width: 275,
//                             margin: EdgeInsets.only(
//                                 left: 32, right: 32, bottom: 46),
//                             child: Text(
//                               removeHtml(
//                                       (widget.data as PostResponse).story ?? "")
//                                   .substring(removeHtml(
//                                           (widget.data as PostResponse).story ??
//                                               "")
//                                       .indexOf(RegExp(r"[A-Za-z]"))),
//                               maxLines: 3,
//                               overflow: TextOverflow.ellipsis,
//                               textAlign: TextAlign.center,
//                               style: GoogleFonts.lato(
//                                 fontWeight: FontWeight.w500,
//                                 color: Color(0xFF0F0F2D),
//                                 fontSize: 14,
//                                 height: 1.4,
//                               ),
//                             ),
//                           ),
//                         }
//                       ],
//                     ),
//                   ),
//                 ),
//                 if (widget.data is PostResponse) ...{
//                   Positioned(
//                     bottom: 0,
//                     left: 0,
//                     right: 0,
//                     child: Transform.translate(
//                       offset: Offset(0, 22),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             margin: EdgeInsets.only(right: 28.78),
//                             child: InkWell(
//                               onTap: () async {
//                                 bool status = await getAuthStatus();
//                                 if (status) {
//                                   newsController.like(widget.index,
//                                       (widget.data as PostResponse).postId!);
//                                 } else {
//                                   await Navigator.of(context).pushNamed(
//                                       SignUp.path,
//                                       arguments: HomePage.path);
//                                   status = await getAuthStatus();
//                                   if (status) {
//                                     newsController.like(widget.index,
//                                         (widget.data as PostResponse).postId!);
//                                   }
//                                 }
//                               },
//                               child: GetBuilder<NewsController>(
//                                 builder: (_controller) => !(_controller
//                                                 .filteredGeoPageList![
//                                             widget.index] as PostResponse)
//                                         .isLiked!
//                                     ? Container(
//                                         padding: EdgeInsets.all(8),
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           color: likeColour,
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color:
//                                                   Colors.pink.withOpacity(0.15),
//                                               offset: Offset(
//                                                 0,
//                                                 3,
//                                               ),
//                                               blurRadius: 12,
//                                             ),
//                                           ],
//                                         ),
//                                         child: Center(
//                                           child: Image.asset(
//                                             "assets/thumbs-up.png",
//                                             height: 29,
//                                             width: 29,
//                                           ),
//                                         ),
//                                       )
//                                     : Container(
//                                         padding: EdgeInsets.all(5),
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           color: Colors.red.withOpacity(0.8),
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color:
//                                                   Colors.pink.withOpacity(0.1),
//                                               offset: Offset(
//                                                 0,
//                                                 3,
//                                               ),
//                                               blurRadius: 12,
//                                             ),
//                                           ],
//                                         ),
//                                         child: Center(
//                                           child: Image.asset(
//                                             "assets/thumbs_up_red.png",
//                                             height: 36,
//                                             width: 36,
//                                           ),
//                                         ),
//                                       ),
//                               ),
//                             ),
//                           ),
//                           InkWell(
//                             onTap: () async {
//                               print("Tapped comment");
//                               showComments();
//                             },
//                             child: Container(
//                               padding: EdgeInsets.all(11),
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.blue.withOpacity(0.2),
//                                     offset: Offset(
//                                       0,
//                                       3,
//                                     ),
//                                     blurRadius: 12,
//                                   ),
//                                 ],
//                                 color: Colors.white,
//                               ),
//                               child: Center(
//                                 child: Image.asset(
//                                   "assets/icons-topic.png",
//                                   height: 24,
//                                   width: 24,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Container(
//                             margin: EdgeInsets.only(left: 28.78),
//                             child: Container(
//                               padding: EdgeInsets.all(11),
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.white,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.green.withOpacity(0.2),
//                                     offset: Offset(
//                                       0,
//                                       3,
//                                     ),
//                                     blurRadius: 12,
//                                   ),
//                                 ],
//                               ),
//                               child: Center(
//                                 child: Image.asset(
//                                   "assets/icons-share.png",
//                                   height: 24,
//                                   width: 24,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 }
//               ],
//             ),
//             Expanded(
//               child: Container(),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class NewsCardDetail extends StatefulWidget {
//   final PostResponse data;
//   final int index;
//   final bool? elevate;
//   const NewsCardDetail(this.data, {Key? key, this.elevate, required this.index})
//       : super(key: key);
//   @override
//   _NewsCardDetailState createState() => _NewsCardDetailState();
// }

// class _NewsCardDetailState extends State<NewsCardDetail> {
//   late PageController controller;
//   int index = 0;
//   late bool carousel;
//   late bool showCarouselController;
//   late bool showVideoCarouselController;
//   var commentController = Get.find<CommentController>();
//   Color likeColour = Colors.white;
//   Map likes = {};

//   @override
//   void initState() {
//     super.initState();
//     runChecks();
//   }

//   void runChecks() {
//     if ((widget.data).images != null) {
//       controller = PageController(viewportFraction: 1);
//       carousel = (widget.data).images!.length > 0 ? true : false;
//       showCarouselController =
//           carousel && (widget.data).images!.length > 1 ? true : false;
//     } else {
//       controller = PageController(viewportFraction: 1);
//       carousel = false;
//       showCarouselController = false;
//     }
//     if ((widget.data).videos != null) {
//       showVideoCarouselController =
//           carousel && (widget.data).videos!.length > 1 ? true : false;
//       controller = PageController(
//           viewportFraction: (widget.data).videos!.length > 1 ? 1 : 1);
//     } else {
//       showVideoCarouselController = false;
//       controller = PageController(viewportFraction: 1);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       alignment: Alignment.topCenter,
//       margin: EdgeInsets.only(
//           left: (widget.elevate != null && widget.elevate == true) ? 16 : 0,
//           right: (widget.elevate != null && widget.elevate == true) ? 16 : 0),
//       child: GestureDetector(
//         onTap: () {
//           log(widget.data.toString(), name: "Like check");
//           log((widget.data).isLiked.toString(), name: "Like check");
//           // showDetails();
//           // addOverlay();
//           print("tapped");
//         },
//         child: Column(
//           children: [
//             Expanded(
//               flex: 6,
//               child: Stack(
//                 alignment: Alignment.topCenter,
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(
//                         widget.data is PostResponse ? 10 : 0,
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Color(0xFF32335E26),
//                           offset: Offset(0, 0),
//                           blurRadius: 10,
//                           spreadRadius: -5,
//                         ),
//                       ],
//                     ),
//                     child: Card(
//                       borderOnForeground: false,
//                       elevation: widget.data is PostResponse &&
//                               (widget.elevate != null && widget.elevate == true)
//                           ? 0
//                           : 0,
//                       color: widget.data is PostResponse
//                           ? Colors.white
//                           : Colors.transparent,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(
//                               widget.data is PostResponse ? 10 : 0)),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             height: 10,
//                           ),
//                           GestureDetector(
//                               onTap: () => Navigator.of(context).pushNamed(
//                                     AuthorProfile.path,
//                                     arguments: {
//                                       "id": (widget.data).author!.id,
//                                       "avatar": (widget.data).author!.image,
//                                       "user_name": (widget.data).author!.name,
//                                     },
//                                   ),
//                               child: Row(
//                                 children: [
//                                   SizedBox(
//                                     width: 4,
//                                   ),
//                                   (widget.data).author != null
//                                       ? Stack(
//                                           children: [
//                                             Container(
//                                               height: 40,
//                                               width: 60,
//                                               alignment: Alignment.center,
//                                               child: CircleAvatar(
//                                                 radius: 20,
//                                                 backgroundImage:
//                                                     CachedNetworkImageProvider(
//                                                         (widget.data)
//                                                             .author!
//                                                             .image!),
//                                               ),
//                                             ),
//                                             if ((widget.data)
//                                                         .userDetails!
//                                                         .length >
//                                                     0 &&
//                                                 (widget.data)
//                                                         .userDetails!
//                                                         .first
//                                                         .isVerified ==
//                                                     true) ...{
//                                               Positioned(
//                                                 top: 0,
//                                                 left: 0,
//                                                 child: Image.asset(
//                                                   "assets/icons-guarantee.png",
//                                                   width: 16,
//                                                   height: 16,
//                                                 ),
//                                               )
//                                             }
//                                           ],
//                                         )
//                                       : CircleAvatar(
//                                           radius: 20,
//                                           backgroundImage:
//                                               AssetImage("assets/avatar.png"),
//                                         ),
//                                   SizedBox(
//                                     width: 7,
//                                   ),
//                                   Expanded(
//                                     child: Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 Container(
//                                                   constraints: BoxConstraints(
//                                                     minWidth: 50,
//                                                     maxWidth: 130,
//                                                   ),
//                                                   child: Container(
//                                                     child: Text(
//                                                       (widget.data).author !=
//                                                               null
//                                                           ? (widget.data)
//                                                               .author!
//                                                               .name!
//                                                           : "User",
//                                                       overflow:
//                                                           TextOverflow.ellipsis,
//                                                       style:
//                                                           GoogleFonts.poppins(
//                                                         fontSize: 12,
//                                                         color:
//                                                             Color(0xFF232629),
//                                                         fontWeight:
//                                                             FontWeight.w500,
//                                                       ),
//                                                       maxLines: 1,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 if ((widget.data).status != null &&
//                                                     (widget.data).author !=
//                                                         null &&
//                                                     (widget.data)
//                                                             .author!
//                                                             .showFollow ==
//                                                         true) ...{
//                                                   space(width: 4),
//                                                   Container(
//                                                     height: 5,
//                                                     width: 5,
//                                                     decoration: BoxDecoration(
//                                                         color:
//                                                             Color(0XFFD5D5D5),
//                                                         shape: BoxShape.circle),
//                                                   ),
//                                                   space(width: 4),
//                                                   Container(
//                                                     child: Text(
//                                                       "Follow".toUpperCase(),
//                                                       style: GoogleFonts.lato(
//                                                           color:
//                                                               Color(0xFF3E7EFF),
//                                                           fontSize: 12,
//                                                           fontWeight:
//                                                               FontWeight.w700),
//                                                     ),
//                                                   ),
//                                                 }
//                                               ],
//                                             ),
//                                             Row(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.center,
//                                               children: [
//                                                 Text(
//                                                   (widget.data)
//                                                               .authorClassification !=
//                                                           null
//                                                       ? (widget.data)
//                                                           .authorClassification!
//                                                       : "User",
//                                                   style: GoogleFonts.lato(
//                                                     fontSize: 10.5,
//                                                     fontWeight: FontWeight.w700,
//                                                     color: Color(0xFFA7AEB4),
//                                                     fontFeatures: [
//                                                       FontFeature.enable(
//                                                           'frac'),
//                                                       FontFeature.enable(
//                                                           'smcp'),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 12,
//                                                 ),
//                                                 Container(
//                                                   height: 5,
//                                                   width: 5,
//                                                   decoration: BoxDecoration(
//                                                       color: Color(0XFFD5D5D5),
//                                                       shape: BoxShape.circle),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 12,
//                                                 ),
//                                                 Text(
//                                                   (widget.data).createdDate ??
//                                                       "",
//                                                   style: GoogleFonts.lato(
//                                                     fontSize: 10.5,
//                                                     fontWeight: FontWeight.w700,
//                                                     color: Color(0xFFA7AEB4),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     margin: EdgeInsets.only(right: 8, left: 36),
//                                     child: Icon(
//                                       Icons.more_vert,
//                                       color: Color(0xFF979EA4),
//                                     ),
//                                   )
//                                 ],
//                               )),
//                           SizedBox(
//                             height: 12,
//                           ),
//                           Expanded(
//                             child: PageView(
//                               controller: controller,
//                               onPageChanged: (v) => setState(() => index = v),
//                               children: carousel
//                                   ? ((widget.data).images as List<dynamic>)
//                                       .map((e) => CachedNetworkImage(
//                                             imageUrl: e,
//                                             fit: BoxFit.fitWidth,
//                                             placeholder: (context, url) =>
//                                                 CupertinoActivityIndicator(),
//                                           ))
//                                       .toList()
//                                   : ((widget.data).videos as List<dynamic>)
//                                       .map((e) => ChewieVideo(
//                                             e['src'],
//                                             index: widget.index,
//                                             onFinished: () {
//                                               controller.nextPage(
//                                                   duration: Duration(
//                                                       milliseconds: 300),
//                                                   curve:
//                                                       Curves.linearToEaseOut);
//                                             },
//                                           ))
//                                       .toList(),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 3,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Expanded(
//                                 child: Row(
//                                   children: [
//                                     space(width: 30),
//                                     // Text(
//                                     //   "👍❤️😩",
//                                     //   textAlign: TextAlign.center,
//                                     //   style: textStyle.copyWith(fontSize: 20),
//                                     // ),
//                                     space(width: 10),
//                                     GestureDetector(
//                                       onTap: () async {
//                                         showDialog(
//                                           useRootNavigator: false,
//                                           useSafeArea: false,
//                                           context: context,
//                                           builder: (context) {
//                                             return ShowUserLikes(
//                                                 id: widget.data.postId!);
//                                           },
//                                         );
//                                       },
//                                       child: Container(
//                                         // padding: EdgeInsets.all(8),
//                                         height: 30,
//                                         width: 30,
//                                         decoration: BoxDecoration(
//                                           color: Colors.red,
//                                           shape: BoxShape.circle,
//                                         ),
//                                         child: Center(
//                                           child: Text(
//                                             calculateComments(
//                                                 widget.data.likes ?? 0),
//                                             textScaleFactor: 0.8,
//                                             textAlign: TextAlign.center,
//                                             style: textStyle.copyWith(
//                                                 color: Colors.white,
//                                                 fontSize: 11),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               if (showCarouselController) ...{
//                                 Container(
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: List.generate(
//                                         (widget.data).images!.length, (i) {
//                                       return Container(
//                                         width: i == index ? 8 : 6,
//                                         height: i == index ? 8 : 6,
//                                         margin: EdgeInsets.only(right: 2),
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           color: i == index
//                                               ? Colors.blue
//                                               : Colors.grey.withOpacity(0.5),
//                                         ),
//                                       );
//                                     }),
//                                   ),
//                                 )
//                               } else if (showVideoCarouselController) ...{
//                                 Container(
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: List.generate(
//                                         (widget.data).videos!.length, (i) {
//                                       return Container(
//                                         width: i == index ? 8 : 6,
//                                         height: i == index ? 8 : 6,
//                                         margin: EdgeInsets.only(right: 2),
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           color: i == index
//                                               ? Colors.blue
//                                               : Colors.grey.withOpacity(0.5),
//                                         ),
//                                       );
//                                     }),
//                                   ),
//                                 )
//                               } else ...{
//                                 Container()
//                               },
//                               Expanded(
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                     Text(
//                                       "${(widget.data).views ?? "0"} Views",
//                                       style: ThreeKmTextConstants
//                                           .tk11PXLatoGreyBold
//                                           .copyWith(
//                                               color: Colors.black,
//                                               fontSize: 10,
//                                               fontWeight: FontWeight.w400),
//                                     ),
//                                     space(width: 15),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Divider(
//                             color: Colors.grey.withOpacity(0.2),
//                             thickness: 0.5,
//                           ),
//                           Row(children: [
//                             if ((widget.data).headline == null ||
//                                 (widget.data).headline!.isNotEmpty) ...{
//                               Expanded(
//                                   child: Container(
//                                 width: 285,
//                                 margin: EdgeInsets.only(
//                                   left: 32,
//                                   right: 32,
//                                   top: 8,
//                                 ),
//                                 child: Text(
//                                   (widget.data).headline != null
//                                       ? (widget.data).headline!
//                                       : "",
//                                   textAlign: TextAlign.center,
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: ThreeKmTextConstants
//                                       .tk14PXPoppinsBlackBold
//                                       .copyWith(
//                                     fontWeight: FontWeight.w700,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                               )),
//                             },
//                           ]),
//                           space(height: 12),
//                           GestureDetector(
//                             onTap: () async {
//                               await showDetails(context, widget.data.postId!,
//                                   response: widget.data);
//                               setState(() {});
//                             },
//                             child: Container(
//                               width: 100,
//                               height: 25,
//                               decoration: BoxDecoration(
//                                 color: Color(0xFFF4F3F8),
//                                 borderRadius: BorderRadius.circular(13),
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   "Read More".toUpperCase(),
//                                   style: GoogleFonts.poppins(
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 12,
//                                     color: Color(0xFF3E7EFF),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           space(height: 50),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     left: 0,
//                     right: 0,
//                     child: Transform.translate(
//                       offset: Offset(0, 22),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             margin: EdgeInsets.only(right: 28.78),
//                             child: LikeButton(
//                               index: widget.index,
//                               response: widget.data,
//                               setter: widget.data,
//                               onDone: () {
//                                 setState(() {});
//                               },
//                             ),
//                           ),
//                           InkWell(
//                             onTap: () async {
//                               print("Tapped comment");
//                               showComments(context, widget.data);
//                             },
//                             child: Container(
//                               padding: EdgeInsets.all(11),
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.blue.withOpacity(0.2),
//                                     offset: Offset(
//                                       0,
//                                       3,
//                                     ),
//                                     blurRadius: 12,
//                                   ),
//                                 ],
//                                 color: Colors.white,
//                               ),
//                               child: Center(
//                                 child: Image.asset(
//                                   "assets/icons-topic.png",
//                                   height: 24,
//                                   width: 24,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Container(
//                             margin: EdgeInsets.only(left: 28.78),
//                             child: Container(
//                               padding: EdgeInsets.all(11),
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.white,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.green.withOpacity(0.2),
//                                     offset: Offset(
//                                       0,
//                                       3,
//                                     ),
//                                     blurRadius: 12,
//                                   ),
//                                 ],
//                               ),
//                               child: Center(
//                                 child: Image.asset(
//                                   "assets/icons-share.png",
//                                   height: 24,
//                                   width: 24,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Container(),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class AdvertDetail extends StatefulWidget {
//   final AdvertResponse data;
//   final int index;
//   final bool? elevate;
//   const AdvertDetail(this.data, {Key? key, this.elevate, required this.index})
//       : super(key: key);
//   @override
//   _AdvertDetailDetailState createState() => _AdvertDetailDetailState();
// }

// class _AdvertDetailDetailState extends State<AdvertDetail> {
//   late PageController controller;
//   int index = 0;
//   var newsController = Get.find<NewsCategoryController>();
//   late bool carousel;
//   late bool showCarouselController;
//   late bool showVideoCarouselController;
//   var commentController = Get.find<CommentController>();
//   Color likeColour = Colors.white;

//   @override
//   void initState() {
//     super.initState();
//     controller = PageController(viewportFraction: 0.9);
//     carousel = (widget.data).images!.length > 0 ? true : false;
//     showVideoCarouselController =
//         carousel && (widget.data).videos!.length > 1 ? true : false;
//     showCarouselController =
//         carousel && (widget.data).images!.length > 1 ? true : false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       alignment: Alignment.topCenter,
//       child: Container(
//         child: Column(
//           children: [
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       Color(0xffFEDA01),
//                       Color(0xffFFCA77),
//                     ],
//                   ),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Flexible(
//                       child: Container(
//                         child: PageView(
//                           controller: controller,
//                           onPageChanged: (v) => setState(() => index = v),
//                           children: carousel && (widget.data).images != null
//                               ? (widget.data).imageswcta!.map((e) {
//                                   if (e.image!
//                                           .substring(e.image!.lastIndexOf("."))
//                                           .toLowerCase()
//                                           .contains("gif") ||
//                                       e.image!
//                                           .substring(e.image!.lastIndexOf("."))
//                                           .toLowerCase()
//                                           .contains("jfif")) {
//                                     return GestureDetector(
//                                       onTap: () => Navigator.of(context)
//                                           .pushNamed(BusinessDetailsPage.path,
//                                               arguments: e.business),
//                                       child: Container(
//                                         height: 450,
//                                         margin: EdgeInsets.only(right: 10),
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(40),
//                                           image: DecorationImage(
//                                               image: CachedNetworkImageProvider(
//                                                   e.image!),
//                                               fit: BoxFit.fill),
//                                         ),
//                                       ),
//                                     );
//                                   }
//                                   return GestureDetector(
//                                     onTap: () => Navigator.of(context)
//                                         .pushNamed(BusinessDetailsPage.path,
//                                             arguments: e.business),
//                                     child: Container(
//                                       height: 450,
//                                       margin: EdgeInsets.only(right: 10),
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(40),
//                                         image: DecorationImage(
//                                             image: CachedNetworkImageProvider(
//                                                 e.image!),
//                                             fit: BoxFit.fill),
//                                       ),
//                                     ),
//                                   );
//                                 }).toList()
//                               : (widget.data).videos != null
//                                   ? (widget.data)
//                                       .videos!
//                                       .map(
//                                         (e) => Container(
//                                           height: 450,
//                                           margin: EdgeInsets.only(right: 10),
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(40),
//                                           ),
//                                           child: ChewieVideo(e['src'],
//                                               index: widget.index),
//                                         ),
//                                       )
//                                       .toList()
//                                   : [
//                                       Container(
//                                         height: 450,
//                                       )
//                                     ],
//                         ),
//                       ),
//                     ),
//                     if (showCarouselController) ...{
//                       Container(
//                         height: 20,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children:
//                               List.generate((widget.data).images!.length, (i) {
//                             return Container(
//                               width: 24,
//                               height: 8,
//                               margin: EdgeInsets.only(right: 6),
//                               decoration: BoxDecoration(
//                                   shape: BoxShape.rectangle,
//                                   borderRadius: BorderRadius.circular(8),
//                                   color: i == index
//                                       ? Colors.white
//                                       : Colors.white54),
//                             );
//                           }),
//                         ),
//                       )
//                     } else if (showVideoCarouselController) ...{
//                       Container(
//                         height: 20,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children:
//                               List.generate((widget.data).videos!.length, (i) {
//                             return Container(
//                               width: 16,
//                               height: 8,
//                               margin: EdgeInsets.only(right: 2),
//                               decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: i == index
//                                       ? Colors.white
//                                       : Colors.white54),
//                             );
//                           }),
//                         ),
//                       )
//                     } else ...{
//                       Container(height: 20)
//                     },
//                     Container(height: 20)
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class LikeButton extends StatefulWidget {
//   final PostResponse response;
//   final PostResponse? setter;
//   final int index;
//   final Size size;
//   final Size unlikeSize;
//   final VoidCallback onDone;

//   const LikeButton({
//     Key? key,
//     required this.index,
//     required this.response,
//     this.size = const Size(44, 44),
//     this.unlikeSize = const Size(29, 29),
//     this.setter,
//     required this.onDone,
//   }) : super(key: key);

//   @override
//   _LikeButtonState createState() => _LikeButtonState();
// }

// class _LikeButtonState extends State<LikeButton> {
//   late OverlayEntry entry;

//   Future<void> unlike() async {
//     var count;
//     Map<String, dynamic> data = {
//       "module": "news_post",
//       "entity_id": widget.response.postId,
//     };
//     count = await HomeRepository.unlike(data);
//     print(count);
//     if (count['data'] != null) {
//       if (mounted) {
//         setState(() {
//           widget.response.likes = widget.response.likes! - 1;
//           widget.response.isLiked = false;
//           if (widget.setter != null) {
//             widget.setter!.isLiked = false;
//             widget.setter!.likes = widget.setter!.likes! - 1;
//           }
//         });
//       }
//     }
//   }

//   void addOverlay(BuildContext context) async {
//     RenderBox? box = context.findRenderObject() as RenderBox;
//     Offset offset = box.localToGlobal(Offset.zero);

//     bool status = await getAuthStatus();
//     if (status) {
//       entry = OverlayEntry(
//         builder: (_context) => LikeOverlay(
//           offset: offset,
//           index: widget.index,
//           response: widget.response,
//           setter: widget.setter,
//           onSelect: () {
//             widget.onDone();
//             entry.remove();
//           },
//         ),
//       );

//       Overlay.of(context)?.insert(entry);
//     } else {
//       await Navigator.of(context)
//           .pushNamed(SignUp.path, arguments: NewsCategoryPage.path);
//       status = await getAuthStatus();
//       if (status) {
//         //   entry = OverlayEntry(
//         //   builder: (context) => LikeOverlay(
//         //     offset: offset,
//         //     index: index,
//         //     onSelect: () => entry.remove(),
//         //   ),
//         // );

//         // Overlay.of(context)?.insert(entry);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => !(widget.response.isLiked)! ? addOverlay(context) : unlike(),
//       child: !(widget.response.isLiked)!
//           ? Container(
//               padding: EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.pink.withOpacity(0.15),
//                     offset: Offset(
//                       0,
//                       3,
//                     ),
//                     blurRadius: 12,
//                   ),
//                 ],
//               ),
//               child: Center(
//                 child: Image.asset(
//                   "assets/thumbs-up.png",
//                   height: widget.unlikeSize.height,
//                   width: widget.unlikeSize.width,
//                 ),
//               ),
//             )
//           : Container(
//               padding: EdgeInsets.all(5),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.pink.withOpacity(0.1),
//                     offset: Offset(
//                       0,
//                       3,
//                     ),
//                     blurRadius: 12,
//                   ),
//                 ],
//               ),
//               child: Center(
//                 child: Image.asset(
//                   "assets/thumbs_up_red.png",
//                   height: widget.size.height,
//                   width: widget.size.width,
//                 ),
//               ),
//             ),
//     );
//   }
// }

// class LikeOverlay extends StatefulWidget {
//   final Offset offset;
//   final int index;
//   final PostResponse response;
//   final VoidCallback onSelect;
//   final PostResponse? setter;
//   const LikeOverlay({
//     Key? key,
//     required this.offset,
//     required this.index,
//     required this.onSelect,
//     required this.response,
//     this.setter,
//   }) : super(key: key);

//   @override
//   _LikeOverlayState createState() => _LikeOverlayState();
// }

// class _LikeOverlayState extends State<LikeOverlay> {
//   Future<void> like(String s) async {
//     var count;
//     Map<String, dynamic> data = {
//       "module": "news_post",
//       "entity_id": widget.response.postId,
//       "emotion": "$s"
//     };
//     if (!widget.response.isLiked!) {
//       print("Not liked --- Liking");
//       count = await HomeRepository.like(data);
//       print(count.toString());
//       if (count['data'] != null) {
//         print(count);
//         if (mounted) {
//           setState(() {
//             widget.response.likes = widget.response.likes! + 1;
//             widget.response.isLiked = true;
//             if (widget.setter != null) {
//               widget.setter!.isLiked = true;
//               widget.setter!.likes = widget.setter!.likes! + 1;
//             }
//           });
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         print("Scaffold selected");
//         widget.onSelect();
//       },
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Transform.translate(
//           offset: Offset(widget.offset.dx - 70, widget.offset.dy - 98),
//           child: Container(
//             color: Colors.transparent,
//             child: ClipPath(
//               clipper: LikeClipper(),
//               child: Container(
//                 height: 98,
//                 width: 344,
//                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                 decoration: BoxDecoration(
//                   color: Color(0xFF0F0F2D).withOpacity(0.9),
//                 ),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     GestureDetector(
//                       behavior: HitTestBehavior.deferToChild,
//                       onTap: () async {
//                         print("like");
//                         await like("like");
//                         widget.onSelect();
//                       },
//                       child: Image.asset(
//                         "assets/icons8-facebook-like-3@3x.png",
//                         height: 40,
//                         width: 37.5,
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () async {
//                         await like("love");
//                         widget.onSelect();
//                       },
//                       child: Image.asset(
//                         "assets/icons8-heart-2@3x.png",
//                         height: 40,
//                         width: 37.5,
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () async {
//                         await like("trust");
//                         widget.onSelect();
//                       },
//                       child: Image.asset(
//                         "assets/icons8-trust@3x.png",
//                         height: 40,
//                         width: 37.5,
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () async {
//                         await like("lol");
//                         widget.onSelect();
//                       },
//                       child: Image.asset(
//                         "assets/icons8-lol-3@3x.png",
//                         height: 40,
//                         width: 37.5,
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () async {
//                         await like("lol");
//                         widget.onSelect();
//                       },
//                       child: Image.asset(
//                         "assets/icons8-lol-3@3x.png",
//                         height: 40,
//                         width: 37.5,
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () async {
//                         await like("sad");
//                         widget.onSelect();
//                       },
//                       child: Image.asset(
//                         "assets/icons8-sad-2@2x.png",
//                         height: 40,
//                         width: 37.5,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class LikeClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var path = Path();
//     var width = size.width;
//     var height = size.height;
//     var heightCurve = height * 0.4;
//     path.moveTo(width / 2, 0);
//     path.lineTo(width - 50, 0);
//     path.quadraticBezierTo(width - 2, 0, width, heightCurve);
//     path.quadraticBezierTo(
//         width - 2, height * 0.8, width - 50, heightCurve * 2);
//     path.lineTo(100, heightCurve * 2);
//     path.lineTo(90, height);
//     path.lineTo(80, heightCurve * 2);
//     path.lineTo(50, heightCurve * 2);
//     path.quadraticBezierTo(2, heightCurve * 2, 0, heightCurve);
//     path.quadraticBezierTo(2, 0, 50, 0);
//     return path;
//   }

//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
//     return true;
//   }
// }

// class ShowUserLikes extends StatefulWidget {
//   final int id;
//   const ShowUserLikes({Key? key, required this.id}) : super(key: key);

//   @override
//   _ShowUserLikesState createState() => _ShowUserLikesState();
// }

// class _ShowUserLikesState extends State<ShowUserLikes> {
//   Map likes = {};

//   @override
//   void initState() {
//     super.initState();
//     getUserLists(widget.id);
//   }

//   void getUserLists(id) async {
//     likes = {};
//     Map<String, dynamic>? data = await HomeRepository.allLikes(
//         AllCommentsRequest(entityId: id, module: "news_post"));
//     if (data['data'] != null) {
//       print("likes gotten");
//       if (mounted) {
//         setState(() {
//           likes = data['data']['result'];
//         });
//         print(data['data']['result']);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Container(
//         height: double.infinity,
//         width: double.infinity,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Container(
//               height: 192,
//               width: double.infinity,
//               color: Colors.white,
//               child: Column(
//                 children: [
//                   space(height: 24),
//                   Row(
//                     children: [
//                       space(width: 18),
//                       Expanded(
//                         child: Text(
//                           "${likes['count'] != null ? likes['count'] + likes['anonymous_count'] : 0} reacted to this",
//                           style: GoogleFonts.poppins(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             color: Color(0xFF0F0F2D),
//                           ),
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () => Navigator.of(context).pop(),
//                         child: Icon(
//                           Icons.close,
//                           color: Colors.black,
//                           size: 24,
//                         ),
//                       ),
//                       space(width: 24),
//                     ],
//                   ),
//                   space(height: 34),
//                   if (likes['users'] != null) ...{
//                     Container(
//                       width: MediaQuery.of(context).size.width,
//                       height: 80,
//                       child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         padding: EdgeInsets.only(left: 18),
//                         itemBuilder: (context, index) {
//                           return Container(
//                             height: 80,
//                             width: 90,
//                             child: Stack(
//                               children: [
//                                 Container(
//                                   height: 80,
//                                   width: 80,
//                                   margin: EdgeInsets.only(right: 12),
//                                   clipBehavior: Clip.antiAlias,
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: ThreeKmTextConstants.lightBlue,
//                                   ),
//                                   child: CachedNetworkImage(
//                                     imageUrl: likes['users'][index]['avatar'],
//                                     fit: BoxFit.fill,
//                                   ),
//                                 ),
//                                 Positioned(
//                                   top: 0,
//                                   right: 0,
//                                   child: Container(
//                                     height: 32,
//                                     width: 32,
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: Color(0xFF0F0F2D),
//                                       border: Border.all(
//                                         color: Colors.white,
//                                         width: 1,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                         itemCount: likes['count'],
//                         shrinkWrap: true,
//                       ),
//                     ),
//                   }
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
