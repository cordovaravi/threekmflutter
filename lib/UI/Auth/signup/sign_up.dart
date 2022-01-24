import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:threekm/UI/Auth/sign_in.dart';
import 'package:threekm/UI/Help_Supportpage.dart';
import 'package:threekm/providers/auth/signUp_Provider.dart';
import 'package:threekm/providers/auth/social_auth/facebook_provider.dart';
import 'package:threekm/providers/auth/social_auth/google_provider.dart';
import 'package:threekm/utils/intl.dart';
import 'package:threekm/utils/threekm_textstyles.dart';
import 'package:threekm/utils/utils.dart';
import 'package:threekm/widgets/custom_button.dart';

class SignUp extends StatefulWidget {
  // static const String path = "/signup";
  // final String popRoute;
  // SignUp({required this.popRoute});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin {
  final phonetextController = TextEditingController();
  S? intl;
  late AnimationController fowardController;
  late AnimationController backwardController;
  bool _keyboardVisible = false;
  ScrollController scrollController = ScrollController();

  // loadIntl() async {
  //   Box hive = await Hive.openBox("language");
  //   Language model = hive.getAt(0);
  //   late S temp;
  //   if (model.language == "English") {
  //     temp = await S.delegate.load(Locale("en"));
  //   } else if (model.language == "Marathi") {
  //     temp = await S.delegate.load(Locale("mr"));
  //   } else {
  //     temp = await S.delegate.load(Locale("hi"));
  //   }

  //   WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
  //     setState(() {
  //       intl = temp;
  //     });
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance!.addObserver(this);
    // loadIntl();
    // controller.popRoute = widget.popRoute;
    fowardController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );
    backwardController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );
    fowardController.repeat();
    backwardController.repeat();
  }

  @override
  void dispose() {
    // Get.delete<AuthController>();
    fowardController.dispose();
    backwardController.dispose();
    phonetextController.dispose();
    scrollController.dispose();
    //WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance!.window.viewInsets.bottom;
    final newValue = bottomInset > 0.0;
    print(newValue);
    if (newValue != _keyboardVisible) {
      setState(() {
        _keyboardVisible = newValue;
      });
      scrollController.animateTo(MediaQuery.of(context).size.height,
          duration: Duration(milliseconds: 600), curve: Curves.linearToEaseOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(
              top: context.height * 0.06, bottom: context.height * 0.03),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              tileMode: TileMode.mirror,
              colors: [
                Color(0xFF0044CE),
                Color(0xFF5F0007),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [buildRotatingIcon, buildInputs, buildFooter],
            ),
          ),
        ),
      ),
    );
  }

  Widget get buildRotatingIcon {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        AnimatedBuilder(
          animation: fowardController,
          child: Image.asset(
            "assets/ring.png",
            height: context.width * 0.36,
            width: context.height * 0.36,
            fit: BoxFit.contain,
            scale: 2,
          ),
          builder: (context, child) {
            return Transform.rotate(
                angle: degreesToRadians(360 * fowardController.value),
                child: child);
          },
        ),
        // 17
        AnimatedBuilder(
          animation: fowardController,
          child: Container(
            height: context.height * 0.15,
            width: context.height * 0.15,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: AssetImage("assets/artwork.png"), fit: BoxFit.fill),
            ),
          ),
          builder: (context, child) {
            return Transform.rotate(
                angle: degreesToRadians(360 - (360 * fowardController.value)),
                child: child);
          },
        ),
        // 51.72
        Image.asset(
          "assets/ring_icon.png",
          height: context.height * 0.19,
          width: context.height * 0.19,
          fit: BoxFit.fill,
        )
      ],
    );
  }

  Widget get buildInputs {
    return Column(
      children: [
        Text(
          "Enter Your Phone Number",
          style: ThreeKmTextConstants.tk12PXPoppinsWhiteRegular.copyWith(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
        ),
        space(
          height: 12,
        ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 32),
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 24,
              ),
              Text(
                "+91",
                style: ThreeKmTextConstants.tk14PXPoppinsBlackMedium
                    .copyWith(fontWeight: FontWeight.normal),
              ),
              Transform.rotate(
                angle: -pi / 2,
                child: Container(
                  width: 48,
                  height: 32,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Divider(
                    color: Color(0xFFD5D5D5),
                    thickness: 1,
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: phonetextController,
                  style: ThreeKmTextConstants.tk14PXPoppinsBlackMedium.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                    FilteringTextInputFormatter.deny(RegExp("[\\.|\\,]")),
                  ],
                  decoration: InputDecoration.collapsed(
                    hintText: "1234567890",
                    hintStyle:
                        ThreeKmTextConstants.tk14PXPoppinsBlackMedium.copyWith(
                      fontWeight: FontWeight.normal,
                      color: Color(0xFFD5D5D5),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        space(height: context.height * 0.02),
        Row(
          children: [
            space(width: 32),
            Consumer<SignUpProvider>(builder: (context, model, _) {
              return GestureDetector(
                child: CustomButton(
                  color: ThreeKmTextConstants.blue1,
                  onTap: () async {
                    if (phonetextController.text.length == 10) {
                      String requestJson =
                          json.encode({"phone_no": phonetextController.text});
                      model.checkLogin(
                          requestJson, phonetextController.text, context, true);
                    } else {
                      Fluttertoast.showToast(msg: "Please enter right number.");
                    }
                  },
                  width: 135,
                  height: context.height * 0.06,
                  borderRadius: BorderRadius.circular(26),
                  shadowRadius: BorderRadius.circular(26),
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  child: model.isLoding
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          "Send OTP",
                          style: ThreeKmTextConstants.tk14PXWorkSansWhiteMedium,
                        ),
                ),
              );
            }),
            Spacer(),
            InkWell(
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SignInScreen(
                            phoneNumber: phonetextController.text)));
              },
              child: Text(
                "Login via password",
                style: ThreeKmTextConstants.tk12PXPoppinsWhiteRegular.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            space(width: 32),
          ],
        ),
        space(
          height: context.height * 0.05,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 19),
          child: Divider(
            thickness: 0.5,
            color: Colors.white.withOpacity(0.2),
          ),
        ),
        SizedBox(
          height: context.height * 0.03,
        ),
        InkWell(
          onTap: () {
            context.read<GoogleSignInprovider>().handleSignIn(context);
          },
          child:
              buildLoginButtons("assets/google_icon.png", "Login with Google"),
        ),
        SizedBox(
          height: 16,
        ),
        InkWell(
          onTap: () {
            context.read<FaceAuthProvider>().handleSignIn(context);
          },
          child:
              buildLoginButtons("assets/facebook.png", "Login with Facebook"),
        ),
        SizedBox(
          height: 16,
        ),
        Platform.isIOS
            ? InkWell(
                onTap: () {
                  // controller.facebookSignIn(context);
                },
                child: buildLoginButtons(
                    "assets/facebook.png", "Login with Apple"),
              )
            : Container()
      ],
    );
  }

  Widget buildLoginButtons(String asset, String title) {
    return Container(
      height: context.height * 0.05,
      width: 297,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: Colors.white.withOpacity(0.15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            asset,
            height: context.height * 0.05,
            width: context.height * 0.05,
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: ThreeKmTextConstants.tk14PXPoppinsBlackSemiBold
                  .copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget get buildFooter {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => HelpAndSupport())),
          child: Text(
            "Help and Support",
            style: ThreeKmTextConstants.tk12PXPoppinsWhiteRegular
                .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

extension SizeExtension on BuildContext {
  double get width {
    return MediaQuery.of(this).size.width;
  }

  double get height {
    return MediaQuery.of(this).size.height;
  }
}
