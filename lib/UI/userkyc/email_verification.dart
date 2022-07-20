import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threekm/UI/main/navigation.dart';
import 'package:threekm/UI/userkyc/profile_picture.dart';
import 'package:threekm/UI/userkyc/user_kyc_main.dart';

import 'package:threekm/providers/userKyc/verify_credential.dart';
import 'package:threekm/utils/constants.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({
    Key? key,
  }) : super(key: key);

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  var _focusNodes = List.generate(4, (index) => FocusNode());
  var _controllers = List.generate(4, (index) => TextEditingController());
  bool isValidEmail = false;
  bool isSendOtp = false;
  bool isVisibleResendOtp = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _otpController = TextEditingController();
  SharedPreferences? _pref;
  RegExp emailExp = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

  validEmail() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        isValidEmail = false;
      });
    });
  }

  Widget buildEmail({required TextEditingController emailController}) {
    // return Consumer<ProfileInfoProvider>(builder: (context, controller, _) {
    return SizedBox(
      width: size(context).width,
      // height: 50,

      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        // focusNode: _controller.node,
        controller: emailController,
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.top,
        maxLines: 1,
        decoration: const InputDecoration(
          hintText: 'email@address.com',
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
        onFieldSubmitted: (val) {
          FocusScope.of(context).unfocus();
          if (val.isNotEmpty && val.contains(".") && val.contains("@")) {
            print("save");
            //   controller.updateProfileInfo(email: emailController.text);
          }
        },

        // style: GoogleFonts.poppins(
        //   fontSize: 16,
        //   color: Color(0xFF0F0F2D),
        //   fontWeight: FontWeight.normal,
        // ),
        validator: (val) {
          log(emailExp.hasMatch(val.toString()).toString());
          if (val!.isEmpty) {
            validEmail();
            return "Email is empty";
          } else if (!emailExp.hasMatch(val)) {
            validEmail();
            return "Please enter valid Email";
          } else {
            if (!isValidEmail)
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                setState(() {
                  isValidEmail = true;
                });
              });
          }
        },
      ),
    );
    // });
  }

  @override
  void initState() {
    context.read<VerifyKYCCredential>().disposeAllData(mounted);
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      _pref = await SharedPreferences.getInstance();
      _emailController.text = _pref?.getString("email") != null &&
              _pref?.getString("email").toString() != "bulbandkey@gmail.com"
          ? _pref?.getString("email") ?? ""
          : "";
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controllers.forEach((e) => e.dispose());
    _emailController.dispose();
    // context.read<VerifyKYCCredential>().disposeAllData(mounted);
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var Kycprovider = context.watch<VerifyKYCCredential>();
    var state = Kycprovider.isLoding;
    var verifyotpfn = () async {
      log('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
      var otp = [
        _controllers[0].text,
        _controllers[1].text,
        _controllers[2].text,
        _controllers[3].text
      ].join();
      if (otp.length == 4) {
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        if (isSendOtp) {
          var res = json.encode({
            "email": _emailController.text,
            "otp": otp,
            "device": _prefs.getString('deviceID')
          });
          log(otp);
          log(res.toString());

          Kycprovider.verifyEmailOTPKYC(res, _emailController.text, context);
        }
      }
      // var otp = _otpController.text;
      // if (otp.length == 10) {
      //   SharedPreferences _prefs = await SharedPreferences.getInstance();
      //   if (isSendOtp) {
      //     // var otp = [
      //     //   _controllers[0].text,
      //     //   _controllers[1].text,
      //     //   _controllers[2].text,
      //     //   _controllers[3].text
      //     // ].join();

      //     var res = json.encode({
      //       "email": _emailController.text,
      //       "otp": otp,
      //       "device": _prefs.getString('deviceID')
      //     });

      //     Kycprovider.verifyEmailOTPKYC(res, _emailController.text, context);
      //   }
      // }
    };
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
                'Step 2/6',
                style: ThreeKmTextConstants.tk18PXPoppinsBlackMedium,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Email verification',
                    style: ThreeKmTextConstants.tk18PXPoppinsBlackMedium,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => TabBarNavigation(
                                    bottomIndex: 3,
                                  )),
                          (route) => false);
                    },
                    child: Text(
                      'Cancel',
                      style: ThreeKmTextConstants.tk18PXPoppinsBlackMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              LinearProgressIndicator(
                valueColor: const AlwaysStoppedAnimation(Color(0xFF3E7EFF)),
                minHeight: 3,
                color: Colors.amber[400],
                backgroundColor: Color(0xFFE7E7E7),
                value: 0.2,
                semanticsLabel: 'Linear progress indicator',
              ),
              const SizedBox(
                height: 46,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'Enter your email',
                  style: ThreeKmTextConstants.tk18PXPoppinsBlackMedium,
                ),
              ),
              buildEmail(emailController: _emailController),
              const SizedBox(
                height: 38,
              ),
              if (isSendOtp)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Please Enter OTP ',
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
                        onChange: verifyotpfn),
                    OtpBox(
                        i: 2,
                        focusNode: _focusNodes,
                        controller: _controllers,
                        onChange: verifyotpfn),
                    OtpBox(
                        i: 3,
                        focusNode: _focusNodes,
                        controller: _controllers,
                        onChange: verifyotpfn),
                  ],
                ),
              // if (isSendOtp)
              //   TextFormField(
              //     controller: _otpController,
              //     textAlign: TextAlign.start,
              //     textAlignVertical: TextAlignVertical.top,
              //     maxLines: 1,
              //     onChanged: (i) {
              //       verifyEmail();
              //     },
              //     decoration: const InputDecoration(
              //       filled: true,
              //       border: OutlineInputBorder(
              //         borderSide: BorderSide.none,
              //         borderRadius: BorderRadius.all(Radius.circular(8.0)),
              //       ),
              //     ),
              //   ),
              if (Kycprovider.iswrongOTP)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    'Incorrect OTP',
                    style: TextStyle(color: Colors.red[300]),
                  ),
                ),
              if (Kycprovider.isTrueOTP)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    children: [
                      Image(image: AssetImage('assets/verified2.png')),
                      Text(
                        '  Your email is Verified now',
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
                    if (state == false && isSendOtp && !Kycprovider.isTrueOTP)
                      SizedBox(
                        child: isVisibleResendOtp
                            ? InkWell(
                                onTap: () {
                                  Kycprovider.sendOtpEmail(json.encode(
                                          {"email": _emailController.text}))
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
                                          'Resend OTP  $minutes:$seconds',
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
                          ? !Kycprovider.isTrueOTP && !isSendOtp
                              ? Container(
                                  key: ValueKey(1),
                                  margin: const EdgeInsets.only(top: 20),
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  OutlinedBorder>(
                                              const StadiumBorder())),
                                      onPressed: isValidEmail
                                          ? () async {
                                              if (!isSendOtp) {
                                                if (_emailController
                                                    .text.isNotEmpty) {
                                                  Kycprovider.sendOtpEmail(json
                                                      .encode({
                                                    "email":
                                                        _emailController.text
                                                  })).whenComplete(
                                                      () => setState(() {
                                                            isSendOtp = true;
                                                            isVisibleResendOtp =
                                                                false;
                                                          }));
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Please enter your Email");
                                                }
                                              }
                                              if (Kycprovider.isTrueOTP)
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            const UploadProfilePicture()));
                                            }
                                          : null,
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          isSendOtp ? "Next" : 'Send OTP',
                                          style: ThreeKmTextConstants
                                              .tk16PXPoppinsWhiteBold,
                                        ),
                                      )))
                              : SizedBox()
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
