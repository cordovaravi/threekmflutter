import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/src/provider.dart';
import 'package:threekm/UI/main/navigation.dart';
import 'package:threekm/UI/userkyc/identity_verification.dart';
import 'package:threekm/providers/userKyc/verify_credential.dart';
import 'package:threekm/utils/constants.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

import 'mobile_verification.dart';

class VerifyAccount extends StatefulWidget {
  VerifyAccount({Key? key}) : super(key: key);

  @override
  State<VerifyAccount> createState() => _VerifyAccountState();
}

class _VerifyAccountState extends State<VerifyAccount> {
  int currentIndex = 0;
  List<String> lowerLabel = [
    "We are building a safe & responsible community",
    "To Encourage Original, Fresh & Abuse Free Content",
    "To Avoid Spam, Rumors & Harmful Content",
    "To Prevent Content Creators Identity Theft",
    "Finally,Reward & Monetize Great Content Creators!"
  ];
  List<String> animation = [
    "assets/json/50443-safe-city.json",
    "assets/json/video-learning.json",
    "assets/json/galaxy-play.json",
    "assets/json/lock-shield-protection.json",
    "assets/json/3d-treasure-box.json",
  ];
  @override
  Widget build(BuildContext context) {
    final userInfo =
        context.watch<VerifyKYCCredential>().userProfileInfo.data?.result;
    return Scaffold(
      body: Container(
        //padding: EdgeInsets.only(top: 100),
        height: size(context).height,
        width: size(context).width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          //mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'verification',
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
            ),
            Spacer(),
            SizedBox(
              height: size(context).height / 1.5,
              child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  physics: const PageScrollPhysics(),
                  onPageChanged: (i) {
                    setState(() {
                      currentIndex = i;
                    });
                  },
                  itemBuilder: (_, i) {
                    return Container(
                      height: 300,
                      width: 350,
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: size(context).width / 1.5,
                            child: Text(
                              'Why are we Verifying your Account?',
                              style: ThreeKmTextConstants.tk20PXPoppinsRedBold
                                  .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 42,
                          ),
                          Container(
                            height: size(context).height / 2.6,
                            width: size(context).width / 1.3,
                            padding: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: Lottie.asset(
                              animation[i],
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                              repeat: true,
                            ),
                          ),
                          SizedBox(
                            height: size(context).height / 14,
                          ),
                          SizedBox(
                            width: size(context).width / 1.2,
                            child: Text(
                              lowerLabel[i],
                              style: ThreeKmTextConstants.tk20PXPoppinsRedBold
                                  .copyWith(color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ),
            Spacer(),
            SizedBox(
              width: size(context).width,
              height: 30,
              child: Center(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, i) {
                      return Container(
                        margin: const EdgeInsets.all(10),
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                            color: currentIndex == i
                                ? Color(0xFF5B5959)
                                : Color(0xFFC4C4C4),
                            shape: BoxShape.circle),
                      );
                    }),
              ),
            ),
            Container(
                margin:
                    EdgeInsets.only(top: 20, left: 38, right: 38, bottom: 20),
                width: double.infinity,
                child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            StadiumBorder())),
                    onPressed: () {
                      userInfo != null && userInfo.isVerified
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => IdentityVerification()))
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => MobileVerification()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        userInfo != null && userInfo.isVerified
                            ? "Identity verification"
                            : 'Verify Your Account',
                        style: ThreeKmTextConstants.tk16PXPoppinsWhiteBold,
                      ),
                    )))
          ],
        ),
      ),
    );
  }
}
