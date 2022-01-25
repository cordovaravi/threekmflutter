import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:threekm/Custom_library/pincodefields.dart';
import 'package:threekm/UI/Auth/signup/update_password_last_step.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/providers/auth/Forgetpassword_provider.dart';
import 'package:threekm/utils/threekm_textstyles.dart';
import 'package:threekm/utils/util_methods.dart';
import 'package:threekm/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  final String? number;
  ForgotPassword({this.number, Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final focus1 = FocusNode();
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool passwordVisible = false;
  final focus2 = FocusNode();
  int index = 1;
  String stepText = "Step 1/2";
  String? otpPin;
  bool visibleresendOTP = true;

  // initTimer() {
  //   controller.time.value = 0;
  //   timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
  //     if (controller.time.value == 120) {
  //       timer.cancel();
  //     } else {
  //       controller.updateText();
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();
    //initTimer();
    if (widget.number != null) {
      setState(() {
        phoneController.text = widget.number.toString();
      });
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    focus2.dispose();
    focus1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        //controller.resetForgotPassword();
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: Text(
            "Reset your Password".toUpperCase(),
            style: ThreeKmTextConstants.tk16PXPoppinsWhiteBold,
          ),
          backgroundColor: Color(0xFF0044CE),
          elevation: 0,
          centerTitle: false,
        ),
        body: Stack(
          children: [
            buildAppBar(context),
            Container(
              margin: EdgeInsets.only(top: 80, left: 18, right: 19),
              width: double.infinity,
              height: //_controller.index == 1 ? 303 :
                  418,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Column(
                children: [
                  space(height: 32),
                  Text(
                    stepText,
                    style: ThreeKmTextConstants.tk14PXPoppinsBlackMedium
                        .copyWith(fontWeight: FontWeight.normal),
                  ),
                  if (index == 1) ...{
                    space(height: 40),
                    Text(
                      "Enter Your Phone Number",
                      style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold,
                    ),
                    space(height: 12),
                    buildTextField,
                    space(height: 16),
                    CustomButton(
                      width: 135,
                      height: 52,
                      onTap: () {
                        if (phoneController.text.length == 10) {
                          String requestJson =
                              json.encode({"phone_no": phoneController.text});
                          context
                              .read<ForgetPasswordProvider>()
                              .forgetPassword(requestJson)
                              .then((value) {
                            setState(() {
                              index = 2;
                              stepText = "Step 2/2";
                            });
                          });
                        } else {
                          CustomSnackBar(context, Text("Please enter number"));
                        }
                      },
                      borderRadius: BorderRadius.circular(26),
                      elevation: 0,
                      child: Text(
                        "Send OTP",
                        style: ThreeKmTextConstants.tk14PXPoppinsBlackBold
                            .copyWith(color: Colors.white),
                      ),
                      color: Colors.blue,
                    ),
                  } else if (index == 2) ...{
                    space(height: 20),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 26),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text:
                              "A 4-digit OTP has been sent to ${phoneController.text}  via SMS. ",
                          style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold
                              .copyWith(fontSize: 14),
                          children: [
                            TextSpan(
                                text: "Change Phone Number",
                                style: ThreeKmTextConstants
                                    .tk16PXPoppinsBlackSemiBold
                                    .copyWith(
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                  color: Color(0xFF3AACFF),
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    setState(() {
                                      index = 1;
                                    });
                                  }),
                          ],
                        ),
                      ),
                    ),
                    space(height: 32),
                    buildOTPTextField(),
                    space(height: 24),
                    CustomButton(
                      width: 152,
                      height: 52,
                      onTap: () async {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => UpdatePasswordLastSteps(
                        //             otp: otpPin!,
                        //             phoneNumber: phoneController.text)));
                      },
                      borderRadius: BorderRadius.circular(26),
                      elevation: 0,
                      child: Text(
                        "Submit OTP",
                        style: ThreeKmTextConstants.tk14PXPoppinsBlackBold
                            .copyWith(color: Colors.white),
                      ),
                      color: Colors.blue,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    visibleresendOTP
                        ? TweenAnimationBuilder<Duration>(
                            duration: Duration(minutes: 1, seconds: 30),
                            tween: Tween(
                                begin: Duration(minutes: 1, seconds: 30),
                                end: Duration.zero),
                            onEnd: () {
                              String requestJson = json
                                  .encode({"phone_no": phoneController.text});
                              context
                                  .read<ForgetPasswordProvider>()
                                  .forgetPassword(requestJson)
                                  .whenComplete(() => setState(() {
                                        visibleresendOTP = false;
                                      }));
                              CustomSnackBar(
                                  context,
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Text("Sending OTP."),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: Container(
                                          height: 10,
                                          width: 10,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      )
                                    ],
                                  ));
                            },
                            builder: (BuildContext context, Duration value,
                                Widget? child) {
                              final minutes = value.inMinutes;
                              final seconds = value.inSeconds % 60;
                              return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                      'Resending OTP in ($minutes: $seconds)',
                                      textAlign: TextAlign.center,
                                      style: ThreeKmTextConstants
                                          .tk12PXPoppinsBlackSemiBold));
                            },
                          )
                        : Container()
                    //space(height: 32),
                  },
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildAppBar(context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
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
    );
  }

  // Widget buildCard(context) {
  //   return ;
  // }

  Widget get buildTextField {
    return Container(
      width: double.infinity,
      height: 48,
      margin: EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
        color: Color(0xFFF4F3F8),
        border: Border.all(color: Color(0xFFD5D5D5), width: 1),
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
              controller: phoneController,
              style: ThreeKmTextConstants.tk14PXPoppinsBlackMedium.copyWith(
                fontWeight: FontWeight.normal,
              ),
              focusNode: focus1,
              onTap: () {
                print("focus");
                focus1.requestFocus();
              },
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                FilteringTextInputFormatter.deny(RegExp("[\\.|\\,]")),
              ],
              keyboardType: TextInputType.number,
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
    );
  }

  Widget buildOTPTextField() {
    return Container(
      child: PinCodeTextField(
        pinTextStyle: TextStyle(color: Colors.black),
        maxLength: 4,
        autofocus: true,
        pinBoxColor: Color(0xFFF4F3F8),
        errorBorderColor: Colors.red,
        defaultBorderColor: Colors.green,
        controller: otpController,
        focusNode: focus2,
        keyboardType: TextInputType.number,
        hasError: context.watch<ForgetPasswordProvider>().isOTPWrong!,
        onDone: (otp) {
          setState(() {
            otpPin = otp.toString();
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UpdatePasswordLastSteps(
                      otp: otp, phoneNumber: phoneController.text)));
        },
      ),
    );
  }
}
