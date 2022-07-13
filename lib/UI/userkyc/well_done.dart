import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threekm/UI/main/Profile/MyProfilePost.dart';
import 'package:threekm/UI/main/navigation.dart';
import 'package:threekm/main.dart';
import 'package:threekm/providers/ProfileInfo/ProfileInfo_Provider.dart';
import 'package:threekm/providers/main/AthorProfile_Provider.dart';
import 'package:threekm/utils/constants.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

class WellDone extends StatefulWidget {
  const WellDone({Key? key}) : super(key: key);

  @override
  State<WellDone> createState() => _WellDoneState();
}

class _WellDoneState extends State<WellDone> {
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
            Lottie.asset(
              'assets/json/14337-well-done.json',
              fit: BoxFit.cover,
              alignment: Alignment.center,
              repeat: false,
            ),
            Spacer(),
            SizedBox(
              width: size(context).width / 1.2,
              child: Text(
                'Congrats Now you are Eligible to Post on your own wall',
                style: ThreeKmTextConstants.tk16PXPoppinsBlackMedium,
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              'Start with your first post now. .',
              style: ThreeKmTextConstants.tk14PXPoppinsBlackMedium
                  .copyWith(color: Colors.grey[400]),
              textAlign: TextAlign.center,
            ),
            Container(
                margin:
                    EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
                width: double.infinity,
                child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            StadiumBorder())),
                    onPressed: () async {
                      SharedPreferences _prefs =
                          await SharedPreferences.getInstance();
                      String? avatar = _prefs.getString("avatar");
                      var fname = _prefs.getString("userfname");
                      var lname = _prefs.getString("userlname");
                      var UserName = "$fname $lname";
                      if (UserName != "")
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
                          context
                              .read<AutthorProfileProvider>()
                              .getSelfProfile();
                          setState(() {});
                          Navigator.pop(context);
                          Navigator.pop(context);
                        });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'Add Post',
                        style: ThreeKmTextConstants.tk16PXPoppinsWhiteBold,
                      ),
                    )))
          ],
        ),
      ),
    );
  }
}
