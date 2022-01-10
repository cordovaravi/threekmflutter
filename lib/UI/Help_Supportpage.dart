import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:threekm/utils/threekm_textstyles.dart';
import 'package:threekm/utils/util_methods.dart';
import 'package:threekm/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpAndSupport extends StatelessWidget {
  const HelpAndSupport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            space(
              height: 40,
            ),
            buildInfoCard,
            space(
              height: 32,
            ),
            sendMessageCard,
            space(height: 32)
          ],
        ),
      ),
    );
  }

  Widget get sendMessageCard {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18),
      child: PhysicalModel(
        color: Colors.transparent,
        shadowColor: Color(0xFF3B4A7424),
        elevation: 10,
        child: Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 24,
            top: 21,
            bottom: 47,
          ),
          width: double.infinity,
          height: 401,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.insert_comment_rounded,
                    color: Colors.green,
                  ),
                  space(
                    width: 8,
                  ),
                  Text(
                    "Send Us a Message",
                    style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold
                        .copyWith(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              space(height: 8),
              Container(
                child: Text(
                  "You can describe your feedback below and our customer team will try to resolve the issue as soon a possible",
                  style: ThreeKmTextConstants.tk14PXLatoBlackSemiBold.copyWith(
                    color: Color(0xFF0F0F2D).withOpacity(0.75),
                  ),
                ),
              ),
              space(height: 16),
              Container(
                height: 166,
                padding:
                    EdgeInsets.only(left: 16, top: 15, right: 16, bottom: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(21),
                  color: Color(0xFFF4F3F8),
                  border: Border.all(
                    color: Color(0xFFD5D5D5),
                  ),
                ),
                child: TextField(
                  expands: true,
                  minLines: null,
                  maxLines: null,
                  style: ThreeKmTextConstants.tk16PXLatoBlackRegular,
                  decoration: InputDecoration.collapsed(
                    hintText: "Describe your issue here.",
                    hintStyle:
                        ThreeKmTextConstants.tk16PXLatoBlackRegular.copyWith(
                      color: Color(0xFF979EA4),
                    ),
                  ),
                ),
              ),
              space(height: 16),
              CustomButton(
                width: 108,
                height: 47,
                borderRadius: BorderRadius.circular(24),
                color: Color(0xFF3E7EFF),
                elevation: 0,
                child: Text(
                  "Submit".toUpperCase(),
                  style:
                      ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold.copyWith(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget get buildInfoCard {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18),
      child: PhysicalModel(
        color: Colors.transparent,
        shadowColor: Color(0xFF3B4A7424),
        elevation: 10,
        child: Container(
          padding: EdgeInsets.only(
            left: 16,
            top: 24,
            bottom: 32,
          ),
          width: double.infinity,
          height: 340,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Customer Support".toUpperCase(),
                style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold
                    .copyWith(fontWeight: FontWeight.w900),
              ),
              space(height: 8),
              Container(
                width: 292,
                child: Text(
                  "Connect with our customer support team if you are facing any issues with the 3km app.",
                  style: ThreeKmTextConstants.tk14PXLatoBlackSemiBold.copyWith(
                    color: Color(0xFF0F0F2D).withOpacity(0.75),
                  ),
                ),
              ),
              space(height: 24),
              rowWidget(
                onTap: () async {
                  var uri = Uri(
                    scheme: "tel",
                    path: "+91 8805499774",
                  );
                  bool willLaunch = await canLaunch(uri.toString());
                  if (willLaunch) {
                    launch(uri.toString());
                  } else {
                    Fluttertoast.showToast(msg: "Unable to launch");
                  }
                },
                text: "+91 8805499774",
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFBA924),
                  ),
                  child: Icon(
                    Icons.call,
                    color: Colors.white,
                  ),
                ),
              ),
              space(height: 24),
              rowWidget(
                onTap: () async {
                  var uri = Uri(
                    scheme: "whatsapp",
                    path: "send",
                    queryParameters: {
                      "text": "",
                      "phone": "8805499774",
                    },
                  );
                  bool willLaunch = await canLaunch(uri.toString());
                  if (willLaunch) {
                    launch(uri.toString());
                  } else {
                    print("Uri for web");
                    var uriWeb = Uri(
                      scheme: "https",
                      path: "wa.me/8805499774",
                      queryParameters: {"text": ""},
                    );
                    bool willLaunchWeb = await canLaunch(uriWeb.toString());
                    if (willLaunchWeb) {
                      launch(uriWeb.toString());
                    } else {
                      Fluttertoast.showToast(msg: "Unable to launch");
                    }
                  }
                },
                text: "+91 8805499774",
                child: Image.asset(
                  "assets/whatsapp.png",
                  height: 48,
                  width: 48,
                ),
              ),
              space(height: 24),
              rowWidget(
                onTap: () async {
                  var uri = Uri(
                    scheme: "mailto",
                    path: "support@3km.com",
                  );
                  bool willLaunch = await canLaunch(uri.toString());
                  if (willLaunch) {
                    launch(uri.toString());
                  } else {
                    Fluttertoast.showToast(msg: "Unable to launch");
                  }
                },
                text: "support@3km.com",
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child: Icon(
                    Icons.mail,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget rowWidget(
      {required Widget child,
      required String text,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          child,
          space(width: 18),
          Text(
            text,
            style: ThreeKmTextConstants.tk16PXPoppinsBlackMedium,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget? buildAppBar(context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: false,
      elevation: 1,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_rounded,
          color: Colors.black,
          size: 22,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        "help and support".toUpperCase(),
        style: ThreeKmTextConstants.tk16PXPoppinsWhiteBold.copyWith(
          fontWeight: FontWeight.w900,
          color: Colors.black,
        ),
      ),
    );
  }
}
