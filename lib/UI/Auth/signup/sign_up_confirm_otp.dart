import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:threekm/Custom_library/pincodefields.dart';
import 'package:provider/provider.dart';
import 'package:threekm/UI/Auth/sign_in.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/providers/auth/signUp_Provider.dart';
import 'package:threekm/utils/threekm_textstyles.dart';
import 'package:threekm/utils/util_methods.dart';
import 'package:threekm/widgets/custom_button.dart';

import '../../Help_Supportpage.dart';

class SignUpConfirmOTP extends StatefulWidget {
  final String phoneNumber;
  SignUpConfirmOTP({required this.phoneNumber});
  @override
  _SignUpConfirmOTPState createState() => _SignUpConfirmOTPState();
}

class _SignUpConfirmOTPState extends State<SignUpConfirmOTP> {
  final textController = TextEditingController();
  final focusNode = FocusNode();
  String? requestJson;
  //String? phoneNumber;

  bool isVisibleResendOtp = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(top: 100, bottom: 31, left: 24, right: 24),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildControls(widget.phoneNumber),
            isVisibleResendOtp
                ? InkWell(onTap: () {
                    if (true) {
                      String requestJson =
                          json.encode({"phone_no": widget.phoneNumber});
                      context
                          .read<SignUpProvider>()
                          .checkLogin(
                              requestJson, widget.phoneNumber, context, false)
                          .whenComplete(() => setState(() {
                                isVisibleResendOtp = !isVisibleResendOtp;
                              }));
                      CustomSnackBar(context, Text("Sending otp again!"));
                    }
                  }, child: Consumer<SignUpProvider>(
                    builder: (context, _controller, child) {
                      return CustomButton(
                        color: ThreeKmTextConstants.blue1,
                        width: 152,
                        height: 52,
                        borderRadius: BorderRadius.circular(26),
                        shadowRadius: BorderRadius.circular(26),
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        child: _controller.isLoding
                            ? CupertinoActivityIndicator()
                            : Text(
                                "Resend Otp",
                                style: ThreeKmTextConstants
                                    .tk14PXWorkSansWhiteMedium,
                              ),
                      );
                    },
                  ))
                : TweenAnimationBuilder<Duration>(
                    duration: Duration(minutes: 1, seconds: 30),
                    tween: Tween(
                        begin: Duration(minutes: 1, seconds: 30),
                        end: Duration.zero),
                    onEnd: () {
                      print('Timer ended');
                      setState(() {
                        isVisibleResendOtp = true;
                      });
                    },
                    builder:
                        (BuildContext context, Duration value, Widget? child) {
                      final minutes = value.inMinutes;
                      final seconds = value.inSeconds % 60;
                      return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                              'Resend confirmation code  $minutes:$seconds',
                              textAlign: TextAlign.center,
                              style: ThreeKmTextConstants
                                  .tk12PXPoppinsWhiteRegular));
                    }),
            Spacer(),
            buildFooter
          ],
        ),
      ),
    );
  }

  Widget buildControls(phone) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          child: buildText(phone),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        buildSpace(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildOTPTextField(phone),
          ],
        ),
        Consumer<SignUpProvider>(builder: (context, model, _) {
          return model.iswrongOTP
              ? Column(
                  children: [
                    buildSpace(height: 12),
                    Text(
                      "Incorrect OTP",
                      style: ThreeKmTextConstants.tk14PXPoppinsWhiteMedium
                          .copyWith(
                        color: Color(0xFFFF5858),
                      ),
                    )
                  ],
                )
              : Container();
        }),
        buildSpace(height: 24),
        requestJson != null
            ? CustomButton(
                color: ThreeKmTextConstants.blue1,
                width: 152,
                height: 52,
                borderRadius: BorderRadius.circular(26),
                shadowRadius: BorderRadius.circular(26),
                shadowColor: Colors.transparent,
                elevation: 0,
                onTap: () async {
                  if (requestJson != null) {
                    context
                        .read<SignUpProvider>()
                        .verifyOTP(requestJson, phone, context);
                  }
                },
                child: Text(
                  "Submit OTP",
                  style: ThreeKmTextConstants.tk14PXWorkSansWhiteMedium,
                ),
              )
            : Container(),
        buildSpace(height: 40),
      ],
    );
  }

  Widget get buildFooter {
    return Column(
      children: [
        Divider(
          thickness: 0.5,
          color: Colors.white.withOpacity(0.2),
        ),
        space(height: 14),
        GestureDetector(
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignInScreen())),
          child: Container(
            height: 48,
            width: 297,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Text(
                "Login Via Password",
                style: ThreeKmTextConstants.tk14PXPoppinsBlackMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        space(height: 24),
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

  Widget buildOTPTextField(phone) {
    return Container(
      //width: MediaQuery.of(context).size.width * 0.65,
      child: PinCodeTextField(
        pinTextStyle: TextStyle(color: Colors.black),
        controller: textController,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        pinBoxHeight: 56,
        pinBoxWidth: 48,
        onTextChanged: (val) {},
        onDone: (otp) async {
          var deviceId;
          DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
          if (Platform.isAndroid) {
            await deviceInfo.androidInfo.then((value) {
              deviceId = value.androidId;
            });
          } else if (Platform.isIOS) {
            await deviceInfo.iosInfo.then((value) {
              deviceId = value.identifierForVendor;
            });
          }
          requestJson = json.encode(
              {"phone_no": phone, "otp": otp, "device": deviceId ?? ""});
          context.read<SignUpProvider>().verifyOTP(requestJson, phone, context);
        },
        maxLength: 4,
        autofocus: true,
        pinBoxColor: Color(0xFFF4F3F8),
        errorBorderColor: Colors.red,
        defaultBorderColor: Colors.green,
        hasError: context.watch<SignUpProvider>().iswrongOTP,
      ),
    );
  }
}

Widget buildSpace({double? width, double? height}) {
  return SizedBox(
    width: width,
    height: height,
  );
}

buildText(number) {
  return RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      text: "A 4-digit OTP has been sent to $number via SMS. ",
      style: ThreeKmTextConstants.tk14PXPoppinsBlackSemiBold
          .copyWith(color: Colors.white),
      children: [
        TextSpan(
          text: "Change Phone Number",
          style: ThreeKmTextConstants.tk14PXPoppinsBlackSemiBold.copyWith(
              color: Color(0xFF3AACFF), decoration: TextDecoration.underline),
        ),
      ],
    ),
  );
}
