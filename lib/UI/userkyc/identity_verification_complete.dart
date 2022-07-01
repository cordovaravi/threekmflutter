import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threekm/UI/main/Profile/MyProfilePost.dart';
import 'package:threekm/UI/main/navigation.dart';
import 'package:threekm/utils/constants.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

class IdentityComplete extends StatelessWidget {
  const IdentityComplete({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),
          Lottie.asset(
            'assets/json/check.json',
            fit: BoxFit.cover,
            alignment: Alignment.center,
            repeat: true,
          ),
          Spacer(),
          SizedBox(
            width: size(context).width / 1.2,
            child: Text(
              'We recived your documents we will verify it soon! till then Explore 3km..',
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
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TabBarNavigation(
                                  bottomIndex: 3,
                                )),
                        (route) => route.isFirst && route.isCurrent != true);
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
    );
  }
}
