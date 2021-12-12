// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:threekm/api_models/request/all_comments_request/all_comments_request.dart';
// import 'package:threekm/api_models/response/post_response.dart';
// import 'package:threekm/models/author_profile_controller.dart';
// import 'package:threekm/models/comment_controller.dart';
// import 'package:threekm/models/my_post_controller.dart';
// import 'package:threekm/models/news_category_controller.dart';
// import 'package:threekm/models/news_controller.dart';
// import 'package:threekm/pages/author_profile.dart';
// import 'package:threekm/pages/home/home_page.dart';
// import 'package:threekm/pages/signup/sign_up.dart';
// import 'package:threekm/repository/home_repository.dart';
// import 'package:threekm/setup/setup.dart';
// import 'package:threekm/utils/constants.dart';
// import 'package:threekm/utils/threekm_textstyles.dart';
// import 'package:threekm/utils/util_methods.dart';
// import 'package:threekm/widgets/chewie_video.dart';
// import 'package:threekm/widgets/text_field.dart';

// import 'comment_widget.dart';
// import 'custom_button.dart';
// import 'news_comment_popup.dart';

// class NewsDetailPopup extends StatefulWidget {
//   final PostResponse data;
//   final double? heightOfWebView;
//   final int index;
//   final VoidCallback? onTapComment;
//   NewsDetailPopup(this.data,
//       {this.heightOfWebView, this.onTapComment, required this.index})
//       : super();

//   @override
//   _NewsDetailPopupState createState() => _NewsDetailPopupState();
// }

// class _NewsDetailPopupState extends State<NewsDetailPopup> {
//   late PageController controller;
//   int index = 0;
//   bool? carousel;
//   bool? showCarouselController;
//   bool? showVideoCarouselController;
//   var newsController = Get.find<NewsController>();
//   Color likeColour = Colors.white;
//   var commentText = TextEditingController();
//   var commentController = Get.find<CommentController>();

//   void showComments() async {
//     await showGeneralDialog(
//       context: context,
//       barrierColor: Colors.black12.withOpacity(0.6), // background color
//       barrierDismissible:
//           false, // should dialog be dismissed when tapped outside
//       routeSettings: RouteSettings(name: "comments"),
//       transitionDuration: Duration(milliseconds: 400),
//       useRootNavigator: false,
//       pageBuilder: (_context, anim, anim2) {
//         return Material(
//           color: Colors.black.withOpacity(0.3),
//           child: CommentPop(
//             newsDetailsData: widget.data,
//             onTap: () => Navigator.of(_context).pop(),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     controller = PageController();
//     runChecks();
//     commentController.getAllComments(widget.data.postId!);
//   }

//   runChecks() {
//     if (widget.data.images != null) {
//       carousel = widget.data.images!.length > 0 ? true : false;
//       showVideoCarouselController =
//           carousel! && widget.data.videos!.length > 1 ? true : false;
//       showCarouselController =
//           carousel! && widget.data.images!.length > 1 ? true : false;
//     }
//   }

//   Widget buildAvatar() {
//     return widget.data.author != null
//         ? CircleAvatar(
//             backgroundImage:
//                 CachedNetworkImageProvider(widget.data.author!.image!),
//           )
//         : CircleAvatar(
//             backgroundImage: AssetImage("assets/avatar.png"),
//           );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           clipBehavior: Clip.antiAlias,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(30),
//               topRight: Radius.circular(30),
//             ),
//           ),
//           child: CustomScrollView(
//             slivers: [
//               SliverToBoxAdapter(
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: 12,
//                     ),
//                     GestureDetector(
//                       onTap: () => Navigator.of(context).pushNamed(
//                         AuthorProfile.path,
//                         arguments: {
//                           "id": (widget.data).author!.id,
//                           "avatar": (widget.data).author!.image,
//                           "user_name": (widget.data).author!.name,
//                         },
//                       ),
//                       child: Row(
//                         children: [
//                           SizedBox(
//                             width: 16,
//                           ),
//                           buildAvatar(),
//                           SizedBox(
//                             width: 8,
//                           ),
//                           Expanded(
//                             child: Row(
//                               children: [
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Container(
//                                           constraints: BoxConstraints(
//                                             minWidth: 50,
//                                             maxWidth: 164,
//                                           ),
//                                           child: Container(
//                                             child: Text(
//                                               widget.data.author != null
//                                                   ? widget.data.author!.name!
//                                                   : "User",
//                                               overflow: TextOverflow.ellipsis,
//                                               style: GoogleFonts.poppins(
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.w500,
//                                                 color: Color(0xFF232629),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(width: 19),
//                                         if (widget.data.status != null &&
//                                             widget.data.isVerified == true) ...{
//                                           Image.asset(
//                                             "assets/icons-guarantee.png",
//                                             width: 20,
//                                             height: 20,
//                                           ),
//                                         }
//                                       ],
//                                     ),
//                                     Row(
//                                       children: [
//                                         Text(
//                                           widget.data.authorClassification !=
//                                                   null
//                                               ? widget
//                                                   .data.authorClassification!
//                                               : "User",
//                                           style: ThreeKmTextConstants
//                                               .tk11PXLatoGreyBold
//                                               .copyWith(
//                                                   fontSize: 12,
//                                                   color: Color(0xFF8A939B),
//                                                   fontWeight:
//                                                       FontWeight.normal),
//                                         ),
//                                         SizedBox(
//                                           width: 12,
//                                         ),
//                                         Container(
//                                           height: 5,
//                                           width: 5,
//                                           decoration: BoxDecoration(
//                                               color: Color(0XFFC4C9CD),
//                                               shape: BoxShape.circle),
//                                         ),
//                                         SizedBox(
//                                           width: 12,
//                                         ),
//                                         Text(
//                                           widget.data.createdDate ?? "",
//                                           style: ThreeKmTextConstants
//                                               .tk11PXLatoGreyBold
//                                               .copyWith(
//                                             fontSize: 10.5,
//                                             fontWeight: FontWeight.w700,
//                                             color: Color(0xFFA7AEB4),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Container(
//                             margin: EdgeInsets.only(right: 8, left: 36),
//                             child: Icon(
//                               Icons.more_vert,
//                               color: Color(0xFF979EA4),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 15,
//                     ),
//                   ],
//                 ),
//               ),
//               SliverAppBar(
//                 backgroundColor: Colors.white,
//                 leading: Container(),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30),
//                     topRight: Radius.circular(30),
//                   ),
//                 ),
//                 expandedHeight: 254,
//                 flexibleSpace: FlexibleSpaceBar(
//                   background: Container(
//                     height: 254,
//                     child: PageView(
//                       controller: controller,
//                       onPageChanged: (v) => setState(() => index = v),
//                       children: carousel != null && carousel!
//                           ? widget.data.images!
//                               .map((e) => CachedNetworkImage(
//                                     imageUrl: e,
//                                     fit: BoxFit.contain,
//                                   ))
//                               .toList()
//                           : carousel != null
//                               ? widget.data.videos!
//                                   .map((e) => ChewieVideo(e['src']))
//                                   .toList()
//                               : [Container()],
//                     ),
//                   ),
//                 ),
//               ),
//               SliverToBoxAdapter(
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: 4,
//                     ),
//                     Stack(
//                       children: [
//                         Positioned(
//                           bottom: 8,
//                           left: 90,
//                           child: Container(
//                             height: 40,
//                             width: 40,
//                             padding: EdgeInsets.all(2),
//                             decoration: BoxDecoration(
//                                 color: Colors.red, shape: BoxShape.circle),
//                             child: Center(
//                               child: GetBuilder<NewsController>(
//                                 builder: (_controller) => Text(
//                                   calculateComments(
//                                       (_controller.filteredGeoPageList![
//                                                   widget.index] as PostResponse)
//                                               .likes ??
//                                           0),
//                                   textAlign: TextAlign.center,
//                                   style: textStyle.copyWith(
//                                       color: Colors.white, fontSize: 11),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           bottom: 16,
//                           left: 12,
//                           child: Center(
//                             child: Text(
//                               "👍❤️😩",
//                               textAlign: TextAlign.center,
//                               style: textStyle.copyWith(fontSize: 20),
//                             ),
//                           ),
//                         ),
//                         if (showCarouselController != null &&
//                             showCarouselController!) ...{
//                           Container(
//                             height: 50,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: List.generate(
//                                 widget.data.images!.length > 12
//                                     ? 12
//                                     : widget.data.images!.length,
//                                 (i) {
//                                   return Container(
//                                     width: i == index ? 8 : 6,
//                                     height: i == index ? 8 : 6,
//                                     margin: EdgeInsets.only(right: 2),
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: i == index || i >= 12
//                                           ? Colors.blue
//                                           : Colors.grey.withOpacity(0.5),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                         }
//                         // else if (showVideoCarouselController != null &&
//                         //     showVideoCarouselController!) ...{
//                         //   Container(
//                         //     height: 35,
//                         //     child: Row(
//                         //       mainAxisAlignment: MainAxisAlignment.center,
//                         //       crossAxisAlignment: CrossAxisAlignment.center,
//                         //       children: List.generate(
//                         //           widget.data.videos!.length, (i) {
//                         //         return Container(
//                         //           width: i == index ? 8 : 6,
//                         //           height: i == index ? 8 : 6,
//                         //           margin: EdgeInsets.only(right: 2),
//                         //           decoration: BoxDecoration(
//                         //               shape: BoxShape.circle,
//                         //               color: i == index
//                         //                   ? Colors.blue
//                         //                   : Colors.grey.withOpacity(0.5)),
//                         //         );
//                         //       }),
//                         //     ),
//                         //   )
//                         // }
//                         else ...{
//                           Container(height: 50)
//                         },
//                         Positioned(
//                           bottom: 16,
//                           right: 12,
//                           child: Text(
//                             "${widget.data.views ?? "0"} Views",
//                             style: textStyle,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 12,
//                     ),
//                     Container(
//                       margin: EdgeInsets.symmetric(horizontal: 16),
//                       padding: EdgeInsets.symmetric(horizontal: 16),
//                       child: Text(
//                         widget.data.headline != null
//                             ? widget.data.headline!
//                             : "",
//                         textAlign: TextAlign.center,
//                         style: ThreeKmTextConstants.tk14PXPoppinsBlackBold
//                             .copyWith(
//                                 fontWeight: FontWeight.w900, fontSize: 14),
//                       ),
//                     ),
//                     Container(
//                       margin: EdgeInsets.only(left: 16, right: 16, bottom: 40),
//                       child: Text(
//                         removeHtml(widget.data.story ?? ""),
//                         textAlign: TextAlign.center,
//                         style: GoogleFonts.lato(
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black,
//                           fontSize: 14,
//                           height: 1.3,
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 28,
//                     ),
//                     Obx(
//                       () => ListView.builder(
//                           shrinkWrap: true,
//                           itemBuilder: (context, i) {
//                             return Container(
//                               padding: EdgeInsets.only(
//                                   left: 18, right: 18, bottom: 32),
//                               child: CommentWidget(
//                                   commentController.comments[i].avatar,
//                                   commentController.comments[i].username,
//                                   commentController.comments[i].comment,
//                                   commentController.comments[i].timeLapsed,
//                                   commentController.comments[i].commentId,
//                                   commentController.comments[i].isSelf,
//                                   widget.data.postId!),
//                             );
//                           },
//                           itemCount: commentController.comments.length),
//                     ),
//                     Container(
//                       padding: EdgeInsets.only(left: 18, right: 18, bottom: 32),
//                       child: CustomTextField(
//                         controller: commentText,
//                         border: false,
//                         fillColor: Color(0XFF0F0F2D).withOpacity(0.05),
//                         height: 116,
//                         hint: "Type a comment…",
//                         hintStyle: GoogleFonts.lato(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 14,
//                           color: Color(0xFF0F0F2D),
//                         ),
//                         style: ThreeKmTextConstants.tk14PXLatoBlackMedium,
//                         borderRadius: 20,
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.only(left: 18, right: 18, bottom: 32),
//                       child: Row(
//                         children: [
//                           CustomButton(
//                             width: 102,
//                             height: 40,
//                             elevation: 0,
//                             color: Colors.blue,
//                             borderRadius: BorderRadius.circular(18),
//                             onTap: () async {
//                               bool status = await getAuthStatus();
//                               if (status) {
//                                 // widget.onTapComment(widget.data);
//                                 if (commentText.text.length > 0) {
//                                   commentController.postComment(
//                                     commentText.text,
//                                     widget.data.postId!,
//                                   );
//                                   commentText.text = "";
//                                 }
//                               } else {
//                                 await Navigator.of(context).pushNamed(
//                                     SignUp.path,
//                                     arguments: HomePage.path);
//                                 bool status = await getAuthStatus();
//                                 if (status) {
//                                   commentController.postComment(
//                                     commentText.text,
//                                     widget.data.postId!,
//                                   );
//                                   commentText.text = "";
//                                 }
//                               }
//                             },
//                             child: Text(
//                               "Submit",
//                               style:
//                                   ThreeKmTextConstants.tk14PXPoppinsWhiteMedium,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 80,
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//         Positioned(
//           bottom: 0,
//           right: 0,
//           left: 0,
//           child: Stack(
//             children: [
//               Container(
//                 color: Colors.blue,
//                 height: 65,
//               ),
//               Transform.translate(
//                 offset: Offset(0, -32),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Transform.translate(
//                       offset: Offset(0, 0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             margin: EdgeInsets.only(right: 32),
//                             child: InkWell(
//                               onTap: () async {
//                                 bool status = await getAuthStatus();
//                                 if (status) {
//                                   newsController.like(
//                                       widget.index, widget.data.postId!);
//                                 } else {
//                                   await Navigator.of(context).pushNamed(
//                                       SignUp.path,
//                                       arguments: HomePage.path);
//                                   status = await getAuthStatus();
//                                   if (status) {
//                                     newsController.like(
//                                         widget.index, widget.data.postId!);
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
//                                             height: 35,
//                                             width: 35,
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
//                           Container(
//                             child: InkWell(
//                               onTap: () async {
//                                 Navigator.of(context).pop(true);
//                               },
//                               child: Container(
//                                 padding: EdgeInsets.all(12),
//                                 margin: EdgeInsets.all(5),
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.blue.withOpacity(0.2),
//                                       offset: Offset(
//                                         0,
//                                         3,
//                                       ),
//                                       blurRadius: 12,
//                                     ),
//                                   ],
//                                   color: Colors.white,
//                                 ),
//                                 child: Center(
//                                   child: Image.asset(
//                                     "assets/icons-topic.png",
//                                     height: 28,
//                                     width: 28,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Container(
//                             margin: EdgeInsets.only(left: 32),
//                             child: Container(
//                               padding: EdgeInsets.all(14),
//                               margin: EdgeInsets.all(5),
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
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
//                                 color: Colors.white,
//                               ),
//                               child: Center(
//                                 child: Image.asset(
//                                   "assets/icons-share.png",
//                                   height: 26,
//                                   width: 26,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class NewsCategoryDetailPopup extends StatefulWidget {
//   final PostResponse data;
//   final double? heightOfWebView;
//   final int index;
//   final VoidCallback? onTapComment;
//   NewsCategoryDetailPopup(this.data,
//       {this.heightOfWebView, this.onTapComment, required this.index})
//       : super();

//   @override
//   _NewsCategoryDetailPopupState createState() =>
//       _NewsCategoryDetailPopupState();
// }

// class _NewsCategoryDetailPopupState extends State<NewsCategoryDetailPopup> {
//   late PageController controller;
//   int index = 0;
//   bool? carousel;
//   bool? showCarouselController;
//   bool? showVideoCarouselController;
//   late NewsCategoryController newsController;
//   Color likeColour = Colors.white;
//   var commentText = TextEditingController();
//   var commentController = Get.find<CommentController>();

//   void showComments() async {
//     await showGeneralDialog(
//       context: context,
//       barrierColor: Colors.black12.withOpacity(0.6), // background color
//       barrierDismissible:
//           false, // should dialog be dismissed when tapped outside
//       routeSettings: RouteSettings(name: "comments"),
//       transitionDuration: Duration(milliseconds: 400),
//       useRootNavigator: false,
//       pageBuilder: (_context, anim, anim2) {
//         return Material(
//           color: Colors.black.withOpacity(0.3),
//           child: CommentPop(
//             newsDetailsData: widget.data,
//             onTap: () => Navigator.of(_context).pop(),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     newsController = Get.put(NewsCategoryController(widget.data.id));
//     controller = PageController();
//     runChecks();
//     commentController.getAllComments(widget.data.postId!);
//   }

//   runChecks() {
//     if (widget.data.images != null) {
//       carousel = widget.data.images!.length > 0 ? true : false;
//       showVideoCarouselController =
//           carousel! && widget.data.videos!.length > 1 ? true : false;
//       showCarouselController =
//           carousel! && widget.data.images!.length > 1 ? true : false;
//     }
//   }

//   Widget buildAvatar() {
//     return widget.data.author != null
//         ? CircleAvatar(
//             backgroundImage:
//                 CachedNetworkImageProvider(widget.data.author!.image!),
//           )
//         : CircleAvatar(
//             backgroundImage: AssetImage("assets/avatar.png"),
//           );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           clipBehavior: Clip.antiAlias,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(30),
//               topRight: Radius.circular(30),
//             ),
//           ),
//           child: CustomScrollView(
//             slivers: [
//               SliverToBoxAdapter(
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: 12,
//                     ),
//                     GestureDetector(
//                       onTap: () => Navigator.of(context).pushNamed(
//                         AuthorProfile.path,
//                         arguments: {
//                           "id": (widget.data).author!.id,
//                           "avatar": (widget.data).author!.image,
//                           "user_name": (widget.data).author!.name,
//                         },
//                       ),
//                       child: Row(
//                         children: [
//                           SizedBox(
//                             width: 16,
//                           ),
//                           buildAvatar(),
//                           SizedBox(
//                             width: 8,
//                           ),
//                           Expanded(
//                             child: Row(
//                               children: [
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Container(
//                                           constraints: BoxConstraints(
//                                             minWidth: 50,
//                                             maxWidth: 164,
//                                           ),
//                                           child: Container(
//                                             child: Text(
//                                               widget.data.author != null
//                                                   ? widget.data.author!.name!
//                                                   : "User",
//                                               overflow: TextOverflow.ellipsis,
//                                               style: GoogleFonts.poppins(
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.w500,
//                                                 color: Color(0xFF232629),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(width: 19),
//                                         if (widget.data.status != null &&
//                                             widget.data.isVerified == true) ...{
//                                           Image.asset(
//                                             "assets/icons-guarantee.png",
//                                             width: 20,
//                                             height: 20,
//                                           ),
//                                         }
//                                       ],
//                                     ),
//                                     Row(
//                                       children: [
//                                         Text(
//                                           widget.data.authorClassification !=
//                                                   null
//                                               ? widget
//                                                   .data.authorClassification!
//                                               : "User",
//                                           style: ThreeKmTextConstants
//                                               .tk11PXLatoGreyBold
//                                               .copyWith(
//                                                   fontSize: 12,
//                                                   color: Color(0xFF8A939B),
//                                                   fontWeight:
//                                                       FontWeight.normal),
//                                         ),
//                                         SizedBox(
//                                           width: 12,
//                                         ),
//                                         Container(
//                                           height: 5,
//                                           width: 5,
//                                           decoration: BoxDecoration(
//                                               color: Color(0XFFC4C9CD),
//                                               shape: BoxShape.circle),
//                                         ),
//                                         SizedBox(
//                                           width: 12,
//                                         ),
//                                         Text(
//                                           widget.data.createdDate ?? "",
//                                           style: ThreeKmTextConstants
//                                               .tk11PXLatoGreyBold
//                                               .copyWith(
//                                             fontSize: 10.5,
//                                             fontWeight: FontWeight.w700,
//                                             color: Color(0xFFA7AEB4),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Container(
//                             margin: EdgeInsets.only(right: 8, left: 36),
//                             child: Icon(
//                               Icons.more_vert,
//                               color: Color(0xFF979EA4),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 15,
//                     ),
//                   ],
//                 ),
//               ),
//               SliverAppBar(
//                 backgroundColor: Colors.white,
//                 leading: Container(),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30),
//                     topRight: Radius.circular(30),
//                   ),
//                 ),
//                 expandedHeight: 254,
//                 flexibleSpace: FlexibleSpaceBar(
//                   background: Container(
//                     height: 254,
//                     child: PageView(
//                       controller: controller,
//                       onPageChanged: (v) => setState(() => index = v),
//                       children: carousel != null && carousel!
//                           ? widget.data.images!
//                               .map((e) => CachedNetworkImage(
//                                     imageUrl: e,
//                                     fit: BoxFit.contain,
//                                   ))
//                               .toList()
//                           : carousel != null
//                               ? widget.data.videos!
//                                   .map((e) => ChewieVideo(e['src']))
//                                   .toList()
//                               : [Container()],
//                     ),
//                   ),
//                 ),
//               ),
//               SliverToBoxAdapter(
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: 4,
//                     ),
//                     Stack(
//                       children: [
//                         Positioned(
//                           bottom: 8,
//                           left: 90,
//                           child: Container(
//                             height: 40,
//                             width: 40,
//                             padding: EdgeInsets.all(2),
//                             decoration: BoxDecoration(
//                                 color: Colors.red, shape: BoxShape.circle),
//                             child: Center(
//                               child: GetBuilder<NewsCategoryController>(
//                                 builder: (_controller) => Text(
//                                   calculateComments(
//                                       (_controller.geoPageList![widget.index]
//                                                   as PostResponse)
//                                               .likes ??
//                                           0),
//                                   textAlign: TextAlign.center,
//                                   style: textStyle.copyWith(
//                                       color: Colors.white, fontSize: 11),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           bottom: 16,
//                           left: 12,
//                           child: Center(
//                             child: Text(
//                               "👍❤️😩",
//                               textAlign: TextAlign.center,
//                               style: textStyle.copyWith(fontSize: 20),
//                             ),
//                           ),
//                         ),
//                         if (showCarouselController != null &&
//                             showCarouselController!) ...{
//                           Container(
//                             height: 50,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: List.generate(
//                                 widget.data.images!.length > 12
//                                     ? 12
//                                     : widget.data.images!.length,
//                                 (i) {
//                                   return Container(
//                                     width: i == index ? 8 : 6,
//                                     height: i == index ? 8 : 6,
//                                     margin: EdgeInsets.only(right: 2),
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: i == index || i >= 12
//                                           ? Colors.blue
//                                           : Colors.grey.withOpacity(0.5),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                         }
//                         // else if (showVideoCarouselController != null &&
//                         //     showVideoCarouselController!) ...{
//                         //   Container(
//                         //     height: 35,
//                         //     child: Row(
//                         //       mainAxisAlignment: MainAxisAlignment.center,
//                         //       crossAxisAlignment: CrossAxisAlignment.center,
//                         //       children: List.generate(
//                         //           widget.data.videos!.length, (i) {
//                         //         return Container(
//                         //           width: i == index ? 8 : 6,
//                         //           height: i == index ? 8 : 6,
//                         //           margin: EdgeInsets.only(right: 2),
//                         //           decoration: BoxDecoration(
//                         //               shape: BoxShape.circle,
//                         //               color: i == index
//                         //                   ? Colors.blue
//                         //                   : Colors.grey.withOpacity(0.5)),
//                         //         );
//                         //       }),
//                         //     ),
//                         //   )
//                         // }
//                         else ...{
//                           Container(height: 50)
//                         },
//                         Positioned(
//                           bottom: 16,
//                           right: 12,
//                           child: Text(
//                             "${widget.data.views ?? "0"} Views",
//                             style: textStyle,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 12,
//                     ),
//                     Container(
//                       margin: EdgeInsets.symmetric(horizontal: 16),
//                       padding: EdgeInsets.symmetric(horizontal: 16),
//                       child: Text(
//                         widget.data.headline != null
//                             ? widget.data.headline!
//                             : "",
//                         textAlign: TextAlign.center,
//                         style: ThreeKmTextConstants.tk14PXPoppinsBlackBold
//                             .copyWith(
//                                 fontWeight: FontWeight.w900, fontSize: 14),
//                       ),
//                     ),
//                     Container(
//                       margin: EdgeInsets.only(left: 16, right: 16, bottom: 40),
//                       child: Text(
//                         removeHtml(widget.data.story ?? ""),
//                         textAlign: TextAlign.center,
//                         style: GoogleFonts.lato(
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black,
//                           fontSize: 14,
//                           height: 1.3,
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 28,
//                     ),
//                     Obx(
//                       () => ListView.builder(
//                           shrinkWrap: true,
//                           itemBuilder: (context, i) {
//                             return Container(
//                               padding: EdgeInsets.only(
//                                   left: 18, right: 18, bottom: 32),
//                               child: CommentWidget(
//                                   commentController.comments[i].avatar,
//                                   commentController.comments[i].username,
//                                   commentController.comments[i].comment,
//                                   commentController.comments[i].timeLapsed,
//                                   commentController.comments[i].commentId,
//                                   commentController.comments[i].isSelf,
//                                   widget.data.postId!),
//                             );
//                           },
//                           itemCount: commentController.comments.length),
//                     ),
//                     Container(
//                       padding: EdgeInsets.only(left: 18, right: 18, bottom: 32),
//                       child: CustomTextField(
//                         controller: commentText,
//                         border: false,
//                         fillColor: Color(0XFF0F0F2D).withOpacity(0.05),
//                         height: 116,
//                         hint: "Type a comment…",
//                         hintStyle: GoogleFonts.lato(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 14,
//                           color: Color(0xFF0F0F2D),
//                         ),
//                         style: ThreeKmTextConstants.tk14PXLatoBlackMedium,
//                         borderRadius: 20,
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.only(left: 18, right: 18, bottom: 32),
//                       child: Row(
//                         children: [
//                           CustomButton(
//                             width: 102,
//                             height: 40,
//                             elevation: 0,
//                             color: Colors.blue,
//                             borderRadius: BorderRadius.circular(18),
//                             onTap: () async {
//                               bool status = await getAuthStatus();
//                               if (status) {
//                                 // widget.onTapComment(widget.data);
//                                 if (commentText.text.length > 0) {
//                                   commentController.postComment(
//                                     commentText.text,
//                                     widget.data.postId!,
//                                   );
//                                   commentText.text = "";
//                                 }
//                               } else {
//                                 await Navigator.of(context).pushNamed(
//                                     SignUp.path,
//                                     arguments: HomePage.path);
//                                 bool status = await getAuthStatus();
//                                 if (status) {
//                                   commentController.postComment(
//                                     commentText.text,
//                                     widget.data.postId!,
//                                   );
//                                   commentText.text = "";
//                                 }
//                               }
//                             },
//                             child: Text(
//                               "Submit",
//                               style:
//                                   ThreeKmTextConstants.tk14PXPoppinsWhiteMedium,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 80,
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//         Positioned(
//           bottom: 0,
//           right: 0,
//           left: 0,
//           child: Stack(
//             children: [
//               Container(
//                 color: Colors.blue,
//                 height: 65,
//               ),
//               Transform.translate(
//                 offset: Offset(0, -32),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Transform.translate(
//                       offset: Offset(0, 0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             margin: EdgeInsets.only(right: 32),
//                             child: InkWell(
//                               onTap: () async {
//                                 bool status = await getAuthStatus();
//                                 if (status) {
//                                   // newsController.like(
//                                   //     widget.index, widget.data.postId!);
//                                 } else {
//                                   await Navigator.of(context).pushNamed(
//                                       SignUp.path,
//                                       arguments: HomePage.path);
//                                   status = await getAuthStatus();
//                                   if (status) {
//                                     // newsController.like(
//                                     //     widget.index, widget.data.postId!);
//                                   }
//                                 }
//                               },
//                               child: GetBuilder<NewsCategoryController>(
//                                 builder: (_controller) => !(_controller
//                                                 .geoPageList![widget.index]
//                                             as PostResponse)
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
//                                             height: 35,
//                                             width: 35,
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
//                           Container(
//                             child: InkWell(
//                               onTap: () async {
//                                 Navigator.of(context).pop(true);
//                               },
//                               child: Container(
//                                 padding: EdgeInsets.all(12),
//                                 margin: EdgeInsets.all(5),
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.blue.withOpacity(0.2),
//                                       offset: Offset(
//                                         0,
//                                         3,
//                                       ),
//                                       blurRadius: 12,
//                                     ),
//                                   ],
//                                   color: Colors.white,
//                                 ),
//                                 child: Center(
//                                   child: Image.asset(
//                                     "assets/icons-topic.png",
//                                     height: 28,
//                                     width: 28,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Container(
//                             margin: EdgeInsets.only(left: 32),
//                             child: Container(
//                               padding: EdgeInsets.all(14),
//                               margin: EdgeInsets.all(5),
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
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
//                                 color: Colors.white,
//                               ),
//                               child: Center(
//                                 child: Image.asset(
//                                   "assets/icons-share.png",
//                                   height: 26,
//                                   width: 26,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class MyNewsDetailPopup extends StatefulWidget {
//   final PostResponse data;
//   final double? heightOfWebView;
//   final int index;
//   final VoidCallback? onTapComment;
//   MyNewsDetailPopup(this.data,
//       {this.heightOfWebView, this.onTapComment, required this.index})
//       : super();

//   @override
//   _MyNewsDetailPopupState createState() => _MyNewsDetailPopupState();
// }

// class _MyNewsDetailPopupState extends State<MyNewsDetailPopup> {
//   late PageController controller;
//   int index = 0;
//   bool? carousel;
//   bool? showCarouselController;
//   bool? showVideoCarouselController;
//   var newsController = Get.find<NewsController>();
//   Color likeColour = Colors.white;

//   void showComments() async {
//     await showGeneralDialog(
//       context: context,
//       barrierColor: Colors.black12.withOpacity(0.6), // background color
//       barrierDismissible:
//           false, // should dialog be dismissed when tapped outside
//       transitionDuration: Duration(milliseconds: 400),
//       useRootNavigator: false,
//       pageBuilder: (_context, anim, anim2) {
//         return Material(
//           color: Colors.black.withOpacity(0.3),
//           child: CommentPop(
//             newsDetailsData: widget.data,
//             onTap: () => Navigator.of(_context).pop(),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     controller = PageController();
//     runChecks();
//   }

//   runChecks() {
//     if (widget.data.images != null) {
//       carousel = widget.data.images!.length > 0 ? true : false;
//       showVideoCarouselController =
//           carousel! && widget.data.videos!.length > 1 ? true : false;
//       showCarouselController =
//           carousel! && widget.data.images!.length > 1 ? true : false;
//     }
//   }

//   Widget buildAvatar() {
//     return widget.data.author != null
//         ? CircleAvatar(
//             backgroundImage:
//                 CachedNetworkImageProvider(widget.data.author!.image!),
//           )
//         : CircleAvatar(
//             backgroundImage: AssetImage("assets/avatar.png"),
//           );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           clipBehavior: Clip.antiAlias,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(30),
//               topRight: Radius.circular(30),
//             ),
//           ),
//           child: CustomScrollView(
//             slivers: [
//               SliverToBoxAdapter(
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: 12,
//                     ),
//                     Row(
//                       children: [
//                         SizedBox(
//                           width: 16,
//                         ),
//                         buildAvatar(),
//                         SizedBox(
//                           width: 8,
//                         ),
//                         Expanded(
//                           child: Row(
//                             children: [
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Container(
//                                         constraints: BoxConstraints(
//                                           minWidth: 50,
//                                           maxWidth: 164,
//                                         ),
//                                         child: Container(
//                                           child: Text(
//                                             widget.data.author != null
//                                                 ? widget.data.author!.name!
//                                                 : "User",
//                                             overflow: TextOverflow.ellipsis,
//                                             style: ThreeKmTextConstants
//                                                 .tk14PXPoppinsBlackBold
//                                                 .copyWith(
//                                                     fontWeight:
//                                                         FontWeight.w600),
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(width: 19),
//                                       if (widget.data.status != null &&
//                                           widget.data.isVerified == true) ...{
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
//                                                 fontSize: 12,
//                                                 color: Color(0xFF8A939B),
//                                                 fontWeight: FontWeight.normal),
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
//                                         style: ThreeKmTextConstants
//                                             .tk11PXLatoGreyBold
//                                             .copyWith(
//                                           fontSize: 10.5,
//                                           fontWeight: FontWeight.w700,
//                                           color: Color(0xFFA7AEB4),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         Container(
//                           margin: EdgeInsets.only(right: 8, left: 36),
//                           child: Icon(Icons.more_vert),
//                         )
//                       ],
//                     ),
//                     SizedBox(
//                       height: 15,
//                     ),
//                   ],
//                 ),
//               ),
//               SliverAppBar(
//                 backgroundColor: Colors.white,
//                 leading: Container(),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30),
//                     topRight: Radius.circular(30),
//                   ),
//                 ),
//                 expandedHeight: 254,
//                 flexibleSpace: FlexibleSpaceBar(
//                   background: Container(
//                     height: 254,
//                     child: PageView(
//                       controller: controller,
//                       onPageChanged: (v) => setState(() => index = v),
//                       children: carousel != null && carousel!
//                           ? widget.data.images!
//                               .map((e) => Image.network(
//                                     e,
//                                     fit: BoxFit.cover,
//                                   ))
//                               .toList()
//                           : carousel != null
//                               ? widget.data.videos!
//                                   .map((e) => ChewieVideo(e['src']))
//                                   .toList()
//                               : [Container()],
//                     ),
//                   ),
//                 ),
//               ),
//               SliverToBoxAdapter(
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: 4,
//                     ),
//                     Stack(
//                       children: [
//                         Positioned(
//                           bottom: 8,
//                           left: 90,
//                           child: Container(
//                             height: 40,
//                             width: 40,
//                             padding: EdgeInsets.all(2),
//                             decoration: BoxDecoration(
//                                 color: Colors.red, shape: BoxShape.circle),
//                             child: Center(
//                               child: GetBuilder<MyPostController>(
//                                 builder: (_controller) => Text(
//                                   calculateComments((_controller.posts!.data!
//                                               .result!.posts![widget.index])
//                                           .likes ??
//                                       0),
//                                   textAlign: TextAlign.center,
//                                   style: textStyle.copyWith(
//                                       color: Colors.white, fontSize: 11),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           bottom: 16,
//                           left: 12,
//                           child: Center(
//                             child: Text(
//                               "👍❤️😩",
//                               textAlign: TextAlign.center,
//                               style: textStyle.copyWith(fontSize: 20),
//                             ),
//                           ),
//                         ),
//                         if (showCarouselController != null &&
//                             showCarouselController!) ...{
//                           Container(
//                             height: 50,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: List.generate(
//                                 widget.data.images!.length > 12
//                                     ? 12
//                                     : widget.data.images!.length,
//                                 (i) {
//                                   return Container(
//                                     width: i == index ? 8 : 6,
//                                     height: i == index ? 8 : 6,
//                                     margin: EdgeInsets.only(right: 2),
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: i == index || i >= 12
//                                           ? Colors.blue
//                                           : Colors.grey.withOpacity(0.5),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                         }
//                         // else if (showVideoCarouselController != null &&
//                         //     showVideoCarouselController!) ...{
//                         //   Container(
//                         //     height: 35,
//                         //     child: Row(
//                         //       mainAxisAlignment: MainAxisAlignment.center,
//                         //       crossAxisAlignment: CrossAxisAlignment.center,
//                         //       children: List.generate(
//                         //           widget.data.videos!.length, (i) {
//                         //         return Container(
//                         //           width: i == index ? 8 : 6,
//                         //           height: i == index ? 8 : 6,
//                         //           margin: EdgeInsets.only(right: 2),
//                         //           decoration: BoxDecoration(
//                         //               shape: BoxShape.circle,
//                         //               color: i == index
//                         //                   ? Colors.blue
//                         //                   : Colors.grey.withOpacity(0.5)),
//                         //         );
//                         //       }),
//                         //     ),
//                         //   )
//                         // }
//                         else ...{
//                           Container(height: 50)
//                         },
//                         Positioned(
//                           bottom: 16,
//                           right: 12,
//                           child: Text(
//                             "${widget.data.views ?? "0"} Views",
//                             style: textStyle,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 12,
//                     ),
//                     Container(
//                       margin: EdgeInsets.symmetric(horizontal: 16),
//                       padding: EdgeInsets.symmetric(horizontal: 16),
//                       child: Text(
//                         widget.data.headline != null
//                             ? widget.data.headline!
//                             : "",
//                         textAlign: TextAlign.center,
//                         style: ThreeKmTextConstants.tk14PXPoppinsBlackBold
//                             .copyWith(
//                                 fontWeight: FontWeight.w900, fontSize: 14),
//                       ),
//                     ),
//                     Container(
//                       margin: EdgeInsets.only(left: 16, right: 16, bottom: 40),
//                       child: Text(
//                         removeHtml(widget.data.story ?? ""),
//                         textAlign: TextAlign.center,
//                         style: GoogleFonts.lato(
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black,
//                           fontSize: 14,
//                           height: 1.3,
//                         ),
//                       ),
//                       // Text(
//                       //   widget.data["story"] ?? "",
//                       //   // "As the Covid-19 vaccine completes its journey from laboratory to hospital, its pricing is being questioned. Public health activists and indus…",
//                       //   textAlign: TextAlign.center,
//                       //   style: textStyleLato.copyWith(
//                       //       fontWeight: FontWeight.w600, fontSize: 14),
//                       // ),
//                     ),
//                     SizedBox(
//                       height: 28,
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//         Positioned(
//           bottom: 12,
//           right: 0,
//           left: 0,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Transform.translate(
//                 offset: Offset(0, 0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       margin: EdgeInsets.only(right: 32),
//                       child: PhysicalModel(
//                         elevation: 5,
//                         shadowColor: Colors.pinkAccent.withOpacity(0.2),
//                         shape: BoxShape.circle,
//                         color: Colors.transparent,
//                         child: InkWell(
//                           onTap: () async {
//                             bool status = await getAuthStatus();
//                             if (status) {
//                               newsController.like(
//                                   widget.index, widget.data.postId!);
//                             } else {
//                               await Navigator.of(context).pushNamed(SignUp.path,
//                                   arguments: HomePage.path);
//                               status = await getAuthStatus();
//                               if (status) {
//                                 newsController.like(
//                                     widget.index, widget.data.postId!);
//                               }
//                             }
//                           },
//                           child: GetBuilder<NewsController>(
//                             builder: (_controller) =>
//                                 !(_controller.filteredGeoPageList![widget.index]
//                                             as PostResponse)
//                                         .isLiked!
//                                     ? Container(
//                                         padding: EdgeInsets.all(5),
//                                         decoration: BoxDecoration(
//                                             shape: BoxShape.circle,
//                                             color: likeColour),
//                                         child: Center(
//                                           child: Image.asset(
//                                             "assets/thumbs-up.png",
//                                             height: 40,
//                                             width: 40,
//                                           ),
//                                         ),
//                                       )
//                                     : Container(
//                                         margin: EdgeInsets.all(5),
//                                         child: Image.asset(
//                                           "assets/thumbs_up_red.png",
//                                           height: 50,
//                                           width: 50,
//                                         ),
//                                       ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       child: PhysicalModel(
//                         elevation: 5,
//                         shadowColor: Colors.blue.withOpacity(0.15),
//                         shape: BoxShape.circle,
//                         color: Colors.transparent,
//                         child: InkWell(
//                           onTap: () async {
//                             Navigator.of(context).pop(true);
//                           },
//                           child: Container(
//                             padding: EdgeInsets.all(10),
//                             margin: EdgeInsets.all(5),
//                             decoration: BoxDecoration(
//                                 shape: BoxShape.circle, color: Colors.white),
//                             child: Center(
//                               child: Image.asset(
//                                 "assets/icons-topic.png",
//                                 height: 30,
//                                 width: 30,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       margin: EdgeInsets.only(left: 32),
//                       child: PhysicalModel(
//                         elevation: 5,
//                         shadowColor: Colors.green.withOpacity(0.15),
//                         shape: BoxShape.circle,
//                         color: Colors.transparent,
//                         child: Container(
//                           padding: EdgeInsets.all(10),
//                           margin: EdgeInsets.all(5),
//                           decoration: BoxDecoration(
//                               shape: BoxShape.circle, color: Colors.white),
//                           child: Center(
//                             child: Image.asset(
//                               "assets/icons-share.png",
//                               height: 30,
//                               width: 30,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class ProfileDetailPopup extends StatefulWidget {
//   final PostResponse data;
//   final double? heightOfWebView;
//   final int index;
//   final VoidCallback? onTapComment;
//   ProfileDetailPopup(this.data,
//       {this.heightOfWebView, this.onTapComment, required this.index})
//       : super();

//   @override
//   _ProfileDetailPopupState createState() => _ProfileDetailPopupState();
// }

// class _ProfileDetailPopupState extends State<ProfileDetailPopup> {
//   late PageController controller;
//   int index = 0;
//   bool? carousel;
//   bool? showCarouselController;
//   bool? showVideoCarouselController;
//   Color likeColour = Colors.white;

//   void showComments() async {
//     await showGeneralDialog(
//       context: context,
//       barrierColor: Colors.black12.withOpacity(0.6), // background color
//       barrierDismissible:
//           false, // should dialog be dismissed when tapped outside
//       transitionDuration: Duration(milliseconds: 400),
//       useRootNavigator: false,
//       pageBuilder: (_context, anim, anim2) {
//         return Material(
//           color: Colors.black.withOpacity(0.3),
//           child: CommentPop(
//             newsDetailsData: widget.data,
//             onTap: () => Navigator.of(_context).pop(),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     controller = PageController();
//     runChecks();
//   }

//   runChecks() {
//     if (widget.data.images != null) {
//       carousel = widget.data.images!.length > 0 ? true : false;
//       showVideoCarouselController =
//           carousel! && widget.data.videos!.length > 1 ? true : false;
//       showCarouselController =
//           carousel! && widget.data.images!.length > 1 ? true : false;
//     }
//   }

//   Widget buildAvatar() {
//     return widget.data.author != null
//         ? CircleAvatar(
//             backgroundImage:
//                 CachedNetworkImageProvider(widget.data.author!.image!),
//           )
//         : CircleAvatar(
//             backgroundImage: AssetImage("assets/avatar.png"),
//           );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           clipBehavior: Clip.antiAlias,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(30),
//               topRight: Radius.circular(30),
//             ),
//           ),
//           child: CustomScrollView(
//             slivers: [
//               SliverToBoxAdapter(
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: 12,
//                     ),
//                     Row(
//                       children: [
//                         SizedBox(
//                           width: 16,
//                         ),
//                         buildAvatar(),
//                         SizedBox(
//                           width: 8,
//                         ),
//                         Expanded(
//                           child: Row(
//                             children: [
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Container(
//                                         constraints: BoxConstraints(
//                                           minWidth: 50,
//                                           maxWidth: 164,
//                                         ),
//                                         child: Container(
//                                           child: Text(
//                                             widget.data.author != null
//                                                 ? widget.data.author!.name!
//                                                 : "User",
//                                             overflow: TextOverflow.ellipsis,
//                                             style: ThreeKmTextConstants
//                                                 .tk14PXPoppinsBlackBold
//                                                 .copyWith(
//                                                     fontWeight:
//                                                         FontWeight.w600),
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(width: 19),
//                                       if (widget.data.status != null &&
//                                           widget.data.isVerified == true) ...{
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
//                                                 fontSize: 12,
//                                                 color: Color(0xFF8A939B),
//                                                 fontWeight: FontWeight.normal),
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
//                                         style: ThreeKmTextConstants
//                                             .tk11PXLatoGreyBold
//                                             .copyWith(
//                                           fontSize: 10.5,
//                                           fontWeight: FontWeight.w700,
//                                           color: Color(0xFFA7AEB4),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         Container(
//                           margin: EdgeInsets.only(right: 8, left: 36),
//                           child: Icon(Icons.more_vert),
//                         )
//                       ],
//                     ),
//                     SizedBox(
//                       height: 15,
//                     ),
//                   ],
//                 ),
//               ),
//               SliverAppBar(
//                 backgroundColor: Colors.white,
//                 leading: Container(),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30),
//                     topRight: Radius.circular(30),
//                   ),
//                 ),
//                 expandedHeight: 254,
//                 flexibleSpace: FlexibleSpaceBar(
//                   background: Container(
//                     height: 254,
//                     child: PageView(
//                       controller: controller,
//                       onPageChanged: (v) => setState(() => index = v),
//                       children: carousel != null && carousel!
//                           ? widget.data.images!
//                               .map((e) => Image.network(
//                                     e,
//                                     fit: BoxFit.cover,
//                                   ))
//                               .toList()
//                           : carousel != null
//                               ? widget.data.videos!
//                                   .map((e) => ChewieVideo(e['src']))
//                                   .toList()
//                               : [Container()],
//                     ),
//                   ),
//                 ),
//               ),
//               SliverToBoxAdapter(
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: 4,
//                     ),
//                     Stack(
//                       children: [
//                         Positioned(
//                           bottom: 8,
//                           left: 90,
//                           child: Container(
//                             height: 40,
//                             width: 40,
//                             padding: EdgeInsets.all(2),
//                             decoration: BoxDecoration(
//                                 color: Colors.red, shape: BoxShape.circle),
//                             child: Center(
//                               child: GetBuilder<AuthorProfileController>(
//                                 builder: (_controller) => Text(
//                                   calculateComments(
//                                       (_controller.posts[widget.index]).likes ??
//                                           0),
//                                   textAlign: TextAlign.center,
//                                   style: textStyle.copyWith(
//                                       color: Colors.white, fontSize: 11),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           bottom: 16,
//                           left: 12,
//                           child: Center(
//                             child: Text(
//                               "👍❤️😩",
//                               textAlign: TextAlign.center,
//                               style: textStyle.copyWith(fontSize: 20),
//                             ),
//                           ),
//                         ),
//                         if (showCarouselController != null &&
//                             showCarouselController!) ...{
//                           Container(
//                             height: 50,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: List.generate(
//                                 widget.data.images!.length > 12
//                                     ? 12
//                                     : widget.data.images!.length,
//                                 (i) {
//                                   return Container(
//                                     width: i == index ? 8 : 6,
//                                     height: i == index ? 8 : 6,
//                                     margin: EdgeInsets.only(right: 2),
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: i == index || i >= 12
//                                           ? Colors.blue
//                                           : Colors.grey.withOpacity(0.5),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                         }
//                         // else if (showVideoCarouselController != null &&
//                         //     showVideoCarouselController!) ...{
//                         //   Container(
//                         //     height: 35,
//                         //     child: Row(
//                         //       mainAxisAlignment: MainAxisAlignment.center,
//                         //       crossAxisAlignment: CrossAxisAlignment.center,
//                         //       children: List.generate(
//                         //           widget.data.videos!.length, (i) {
//                         //         return Container(
//                         //           width: i == index ? 8 : 6,
//                         //           height: i == index ? 8 : 6,
//                         //           margin: EdgeInsets.only(right: 2),
//                         //           decoration: BoxDecoration(
//                         //               shape: BoxShape.circle,
//                         //               color: i == index
//                         //                   ? Colors.blue
//                         //                   : Colors.grey.withOpacity(0.5)),
//                         //         );
//                         //       }),
//                         //     ),
//                         //   )
//                         // }
//                         else ...{
//                           Container(height: 50)
//                         },
//                         Positioned(
//                           bottom: 16,
//                           right: 12,
//                           child: Text(
//                             "${widget.data.views ?? "0"} Views",
//                             style: textStyle,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 12,
//                     ),
//                     Container(
//                       margin: EdgeInsets.symmetric(horizontal: 16),
//                       padding: EdgeInsets.symmetric(horizontal: 16),
//                       child: Text(
//                         widget.data.headline != null
//                             ? widget.data.headline!
//                             : "",
//                         textAlign: TextAlign.center,
//                         style: ThreeKmTextConstants.tk14PXPoppinsBlackBold
//                             .copyWith(
//                                 fontWeight: FontWeight.w900, fontSize: 14),
//                       ),
//                     ),
//                     Container(
//                       margin: EdgeInsets.only(left: 16, right: 16, bottom: 40),
//                       child: Text(
//                         removeHtml(widget.data.story ?? ""),
//                         textAlign: TextAlign.center,
//                         style: GoogleFonts.lato(
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black,
//                           fontSize: 14,
//                           height: 1.3,
//                         ),
//                       ),
//                       // Text(
//                       //   widget.data["story"] ?? "",
//                       //   // "As the Covid-19 vaccine completes its journey from laboratory to hospital, its pricing is being questioned. Public health activists and indus…",
//                       //   textAlign: TextAlign.center,
//                       //   style: textStyleLato.copyWith(
//                       //       fontWeight: FontWeight.w600, fontSize: 14),
//                       // ),
//                     ),
//                     SizedBox(
//                       height: 28,
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//         Positioned(
//           bottom: 12,
//           right: 0,
//           left: 0,
//           child: GetBuilder<AuthorProfileController>(
//             builder: (_controller) => Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Transform.translate(
//                   offset: Offset(0, 0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         margin: EdgeInsets.only(right: 32),
//                         child: PhysicalModel(
//                           elevation: 5,
//                           shadowColor: Colors.pinkAccent.withOpacity(0.2),
//                           shape: BoxShape.circle,
//                           color: Colors.transparent,
//                           child: InkWell(
//                             onTap: () async {
//                               bool status = await getAuthStatus();
//                               if (status) {
//                                 _controller.like(
//                                   widget.index,
//                                   widget.data.postId!,
//                                 );
//                               } else {
//                                 await Navigator.of(context).pushNamed(
//                                     SignUp.path,
//                                     arguments: HomePage.path);
//                                 status = await getAuthStatus();
//                                 if (status) {
//                                   _controller.like(
//                                     widget.index,
//                                     widget.data.postId!,
//                                   );
//                                 }
//                               }
//                             },
//                             child: GetBuilder<AuthorProfileController>(
//                               builder: (_controller) =>
//                                   !_controller.posts[widget.index].isLiked!
//                                       ? Container(
//                                           padding: EdgeInsets.all(5),
//                                           decoration: BoxDecoration(
//                                               shape: BoxShape.circle,
//                                               color: likeColour),
//                                           child: Center(
//                                             child: Image.asset(
//                                               "assets/thumbs-up.png",
//                                               height: 40,
//                                               width: 40,
//                                             ),
//                                           ),
//                                         )
//                                       : Container(
//                                           margin: EdgeInsets.all(5),
//                                           child: Image.asset(
//                                             "assets/thumbs_up_red.png",
//                                             height: 50,
//                                             width: 50,
//                                           ),
//                                         ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Container(
//                         child: PhysicalModel(
//                           elevation: 5,
//                           shadowColor: Colors.blue.withOpacity(0.15),
//                           shape: BoxShape.circle,
//                           color: Colors.transparent,
//                           child: InkWell(
//                             onTap: () async {
//                               Navigator.of(context).pop(true);
//                             },
//                             child: Container(
//                               padding: EdgeInsets.all(10),
//                               margin: EdgeInsets.all(5),
//                               decoration: BoxDecoration(
//                                   shape: BoxShape.circle, color: Colors.white),
//                               child: Center(
//                                 child: Image.asset(
//                                   "assets/icons-topic.png",
//                                   height: 30,
//                                   width: 30,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Container(
//                         margin: EdgeInsets.only(left: 32),
//                         child: PhysicalModel(
//                           elevation: 5,
//                           shadowColor: Colors.green.withOpacity(0.15),
//                           shape: BoxShape.circle,
//                           color: Colors.transparent,
//                           child: Container(
//                             padding: EdgeInsets.all(10),
//                             margin: EdgeInsets.all(5),
//                             decoration: BoxDecoration(
//                                 shape: BoxShape.circle, color: Colors.white),
//                             child: Center(
//                               child: Image.asset(
//                                 "assets/icons-share.png",
//                                 height: 30,
//                                 width: 30,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
