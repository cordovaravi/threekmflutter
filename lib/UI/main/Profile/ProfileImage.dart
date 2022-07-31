import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:threekm/UI/main/AddPost/ImageEdit/EditHelper.dart';
import 'package:threekm/providers/ProfileInfo/ProfileInfo_Provider.dart';
import 'package:threekm/utils/constants.dart';
import 'package:threekm/utils/threekm_textstyles.dart';
import 'package:threekm/utils/util_methods.dart';
import 'package:threekm/widgets/animated_button_circle.dart';
import 'package:threekm/widgets/custom_button.dart';

class ProfileImagePopUp extends StatefulWidget {
  ProfileImagePopUp({Key? key}) : super(key: key);

  @override
  State<ProfileImagePopUp> createState() => _ProfileImagePopUpState();
}

class _ProfileImagePopUpState extends State<ProfileImagePopUp> {
  ImagePicker _imagePicker = ImagePicker();

  XFile? image;

  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          "Crop and adjust".toUpperCase(),
          style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold.copyWith(
            fontWeight: FontWeight.w900,
            color: Color(0xFF0F0F2D),
          ),
        ),
      ),
      body: Container(
        // padding: EdgeInsets.only(left: 25, top: 48, right: 25, bottom: 30),
        height: MediaQuery.of(context).size.height / 1.3,
        width: double.infinity,
        margin: EdgeInsets.only(
          top: 24,
          bottom: 24,
          right: 8,
          left: 8,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Text(
              //   "Crop and adjust".toUpperCase(),
              //   style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold.copyWith(
              //     fontWeight: FontWeight.w900,
              //     color: Color(0xFF0F0F2D),
              //   ),
              // ),
              space(
                height: 24,
              ),
              buildProfileButton(
                title: "Select other Photo",
                onTap: () async {
                  image = await _imagePicker.pickImage(
                      source: ImageSource.gallery, imageQuality: 60);
                  if (image != null) {
                    //Navigator.pop(context);
                    setState(() {});
                  }
                },
                width: 177,
              ),
              space(
                height: 62,
              ),
              Container(
                  height: 400,
                  width: size(context).width,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    // shape: BoxShape.circle,
                  ),
                  child: image == null
                      ? Icon(
                          Icons.collections,
                          size: 100,
                          color: Colors.grey,
                        )
                      // : Image.file(
                      //     File(image!.path),
                      //     fit: BoxFit.contain,
                      //   ),
                      : ExtendedImage.file(
                          File(image!.path),
                          height: 300,
                          width: size(context).width / 2,
                          shape: BoxShape.circle,
                          cacheRawData: true,
                          fit: BoxFit.contain,
                          clearMemoryCacheWhenDispose: true,
                          // enableLoadState: true,
                          mode: ExtendedImageMode.editor,
                          extendedImageEditorKey: editorKey,
                          borderRadius: BorderRadius.circular(30),
                          initEditorConfigHandler: (state) {
                            return EditorConfig(
                              maxScale: 10.0,
                              // cropRectPadding: EdgeInsets.all(20.0),
                              hitTestSize: 10.0,
                              //cropAspectRatio: CropAspectRatios.custom
                            );
                          },
                        )),
              space(
                height: 72,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildSaveButton(context),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileButton(
      {required String title, double? width, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.collections,
              color: Colors.blue,
            ),
            space(
              width: 8,
            ),
            Text(
              "$title",
              style: ThreeKmTextConstants.tk12PXPoppinsBlackSemiBold.copyWith(
                color: Color(0xFF3E7EFF),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Color(0xFF3E7EFF).withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  Widget buildSaveButton(BuildContext context) {
    return CustomButton(
      height: 52,
      width: 176,
      onTap: () async {
        // var pop = await Get.find<ProfileController>().changeProfilePicture();
        // if (pop == true) {
        //   Get.find<ProfileController>().imageName = null;
        //   Get.find<ProfileController>().imageList = null;
        //   Navigator.of(context).pop();
        // }
        Uint8List? fileData;
        if (editorKey.currentState?.rawImageData != null) {
          fileData = await cropImageDataWithNativeLibrary(
              state: editorKey.currentState!);
          final tempDir = await getTemporaryDirectory();
          File file = await File('${tempDir.path}/image.png').create();
          file.writeAsBytesSync(fileData!);
          print(file.path);
          context
              .read<ProfileInfoProvider>()
              .uploadPhoto(context: context, filePath: file.path);
        }
      },
      borderRadius: BorderRadius.circular(26),
      color: Color(0xFF3E7EFF),
      elevation: 0,
      child: Consumer<ProfileInfoProvider>(
        builder: (context, controller, _) {
          return controller.uploadingPhoto == false
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedButtonCircle(),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      "Save Image",
                      style: ThreeKmTextConstants.tk14PXPoppinsBlackBold
                          .copyWith(color: Colors.white),
                    )
                  ],
                )
              : Container(
                  height: 30,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                );
        },
      ),
    );
  }
}
