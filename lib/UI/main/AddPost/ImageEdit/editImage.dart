import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:chewie/chewie.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:threekm/UI/main/AddPost/AddNewPost.dart';
import 'package:threekm/UI/main/News/NewsList.dart';
import 'package:threekm/providers/Widgets/local_player.dart';
import 'package:threekm/providers/main/AddPost_Provider.dart';
import 'package:threekm/utils/utils.dart';
import 'package:video_player/video_player.dart';

import 'EditHelper.dart';

class EditImage extends StatefulWidget {
  final List<XFile> images;
  EditImage({required this.images, Key? key}) : super(key: key);

  @override
  _EditImageState createState() => _EditImageState();
}

class _EditImageState extends State<EditImage> {
  File? ImageEditingFile;
  final List<GlobalObjectKey<ExtendedImageEditorState>> imageKey =
      List.generate(
          50, (index) => GlobalObjectKey<ExtendedImageEditorState>(index));

  final GlobalKey<PopupMenuButtonState<EditorCropLayerPainter>> popupMenuKey =
      GlobalKey<PopupMenuButtonState<EditorCropLayerPainter>>();
  int currentIndex = 0;
  int editingIndex = 0;
  int imageselectedIndex = 0;
  //List<File> imagesList = [];
  ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    ImageEditingFile = File(widget.images.first.path);
    //imagesList = widget.images;
    Future.delayed(Duration.zero, () {
      context.read<AddPostProvider>().asignImages(widget.images);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //  print("Calling Scaffold again");
    final imageList = context.watch<AddPostProvider>();
    return Scaffold(
      //backgroundColor: Color(0xff000000),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            if (imageList.getMoreImages.length == 0) {
              _showImageVideoBottomModalSheet(context);
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddNewPost(
                            imageFile: ImageEditingFile!,
                          )));
            }
            // context.read<AddPostProvider>().addImages(ImageEditingFile);
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => AddNewPost(
            //               imageFile: ImageEditingFile!,
            //             )));

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
          label: imageList.getMoreImages.length > 0
              ? Text("Next")
              : Text("Upload Image to Continue")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        backgroundColor: Color(0xff0F0F2D),
        title: Text(
          "NEW POST",
          style: ThreeKmTextConstants.tk16PXPoppinsWhiteBold,
        ),
        actions: [
          imageList.getMoreImages.length > 0
              ? TextButton(
                  onPressed: () async {
                    editingIndex++;
                    Uint8List? fileData;
                    if (imageKey[imageselectedIndex]
                            .currentState
                            ?.rawImageData !=
                        null) {
                      fileData = await cropImageDataWithNativeLibrary(
                          state: imageKey[imageselectedIndex].currentState!);
                      final tempDir = await getTemporaryDirectory();
                      File file =
                          await File('${tempDir.path}/${editingIndex}image.png')
                              .create();
                      file.writeAsBytesSync(fileData!);
                      print(file.path);
                      //imagesList.removeAt(imageselectedIndex);
                      //imageList.removeImages(XFile(file.path));
                      context
                          .read<AddPostProvider>()
                          .removeImages(imageselectedIndex);
                      setState(() {
                        ImageEditingFile = file;
                        //imagesList.insert(imageselectedIndex, XFile(file.path));
                        context
                            .read<AddPostProvider>()
                            .insertImage(imageselectedIndex, file);
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
              : Container(),
          imageList.getMoreImages.length > 0
              ? IconButton(
                  onPressed: () {
                    context
                        .read<AddPostProvider>()
                        .removeImages(imageselectedIndex);
                    setState(() {
                      imageselectedIndex = 0;
                      ImageEditingFile = File(widget.images.first.path);
                    });
                  },
                  icon: Icon(
                    FeatherIcons.trash2,
                    color: Colors.redAccent,
                  ))
              : Container()
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Spacer(),
            imageList.getMoreImages.length > 0
                ? Container(
                    height: 70,
                    width: double.infinity,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: ListView.builder(
                              primary: true,
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: imageList.getMoreImages.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      left: 8, right: 8, top: 8, bottom: 8),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        imageselectedIndex = index;
                                        ImageEditingFile = File(imageList
                                            .getMoreImages[imageselectedIndex]
                                            .path);
                                      });
                                      context
                                          .read<LocalPlayerProvider>()
                                          .pathChanged(
                                              path: imageList
                                                  .getMoreImages[
                                                      imageselectedIndex]
                                                  .path);
                                      print(ImageEditingFile?.path);
                                    },
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      child: imageList.getMoreImages[index].path
                                                  .contains(".jpg") ||
                                              imageList
                                                  .getMoreImages[index].path
                                                  .contains(".jpeg") ||
                                              imageList
                                                  .getMoreImages[index].path
                                                  .contains(".png")
                                          ? Image.file(File(imageList
                                              .getMoreImages[index].path))
                                          : Image.asset("assets/ring_icon.png"),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: index == imageselectedIndex
                                                  ? Color(0xff3E7EFF)
                                                  : Colors.white,
                                              width: index == imageselectedIndex
                                                  ? 3
                                                  : 1)),
                                    ),
                                  ),
                                );
                              }),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 8),
                          height: 48,
                          width: 48,
                          child: Center(
                            child: IconButton(
                                onPressed: () {
                                  _showImageVideoBottomModalSheet(context);
                                },
                                icon: Icon(
                                  FeatherIcons.plus,
                                  color: Colors.white,
                                )),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xff979797),
                              border: Border.all(color: Colors.white)),
                        ),
                      ],
                    ))
                : Container(),
            Spacer(),
            imageList.getMoreImages.length > 0
                ? Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: ImageEditingFile!.path.contains(".jpg") ||
                            ImageEditingFile!.path.contains(".jpeg") ||
                            ImageEditingFile!.path.contains(".png")
                        ? ExtendedImage.file(
                            ImageEditingFile!,
                            cacheRawData: true,
                            fit: BoxFit.contain,
                            clearMemoryCacheWhenDispose: true,
                            // enableLoadState: true,
                            mode: ExtendedImageMode.editor,
                            extendedImageEditorKey:
                                imageKey[imageselectedIndex],
                            initEditorConfigHandler: (state) {
                              return EditorConfig(
                                maxScale: 8.0,
                                cropRectPadding: EdgeInsets.all(20.0),
                                hitTestSize: 20.0,
                                //cropAspectRatio: _aspectRatio.aspectRatio
                              );
                            },
                          )
                        : Consumer<LocalPlayerProvider>(
                            builder: (context, controller, _) {
                            return Container(
                                height: 300,
                                width: MediaQuery.of(context).size.width,
                                child: LocalPlayer(
                                  url: controller.videoPath!,
                                ));
                          }))
                : Container(),
            Spacer(),
            imageList.getMoreImages.length > 0
                ? imageList.getMoreImages[imageselectedIndex].path
                            .contains(".png") ||
                        imageList.getMoreImages[imageselectedIndex].path
                            .contains(".jpg") ||
                        imageList.getMoreImages[imageselectedIndex].path
                            .contains(".jpeg")
                    ? ButtonBar(
                        alignment: MainAxisAlignment.spaceBetween,
                        children: [
                            TextButton.icon(
                                onPressed: () {
                                  //editorKey.currentState!.flip();
                                  imageKey[imageselectedIndex]
                                      .currentState!
                                      .flip();
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
                                  //editorKey.currentState!.rotate();
                                  imageKey[imageselectedIndex]
                                      .currentState!
                                      .rotate();
                                },
                                icon: Icon(Icons.rotate_right),
                                label: Text("Rotat right")),
                            TextButton.icon(
                                onPressed: () {
                                  imageKey[imageselectedIndex]
                                      .currentState!
                                      .reset();
                                  // editorKey.currentState!.reset();
                                  // setState(() {
                                  //   ImageEditingFile = File(widget.images.path);
                                  // });
                                },
                                icon: Icon(Icons.restore),
                                label: Text("Reset"))
                          ])
                    : SizedBox.shrink()
                : Container(),
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

  _showImageVideoBottomModalSheet(BuildContext context) {
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return ClipPath(
                clipper: OvalTopBorderClipper(),
                child: Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height / 4,
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          final image = await _imagePicker.pickImage(
                              source: ImageSource.gallery);
                          if (image != null) {
                            context
                                .read<AddPostProvider>()
                                .addImages(File(image.path));
                            Navigator.pop(context);
                            context
                                .read<LocalPlayerProvider>()
                                .pathChanged(path: image.path);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Color(0xff0F0F2D),
                              )),
                          child: ListTile(
                            leading: Image.asset(
                              "assets/camera.png",
                              color: Color(0xff0F0F2D),
                            ),
                            title: Text(
                              "Upload Image via Gallery",
                              style: ThreeKmTextConstants.tk14PXLatoBlackBold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          final pickedVideo = await _imagePicker.pickVideo(
                              source: ImageSource.gallery);
                          //final file = XFile(pickedVideo!.path);
                          Navigator.pop(context);
                          if (pickedVideo != null) {
                            context
                                .read<AddPostProvider>()
                                .addImages(File(pickedVideo.path));
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Color(0xff0F0F2D),
                              )),
                          child: ListTile(
                            leading: Image.asset(
                              "assets/videocam.png",
                              color: Color(0xff0F0F2D),
                            ),
                            title: Text(
                              "Upload Video via Gallery",
                              style: ThreeKmTextConstants.tk14PXLatoBlackBold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class LocalPlayer extends StatefulWidget {
  final String url;
  LocalPlayer({required this.url, Key? key}) : super(key: key);

  @override
  _LocalPlayerState createState() => _LocalPlayerState();
}

class _LocalPlayerState extends State<LocalPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    print("url from ${widget.url}");
    _controller = VideoPlayerController.file(File(widget.url));
    _controller.addListener(() {
      setState(() {});
    });
    _controller.initialize().then((_) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          _controller.value.isPlaying
              ? _controller.pause()
              : _controller.play();
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            VideoPlayer(_controller),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 50),
              reverseDuration: Duration(milliseconds: 200),
              child: _controller.value.isPlaying
                  ? SizedBox.shrink()
                  : Container(
                      color: Colors.black26,
                      child: Center(
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 100.0,
                          semanticLabel: 'Play',
                        ),
                      ),
                    ),
            ),
            VideoProgressIndicator(_controller, allowScrubbing: true),
          ],
        ),
      ),
    );
  }
}
