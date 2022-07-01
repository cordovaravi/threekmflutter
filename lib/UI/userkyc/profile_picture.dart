import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threekm/UI/main/navigation.dart';
import 'package:threekm/UI/userkyc/profile_pic.dart';
import 'package:threekm/providers/userKyc/verify_credential.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

import 'basic_info.dart';

class UploadProfilePicture extends StatefulWidget {
  const UploadProfilePicture({Key? key}) : super(key: key);

  @override
  State<UploadProfilePicture> createState() => _UploadProfilePictureState();
}

class _UploadProfilePictureState extends State<UploadProfilePicture> {
  XFile? profilePhoto;
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    context.read<VerifyKYCCredential>().getAvatar();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<VerifyKYCCredential>();
    return Scaffold(
      body: Container(
        color: Colors.white,
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Step 2/5',
              style: ThreeKmTextConstants.tk18PXPoppinsBlackMedium,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Upload Profile',
                  style: ThreeKmTextConstants.tk18PXPoppinsBlackMedium,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => TabBarNavigation( bottomIndex: 3,)),
                        (route) => false);
                  },
                  child: Text(
                    'Cancel',
                    style: ThreeKmTextConstants.tk18PXPoppinsBlackMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            LinearProgressIndicator(
              valueColor: const AlwaysStoppedAnimation(Color(0xFF3E7EFF)),
              minHeight: 3,
              color: Colors.amber[400],
              backgroundColor: const Color(0xFFE7E7E7),
              value: 0.3,
              semanticsLabel: 'Linear progress indicator',
            ),
            const SizedBox(
              height: 46,
            ),
            InkWell(
              onTap: () async {
                showProfileImageDialog(context: context).whenComplete(
                    () => context.read<VerifyKYCCredential>().getAvatar());
                // profilePhoto = await _picker
                //     .pickImage(
                //         source: ImageSource.camera,
                //         imageQuality: 50,
                //         preferredCameraDevice: CameraDevice.front)
                //     .whenComplete(() => setState(() {}));
              },
              child: Center(
                child: Column(
                  children: [
                    provider.avtar != null
                        ? Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image(
                                  image: NetworkImage('${provider.avtar}'),
                                  height: 150,
                                  width: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red[400]),
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.mode_edit_outline_outlined,
                                          color: Colors.white,
                                        ),
                                      )))
                            ],
                          )
                        : const Image(
                            image: AssetImage('assets/user_profile.png'),
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Add Profile photo',
                      style: ThreeKmTextConstants.tk18PXPoppinsBlackMedium
                          .copyWith(fontSize: 24),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Text(
                        'Make your profile verified by uploading your best profile picture',
                        style: ThreeKmTextConstants.tk16PXPoppinsBlackMedium
                            .copyWith(color: const Color(0xFF988F8F)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  Text(
                    'Please make sure you upload a clear photo of yours',
                    style: ThreeKmTextConstants.tk18PXPoppinsBlackMedium
                        .copyWith(color: Color(0xFF979EA4)),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 20),
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                  StadiumBorder())),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => BasicInfo()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              'Next',
                              style:
                                  ThreeKmTextConstants.tk16PXPoppinsWhiteBold,
                            ),
                          )))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
