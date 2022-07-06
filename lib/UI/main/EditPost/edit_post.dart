// // author: Prateek Aher
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:html/parser.dart' as html;
// import 'package:provider/provider.dart';
// import 'package:threekm/Models/deepLinkPost.dart';
// import 'package:threekm/UI/main/AddPost/utils/uploadPost.dart';
// import 'package:threekm/UI/main/Profile/AuthorProfile.dart';
// import 'package:threekm/providers/main/singlePost_provider.dart';
//
// import '../../../providers/main/AddPost_Provider.dart';
// import '../../../utils/threekm_textstyles.dart';
//
// class EditPost extends StatefulWidget {
//   const EditPost({Key? key, required this.postId}) : super(key: key);
//   final int postId;
//
//   @override
//   State<EditPost> createState() => _EditPostState();
// }
//
// class _EditPostState extends State<EditPost> {
//   Post? post;
//   final _formKey = GlobalKey<FormState>();
//   int headlineCount = 0;
//   int descriptionCount = 0;
//   TextEditingController _headLineController = TextEditingController();
//   TextEditingController _descriptionController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     final imageList = context.watch<AddPostProvider>()..editMode = true;
//     final Size screenSize = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 1,
//         title: Text("Edit Post", style: ThreeKmTextConstants.tk16PXPoppinsBlackMedium),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         centerTitle: false,
//         titleSpacing: 0,
//         actions: [
//           Center(
//             child: ElevatedButton(
//               onPressed: () {
//                 FocusScope.of(context).unfocus();
//                 // if (_formKey.currentState?.validate() ?? false) {
//                 //   if (!(descriptionCount > 0 ||
//                 //       imageList.getMoreImages.isNotEmpty ||
//                 //       headlineCount > 0)) {
//                 //     Fluttertoast.showToast(
//                 //         msg: "Add either a headline, description or upload image/video");
//                 //     return;
//                 //   }
//                 //   if (context.read<AddPostProvider>().tagsList.length < 3) {
//                 //     Fluttertoast.showToast(msg: "Minimum 3 tags required");
//                 //     return;
//                 //   }
//                 //   if (_selectedAddress == null) {
//                 //     Fluttertoast.showToast(msg: "Location required");
//                 //     return;
//                 //   }
//                 //
//                 //   Navigator.push(
//                 //       context,
//                 //       MaterialPageRoute(
//                 //           builder: (context) => PostUploadPage(
//                 //               // Title: _headLineController.text,
//                 //               // Story: _storyController.text,
//                 //               // address: _selectedAddress ?? "",
//                 //               // lat: _geometry?.location.lat,
//                 //               // long: _geometry?.location.lng,
//                 //               )));
//                 // }
//               },
//               child: Text(
//                 "Save",
//                 style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16),
//               ),
//               style: ElevatedButton.styleFrom(
//                 primary: (context.read<AddPostProvider>().tagsList.length >= 3)
//                     ? const Color(0xff3E7EFF)
//                     : const Color(0xffF1F2F6),
//                 elevation: 0,
//                 shape: const StadiumBorder(),
//                 padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//               ),
//             ),
//           )
//         ],
//       ),
//       body: Form(
//           key: _formKey,
//           child: ListView(
//             padding: const EdgeInsets.all(16),
//             shrinkWrap: true,
//             children: [
//               //profile header
//               ListTile(
//                 minLeadingWidth: 0,
//                 horizontalTitleGap: 0,
//                 leading: Container(
//                   height: 72,
//                   width: 72,
//                   decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       image: DecorationImage(
//                           fit: BoxFit.contain,
//                           image: CachedNetworkImageProvider(post!.author!.image.toString()))),
//                 ),
//                 title: Text(
//                   post?.author?.name ?? '',
//                   style: GoogleFonts.poppins(
//                       fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black),
//                 ),
//                 subtitle: Text(
//                   DateFormat('MMMM dd, yyyy').format(post!.postCreatedDate!),
//                   style: GoogleFonts.poppins(
//                       fontWeight: FontWeight.w600, fontSize: 12, color: const Color(0xff7c7c7c)),
//                 ),
//               ),
//               //headline
//               TextFormField(
//                 validator: (String? title) {
//                   // if (title == null || title.trim().isEmpty) {
//                   //   return "*required";
//                   // }
//                   if ((title?.trim().length ?? 0) > 100) {
//                     return "*Exceeds ${headlineCount - 100} characters";
//                   }
//                   return null;
//                 },
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 controller: _headLineController,
//                 maxLines: 1,
//                 minLines: null,
//                 expands: false,
//                 // maxLength: 100,
//                 textAlignVertical: TextAlignVertical.bottom,
//                 maxLengthEnforcement: MaxLengthEnforcement.enforced,
//                 buildCounter: (context, {required currentLength, required isFocused, maxLength}) {
//                   WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
//                     setState(() {
//                       headlineCount = currentLength;
//                     });
//                   });
//                   return Text("${headlineCount}/100",
//                       style: ThreeKmTextConstants.tk12PXPoppinsWhiteRegular.copyWith(
//                         fontSize: 10.5,
//                         fontWeight: FontWeight.normal,
//                         color: Color(0xFF7c7c7c),
//                       ));
//                 },
//                 style: ThreeKmTextConstants.tk16PXLatoBlackRegular.copyWith(
//                   color: Color(0xFF0F0F2D),
//                   fontWeight: FontWeight.w500,
//                 ),
//                 decoration: InputDecoration(
//                     hintText: 'Headline',
//                     hintStyle: GoogleFonts.poppins(fontSize: 14, color: const Color(0xff7c7c7c)),
//                     enabledBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(color: const Color(0xffc7c7c7)))),
//               ),
//               //description
//               TextFormField(
//                 validator: (String? story) {
//                   if ((story?.trim().length ?? 0) > 2000) {
//                     return "*Exceeded by ${descriptionCount - 2000} characters";
//                   }
//                   return null;
//                 },
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 textAlignVertical: TextAlignVertical.bottom,
//                 controller: _descriptionController,
//                 maxLines: null,
//                 buildCounter: (context, {required currentLength, required isFocused, maxLength}) {
//                   WidgetsBinding.instance!.addPostFrameCallback((_) {
//                     setState(() {
//                       descriptionCount = currentLength;
//                     });
//                   });
//                   return Text("${descriptionCount}/2000",
//                       style: ThreeKmTextConstants.tk12PXPoppinsWhiteRegular.copyWith(
//                         fontSize: 10.5,
//                         fontWeight: FontWeight.normal,
//                         color: Color(0xFF7c7c7c),
//                       ));
//                 },
//                 style: ThreeKmTextConstants.tk16PXLatoBlackRegular.copyWith(
//                   color: Color(0xFF0F0F2D),
//                   fontWeight: FontWeight.w500,
//                 ),
//                 decoration: InputDecoration(
//                     hintText: 'Description',
//                     hintStyle: GoogleFonts.poppins(fontSize: 14, color: const Color(0xff7c7c7c)),
//                     enabledBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(color: const Color(0xffc7c7c7)))),
//               ),
//               imageList.getMoreImages.length > 0
//                   ? Consumer<AddPostProvider>(builder: (context, controller, _) {
//                       return GridView.builder(
//                           shrinkWrap: true,
//                           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 3, mainAxisSpacing: 3, crossAxisSpacing: 3),
//                           itemCount: imageList.getMoreImages.length,
//                           itemBuilder: (BuildContext context, int index) {
//                             return Stack(
//                               children: [
//                                 Positioned.fill(
//                                   child: Container(
//                                     height: 82,
//                                     width: 82,
//                                     clipBehavior: Clip.hardEdge,
//                                     decoration: BoxDecoration(
//                                         color: const Color(0xffD9D9D9),
//                                         borderRadius: BorderRadius.circular(8)),
//                                     child: imageList.getMoreImages[index].path.contains("mp4")
//                                         ? Image.asset(
//                                             "assets/ring_icon.png",
//                                             fit: BoxFit.cover,
//                                           )
//                                         : Image.file(imageList.getMoreImages[index],
//                                             fit: BoxFit.cover),
//                                   ),
//                                 ),
//                                 Positioned(
//                                   right: 0,
//                                   top: 0,
//                                   child: Container(
//                                       height: 20,
//                                       width: 20,
//                                       // margin: EdgeInsets.all(20),
//                                       decoration: BoxDecoration(
//                                           color: Color(0xffFF5858),
//                                           borderRadius: BorderRadius.circular(8)),
//                                       child: InkWell(
//                                         onTap: () {
//                                           context.read<AddPostProvider>().removeImages(index);
//                                         },
//                                         child: Icon(
//                                           FeatherIcons.x,
//                                           size: 12,
//                                           color: Colors.white,
//                                         ),
//                                       )),
//                                 ),
//                               ],
//                             );
//                           });
//                     })
//                   : const SizedBox.shrink(),
//             ],
//           )),
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       post = context.read<SinglePostProvider>().postDetails?.data?.result?.post;
//     }).then((_) {
//       setState(() {
//         _headLineController.text = post!.submittedHeadline!;
//         _descriptionController.text = htmlToText(post!.story!) ?? '';
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _headLineController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }
//
//   String? htmlToText(String s) {
//     var document = html.parse(s);
//     return document.body?.children.map((e) => e.text).join();
//   }
// }
