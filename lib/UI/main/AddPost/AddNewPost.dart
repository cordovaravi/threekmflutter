import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:threekm/UI/main/AddPost/ImageEdit/editImage.dart';
import 'package:threekm/UI/main/AddPost/utils/FileUtils.dart';
import 'package:threekm/UI/main/AddPost/utils/uploadPost.dart';
import 'package:threekm/providers/Location/locattion_Provider.dart';
import 'package:threekm/providers/main/AddPost_Provider.dart';
import 'package:threekm/utils/utils.dart';

import 'add_post_location.dart';

class AddNewPost extends StatefulWidget {
  //final File imageFile;
  // AddNewPost({required this.imageFile, Key? key}) : super(key: key);

  @override
  _AddNewPostState createState() => _AddNewPostState();
}

class _AddNewPostState extends State<AddNewPost> {
  TextEditingController _tagsController = TextEditingController();
  TextEditingController _storyController = TextEditingController();
  TextEditingController _headLineController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final addPost = Provider.of<AddPostProvider>(context, listen: false);
      final location = Provider.of<LocationProvider>(context, listen: false);
      addPost.selectedAddress = location.AddressFromCordinate;
    });
  }

  @override
  void dispose() {
    _tagsController.dispose();
    _storyController.dispose();
    _headLineController.dispose();
    super.dispose();
  }

  TextStyle get _titleStyle => GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF7c7c7c));

  @override
  Widget build(BuildContext context) {
    final imageList = context.watch<AddPostProvider>();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "New Post",
            style: ThreeKmTextConstants.appBarTitleTextStyle,
          ),
          titleSpacing: 0,
          actions: [_postUploadButton(context, imageList), SizedBox(width: 6)],
          backgroundColor: Colors.white,
          elevation: 0.5,
          foregroundColor: Colors.black,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shrinkWrap: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              SizedBox(height: 20),
              locationSection(context),
              Divider(color: Color(0xFFa7abad).withOpacity(0.5), thickness: 1),
              SizedBox(height: 20),
              buildMediaHeading,
              SizedBox(height: 2),
              buildImageGrid(imageList),
              SizedBox(height: 4),
              _addPhotosVideosButton(),
              SizedBox(height: 30),
              builddescriptionHeading,
              buildDescriptionField(),
              SizedBox(height: 20),
              buildPostTitleHeader,
              buildPostTitleField(),
              SizedBox(height: 20),
              buildTagsHeader,
              SizedBox(height: 6),
              buildTags,
              // SizedBox(height: 16),
              Divider(color: Color(0xff7c7c7c).withOpacity(0.5), thickness: 1),
            ],
          ),
        ),
      ),
    );
  }

  Center _postUploadButton(BuildContext context, AddPostProvider imageList) {
    return Center(
      child: Consumer<AddPostProvider>(builder: (_, provider, __) {
        return ElevatedButton(
          onPressed: provider.isCompressionOngoing
              ? null
              : () {
                  FocusScope.of(context).unfocus();
                  if (_formKey.currentState?.validate() ?? false) {
                    if (provider.selectedAddress == null) {
                      Fluttertoast.showToast(msg: "Location required");
                      return;
                    }
                    if (!(_storyController.text.trim().length > 0 ||
                        provider.getMoreImages.isNotEmpty)) {
                      Fluttertoast.showToast(msg: "Add either a description or upload image/video");
                      return;
                    }
                    // if (provider.tagsList.length < 3) {
                    //   Fluttertoast.showToast(msg: "Minimum 3 tags required");
                    //   return;
                    // }

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PostUploadPage(
                                  Title: _headLineController.text,
                                  Story: _storyController.text,
                                  address: provider.selectedAddress ?? "",
                                  lat: provider.geometry?.location.lat,
                                  long: provider.geometry?.location.lng,
                                )));
                  }
                },
          child: Text(
            "Post",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            primary: provider.selectedAddress != null
                ? const Color(0xff3E7EFF)
                : const Color(0xffF1F2F6),
            elevation: 0,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          ),
        );
      }),
    );
  }

  TextFormField buildDescriptionField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textAlignVertical: TextAlignVertical.top,
      controller: _storyController,
      maxLines: null,
      // minLines: 2,
      maxLength: 2000,
      style: ThreeKmTextConstants.tk16PXLatoBlackRegular.copyWith(
        color: Color(0xFF0F0F2D),
        fontWeight: FontWeight.w400,
      ),
      decoration: buildInputDecoration.copyWith(hintText: "Enter your text here"),
    );
  }

  Text get builddescriptionHeading => Text("Description", style: _titleStyle);

  Text get buildMediaHeading => Text("Media", style: _titleStyle);

  TextFormField buildPostTitleField() {
    return TextFormField(
      controller: _headLineController,
      maxLength: 100,
      textAlignVertical: TextAlignVertical.top,
      // maxLengthEnforcement: MaxLengthEnforcement.enforced,
      style: ThreeKmTextConstants.tk16PXLatoBlackRegular.copyWith(
        color: Color(0xFF0F0F2D),
        fontWeight: FontWeight.w400,
      ),
      minLines: 1,
      maxLines: null,
      decoration: buildInputDecoration.copyWith(hintText: "Enter your Headline/Title"),
    );
  }

  Row get buildPostTitleHeader {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Headline/Title", style: _titleStyle),
        SizedBox(width: 5),
        Text("(optional)", style: _titleStyle.copyWith(fontSize: 12)),
      ],
    );
  }

  Consumer<AddPostProvider> locationSection(BuildContext context) {
    return Consumer<AddPostProvider>(
      builder: (_, provider, __) {
        addOrChangeLocation() async {
          FocusScope.of(context).unfocus();
          if (context.read<LocationProvider>().ispermitionGranted) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddPostLocation()));
          } // Future.delayed(Duration.zero, () {
          //   context.read<LocationProvider>().getLocation().whenComplete(() async {
          //     final _locationProvider = context.read<LocationProvider>().getlocationData;
          //     final kInitialPosition =
          //         LatLng(_locationProvider!.latitude!, _locationProvider.longitude!);
          //     if (_locationProvider != null) {
          //       LocationResult? result = await Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) => PlacePicker(
          //               GMap_Api_Key,
          //               displayLocation: kInitialPosition,
          //             ),
          //           ));
          //       provider.selectedAddress = result?.formattedAddress;
          //     }
          //   });
          // });
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _locationFieldTitle,
            SizedBox(height: 10),
            Text(
              provider.selectedAddress ?? "",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 10),
            InkWell(
              onTap: addOrChangeLocation,
              child: Text(
                provider.selectedAddress == null ? "Add Post location" : "Change Location",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, color: const Color(0xFF3E7EFF), fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  Consumer<AddPostProvider> buildImageGrid(AddPostProvider imageList) {
    return Consumer<AddPostProvider>(builder: (context, provider, _) {
      return Visibility(
        visible: provider.getMoreImages.isNotEmpty ||
            (provider.getMoreImages.isEmpty && provider.isCompressionOngoing),
        child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, mainAxisSpacing: 4, crossAxisSpacing: 4),
            itemCount: imageList.getMoreImages.length + (provider.isCompressionOngoing ? 1 : 0),
            itemBuilder: (BuildContext context, int index) {
              return index == imageList.getMoreImages.length
                  ?
                  // Placeholder item during video processing event
                  provider.isCompressionOngoing
                      ? StreamBuilder<double>(
                          stream: provider.lightCompressor?.onProgressUpdated,
                          builder: (context, AsyncSnapshot<dynamic> snapshot) {
                            return Stack(children: [
                              Visibility(
                                visible: provider.isCompressionOngoing,
                                child: Positioned.fill(
                                  child: Container(
                                    height: 82,
                                    width: 82,
                                    padding: EdgeInsets.only(left: 5, top: 5),
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        color: ThreeKmTextConstants.black,
                                        borderRadius: BorderRadius.circular(8)),
                                    alignment: Alignment.topLeft,
                                    child: Icon(
                                      Icons.videocam,
                                      size: 20,
                                      color: ThreeKmTextConstants.white,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                  child: Container(
                                      height: 55,
                                      width: 55,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 6,
                                          backgroundColor: ThreeKmTextConstants.white,
                                          color: ThreeKmTextConstants.blue2,
                                          value: snapshot.data / 100))),
                              Center(
                                  child: Text('${snapshot.data.toStringAsFixed(0)}%',
                                      style: TextStyle(
                                          color: ThreeKmTextConstants.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600)))
                            ]);
                          })
                      : SizedBox.shrink()
                  : Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            height: 82,
                            width: 82,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                color: const Color(0xffD9D9D9),
                                borderRadius: BorderRadius.circular(8)),
                            child: imageList.getMoreImages[index].path.contains("mp4")
                                ? Image.asset(
                                    "assets/ring_icon.png",
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(imageList.getMoreImages[index], fit: BoxFit.cover),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                              height: 20,
                              width: 20,
                              // margin: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: Color(0xffFF5858), borderRadius: BorderRadius.circular(8)),
                              child: InkWell(
                                onTap: () {
                                  context.read<AddPostProvider>().removeImages(index);
                                },
                                child: Icon(
                                  FeatherIcons.x,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              )),
                        ),
                      ],
                    );
            }),
      );
    });
  }

  Row get _locationFieldTitle {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.location_on_rounded,
          size: 28,
          color: const Color(0xFF7c7c7c).withOpacity(0.5),
        ),
        SizedBox(width: 5),
        Text(
          "Post Location ",
          style: _titleStyle,
        ),
        Text(
          "(required)",
          style: _titleStyle.copyWith(fontSize: 12),
        ),
      ],
    );
  }

  InputDecoration get buildInputDecoration {
    return InputDecoration(
        border: _underlineInputBorder,
        focusedErrorBorder: _underlineInputBorder,
        focusedBorder: _underlineInputBorder,
        enabledBorder: _underlineInputBorder);
  }

  UnderlineInputBorder get _underlineInputBorder =>
      UnderlineInputBorder(borderSide: BorderSide(color: const Color(0xff7c7c7c)));

  Widget get buildTagsHeader => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(mainAxisSize: MainAxisSize.min, children: [
              Text("Tags ", style: _titleStyle),
              Text("(optional)", style: _titleStyle.copyWith(fontSize: 12))
            ]),
            SizedBox(height: 2),
            Text(
              "Adding tags will help your post reach more more people",
              style: _titleStyle.copyWith(fontSize: 10),
            ),
          ],
        ),
      );

  // Widget get buildFooter {
  //   return Positioned(
  //     bottom: 0,
  //     child: Container(

  //       height: 68,
  //       width: MediaQuery.of(context).size.width,
  //       child: Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Padding(
  //             padding: EdgeInsets.only(
  //               top: 12,
  //               right: 12,
  //               left: 18,
  //             ),
  //             child: Container(
  //                 height: 48,
  //                 width: 48,
  //                 child: Image.file(
  //                   widget.imageFile,
  //                   fit: BoxFit.cover,
  //                 )),
  //           ),
  //           Column(
  //             mainAxisSize: MainAxisSize.min,
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 "Uploading Post",
  //                 style: ThreeKmTextConstants.tk14PXPoppinsWhiteMedium,
  //               ),
  //               SizedBox(
  //                 height: 8,
  //               ),
  //               Container(
  //                   height: 5,
  //                   width: MediaQuery.of(context).size.width * 0.65,
  //                   alignment: Alignment.topCenter,
  //                   child: LinearProgressIndicator(
  //                     minHeight: 1,
  //                     value: 0.7,
  //                     color: Color(0xffFF5858),
  //                   ))
  //             ],
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _addPhotosVideosButton() {
    return Consumer<AddPostProvider>(
      builder: (context, provider, __) => InkWell(
        onTap: provider.isCompressionOngoing
            ? null
            : () {
                FocusScope.of(context).unfocus();
                _showImageVideoBottomModalSheet(context);
              },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xfff5f5f5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            width:
                MediaQuery.of(context).size.width * (provider.getMoreImages.length > 0 ? 0.6 : 0.4),
            child: Wrap(
              alignment: WrapAlignment.center, crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 5, runSpacing: 5,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add_photo_alternate,
                  size: 24,
                  color: provider.isCompressionOngoing
                      ? ThreeKmTextConstants.grey3.withOpacity(0.5)
                      : const Color(0xff3E7EFF),
                ),
                Text(
                  "Add Photos/Videos",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: provider.isCompressionOngoing
                          ? ThreeKmTextConstants.grey3.withOpacity(0.5)
                          : const Color(0xff3E7EFF)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get buildTags {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Consumer<AddPostProvider>(
        builder: (context, addPostProvider, _) {
          return Wrap(
            runAlignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            runSpacing: -5,
            spacing: 5,
            children: [
              ...addPostProvider.tagsList.map((value) {
                return Chip(
                  label: Text(value.toString()),
                  backgroundColor: Colors.white,
                  shape: StadiumBorder(),
                  side: BorderSide(color: const Color(0xFF8E8A8A)),
                  labelStyle: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF8E8A8A),
                  ),
                  deleteButtonTooltipMessage: 'Remove tag',
                  useDeleteButtonTooltip: true,
                  onDeleted: () {
                    context.read<AddPostProvider>().removeTag(value);
                  },
                  deleteIconColor: const Color(0xFF8E8A8A),
                  deleteIcon: Icon(Icons.cancel_rounded),
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                );
              }).toList(),
              ActionChip(
                label: Text('+ Add'),
                onPressed: () => addTag(context),
                backgroundColor: Colors.white,
                shape: StadiumBorder(),
                labelStyle: GoogleFonts.poppins(
                    fontSize: 14, color: const Color(0xff3e7eff), fontWeight: FontWeight.w700),
                elevation: 0,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                side: BorderSide(width: 1, color: const Color(0xFF3E7EFF)),
              ),
            ],
          );
        },
      ),
    );
  }

  addTag(BuildContext context) async {
    String? tag = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text(
            "Add Tag",
            style: ThreeKmTextConstants.tk14PXPoppinsBlackSemiBold
                .copyWith(color: Colors.black, fontWeight: FontWeight.w900),
          ),
          content: TextField(
            controller: _tagsController,
            decoration: InputDecoration(
                hintText: "Tag",
                hintStyle: ThreeKmTextConstants.tk14PXPoppinsBlackSemiBold
                    .copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                )),
          ),
          actions: [
            TextButton(
              child: Text(
                "Cancel",
                style: ThreeKmTextConstants.tk14PXPoppinsBlackSemiBold.copyWith(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                FocusScope.of(context).unfocus();
              },
            ),
            TextButton(
              child: Text(
                "Continue",
                style: ThreeKmTextConstants.tk14PXPoppinsBlackSemiBold.copyWith(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop(_tagsController.text.trim());
                FocusScope.of(context).unfocus();
              },
            )
          ],
        );
      },
    );
    if (tag != null && _tagsController.text.isNotEmpty) {
      context
          .read<AddPostProvider>()
          .addTags(_tagsController.text)
          .whenComplete(() => _tagsController.clear());
    }
  }

  // Widget get buildFooter {
  //   return Positioned(
  //     bottom: 0,
  //     right: 0,
  //     left: 0,
  //     child: Container(
  //       height: 84,
  //       width: MediaQuery.of(context).size.width,
  //       padding: EdgeInsets.symmetric(vertical: 16, horizontal: 18),
  //       color: Color(0xFFF4F3F8),
  //       child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Icon(
  //             Icons.grid_view,
  //             size: 24,
  //           ),
  //           SizedBox(
  //             width: 8,
  //           ),
  //           Expanded(
  //             child: Container(
  //               margin: EdgeInsets.only(top: 2),
  //               child: Text(
  //                 "Advance".toUpperCase(),
  //                 style: ThreeKmTextConstants.tk14PXPoppinsWhiteMedium.copyWith(
  //                   color: Color(0xFF0F0F2D),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           SizedBox(
  //             width: 8,
  //           ),
  //           Icon(
  //             Icons.arrow_forward,
  //             size: 24,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
              return Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height / 4,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () async {
                        List<XFile>? imageFileList = [];
                        final List<XFile>? images = await _imagePicker.pickMultiImage();
                        if (imageFileList.isEmpty) {
                          imageFileList.addAll(images!);
                        }
                        imageFileList.forEach((element) {
                          print("name: " + element.name);
                          print("path: " + element.path);
                        });
                        Navigator.pop(context);
                        if (imageFileList.isNotEmpty) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditImage(images: imageFileList)));
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
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () async {
                        final pickedVideo =
                            await _imagePicker.pickVideo(source: ImageSource.gallery);
                        //final file = XFile(pickedVideo!.path);
                        Navigator.pop(context);
                        if (pickedVideo != null) {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             VideoCompress(videoFile: File(pickedVideo.path))));
                          context.read<AddPostProvider>().compressVideoFile(File(pickedVideo.path));
                          // final size =
                          //     getVideoSize(file: File(pickedVideo.path));
                          // log("size is $size");
                          // final lenght = size.replaceAll(" MB", "");
                          // log(lenght);
                          // if (double.tryParse(lenght)!.toDouble() < 20.0) {
                          //   context
                          //       .read<AddPostProvider>()
                          //       .addImages(File(pickedVideo.path));
                          // } else {
                          //   log("go to copressor");
                          // }
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
              );
            },
          ),
        );
      },
    );
  }
}

String getVideoSize({required File file}) => formatBytes(file.lengthSync(), 2);
