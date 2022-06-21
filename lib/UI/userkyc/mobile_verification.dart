import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threekm/UI/userkyc/user_kyc_main.dart';
import 'package:threekm/providers/auth/signUp_Provider.dart';
import 'package:threekm/providers/userKyc/verify_credential.dart';
import 'package:threekm/utils/constants.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

class MobileVerification extends StatefulWidget {
  const MobileVerification({
    Key? key,
  }) : super(key: key);

  @override
  State<MobileVerification> createState() => _MobileVerificationState();
}

class _MobileVerificationState extends State<MobileVerification> {
  var _focusNodes = List.generate(4, (index) => FocusNode());
  var _controllers = List.generate(4, (index) => TextEditingController());
  TextEditingController phonenumber = TextEditingController();
  bool isSendOtp = false;
  bool isVisibleResendOtp = false;

  Widget get buildPhoneNumber {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 60,
              child: TextFormField(
                initialValue: '+91',
                readOnly: true,
                decoration: const InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
                width: size(context).width / 1.4,
                child: TextFormField(
                  controller: phonenumber,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                    FilteringTextInputFormatter.deny(RegExp("[\\.|\\,]")),
                  ],
                  decoration: const InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                ))
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controllers.forEach((e) => e.dispose());
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var state = context.watch<SignUpProvider>().isLoding;
    var provider = context.read<SignUpProvider>();
    var Kycprovider = context.read<VerifyKYCCredential>();

    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mobile verification',
                style: ThreeKmTextConstants.tk18PXPoppinsBlackMedium,
              ),
              const SizedBox(
                height: 24,
              ),
              LinearProgressIndicator(
                valueColor: const AlwaysStoppedAnimation(Color(0xFF3E7EFF)),
                minHeight: 3,
                color: Colors.amber[400],
                backgroundColor: const Color(0xFFE7E7E7),
                value: 0.1,
                semanticsLabel: 'Linear progress indicator',
              ),
              const SizedBox(
                height: 46,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'Enter your Phone',
                  style: ThreeKmTextConstants.tk18PXPoppinsBlackMedium,
                ),
              ),
              buildPhoneNumber,
              const SizedBox(
                height: 38,
              ),
              if (isSendOtp)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Please Enter 4 Digit OTP ',
                    style: ThreeKmTextConstants.tk16PXPoppinsBlackMedium
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
                ),
              if (isSendOtp)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OtpBox(
                      i: 0,
                      focusNode: _focusNodes,
                      controller: _controllers,
                    ),
                    OtpBox(
                      i: 1,
                      focusNode: _focusNodes,
                      controller: _controllers,
                    ),
                    OtpBox(
                      i: 2,
                      focusNode: _focusNodes,
                      controller: _controllers,
                    ),
                    OtpBox(
                      i: 3,
                      focusNode: _focusNodes,
                      controller: _controllers,
                    ),
                  ],
                ),
              if (Kycprovider.iswrongOTP)
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      'Wrong OTP',
                      style: TextStyle(color: Colors.red[300]),
                    ),
                  ),
                ),
              if (Kycprovider.isTrueOTP)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    children: [
                      Image(image: AssetImage('assets/verified2.png')),
                      Text(
                        '  Your phone number is Verified now',
                        style: ThreeKmTextConstants.tk14PXPoppinsBlackMedium,
                      ),
                    ],
                  ),
                ),
              Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    if (state == false)
                      SizedBox(
                        child: isVisibleResendOtp
                            ? InkWell(
                                onTap: () {
                                  provider
                                      .sendOTP(json.encode(
                                          {"phone_no": phonenumber.text}))
                                      .whenComplete(() => setState(() {
                                            isSendOtp = true;
                                            isVisibleResendOtp = false;
                                          }));
                                },
                                child: Text(
                                  'Resend OTP',
                                  style: ThreeKmTextConstants
                                      .tk16PXPoppinsBlackSemiBold
                                      .copyWith(color: const Color(0xFF979EA4)),
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
                                builder: (BuildContext context, Duration value,
                                    Widget? child) {
                                  final minutes = value.inMinutes;
                                  final seconds = value.inSeconds % 60;
                                  return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text(
                                          'Resend confirmation code  $minutes:$seconds',
                                          textAlign: TextAlign.center,
                                          style: ThreeKmTextConstants
                                              .tk12PXPoppinsBlackSemiBold));
                                }),
                      ),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
                      transitionBuilder: (_, ani) {
                        return ScaleTransition(
                          scale: ani,
                          child: _,
                        );
                      },
                      child: state == false
                          ? Container(
                              key: ValueKey(1),
                              margin: const EdgeInsets.only(top: 20),
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              OutlinedBorder>(
                                          const StadiumBorder())),
                                  onPressed: () async {
                                    SharedPreferences _prefs =
                                        await SharedPreferences.getInstance();
                                    if (isSendOtp) {
                                      var otp = [
                                        _controllers[0].text,
                                        _controllers[1].text,
                                        _controllers[2].text,
                                        _controllers[3].text
                                      ].join();
                                      var res = json.encode({
                                        "phone_no": phonenumber.text,
                                        "otp": otp,
                                        "device": _prefs.getString('deviceID')
                                      });
                                      log(otp);
                                      log(res.toString());
                                      if (otp.length == 4) {
                                        Kycprovider.verifyOTPKYC(
                                            res, phonenumber.text, context);
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Please enter OTP");
                                      }
                                    } else {
                                      provider
                                          .sendOTP(json.encode(
                                              {"phone_no": phonenumber.text}))
                                          .whenComplete(() => setState(() {
                                                isSendOtp = true;
                                                isVisibleResendOtp = false;
                                              }));
                                    }
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (_) =>
                                    //             const EmailVerification()));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      isSendOtp ? "Verify OTP" : 'Send OTP',
                                      style: ThreeKmTextConstants
                                          .tk16PXPoppinsWhiteBold,
                                    ),
                                  )))
                          : Container(
                              key: ValueKey(2),
                              child: const CircularProgressIndicator(),
                            ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
