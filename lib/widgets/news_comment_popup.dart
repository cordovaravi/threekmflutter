// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:threekm/api_models/request/all_comments_request/all_comments_request.dart';
// import 'package:threekm/api_models/response/post_response.dart';
// import 'package:threekm/models/comment_controller.dart';
// import 'package:threekm/pages/author_profile.dart';
// import 'package:threekm/pages/home/home_page.dart';
// import 'package:threekm/pages/signup/sign_up.dart';
// import 'package:threekm/repository/home_repository.dart';
// import 'package:threekm/setup/setup.dart';
// import 'package:threekm/utils/constants.dart';
// import 'package:threekm/utils/threekm_textstyles.dart';
// import 'package:threekm/utils/util_methods.dart';
// import 'package:threekm/widgets/chewie_video.dart';
// import 'package:threekm/widgets/custom_button.dart';
// import 'package:threekm/widgets/overlapped_image.dart';
// import 'package:threekm/widgets/text_field.dart';

// import 'comment_clipper.dart';

// class NewsCommentPopup extends StatefulWidget {
//   final PostResponse data;
//   final double? heightOfWebView;
//   final VoidCallback? onTap;
//   NewsCommentPopup(this.data, {this.heightOfWebView, this.onTap})
//       : super(key: ValueKey("NewsCommentPopup"));

//   @override
//   _NewsCommentPopupState createState() => _NewsCommentPopupState();
// }

// class _NewsCommentPopupState extends State<NewsCommentPopup> {
//   late PageController controller;
//   int index = 0;
//   bool? carousel;
//   bool? showCarouselController;
//   bool? showVideoCarouselController;
//   var commentController = Get.find<CommentController>();
//   var commentText = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     controller = PageController();
//     if (widget.data.images != null && widget.data.videos != null) {
//       carousel = widget.data.images!.length > 0 ? true : false;
//       showVideoCarouselController =
//           carousel! && widget.data.videos!.length > 1 ? true : false;
//       showCarouselController =
//           carousel! && widget.data.images!.length > 1 ? true : false;
//     }
//     commentController.getAllComments(widget.data.postId!);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         NestedScrollView(
//           body: SingleChildScrollView(
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(30),
//                   topRight: Radius.circular(30),
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   if (widget.data.postId != null) ...{
//                     Transform.translate(
//                       offset: Offset(0, -60),
//                       child: ClipPath(
//                         clipper: CommentClipper(),
//                         child: Container(
//                           color: Colors.white,
//                           child: Column(children: [
//                             SizedBox(
//                               height: 40,
//                             ),
//                             Container(
//                               height: 28,
//                               width: MediaQuery.of(context).size.width,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Container(
//                                     width: 24,
//                                     child: Divider(
//                                       color: Colors.grey,
//                                       thickness: 3,
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               height: 60,
//                               width: MediaQuery.of(context).size.width,
//                               padding: EdgeInsets.symmetric(horizontal: 18),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Image.asset(
//                                         "assets/icons-topic.png",
//                                         height: 32,
//                                         width: 32,
//                                       ),
//                                       Container(
//                                         padding: EdgeInsets.only(left: 8),
//                                         child: Obx(
//                                           () => Text(
//                                             "${commentController.comments.length} Comments",
//                                             style: ThreeKmTextConstants
//                                                 .tk14PXPoppinsBlueMedium,
//                                           ),
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                   Obx(
//                                     () => OverlappedImage(
//                                       commentController.comments
//                                           .map((element) => element.avatar)
//                                           .toSet()
//                                           .toList()
//                                           .sublist(
//                                               0,
//                                               commentController
//                                                           .comments.length >
//                                                       3
//                                                   ? 2
//                                                   : null),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Divider(thickness: 1, color: Colors.grey),
//                             SizedBox(
//                               height: 12,
//                             ),
//                             Obx(
//                               () => ListView.builder(
//                                   shrinkWrap: true,
//                                   itemBuilder: (context, i) {
//                                     return Container(
//                                       padding: EdgeInsets.only(
//                                           left: 18, right: 18, bottom: 32),
//                                       child: CommentWidget(
//                                           commentController.comments[i].avatar,
//                                           commentController
//                                               .comments[i].username,
//                                           commentController.comments[i].comment,
//                                           commentController
//                                               .comments[i].timeLapsed,
//                                           commentController
//                                               .comments[i].commentId,
//                                           commentController.comments[i].isSelf,
//                                           widget.data.postId!),
//                                     );
//                                   },
//                                   itemCount: commentController.comments.length),
//                             ),
//                             Container(
//                               padding: EdgeInsets.only(
//                                   left: 18, right: 18, bottom: 32),
//                               child: CustomTextField(
//                                 controller: commentText,
//                                 border: false,
//                                 fillColor: Color(0XFF0F0F2D).withOpacity(0.05),
//                                 height: 116,
//                                 hint: "Type a comment…",
//                                 hintStyle: GoogleFonts.lato(
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 14,
//                                   color: Color(0xFF0F0F2D),
//                                 ),
//                                 style:
//                                     ThreeKmTextConstants.tk14PXLatoBlackMedium,
//                                 borderRadius: 20,
//                               ),
//                             ),
//                             Container(
//                               padding: EdgeInsets.only(
//                                   left: 18, right: 18, bottom: 32),
//                               child: Row(
//                                 children: [
//                                   CustomButton(
//                                     width: 102,
//                                     height: 40,
//                                     elevation: 0,
//                                     color: Colors.blue,
//                                     borderRadius: BorderRadius.circular(18),
//                                     onTap: () async {
//                                       bool status = await getAuthStatus();
//                                       if (status) {
//                                         // widget.onTapComment(widget.data);
//                                         if (commentText.text.length > 0) {
//                                           commentController.postComment(
//                                             commentText.text,
//                                             widget.data.postId!,
//                                           );
//                                           commentText.text = "";
//                                         }
//                                       } else {
//                                         await Navigator.of(context).pushNamed(
//                                             SignUp.path,
//                                             arguments: HomePage.path);
//                                         bool status = await getAuthStatus();
//                                         if (status) {
//                                           commentController.postComment(
//                                             commentText.text,
//                                             widget.data.postId!,
//                                           );
//                                           commentText.text = "";
//                                         }
//                                       }
//                                     },
//                                     child: Text(
//                                       "Submit",
//                                       style: ThreeKmTextConstants
//                                           .tk14PXPoppinsWhiteMedium,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             )
//                           ]),
//                         ),
//                       ),
//                     ),
//                   }
//                 ],
//               ),
//             ),
//           ),
//           headerSliverBuilder: (context, innerBoxIsScrolled) => [
//             SliverAppBar(
//               pinned: false,
//               floating: false,
//               leading: Container(),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30))),
//               expandedHeight: 325,
//               backgroundColor: Colors.white,
//               flexibleSpace: FlexibleSpaceBar(
//                 background: Column(children: [
//                   if (widget.data.postId != null) ...{
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
//                           widget.data.author != null
//                               ? CircleAvatar(
//                                   backgroundImage: CachedNetworkImageProvider(
//                                       widget.data.author!.image!),
//                                 )
//                               : CircleAvatar(
//                                   backgroundImage:
//                                       AssetImage("assets/avatar.png"),
//                                 ),
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
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
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
//                                           width: 8,
//                                         ),
//                                         Container(
//                                           height: 5,
//                                           width: 5,
//                                           margin: EdgeInsets.only(top: 2),
//                                           decoration: BoxDecoration(
//                                             color: Colors.grey.withOpacity(0.7),
//                                             shape: BoxShape.circle,
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: 8,
//                                         ),
//                                         Text(
//                                           widget.data.createdDate ?? "",
//                                           style: textStyleLato.copyWith(
//                                               fontSize: 12,
//                                               fontWeight: FontWeight.normal,
//                                               color: Colors.grey),
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
//                     Container(
//                       height: 280,
//                       child: PageView(
//                         controller: controller,
//                         onPageChanged: (v) => setState(() => index = v),
//                         children: carousel != null && carousel!
//                             ? widget.data.images!
//                                 .map(
//                                   (e) => CachedNetworkImage(
//                                     imageUrl: e,
//                                     fit: BoxFit.contain,
//                                   ),
//                                 )
//                                 .toList()
//                             : carousel != null
//                                 ? widget.data.videos!
//                                     .map((e) => ChewieVideo(e['src']))
//                                     .toList()
//                                 : [Container()],
//                       ),
//                     ),
//                   }
//                 ]),
//               ),
//             )
//           ],
//         )
//       ],
//     );
//   }
// }

// class CommentWidget extends StatefulWidget {
//   final String url;
//   final int id;
//   final int postId;
//   final String title;
//   final bool isSelf;
//   final String comment;
//   final String timeOfComment;
//   CommentWidget(this.url, this.title, this.comment, this.timeOfComment, this.id,
//       this.isSelf, this.postId);
//   @override
//   _CommentWidgetState createState() => _CommentWidgetState();
// }

// class _CommentWidgetState extends State<CommentWidget> {
//   bool liked = false;
//   Color likeColour = Colors.white;
//   var commentController = Get.find<CommentController>();

//   @override
//   void initState() {
//     super.initState();
//     checkLikes();
//   }

//   deletePost() async {
//     bool update = await commentController.deleteComments({
//       "module": "news_post",
//       "entity_id": widget.postId,
//       "comment_id": widget.id
//     });
//     if (update) {
//       commentController.getAllComments(widget.postId);
//     }
//   }

//   checkLikes() {
//     HomeRepository.allLikes(
//             AllCommentsRequest(entityId: widget.id, module: "user_comments"))
//         .then((e) {
//       if (e['data'] != null && e['data']['result']['count'] > 0) {
//         if (mounted) {
//           setState(() {
//             likeColour = Colors.white;
//             liked = true;
//           });
//         }
//       } else {
//         if (mounted) {
//           setState(() {
//             liked = false;
//           });
//         }
//       }
//     });
//   }

//   like() async {
//     var count;
//     if (!liked) {
//       count = await HomeRepository.like({
//         "module": "user_comments",
//         "entity_id": widget.id,
//         "emotion": "love"
//       });
//     } else {
//       count = await HomeRepository.unlike({
//         "module": "user_comments",
//         "entity_id": widget.id,
//         "emotion": "love"
//       });
//     }
//     if (count['data'] != null) {
//       if (liked) {
//         if (mounted) {
//           setState(() {
//             liked = false;
//             likeColour = Colors.white;
//           });
//         }
//       } else {
//         if (mounted) {
//           setState(() {
//             liked = true;
//             likeColour = Colors.red.withOpacity(0.6);
//           });
//         }
//       }
//     }
//   }

//   Widget buildLikeButton() {
//     return Transform.translate(
//       offset: Offset(0, -12),
//       child: !liked
//           ? Container(
//               padding: EdgeInsets.all(5),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.pink.withOpacity(0.015),
//               ),
//               child: Center(
//                 child: Image.asset(
//                   "assets/thumbs-up.png",
//                   height: 28,
//                   width: 28,
//                 ),
//               ),
//             )
//           : Container(
//               padding: EdgeInsets.all(5),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.red.withOpacity(0.8),
//               ),
//               child: Image.asset(
//                 "assets/thumbs_up_red.png",
//                 height: 28,
//                 width: 28,
//               ),
//             ),
//     );
//   }

//   Widget buildCommentDescription() {
//     return Expanded(
//       child: Container(
//         padding: EdgeInsets.only(left: 7, right: 7),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               widget.title,
//               style: ThreeKmTextConstants.tk14PXPoppinsBlackSemiBold,
//             ),
//             SizedBox(
//               height: 4,
//             ),
//             Text(
//               widget.comment,
//               style: ThreeKmTextConstants.tk14PXLatoBlackMedium.copyWith(
//                 fontWeight: FontWeight.w500,
//                 color: Color(0xFF0F0F2D),
//               ),
//             ),
//             SizedBox(
//               height: 8,
//             ),
//             Text(
//               widget.timeOfComment,
//               style: ThreeKmTextConstants.tk11PXLatoGreyBold
//                   .copyWith(fontSize: 10.5),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildAvatar() {
//     return CircleAvatar(
//       radius: 20,
//       backgroundImage: CachedNetworkImageProvider(widget.url),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () => print(widget.id.toString()),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           buildAvatar(),
//           space(width: 4),
//           buildCommentDescription(),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               if (widget.isSelf) ...{
//                 PopupMenuButton(
//                   iconSize: 20,
//                   icon: Icon(Icons.more_vert),
//                   offset: Offset(0, -6),
//                   padding: EdgeInsets.only(bottom: 14),
//                   onSelected: (value) {
//                     switch (value) {
//                       case "delete":
//                         {
//                           print(value);
//                           deletePost();
//                           break;
//                         }
//                     }
//                   },
//                   itemBuilder: (context) {
//                     return [
//                       PopupMenuItem(
//                         value: "delete",
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "Delete",
//                               style: ThreeKmTextConstants.tk14PXPoppinsBlackBold
//                                   .copyWith(fontWeight: FontWeight.w500),
//                             ),
//                             Icon(Icons.delete_forever, color: Colors.red),
//                           ],
//                         ),
//                       ),
//                     ];
//                   },
//                 ),
//               } else ...{
//                 Container(
//                   height: 23,
//                 )
//               },
//               InkWell(
//                 onTap: () => like(),
//                 child: buildLikeButton(),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
