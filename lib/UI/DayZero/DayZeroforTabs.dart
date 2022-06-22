import 'package:flutter/material.dart';
import 'package:threekm/providers/Global/logged_in_or_not.dart';
import 'package:threekm/utils/utils.dart';

class DayZeroforTabs extends StatefulWidget {
  final String ScreenName;
  final bool? islogin;
  const DayZeroforTabs({required this.ScreenName, this.islogin, Key? key})
      : super(key: key);

  @override
  _DayZeroforTabsState createState() => _DayZeroforTabsState();
}

getImagePath({required String nameOfScreen}) {
  switch (nameOfScreen) {
    case "shop":
      return "assets/dayzero/shop.png";

    case "address":
      return "assets/dayzero/address.png";

    case "login":
      return "assets/dayzero/login.png";

    case "wishlist":
      return "assets/dayzero/wishlist.png";
    case "post":
      return "assets/dayzero/addpost.png";
  }
}

getText({required String nameofScreen}) {
  switch (nameofScreen) {
    case "shop":
      return "Uh Oh! You haven’t ordered anything yet!";

    case "address":
      return "Uh Oh! looks like you have not added any address";

    case "login":
      return "Uh Oh! You need to  log in to access your profile!";

    case "wishlist":
      return "Uh Oh! looks like your wish list is empty  start your shopping now";
  }
}

getTextLogin({required String nameofScreen}) {
  switch (nameofScreen) {
    case "shop":
      return "Uh Oh! looks like your cart is empty  start your shopping now";

    case "address":
      return "Uh Oh! looks like you have not added any address";

    case "login":
      return "Uh Oh! You need to  log in to access your profile!";

    case "wishlist":
      return "Uh Oh! looks like your wish list is empty  start your shopping now";

    case "post":
      return "Uh Oh! You don’t have any posts yet!";
  }
}

class _DayZeroforTabsState extends State<DayZeroforTabs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Spacer(),
          Image.asset(getImagePath(nameOfScreen: widget.ScreenName)),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.islogin == false || widget.islogin == null
                ? getText(nameofScreen: widget.ScreenName)
                : getTextLogin(nameofScreen: widget.ScreenName)),
          ),
          SizedBox(height: 20),
          widget.islogin != true
              ? Container(
                  alignment: Alignment.center,
                  width: 102,
                  height: 44,
                  decoration: BoxDecoration(
                      color: Color(0xff3E7EFF),
                      borderRadius: BorderRadius.circular(20)),
                  child: InkWell(
                    onTap: () {
                      NaviagateToLogin(context);
                    },
                    child: Text(
                      "Login",
                      style: ThreeKmTextConstants.tk12PXPoppinsWhiteRegular,
                    ),
                  ),
                )
              : SizedBox(),
          Spacer()
        ],
      ),
    );
  }
}
