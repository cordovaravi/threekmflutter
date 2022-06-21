import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:threekm/utils/constants.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

class IdentityUpload extends StatefulWidget {
  const IdentityUpload({Key? key}) : super(key: key);

  @override
  State<IdentityUpload> createState() => _IdentityUploadState();
}

class _IdentityUploadState extends State<IdentityUpload> {
  final ImagePicker _picker = ImagePicker();
  XFile? frontphoto;
  XFile? backphoto;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Identity verification',
                    style: ThreeKmTextConstants.tk18PXPoppinsBlackMedium,
                  ),
                ),
                Text(
                  'Skip',
                  style: ThreeKmTextConstants.tk18PXPoppinsBlackMedium,
                )
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
              value: 0.2,
              semanticsLabel: 'Linear progress indicator',
            ),
            const SizedBox(
              height: 46,
            ),
            Text(
              'ID Varification',
              style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold,
              textAlign: TextAlign.center,
            ),
            Text(
              'Please take a clear photo of your ID Name, Address, Date Of Birth And Aadhar Number Should Be Clearly Visible.',
              style: ThreeKmTextConstants.tk14PXPoppinsBlackMedium
                  .copyWith(color: const Color(0xFFA7ABAD)),
            ),
            const SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () {
                setState(() async {
                  frontphoto =
                      await _picker.pickImage(source: ImageSource.camera);
                });
              },
              child: frontphoto != null
                  ? Image.file(
                      File(frontphoto!.path),
                      width: size(context).width,
                      height: 200,
                    )
                  : Container(
                      width: size(context).width,
                      height: 200,
                      decoration: BoxDecoration(
                          color: const Color(0xFFF4F3F8),
                          borderRadius: BorderRadius.circular(8)),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          ),
                          Column(
                            children: [
                              Text('Take a clear photo of',
                                  style: ThreeKmTextConstants
                                      .tk16PXPoppinsBlackMedium
                                      .copyWith(color: Colors.grey)),
                              Wrap(
                                children: [
                                  Text(
                                    'your ID-',
                                    style: ThreeKmTextConstants
                                        .tk16PXPoppinsBlackMedium
                                        .copyWith(color: Colors.grey),
                                  ),
                                  Text(
                                    'Front side',
                                    style: ThreeKmTextConstants
                                        .tk16PXPoppinsBlackMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      )),
            ),
            const SizedBox(
              height: 24,
            ),
            InkWell(
              onTap: () {
                setState(() async {
                  backphoto =
                      await _picker.pickImage(source: ImageSource.camera);
                });
              },
              child: backphoto != null
                  ? Image.file(
                      File(backphoto!.path),
                      width: size(context).width,
                      height: 200,
                    )
                  : Container(
                      width: size(context).width,
                      height: 200,
                      decoration: BoxDecoration(
                          color: const Color(0xFFF4F3F8),
                          borderRadius: BorderRadius.circular(8)),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          ),
                          Column(
                            children: [
                              Text(
                                'Take a clear photo of ',
                                style: ThreeKmTextConstants
                                    .tk16PXPoppinsBlackMedium
                                    .copyWith(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                              Wrap(
                                children: [
                                  Text(
                                    'your ID-',
                                    style: ThreeKmTextConstants
                                        .tk16PXPoppinsBlackMedium
                                        .copyWith(color: Colors.grey),
                                  ),
                                  Text(
                                    'Back side',
                                    style: ThreeKmTextConstants
                                        .tk16PXPoppinsBlackMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      )),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.center,
              child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              const StadiumBorder())),
                      onPressed: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (_) => IdentityUpload()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'Next',
                          style: ThreeKmTextConstants.tk16PXPoppinsWhiteBold,
                        ),
                      ))),
            )
          ],
        ),
      ),
    );
  }
}
