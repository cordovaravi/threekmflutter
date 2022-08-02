import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threekm/UI/main/Profile/MyProfilePost.dart';
import 'package:threekm/UI/main/navigation.dart';
import 'package:threekm/providers/ProfileInfo/ProfileInfo_Provider.dart';
import 'package:threekm/providers/main/AthorProfile_Provider.dart';
import 'package:threekm/providers/userKyc/verify_credential.dart';
import 'package:threekm/utils/constants.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

class IdentityComplete extends StatefulWidget {
  const IdentityComplete({Key? key}) : super(key: key);

  @override
  State<IdentityComplete> createState() => _IdentityCompleteState();
}

class _IdentityCompleteState extends State<IdentityComplete>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller?.addListener(() {
      log(_controller!.value.toString());
      //  if the full duration of the animation is 8 secs then 0.5 is 4 secs
      if (_controller != null && _controller!.value == 1) {
// When it gets there hold it there.
        _controller!.value = 0.544;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Lottie.asset('assets/json/check.json',
                controller: _controller,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                repeat: false, onLoaded: (comp) {
              _controller!
                ..duration = comp.duration
                ..forward();
            }),
            Spacer(),
            SizedBox(
              width: size(context).width / 1.2,
              child: Text(
                'We have received your document. Our team will verify your identity soon. Till then explore 3km.',
                style: ThreeKmTextConstants.tk16PXPoppinsBlackMedium,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                width: double.infinity,
                child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            StadiumBorder())),
                    onPressed: () async {
                      context
                          .read<ProfileInfoProvider>()
                          .updateProfileInfo(isDocumentUploaded: true);
                      Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TabBarNavigation(
                                        bottomIndex: 3,
                                      )),
                              (route) =>
                                  route.isFirst && route.isCurrent != true)
                          .whenComplete(() {
                        context
                            .read<ProfileInfoProvider>()
                            .updateProfileInfo(is_verified: true);
                        context.read<AutthorProfileProvider>().getSelfProfile();
                        Future.delayed(Duration(seconds: 2), () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          context
                              .read<VerifyKYCCredential>()
                              .getUserProfileInfo();
                          setState(() {});
                        });
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'Done',
                        style: ThreeKmTextConstants.tk16PXPoppinsWhiteBold,
                      ),
                    )))
          ],
        ),
      ),
    );
  }
}
