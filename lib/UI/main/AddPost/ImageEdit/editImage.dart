import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:threekm/UI/main/AddPost/AddNewPost.dart';
import 'package:threekm/utils/utils.dart';

import '../widgets.dart/FlatButtonwithIcon.dart';
import 'EditHelper.dart';

class EditImage extends StatefulWidget {
  final XFile images;
  EditImage({required this.images, Key? key}) : super(key: key);

  @override
  _EditImageState createState() => _EditImageState();
}

class _EditImageState extends State<EditImage> {
  File? ImageEditingFile;
  // final List<GlobalObjectKey<ExtendedImageEditorState>> imageKey =
  //     List.generate(
  //         50, (index) => GlobalObjectKey<ExtendedImageEditorState>(index));
  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
  final GlobalKey<PopupMenuButtonState<EditorCropLayerPainter>> popupMenuKey =
      GlobalKey<PopupMenuButtonState<EditorCropLayerPainter>>();
  int currentIndex = 0;
  int editingIndex = 0;

  @override
  void initState() {
    ImageEditingFile = File(widget.images.path);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xff000000),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddNewPost()));
            // editingIndex++;
            // Uint8List? fileData;
            // if (editorKey.currentState?.rawImageData != null) {
            //   fileData = await cropImageDataWithNativeLibrary(
            //       state: editorKey.currentState!);
            //   final tempDir = await getTemporaryDirectory();
            //   File file = await File('${tempDir.path}/${editingIndex}image.png')
            //       .create();
            //   file.writeAsBytesSync(fileData!);
            //   print(file.path);
            //   setState(() {
            //     ImageEditingFile = file;
            //   });
            //   //await imageFile.writeAsBytesSync(bytes)
            // } else {
            //   log("image UnitList is null");
            // }
          },
          label: Text("Next")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        backgroundColor: Color(0xff0F0F2D),
        title: Text(
          "NEW POST",
          style: ThreeKmTextConstants.tk16PXPoppinsWhiteBold,
        ),
        actions: [
          TextButton(
              onPressed: () async {
                editingIndex++;
                Uint8List? fileData;
                if (editorKey.currentState?.rawImageData != null) {
                  fileData = await cropImageDataWithNativeLibrary(
                      state: editorKey.currentState!);
                  final tempDir = await getTemporaryDirectory();
                  File file =
                      await File('${tempDir.path}/${editingIndex}image.png')
                          .create();
                  file.writeAsBytesSync(fileData!);
                  print(file.path);
                  setState(() {
                    ImageEditingFile = file;
                  });
                  //await imageFile.writeAsBytesSync(bytes)
                } else {
                  log("image UnitList is null");
                }
                //imageKey[currentIndex].currentState.image
                // File imageFile = File.fromRawPath(
                //     imageKey[currentIndex].currentState!.rawImageData);
                // setState(() {
                //   final XFile xImage = XFile(imageFile.path);
                //   print(xImage.path);
                //   //widget.images.add();
                // });
              },
              child: Container(
                child: Text(
                  "Save",
                  style: ThreeKmTextConstants.tk14PXPoppinsWhiteMedium,
                ),
              ))
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Spacer(),
            Spacer(),
            Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: ExtendedImage.file(
                ImageEditingFile!,
                cacheRawData: true,
                fit: BoxFit.contain,
                clearMemoryCacheWhenDispose: true,
                // enableLoadState: true,
                mode: ExtendedImageMode.editor,
                extendedImageEditorKey: editorKey,
                initEditorConfigHandler: (state) {
                  return EditorConfig(
                    maxScale: 8.0,
                    cropRectPadding: EdgeInsets.all(20.0),
                    hitTestSize: 20.0,
                    //cropAspectRatio: _aspectRatio.aspectRatio
                  );
                },
              ),
            ),
            Spacer(),
            ButtonBar(alignment: MainAxisAlignment.spaceBetween, children: [
              TextButton.icon(
                  onPressed: () {
                    editorKey.currentState!.flip();
                  },
                  icon: Icon(Icons.flip),
                  label: Text("Flip")),
              // TextButton.icon(
              //     onPressed: () {
              //       editorKey.currentState!.rotate(right: false);
              //     },
              //     icon: Icon(FeatherIcons.rotateCcw),
              //     label: Text("Rotat")),
              TextButton.icon(
                  onPressed: () {
                    editorKey.currentState!.rotate();
                  },
                  icon: Icon(Icons.rotate_right),
                  label: Text("Rotat right")),
              TextButton.icon(
                  onPressed: () {
                    // editorKey.currentState!.reset();
                    setState(() {
                      ImageEditingFile = File(widget.images.path);
                    });
                  },
                  icon: Icon(Icons.restore),
                  label: Text("Reset"))
            ]),
            Spacer()
          ],
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //     //color: Colors.lightBlue,
      //     shape: const CircularNotchedRectangle(),
      //     child: ButtonTheme(
      //       minWidth: 0.0,
      //       padding: EdgeInsets.zero,
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceAround,
      //         mainAxisSize: MainAxisSize.max,
      //         children: <Widget>[
      //           // FlatButtonWithIcon(
      //           //   icon: const Icon(Icons.crop),
      //           //   label: const Text(
      //           //     'Crop',
      //           //     style: TextStyle(fontSize: 10.0),
      //           //   ),
      //           //   textColor: Colors.white,
      //           //   onPressed: () {
      //           //     showDialog<void>(
      //           //         context: context,
      //           //         builder: (BuildContext context) {
      //           //           return Column(
      //           //             children: <Widget>[
      //           //               const Expanded(
      //           //                 child: SizedBox(),
      //           //               ),
      //           //               SizedBox(
      //           //                 height: 100,
      //           //                 child: ListView.builder(
      //           //                   shrinkWrap: true,
      //           //                   scrollDirection: Axis.horizontal,
      //           //                   padding: const EdgeInsets.all(20.0),
      //           //                   itemBuilder: (_, int index) {
      //           //                     final AspectRatioItem item =
      //           //                         _aspectRatios[index];
      //           //                     return GestureDetector(
      //           //                       child: AspectRatioWidget(
      //           //                         aspectRatio: item.value,
      //           //                         aspectRatioS: item.text,
      //           //                         isSelected: item == _aspectRatio,
      //           //                       ),
      //           //                       onTap: () {
      //           //                         Navigator.pop(context);
      //           //                         setState(() {
      //           //                           _aspectRatio = item;
      //           //                         });
      //           //                       },
      //           //                     );
      //           //                   },
      //           //                   itemCount: _aspectRatios.length,
      //           //                 ),
      //           //               ),
      //           //             ],
      //           //           );
      //           //         });
      //           //   },
      //           // ),
      //           FlatButtonWithIcon(
      //             icon: const Icon(Icons.flip),
      //             label: const Text(
      //               'Flip',
      //               style: TextStyle(fontSize: 10.0),
      //             ),
      //             textColor: Colors.white,
      //             onPressed: () {
      //               editorKey.currentState!.flip();
      //             },
      //           ),
      //           FlatButtonWithIcon(
      //             icon: const Icon(Icons.rotate_left),
      //             label: const Text(
      //               'Rotate Left',
      //               style: TextStyle(fontSize: 8.0),
      //             ),
      //             textColor: Colors.white,
      //             onPressed: () {
      //               editorKey.currentState!.rotate(right: false);
      //             },
      //           ),
      //           FlatButtonWithIcon(
      //             icon: const Icon(Icons.rotate_right),
      //             label: const Text(
      //               'Rotate Right',
      //               style: TextStyle(fontSize: 8.0),
      //             ),
      //             textColor: Colors.white,
      //             onPressed: () {
      //               editorKey.currentState!.rotate(right: true);
      //             },
      //           ),
      //           // FlatButtonWithIcon(
      //           //   icon: const Icon(Icons.rounded_corner_sharp),
      //           //   label: PopupMenuButton<EditorCropLayerPainter>(
      //           //     key: popupMenuKey,
      //           //     enabled: false,
      //           //     offset: const Offset(100, -300),
      //           //     child: const Text(
      //           //       'Painter',
      //           //       style: TextStyle(fontSize: 8.0),
      //           //     ),
      //           //     //initialValue: _cropLayerPainter,
      //           //     itemBuilder: (BuildContext context) {
      //           //       return <PopupMenuEntry<EditorCropLayerPainter>>[
      //           //         PopupMenuItem<EditorCropLayerPainter>(
      //           //           child: Row(
      //           //             children: const <Widget>[
      //           //               Icon(
      //           //                 Icons.rounded_corner_sharp,
      //           //                 color: Colors.blue,
      //           //               ),
      //           //               SizedBox(
      //           //                 width: 5,
      //           //               ),
      //           //               Text('Default'),
      //           //             ],
      //           //           ),
      //           //           value: const EditorCropLayerPainter(),
      //           //         ),
      //           //         const PopupMenuDivider(),
      //           //         PopupMenuItem<EditorCropLayerPainter>(
      //           //           child: Row(
      //           //             children: const <Widget>[
      //           //               Icon(
      //           //                 Icons.circle,
      //           //                 color: Colors.blue,
      //           //               ),
      //           //               SizedBox(
      //           //                 width: 5,
      //           //               ),
      //           //               Text('Custom'),
      //           //             ],
      //           //           ),
      //           //           value: const CustomEditorCropLayerPainter(),
      //           //         ),
      //           //         const PopupMenuDivider(),
      //           //         PopupMenuItem<EditorCropLayerPainter>(
      //           //           child: Row(
      //           //             children: const <Widget>[
      //           //               Icon(
      //           //                 CupertinoIcons.circle,
      //           //                 color: Colors.blue,
      //           //               ),
      //           //               SizedBox(
      //           //                 width: 5,
      //           //               ),
      //           //               Text('Circle'),
      //           //             ],
      //           //           ),
      //           //           value: const CircleEditorCropLayerPainter(),
      //           //         ),
      //           //       ];
      //           //     },
      //           //     onSelected: (EditorCropLayerPainter value) {
      //           //       if (_cropLayerPainter != value) {
      //           //         setState(() {
      //           //           if (value is CircleEditorCropLayerPainter) {
      //           //             _aspectRatio = _aspectRatios[2];
      //           //           }
      //           //           _cropLayerPainter = value;
      //           //         });
      //           //       }
      //           //     },
      //           //   ),
      //           //   textColor: Colors.white,
      //           //   onPressed: () {
      //           //     popupMenuKey.currentState!.showButtonMenu();
      //           //   },
      //           // ),
      //           FlatButtonWithIcon(
      //             icon: const Icon(Icons.restore),
      //             label: const Text(
      //               'Reset',
      //               style: TextStyle(fontSize: 10.0),
      //             ),
      //             textColor: Colors.white,
      //             onPressed: () {
      //               editorKey.currentState!.reset();
      //             },
      //           ),
      //         ],
      //       ),
      //     )));
    );
  }
}
