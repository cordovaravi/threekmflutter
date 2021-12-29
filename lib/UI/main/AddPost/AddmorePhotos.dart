// import 'dart:developer';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:extended_image/extended_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:threekm/UI/main/News/NewsList.dart';
// import 'package:threekm/providers/main/AddPost_Provider.dart';
// import 'package:threekm/utils/threekm_textstyles.dart';
// import 'package:provider/provider.dart';
// import 'ImageEdit/EditHelper.dart';

// class AddmorePhotos extends StatefulWidget {
//   // final File imageFile;
//   AddmorePhotos({Key? key}) : super(key: key);

//   @override
//   _AddmorePhotosState createState() => _AddmorePhotosState();
// }

// class _AddmorePhotosState extends State<AddmorePhotos> {
//   final ImagePicker _imagePicker = ImagePicker();

//   @override
//   void initState() {
//     Future.delayed(Duration.zero, () {
//       //context.read<AddPostProvider>().getMoreImages;
//     });
//     super.initState();
//   }

//   @override
//   void didChangeDependencies() {
//     //
//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Upload More"),
//           backgroundColor: Color(0xff0F0F2D),
//           actions: [
//             IconButton(
//                 onPressed: () async {
//                   _showImageVideoBottomModalSheet(context);
//                 },
//                 icon: Icon(FeatherIcons.upload))
//           ],
//         ),
//         body: Consumer<AddPostProvider>(
//           builder: (context, addPostProvider, _) {
//             return CustomScrollView(
//               primary: false,
//               slivers: <Widget>[
//                 SliverPadding(
//                   padding: EdgeInsets.all(3.0),
//                   sliver: SliverGrid.count(
//                       mainAxisSpacing: 1, //horizontal space
//                       crossAxisSpacing: 1, //vertical space
//                       crossAxisCount: 2, //number of images for a row
//                       children: context
//                           .read<AddPostProvider>()
//                           .getMoreImages
//                           .map((image) {
//                         return Container(
//                           margin: EdgeInsets.only(top: 10, left: 10),
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               //border: Border.all(color: Colors.grey),
//                               borderRadius: BorderRadius.circular(10),
//                               boxShadow: [
//                                 BoxShadow(
//                                     color: Color(0xff32335E26), blurRadius: 10)
//                               ]),
//                           child: Stack(
//                             fit: StackFit.expand,
//                             children: [
//                               Image.file(image),
//                               Positioned(
//                                 right: -10,
//                                 top: -10,
//                                 child: IconButton(
//                                   onPressed: () {
//                                     context
//                                         .read<AddPostProvider>()
//                                         .removeImages(image);
//                                   },
//                                   icon: Icon(FeatherIcons.x),
//                                   color: Colors.redAccent,
//                                 ),
//                               )
//                             ],
//                           ),
//                         );
//                       }).toList()),
//                 )
//               ],
//             );
//           },
//         ));
//   }

//   _showImageVideoBottomModalSheet(BuildContext context) {
//     showModalBottomSheet<void>(
//       backgroundColor: Colors.transparent,
//       context: context,
//       isScrollControlled: true,
//       builder: (BuildContext context) {
//         return Padding(
//           padding: MediaQuery.of(context).viewInsets,
//           child: StatefulBuilder(
//             builder: (BuildContext context, StateSetter setModalState) {
//               return ClipPath(
//                 clipper: OvalTopBorderClipper(),
//                 child: Container(
//                   color: Colors.white,
//                   height: MediaQuery.of(context).size.height / 4,
//                   padding: const EdgeInsets.all(15.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       SizedBox(
//                         height: 20,
//                       ),
//                       InkWell(
//                         onTap: () async {
//                           final image = await _imagePicker.pickImage(
//                               source: ImageSource.gallery);
//                           if (image != null) {
//                             final addedImage = await Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) =>
//                                         UploadEditMore(images: image)));
//                             print(addedImage);
//                             if (addedImage is File) {
//                               context
//                                   .read<AddPostProvider>()
//                                   .addImages(addedImage);
//                             }
//                           }
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                               border: Border.all(
//                                 color: Color(0xff0F0F2D),
//                               )),
//                           child: ListTile(
//                             leading: Image.asset(
//                               "assets/camera.png",
//                               color: Color(0xff0F0F2D),
//                             ),
//                             title: Text(
//                               "Upload Image via Gallery",
//                               style: ThreeKmTextConstants.tk14PXLatoBlackBold,
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       InkWell(
//                         onTap: () async {
//                           final image = await _imagePicker.pickVideo(
//                               source: ImageSource.gallery);
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                               border: Border.all(
//                                 color: Color(0xff0F0F2D),
//                               )),
//                           child: ListTile(
//                             leading: Image.asset(
//                               "assets/videocam.png",
//                               color: Color(0xff0F0F2D),
//                             ),
//                             title: Text(
//                               "Upload Video via Gallery",
//                               style: ThreeKmTextConstants.tk14PXLatoBlackBold,
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }

// class UploadEditMore extends StatefulWidget {
//   final XFile images;
//   UploadEditMore({required this.images, Key? key}) : super(key: key);

//   @override
//   _UploadEditMoreState createState() => _UploadEditMoreState();
// }

// class _UploadEditMoreState extends State<UploadEditMore> {
//   File? ImageEditingFile;

//   final GlobalKey<ExtendedImageEditorState> editorKey =
//       GlobalKey<ExtendedImageEditorState>();
//   final GlobalKey<PopupMenuButtonState<EditorCropLayerPainter>> popupMenuKey =
//       GlobalKey<PopupMenuButtonState<EditorCropLayerPainter>>();
//   int currentIndex = 0;
//   var editingIndex = UniqueKey();

//   @override
//   void initState() {
//     ImageEditingFile = File(widget.images.path);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     //editorKey.currentState!.dispose();
//     ImageEditingFile = null;
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       //backgroundColor: Color(0xff000000),
//       floatingActionButton: FloatingActionButton.extended(
//           onPressed: () async {
//             Navigator.pop(context, ImageEditingFile);
//           },
//           label: Text("Add")),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       appBar: AppBar(
//         backgroundColor: Color(0xff0F0F2D),
//         title: Text(
//           "NEW POST",
//           style: ThreeKmTextConstants.tk16PXPoppinsWhiteBold,
//         ),
//         actions: [
//           TextButton(
//               onPressed: () async {
//                 // editingIndex++;
//                 Uint8List? fileData;
//                 if (editorKey.currentState?.rawImageData != null) {
//                   fileData = await cropImageDataWithNativeLibrary(
//                       state: editorKey.currentState!);
//                   final tempDir = await getTemporaryDirectory();
//                   File file =
//                       await File('${tempDir.path}/${editingIndex}image.png')
//                           .create();
//                   file.writeAsBytesSync(fileData!);
//                   print(file.path);
//                   setState(() {
//                     ImageEditingFile = file;
//                   });

//                   //await imageFile.writeAsBytesSync(bytes)
//                 } else {
//                   log("image UnitList is null");
//                 }
//               },
//               child: Container(
//                 child: Text(
//                   "Save",
//                   style: ThreeKmTextConstants.tk14PXPoppinsWhiteMedium,
//                 ),
//               ))
//         ],
//       ),
//       body: Container(
//         color: Colors.black,
//         child: Column(
//           children: [
//             Spacer(),
//             Spacer(),
//             Container(
//               height: 300,
//               width: MediaQuery.of(context).size.width,
//               child: ExtendedImage.file(
//                 ImageEditingFile!,
//                 cacheRawData: true,
//                 fit: BoxFit.contain,
//                 clearMemoryCacheWhenDispose: true,
//                 // enableLoadState: true,
//                 mode: ExtendedImageMode.editor,
//                 extendedImageEditorKey: editorKey,
//                 initEditorConfigHandler: (state) {
//                   return EditorConfig(
//                     maxScale: 8.0,
//                     cropRectPadding: EdgeInsets.all(20.0),
//                     hitTestSize: 20.0,
//                     //cropAspectRatio: _aspectRatio.aspectRatio
//                   );
//                 },
//               ),
//             ),
//             Spacer(),
//             ButtonBar(alignment: MainAxisAlignment.spaceBetween, children: [
//               TextButton.icon(
//                   onPressed: () {
//                     editorKey.currentState!.flip();
//                   },
//                   icon: Icon(Icons.flip),
//                   label: Text("Flip")),
//               TextButton.icon(
//                   onPressed: () {
//                     editorKey.currentState!.rotate();
//                   },
//                   icon: Icon(Icons.rotate_right),
//                   label: Text("Rotat right")),
//               TextButton.icon(
//                   onPressed: () {
//                     // editorKey.currentState!.reset();
//                     setState(() {
//                       ImageEditingFile = File(widget.images.path);
//                     });
//                   },
//                   icon: Icon(Icons.restore),
//                   label: Text("Reset"))
//             ]),
//             Spacer()
//           ],
//         ),
//       ),
//     );
//   }
// }
