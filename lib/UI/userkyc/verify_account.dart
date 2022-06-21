import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
    "assets/json/3d-treasure-box.json",
    "assets/json/galaxy-play.json",
    "assets/json/lock-shield-protection.json",
    "assets/json/video-learning.json",
    "assets/json/community-shield.json",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 10),
        height: size(context).height,
        width: size(context).width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          //mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: size(context).height / 1.5,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  physics: const PageScrollPhysics(),
                  itemBuilder: (_, i) {
                    return Container(
                      height: 300,
                      width: 350,
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                          color: const Color(0xFF010B50),
                          borderRadius: BorderRadius.circular(14)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Why are we Verifying your Account?',
                            style: ThreeKmTextConstants.tk20PXPoppinsRedBold
                                .copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 42,
                          ),
                          Container(
                            height: 239,
                            width: 239,
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
                          const SizedBox(
                            height: 31,
                          ),
                          Text(
                            lowerLabel[i],
                            style: ThreeKmTextConstants.tk18PXPoppinsBlackMedium
                                .copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    );
                  }),
            ),
            SizedBox(
              width: size(context).width,
              height: 80,
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
            Spacer(),
            Container(
                margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                width: double.infinity,
                child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            StadiumBorder())),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => MobileVerification()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'Verify Your Account',
                        style: ThreeKmTextConstants.tk16PXPoppinsWhiteBold,
                      ),
                    )))
          ],
        ),
      ),
    );
  }
}
