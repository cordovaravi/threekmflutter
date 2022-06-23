import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:threekm/Custom_library/GooleMapsWidget/src/place_picker.dart';
import 'package:threekm/UI/main/AddPost/ImageEdit/editImage.dart';
import 'package:threekm/UI/main/AddPost/utils/FileUtils.dart';
import 'package:threekm/UI/main/AddPost/utils/uploadPost.dart';
import 'package:threekm/UI/main/AddPost/utils/video.dart';
import 'package:threekm/UI/main/News/NewsList.dart';
import 'package:threekm/providers/Location/locattion_Provider.dart';
import 'package:threekm/providers/main/AddPost_Provider.dart';
import 'package:threekm/utils/api_paths.dart';
import 'package:threekm/utils/utils.dart';

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

  Geometry? _geometry;

  int headlineCount = 0;
  int descriptionCount = 0;
  String? _selectedAddress;

  @override
  void initState() {
    Future.microtask(() => context.read<AddPostProvider>());
    super.initState();
  }

  @override
  void dispose() {
    _tagsController.dispose();
    _storyController.dispose();
    _headLineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageList = context.watch<AddPostProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "New Post",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        titleSpacing: 0,
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                if (_formKey.currentState?.validate() ?? false) {
                  if (!(descriptionCount > 0 ||
                      imageList.getMoreImages.isNotEmpty ||
                      headlineCount > 0)) {
                    Fluttertoast.showToast(
                        msg: "Add either a headline, description or upload image/video");
                    return;
                  }
                  if (context.read<AddPostProvider>().tagsList.length < 3) {
                    Fluttertoast.showToast(msg: "Minimum 3 tags required");
                    return;
                  }
                  if (_selectedAddress == null) {
                    Fluttertoast.showToast(msg: "Location required");
                    return;
                  }

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PostUploadPage(
                                Title: _headLineController.text,
                                Story: _storyController.text,
                                address: _selectedAddress ?? "",
                                lat: _geometry?.location.lat,
                                long: _geometry?.location.lng,
                              )));
                }
                // if (_formKey.currentState!.validate()) {
                //   if (_geometry?.location.lat != null) {
                //     context
                //         .read<AddPostProvider>()
                //         .uploadPng(
                //             context,
                //             _headLineController.text,
                //             _storyController.text,
                //             _selecetdAddress ?? "",
                //             _geometry!.location.lat,
                //             _geometry!.location.lng)
                //         .whenComplete(() {
                //       Navigator.pushAndRemoveUntil(
                //           context,
                //           MaterialPageRoute(
                //               builder: (context) => TabBarNavigation(
                //                     redirectedFromPost: true,
                //                   )),
                //           (route) => false);
                //     });
                //   } else {
                //     CustomSnackBar(context, Text("Please Select Location"));
                //   }
                // }
              },
              child: Text(
                "Post",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                primary: _selectedAddress != null &&
                        (context.read<AddPostProvider>().tagsList.length >= 3)
                    ? const Color(0xff3E7EFF)
                    : const Color(0xffF1F2F6),
                elevation: 0,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
            ),
          ),
          SizedBox(width: 6)
        ],
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
            SizedBox(height: 30),
            buildHeadline,
            SizedBox(height: 2),
            TextFormField(
              validator: (String? title) {
                // if (title == null || title.trim().isEmpty) {
                //   return "*required";
                // }
                if (title!.length > 100) {
                  return "*Exceeded ${headlineCount - 100} characters";
                }
                return null;
              },
              onChanged: (String story) {
                headlineCount = story.length;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _headLineController,
              maxLines: null,
              minLines: 2,
              expands: false,
              // maxLength: 100,
              textAlignVertical: TextAlignVertical.center,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              buildCounter: (context, {required currentLength, required isFocused, maxLength}) {
                // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                //   setState(() {
                //     headlineCount = currentLength;
                //   });
                // });
                return Text("${headlineCount}/100",
                    style: ThreeKmTextConstants.tk12PXPoppinsWhiteRegular.copyWith(
                      fontSize: 10.5,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF7c7c7c),
                    ));
              },
              style: ThreeKmTextConstants.tk16PXLatoBlackRegular.copyWith(
                color: Color(0xFF0F0F2D),
                fontWeight: FontWeight.w500,
              ),
              decoration: buildInputDecoration,
            ),
            Divider(color: Color(0xFFa7abad).withOpacity(0.5), thickness: 1),
            SizedBox(height: 30),
            buildDescription,
            SizedBox(height: 2),
            TextFormField(
              validator: (String? story) {
                if ((story!.length) > 2000) {
                  return "*Exceeded by ${descriptionCount - 2000} characters";
                }
                return null;
              },
              onChanged: (String story) {
                descriptionCount = story.length;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textAlignVertical: TextAlignVertical.bottom,
              controller: _storyController,
              maxLines: null,
              minLines: 2,
              buildCounter: (context, {required currentLength, required isFocused, maxLength}) {
                // WidgetsBinding.instance!.addPostFrameCallback((_) {
                //   setState(() {
                //     descriptionCount = currentLength;
                //   });
                // });
                return Text("${descriptionCount}/2000",
                    style: ThreeKmTextConstants.tk12PXPoppinsWhiteRegular.copyWith(
                      fontSize: 10.5,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF7c7c7c),
                    ));
              },
              style: ThreeKmTextConstants.tk16PXLatoBlackRegular.copyWith(
                color: Color(0xFF0F0F2D),
                fontWeight: FontWeight.w500,
              ),
              decoration: buildInputDecoration,
            ),
            Divider(color: Color(0xFFa7abad).withOpacity(0.5), thickness: 1),
            SizedBox(height: 30),
            buildTagsHeader,
            SizedBox(height: 6),
            buildTags,
            // SizedBox(height: 16),
            Divider(color: Color(0xFFa7abad).withOpacity(0.5), thickness: 1),
            SizedBox(height: 30),
            // Location
            Builder(
              builder: (_controller) => InkWell(
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  Future.delayed(Duration.zero, () {
                    context.read<LocationProvider>().getLocation().whenComplete(() {
                      final _locationProvider = context.read<LocationProvider>().getlocationData;
                      final kInitialPosition =
                          LatLng(_locationProvider!.latitude!, _locationProvider.longitude!);
                      if (_locationProvider != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlacePicker(
                                apiKey: GMap_Api_Key,
                                // initialMapType: MapType.satellite,
                                onPlacePicked: (result) {
                                  //print(result.formattedAddress);
                                  setState(() {
                                    _selectedAddress = result.formattedAddress;
                                    print(result.geometry!.toJson());
                                    _geometry = result.geometry;
                                  });
                                  Navigator.of(context).pop();
                                },
                                initialPosition: kInitialPosition,
                                useCurrentLocation: true,
                                selectInitialPosition: true,
                                usePinPointingSearch: true,
                                usePlaceDetailSearch: true,
                              ),
                            ));
                      }
                    });
                  });
                  // await Navigator.of(context)
                  //     .pushNamed(LocationBasePage.path);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 28,
                          color: const Color(0xFF3E7EFF),
                        ),
                        SizedBox(width: 5),
                        Text(
                          _selectedAddress == null ? "Add Post location" : "Change Location",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF3E7EFF),
                              fontSize: 16),
                        ),
                        if (_selectedAddress == null)
                          Text(
                            " (required)",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFa7abad),
                            ),
                          )
                      ],
                    ),
                    if (_selectedAddress != null) ...[
                      SizedBox(height: 8),
                      Text(
                        _selectedAddress!,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // SizedBox(height: 13),
                    ],
                  ],
                ),
              ),
            ),
            Divider(color: Color(0xFFa7abad).withOpacity(0.5), thickness: 1),
            SizedBox(height: 15),
            imageList.getMoreImages.length > 0
                ? Consumer<AddPostProvider>(builder: (context, controller, _) {
                    return GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, mainAxisSpacing: 3, crossAxisSpacing: 3),
                        itemCount: imageList.getMoreImages.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Stack(
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
                                      : Image.file(imageList.getMoreImages[index],
                                          fit: BoxFit.cover),
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
                                        color: Color(0xffFF5858),
                                        borderRadius: BorderRadius.circular(8)),
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
                        });
                  })
                : const SizedBox.shrink(),
            SizedBox(height: 15),
            buildFooter(imageList),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }

  InputDecoration get buildInputDecoration {
    return InputDecoration(
        filled: true,
        fillColor: Color(0xfff1f1f1).withOpacity(0.8),
        border: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(8)));
  }

  Widget get buildHeadline {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Title/Headline",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFFa7abad),
          ),
        ),
        // Text(
        //   "($headlineCount/100)",
        //   style: ThreeKmTextConstants.tk12PXPoppinsWhiteRegular.copyWith(
        //     fontSize: 10.5,
        //     fontWeight: FontWeight.normal,
        //     color: Color(0xFF7c7c7c),
        //   ),
        // ),
      ],
    );
  }

  Widget get buildDescription {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Description",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFFa7abad),
          ),
        ),
        // Text(
        //   // "",
        //   "($descriptionCount/2000)",
        //   style: GoogleFonts.poppins(
        //       fontWeight: FontWeight.normal, fontSize: 10.5, color: Color(0xff7c7c7c)),
        // ),
      ],
    );
  }

  Widget get buildTagsHeader => Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Tags",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFFa7abad),
              ),
            ),
            Text('(min 3 required)',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFa7abad),
                )),
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

  Widget buildFooter(AddPostProvider imageList) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
            _showImageVideoBottomModalSheet(context);
          },
          borderRadius: BorderRadius.circular(50),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Color(0xff3E7EFF), width: 2),
            ),
            child: Text(
              imageList.getMoreImages.length > 0 ? "Add More Media" : "Upload Image/Video",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff3E7EFF)),
            ),
          ),
        ),
      ],
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      VideoCompress(videoFile: File(pickedVideo.path))));
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
