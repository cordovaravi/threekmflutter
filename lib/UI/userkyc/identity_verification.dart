import 'package:flutter/material.dart';
import 'package:threekm/UI/main/navigation.dart';
import 'package:threekm/utils/constants.dart';
import 'package:threekm/utils/utils.dart';

import 'identity_verification_upload.dart';

class IdentityVerification extends StatefulWidget {
  const IdentityVerification({Key? key}) : super(key: key);

  @override
  State<IdentityVerification> createState() => _IdentityVerificationState();
}

class _IdentityVerificationState extends State<IdentityVerification> {
  String _identityOptions = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Step 1/2',
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
              value: 0.5,
              semanticsLabel: 'Linear progress indicator',
            ),
            const SizedBox(
              height: 46,
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Use a valid government-Issued document',
                    style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Only the following documents listed below will be accepted all other documents will be rejected please select any one',
                    style: ThreeKmTextConstants.tk14PXPoppinsBlackMedium
                        .copyWith(color: const Color(0xFFA7ABAD)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _identityOptions = "Pancard";
                      });
                    },
                    child: Container(
                      width: size(context).width,
                      height: 60,
                      padding: const EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                          color: _identityOptions == "Pancard"
                              ? const Color(0x2B33FF11)
                              : const Color(0xFFF4F3F8),
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          Icon(
                            Icons.credit_card,
                            color: _identityOptions == "Pancard"
                                ? Colors.black
                                : Colors.grey,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Pancard',
                            style: ThreeKmTextConstants.tk14PXPoppinsBlackMedium
                                .copyWith(color: const Color(0xFF979EA4)),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _identityOptions = "Voter ID";
                      });
                    },
                    child: Container(
                      width: size(context).width,
                      height: 60,
                      padding: const EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                          color: _identityOptions == "Voter ID"
                              ? const Color(0x2B33FF11)
                              : const Color(0xFFF4F3F8),
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          Icon(
                            Icons.chrome_reader_mode_outlined,
                            color: _identityOptions == "Voter ID"
                                ? Colors.black
                                : Colors.grey,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Voter ID',
                            style: ThreeKmTextConstants.tk14PXPoppinsBlackMedium
                                .copyWith(color: const Color(0xFF979EA4)),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _identityOptions = "Driver’s License";
                      });
                    },
                    child: Container(
                      width: size(context).width,
                      height: 60,
                      padding: const EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                          color: _identityOptions == "Driver’s License"
                              ? const Color(0x2B33FF11)
                              : const Color(0xFFF4F3F8),
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          Icon(
                            Icons.chrome_reader_mode_rounded,
                            color: _identityOptions == "Driver’s License"
                                ? Colors.black
                                : Colors.grey,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Driver’s License',
                            style: ThreeKmTextConstants.tk14PXPoppinsBlackMedium
                                .copyWith(color: const Color(0xFF979EA4)),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _identityOptions = "Other governement issued document";
                      });
                    },
                    child: Container(
                      width: size(context).width,
                      height: 60,
                      padding: const EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                          color: _identityOptions ==
                                  "Other governement issued document"
                              ? const Color(0x2B33FF11)
                              : const Color(0xFFF4F3F8),
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          Icon(
                            Icons.featured_play_list_outlined,
                            color: _identityOptions ==
                                    "Other governement issued document"
                                ? Colors.black
                                : Colors.grey,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Other governement issued document',
                            style: ThreeKmTextConstants.tk14PXPoppinsBlackMedium
                                .copyWith(color: const Color(0xFF979EA4)),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'NOTE- This Data will be only used for varification',
                    style: ThreeKmTextConstants.tk14PXPoppinsBlackSemiBold
                        .copyWith(color: const Color(0xFF979EA4)),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 20),
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                  const StadiumBorder())),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => IdentityUpload(
                                          documentname: _identityOptions,
                                        )));
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
