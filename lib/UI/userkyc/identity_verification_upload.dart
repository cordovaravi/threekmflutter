import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/src/provider.dart';
import 'package:threekm/UI/main/navigation.dart';
import 'package:threekm/UI/userkyc/identity_verification_complete.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/commenwidgets/commenwidget.dart' as commonWidget;
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/providers/userKyc/verify_credential.dart';
import 'package:threekm/utils/api_paths.dart';
import 'package:threekm/utils/constants.dart';

import 'package:http/http.dart' as http;
import 'package:threekm/utils/threekm_textstyles.dart';

class IdentityUpload extends StatefulWidget {
  const IdentityUpload({Key? key, required this.documentname})
      : super(key: key);
  final String documentname;
  @override
  State<IdentityUpload> createState() => _IdentityUploadState();
}

class _IdentityUploadState extends State<IdentityUpload> {
  final ImagePicker _picker = ImagePicker();
  XFile? frontphoto;
  XFile? backphoto;
  TextEditingController _controller = TextEditingController();

  List<String> _uploadImageUrls = [];
  List<String> get uploadedImagesUrl => _uploadImageUrls;
  final ApiProvider _apiProvider = ApiProvider();

  uploadDoc() async {
    if (frontphoto?.name != null && backphoto?.name != null) {
      // showUploadingSnackbar(context, img.first);
      List<XFile> img = [frontphoto!, backphoto!];
      img.forEach((element) async {
        if (element.path.contains(".png") ||
            element.path.contains(".jpg") ||
            element.path.contains(".jpeg")) {
          try {
            commonWidget.showLoading();
            var request = await http.MultipartRequest(
                'POST', Uri.parse(upload_Imagefile));
            request.headers['Authorization'] = await _apiProvider.getToken();
            request.fields['storage_url'] = "kycDoc";
            request.fields['record_id'] = "0";
            request.fields['filename'] = "post.png";
            request.files
                .add(await http.MultipartFile.fromPath('file', element.path));
            var httpresponse = await request.send();
            final res = await http.Response.fromStream(httpresponse);
            final response = json.decode(res.body);
            if (httpresponse.statusCode == 200) {
              print("uploaded");
              if (response["status"] == "success") {
                log(response["photo"]["photo"]);
                _uploadImageUrls.add(response["photo"]["photo"]);
                //log(_uploadImageUrls.toList().toString());
                if (img.length == _uploadImageUrls.length) {
                  log("progress is 100");
                  // uploadPost(context, headLine, story, address, lat, long);
                  var requestJson = {
                    "type": "${widget.documentname}",
                    "number": _controller.text,
                    "images": uploadedImagesUrl
                  };
                  commonWidget.hideLoading();

                  context
                      .read<VerifyKYCCredential>()
                      .updateKYCDoc(jsonEncode(requestJson))
                      .whenComplete(() {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => IdentityComplete()));
                  });
                }
              }
            } else {
              CustomSnackBar(context, Text("Upload Failed.!"));
            }
          } catch (e) {
            CustomSnackBar(context, Text("Upload Failed.!"));
          }
        }
      });
    } else {
      CustomSnackBar(context, Text("Please Select a file to upload."));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            width: size(context).width,
            height: size(context).height,
            // margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step 2/2',
                  style: ThreeKmTextConstants.tk18PXPoppinsBlackMedium,
                ),
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
                    InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => TabBarNavigation(
                                      bottomIndex: 3,
                                    )),
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
                  value: 1,
                  semanticsLabel: 'Linear progress indicator',
                ),
                const SizedBox(
                  height: 25,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'ID Verification',
                          style:
                              ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Please take a clear photo of your ID Name, Date Of Birth And ${widget.documentname} number Should Be Clearly Visible.',
                          style: ThreeKmTextConstants.tk14PXPoppinsBlackMedium
                              .copyWith(color: const Color(0xFFA7ABAD)),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        InkWell(
                          onTap: () async {
                            frontphoto = await _picker.pickImage(
                                source: ImageSource.gallery);
                            setState(() {});
                          },
                          child: frontphoto != null
                              ? Image.file(
                                  File(frontphoto!.path),
                                  width: size(context).width,
                                  height: 170,
                                )
                              : Container(
                                  width: size(context).width,
                                  height: 170,
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
                                                  .copyWith(
                                                      color: Colors.grey)),
                                          Wrap(
                                            children: [
                                              Text(
                                                'your ID-',
                                                style: ThreeKmTextConstants
                                                    .tk16PXPoppinsBlackMedium
                                                    .copyWith(
                                                        color: Colors.grey),
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
                          onTap: () async {
                            backphoto = await _picker.pickImage(
                                source: ImageSource.gallery);
                            setState(() {});
                          },
                          child: backphoto != null
                              ? Image.file(
                                  File(backphoto!.path),
                                  width: size(context).width,
                                  height: 170,
                                )
                              : Container(
                                  width: size(context).width,
                                  height: 170,
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
                                                    .copyWith(
                                                        color: Colors.grey),
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
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              'Enter ID Number',
                              style: ThreeKmTextConstants
                                  .tk16PXPoppinsBlackSemiBold,
                            ),
                            Text(
                              ' (Required)',
                              style: ThreeKmTextConstants
                                  .tk12PXPoppinsWhiteRegular
                                  .copyWith(color: Colors.red),
                            )
                          ],
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          // focusNode: _controller.node,
                          controller: _controller,
                          textAlign: TextAlign.start,
                          textAlignVertical: TextAlignVertical.top,
                          maxLines: 1,
                          decoration: InputDecoration(
                            hintText: '${widget.documentname} number',
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                          ),

                          validator: (val) {
                            if (val!.isEmpty || val == null) {
                              return "ID number is empty";
                            } else if (val.contains(" ")) {
                              return "Space is not allowed";
                            }
                            // else if (!val.contains(".")) {
                            //   return "Please enter valid Email";
                            // else if (!val.contains("@")) {
                            //   return "Please enter valid Email";
                            // } else {
                            //   WidgetsBinding.instance?.addPostFrameCallback((_) {
                            //     setState(() {
                            //       isValidEmail = true;
                            //     });
                            //   });
                            // }
                          },
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                              margin:
                                  const EdgeInsets.only(top: 30, bottom: 20),
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              OutlinedBorder>(
                                          const StadiumBorder())),
                                  onPressed: () {
                                    if (_controller.text != "" &&
                                        _controller.text.contains(" ") ==
                                            false) {
                                      uploadDoc();
                                    } else if (_controller.text.contains(" ") ==
                                        true) {
                                      Fluttertoast.showToast(
                                          msg: "Space is not allowed");
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Please Enter Id number");
                                    }
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (_) => IdentityUpload()));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      'Next',
                                      style: ThreeKmTextConstants
                                          .tk16PXPoppinsWhiteBold,
                                    ),
                                  ))),
                        ),
                        SizedBox(
                          height: 90,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
