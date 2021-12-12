// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:threekm/api_models/response/post_response.dart';
// import 'package:threekm/apis/api_calls.dart';
// import 'package:threekm/models/comment_controller.dart';
// import 'package:threekm/models/news_controller.dart';
// import 'package:threekm/pages/author_profile.dart';
// import 'package:threekm/pages/home/home_page.dart';
// import 'package:threekm/pages/signup/sign_up.dart';
// import 'package:threekm/setup/setup.dart';
// import 'package:threekm/utils/constants.dart';
// import 'package:threekm/utils/threekm_textstyles.dart';
// import 'package:threekm/utils/util_methods.dart';
// import 'package:threekm/widgets/chewie_video.dart';
// import 'package:threekm/widgets/custom_button.dart';
// import 'package:threekm/widgets/news_card.dart';
// import 'package:threekm/widgets/news_comment_popup.dart';
// import 'package:threekm/widgets/text_field.dart';

// class NewsDetailPopupGeneric extends StatefulWidget {
//   final int data;
//   final PostResponse? setter;
//   final double? heightOfWebView;
//   final int index;
//   final VoidCallback? onTapComment;
//   NewsDetailPopupGeneric(this.data,
//       {this.heightOfWebView,
//       this.onTapComment,
//       required this.index,
//       this.setter})
//       : super();

//   @override
//   _NewsDetailPopupGenericState createState() => _NewsDetailPopupGenericState();
// }

// class _NewsDetailPopupGenericState extends State<NewsDetailPopupGeneric> {
//   late PageController controller;
//   int index = 0;
//   bool? carousel;
//   bool? showCarouselController;
//   bool? showVideoCarouselController;
//   Color likeColour = Colors.white;
//   PostResponse? response;
//   var commentText = TextEditingController();
//   var commentController = Get.find<CommentController>();

//   // void showComments() async {
//   //   await showGeneralDialog(
//   //     context: context,
//   //     barrierColor: Colors.black12.withOpacity(0.6), // background color
//   //     barrierDismissible:
//   //         false, // should dialog be dismissed when tapped outside
//   //     routeSettings: RouteSettings(name: "comments"),
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

//   @override
//   void initState() {
//     super.initState();
//     controller = PageController();
//     // runChecks();
//     getPost();
//     commentController.getAllComments(widget.data);
//   }

//   getPost() async {
//     var data = await ApiCalls.getNewsDetails(widget.data);
//     print(data);
//     if (data != null) {
//       response = data;
//       runChecks();
//       postFrame(() => setState(() {}));
//     }
//   }

//   runChecks() {
//     if (response!.images != null) {
//       carousel = response!.images!.length > 0 ? true : false;
//       showVideoCarouselController =
//           carousel! && response!.videos!.length > 1 ? true : false;
//       showCarouselController =
//           carousel! && response!.images!.length > 1 ? true : false;
//     }
//   }

//   Widget buildAvatar() {
//     return response != null && response!.author != null
//         ? CircleAvatar(
//             backgroundImage:
//                 CachedNetworkImageProvider(response!.author!.image!),
//           )
//         : CircleAvatar(
//             backgroundImage: AssetImage("assets/avatar.png"),
//           );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return response != null
//         ? Stack(
//             children: [
//               Container(
//                 clipBehavior: Clip.antiAlias,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30),
//                     topRight: Radius.circular(30),
//                   ),
//                 ),
//                 child: CustomScrollView(
//                   slivers: [
//                     SliverToBoxAdapter(
//                       child: Column(
//                         children: [
//                           SizedBox(
//                             height: 12,
//                           ),
//                           GestureDetector(
//                             onTap: () => Navigator.of(context).pushNamed(
//                               AuthorProfile.path,
//                               arguments: {
//                                 "id": response!.author!.id!,
//                                 "avatar": response!.author!.image,
//                                 "user_name": response!.author!.name,
//                               },
//                             ),
//                             child: Row(
//                               children: [
//                                 SizedBox(
//                                   width: 16,
//                                 ),
//                                 buildAvatar(),
//                                 SizedBox(
//                                   width: 8,
//                                 ),
//                                 Expanded(
//                                   child: Row(
//                                     children: [
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Row(
//                                             children: [
//                                               Container(
//                                                 constraints: BoxConstraints(
//                                                   minWidth: 50,
//                                                   maxWidth: 164,
//                                                 ),
//                                                 child: Container(
//                                                   child: Text(
//                                                     response!.author != null
//                                                         ? response!
//                                                             .author!.name!
//                                                         : "User",
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                     style: GoogleFonts.poppins(
//                                                       fontSize: 14,
//                                                       fontWeight:
//                                                           FontWeight.w500,
//                                                       color: Color(0xFF232629),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(width: 19),
//                                               if (response!.status != null &&
//                                                   response!.isVerified ==
//                                                       true) ...{
//                                                 Image.asset(
//                                                   "assets/icons-guarantee.png",
//                                                   width: 20,
//                                                   height: 20,
//                                                 ),
//                                               }
//                                             ],
//                                           ),
//                                           Row(
//                                             children: [
//                                               Text(
//                                                 response!.authorClassification !=
//                                                         null
//                                                     ? response!
//                                                         .authorClassification!
//                                                     : "User",
//                                                 style: ThreeKmTextConstants
//                                                     .tk11PXLatoGreyBold
//                                                     .copyWith(
//                                                         fontSize: 12,
//                                                         color:
//                                                             Color(0xFF8A939B),
//                                                         fontWeight:
//                                                             FontWeight.normal),
//                                               ),
//                                               SizedBox(
//                                                 width: 12,
//                                               ),
//                                               Container(
//                                                 height: 5,
//                                                 width: 5,
//                                                 decoration: BoxDecoration(
//                                                     color: Color(0XFFC4C9CD),
//                                                     shape: BoxShape.circle),
//                                               ),
//                                               SizedBox(
//                                                 width: 12,
//                                               ),
//                                               Text(
//                                                 response!.createdDate ?? "",
//                                                 style: ThreeKmTextConstants
//                                                     .tk11PXLatoGreyBold
//                                                     .copyWith(
//                                                   fontSize: 10.5,
//                                                   fontWeight: FontWeight.w700,
//                                                   color: Color(0xFFA7AEB4),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Container(
//                                   margin: EdgeInsets.only(right: 8, left: 36),
//                                   child: Icon(
//                                     Icons.more_vert,
//                                     color: Color(0xFF979EA4),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             height: 15,
//                           ),
//                         ],
//                       ),
//                     ),
//                     SliverAppBar(
//                       backgroundColor: Colors.white,
//                       leading: Container(),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(30),
//                           topRight: Radius.circular(30),
//                         ),
//                       ),
//                       expandedHeight: 254,
//                       flexibleSpace: FlexibleSpaceBar(
//                         background: Container(
//                           height: 254,
//                           child: PageView(
//                             controller: controller,
//                             onPageChanged: (v) => setState(() => index = v),
//                             children: carousel != null && carousel!
//                                 ? response!.images!
//                                     .map((e) => CachedNetworkImage(
//                                           imageUrl: e,
//                                           fit: BoxFit.contain,
//                                         ))
//                                     .toList()
//                                 : carousel != null
//                                     ? response!.videos!
//                                         .map((e) => ChewieVideo(e['src']))
//                                         .toList()
//                                     : [Container()],
//                           ),
//                         ),
//                       ),
//                     ),
//                     SliverToBoxAdapter(
//                       child: Column(
//                         children: [
//                           SizedBox(
//                             height: 4,
//                           ),
//                           Stack(
//                             children: [
//                               Positioned(
//                                 bottom: 8,
//                                 left: 90,
//                                 child: Container(
//                                   height: 40,
//                                   width: 40,
//                                   padding: EdgeInsets.all(2),
//                                   decoration: BoxDecoration(
//                                       color: Colors.red,
//                                       shape: BoxShape.circle),
//                                   child: Center(
//                                     child: GetBuilder<NewsController>(
//                                       builder: (_controller) => Text(
//                                         calculateComments(response!.likes ?? 0),
//                                         textAlign: TextAlign.center,
//                                         style: textStyle.copyWith(
//                                             color: Colors.white, fontSize: 11),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Positioned(
//                                 bottom: 16,
//                                 left: 12,
//                                 child: Center(
//                                   child: Text(
//                                     "👍❤️😩",
//                                     textAlign: TextAlign.center,
//                                     style: textStyle.copyWith(fontSize: 20),
//                                   ),
//                                 ),
//                               ),
//                               if (showCarouselController != null &&
//                                   showCarouselController!) ...{
//                                 Container(
//                                   height: 50,
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: List.generate(
//                                       response!.images!.length > 12
//                                           ? 12
//                                           : response!.images!.length,
//                                       (i) {
//                                         return Container(
//                                           width: i == index ? 8 : 6,
//                                           height: i == index ? 8 : 6,
//                                           margin: EdgeInsets.only(right: 2),
//                                           decoration: BoxDecoration(
//                                             shape: BoxShape.circle,
//                                             color: i == index || i >= 12
//                                                 ? Colors.blue
//                                                 : Colors.grey.withOpacity(0.5),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                               }
//                               // else if (showVideoCarouselController != null &&
//                               //     showVideoCarouselController!) ...{
//                               //   Container(
//                               //     height: 35,
//                               //     child: Row(
//                               //       mainAxisAlignment: MainAxisAlignment.center,
//                               //       crossAxisAlignment: CrossAxisAlignment.center,
//                               //       children: List.generate(
//                               //           widget.data.videos!.length, (i) {
//                               //         return Container(
//                               //           width: i == index ? 8 : 6,
//                               //           height: i == index ? 8 : 6,
//                               //           margin: EdgeInsets.only(right: 2),
//                               //           decoration: BoxDecoration(
//                               //               shape: BoxShape.circle,
//                               //               color: i == index
//                               //                   ? Colors.blue
//                               //                   : Colors.grey.withOpacity(0.5)),
//                               //         );
//                               //       }),
//                               //     ),
//                               //   )
//                               // }
//                               else ...{
//                                 Container(height: 50)
//                               },
//                               Positioned(
//                                 bottom: 16,
//                                 right: 12,
//                                 child: Text(
//                                   "${response!.views ?? "0"} Views",
//                                   style: textStyle,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                             height: 12,
//                           ),
//                           Container(
//                             margin: EdgeInsets.symmetric(horizontal: 16),
//                             padding: EdgeInsets.symmetric(horizontal: 16),
//                             child: Text(
//                               response!.headline != null
//                                   ? response!.headline!
//                                   : "",
//                               textAlign: TextAlign.center,
//                               style: ThreeKmTextConstants.tk14PXPoppinsBlackBold
//                                   .copyWith(
//                                       fontWeight: FontWeight.w900,
//                                       fontSize: 14),
//                             ),
//                           ),
//                           Container(
//                             margin: EdgeInsets.only(
//                                 left: 16, right: 16, bottom: 40),
//                             child: Text(
//                               removeHtml(response!.story ?? ""),
//                               textAlign: TextAlign.center,
//                               style: GoogleFonts.lato(
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.black,
//                                 fontSize: 14,
//                                 height: 1.3,
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 28,
//                           ),
//                           Obx(
//                             () => ListView.builder(
//                                 shrinkWrap: true,
//                                 itemBuilder: (context, i) {
//                                   return Container(
//                                     padding: EdgeInsets.only(
//                                         left: 18, right: 18, bottom: 32),
//                                     child: CommentWidget(
//                                         commentController.comments[i].avatar,
//                                         commentController.comments[i].username,
//                                         commentController.comments[i].comment,
//                                         commentController
//                                             .comments[i].timeLapsed,
//                                         commentController.comments[i].commentId,
//                                         commentController.comments[i].isSelf,
//                                         response!.postId!),
//                                   );
//                                 },
//                                 itemCount: commentController.comments.length),
//                           ),
//                           Container(
//                             padding: EdgeInsets.only(
//                                 left: 18, right: 18, bottom: 32),
//                             child: CustomTextField(
//                               controller: commentText,
//                               border: false,
//                               fillColor: Color(0XFF0F0F2D).withOpacity(0.05),
//                               height: 116,
//                               hint: "Type a comment…",
//                               hintStyle: GoogleFonts.lato(
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 14,
//                                 color: Color(0xFF0F0F2D),
//                               ),
//                               style: ThreeKmTextConstants.tk14PXLatoBlackMedium,
//                               borderRadius: 20,
//                             ),
//                           ),
//                           Container(
//                             padding: EdgeInsets.only(
//                                 left: 18, right: 18, bottom: 32),
//                             child: Row(
//                               children: [
//                                 CustomButton(
//                                   width: 102,
//                                   height: 40,
//                                   elevation: 0,
//                                   color: Colors.blue,
//                                   borderRadius: BorderRadius.circular(18),
//                                   onTap: () async {
//                                     bool status = await getAuthStatus();
//                                     if (status) {
//                                       // widget.onTapComment(widget.data);
//                                       if (commentText.text.length > 0) {
//                                         commentController.postComment(
//                                           commentText.text,
//                                           response!.postId!,
//                                         );
//                                         commentText.text = "";
//                                       }
//                                     } else {
//                                       await Navigator.of(context).pushNamed(
//                                           SignUp.path,
//                                           arguments: HomePage.path);
//                                       bool status = await getAuthStatus();
//                                       if (status) {
//                                         commentController.postComment(
//                                           commentText.text,
//                                           response!.postId!,
//                                         );
//                                         commentText.text = "";
//                                       }
//                                     }
//                                   },
//                                   child: Text(
//                                     "Submit",
//                                     style: ThreeKmTextConstants
//                                         .tk14PXPoppinsWhiteMedium,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             height: 80,
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               Positioned(
//                 bottom: 0,
//                 right: 0,
//                 left: 0,
//                 child: Stack(
//                   children: [
//                     Container(
//                       color: Colors.blue,
//                       height: 65,
//                     ),
//                     Transform.translate(
//                       offset: Offset(0, -32),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Transform.translate(
//                             offset: Offset(0, 0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Container(
//                                   margin: EdgeInsets.only(right: 32),
//                                   child: LikeButton(
//                                     index: 0,
//                                     response: response!,
//                                     setter: widget.setter,
//                                     onDone: () => setState(() {}),
//                                     size: Size(50, 50),
//                                     unlikeSize: Size(35, 35),
//                                   ),
//                                 ),
//                                 Container(
//                                   child: InkWell(
//                                     onTap: () async {
//                                       print("tapped");
//                                       Navigator.of(context).pop(CommentDetails(
//                                           comment: true,
//                                           response: response!,
//                                           isLiked: response!.isLiked!));
//                                     },
//                                     child: Container(
//                                       padding: EdgeInsets.all(12),
//                                       margin: EdgeInsets.all(5),
//                                       decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Colors.blue.withOpacity(0.2),
//                                             offset: Offset(
//                                               0,
//                                               3,
//                                             ),
//                                             blurRadius: 12,
//                                           ),
//                                         ],
//                                         color: Colors.white,
//                                       ),
//                                       child: Center(
//                                         child: Image.asset(
//                                           "assets/icons-topic.png",
//                                           height: 28,
//                                           width: 28,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                   margin: EdgeInsets.only(left: 32),
//                                   child: Container(
//                                     padding: EdgeInsets.all(14),
//                                     margin: EdgeInsets.all(5),
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.green.withOpacity(0.2),
//                                           offset: Offset(
//                                             0,
//                                             3,
//                                           ),
//                                           blurRadius: 12,
//                                         ),
//                                       ],
//                                       color: Colors.white,
//                                     ),
//                                     child: Center(
//                                       child: Image.asset(
//                                         "assets/icons-share.png",
//                                         height: 26,
//                                         width: 26,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           )
//         : Center(
//             child: CupertinoActivityIndicator(),
//           );
//   }
// }
