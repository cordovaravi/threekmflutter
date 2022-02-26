import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threekm/UI/Auth/signup/forgot_password.dart';
import 'package:threekm/providers/auth/signIn_Provider.dart';
import 'package:threekm/providers/localization_Provider/AppLocaliztion.dart';
import 'package:threekm/utils/constants.dart';
import 'package:threekm/utils/intl.dart';
import 'package:threekm/utils/spacings.dart';
import 'package:threekm/utils/threekm_textstyles.dart';
import 'package:threekm/utils/util_methods.dart';
import 'package:threekm/widgets/custom_button.dart';
import 'package:provider/provider.dart';

import '../Help_Supportpage.dart';

class SignInScreen extends StatefulWidget {
  final String? phoneNumber;
  SignInScreen({this.phoneNumber});
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  S? intl;
  bool valid = false;
  bool passwordNotVisible = true;
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final focus1 = FocusNode();
  final focus2 = FocusNode();

  Widget buildCloseButton({VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(12.68),
        child: Icon(Icons.close),
      ),
    );
  }

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
    getPhoneNumber();
    if (widget.phoneNumber != null) {
      setState(() {
        _phoneController.text = widget.phoneNumber.toString();
      });
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    focus1.dispose();
    focus2.dispose();
    super.dispose();
  }

  void getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    final phoneNumber = prefs.getString(PHONE_NUMBER);
    if (phoneNumber == null) {
      print("Phone number is null");
      return;
    }
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      setState(() {
        _phoneController.text = phoneNumber;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(top: 32, bottom: 31),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: Navigator.of(context).pop,
                    )
                  ],
                ),
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        verticalSpacing(height: 24),
                        Text(
                          AppLocalizations.of(context)
                                  ?.translate("phone_number") ??
                              "Enter Your Phone Number",
                          style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold
                              .copyWith(color: Colors.white),
                        ),
                        verticalSpacing(height: 12),
                        Container(
                          width: double.infinity,
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
                                style: ThreeKmTextConstants
                                    .tk14PXPoppinsBlackMedium
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
                                  controller: _phoneController,
                                  style: ThreeKmTextConstants
                                      .tk14PXPoppinsBlackMedium
                                      .copyWith(
                                    fontWeight: FontWeight.normal,
                                  ),
                                  focusNode: focus1,
                                  onTap: () {
                                    print("focus");
                                    focus1.requestFocus();
                                  },
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10),
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[0-9]")),
                                    FilteringTextInputFormatter.deny(
                                        RegExp("[\\.|\\,]")),
                                  ],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration.collapsed(
                                    hintText: "1234567890",
                                    hintStyle: ThreeKmTextConstants
                                        .tk14PXPoppinsBlackMedium
                                        .copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xFFD5D5D5),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        verticalSpacing(height: 40),
                        Text(
                          "Enter Your Password",
                          style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold
                              .copyWith(color: Colors.white),
                        ),
                        verticalSpacing(height: 12),
                        Container(
                          width: double.infinity,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            children: [
                              space(width: 24),
                              Expanded(
                                child: TextField(
                                  obscureText: passwordNotVisible,
                                  obscuringCharacter: "*",
                                  controller: _passwordController,
                                  style: ThreeKmTextConstants
                                      .tk14PXPoppinsBlackMedium
                                      .copyWith(
                                    fontWeight: FontWeight.normal,
                                  ),
                                  focusNode: focus2,
                                  onTap: () {
                                    print("focus");
                                    focus2.requestFocus();
                                  },
                                  decoration: InputDecoration.collapsed(
                                    hintText: "Password",
                                    hintStyle: ThreeKmTextConstants
                                        .tk14PXPoppinsBlackMedium
                                        .copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xFFD5D5D5),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  passwordNotVisible
                                      ? Icons.remove_red_eye_outlined
                                      : Icons.remove_red_eye,
                                  color: passwordNotVisible
                                      ? Colors.grey.withOpacity(0.3)
                                      : Colors.blue,
                                ),
                                onPressed: () {
                                  setState(() =>
                                      passwordNotVisible = !passwordNotVisible);
                                },
                              )
                            ],
                          ),
                        ),
                        verticalSpacing(height: 24),
                        CustomButton(
                          color: ThreeKmTextConstants.blue1,
                          onTap: () async {
                            if (_phoneController.text.length == 10 &&
                                _passwordController.text.isNotEmpty) {
                              String requestJson = json.encode({
                                "phone_no": _phoneController.text,
                                "password": _passwordController.text
                              });
                              context
                                  .read<SignInProvider>()
                                  .loginWithPassword(requestJson, context);
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Please Provide credentials");
                            }
                            focus1.unfocus();
                            focus2.unfocus();
                            // bool navigate = await _controller.logIn(
                            //     phoneNo: phoneController.text,
                            //     password: passwordController.text);
                            // if (navigate) {
                            //   print(controller.popRoute);
                            //   loginNavigateBack(context);
                            // }
                          },
                          width: 105,
                          height: 52,
                          elevation: 0,
                          borderRadius: BorderRadius.circular(26),
                          child:
                              //  _controller.loading
                              //     ? Center(
                              //         child: CircularProgressIndicator(
                              //           valueColor: AlwaysStoppedAnimation<Color>(
                              //               Colors.white),
                              //         ),
                              //       )
                              //     :
                              Text(
                            "Login",
                            style:
                                ThreeKmTextConstants.tk14PXWorkSansWhiteMedium,
                          ),
                        ),
                        space(height: 16),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (conext) => ForgotPassword(
                                          number: widget.phoneNumber,
                                        )));
                          },
                          child: Container(
                            height: 48,
                            width: MediaQuery.of(context).size.width * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.white.withOpacity(0.25),
                            ),
                            child: Center(
                              child: Text(
                                "Forgot Password",
                                style: ThreeKmTextConstants
                                    .tk14PXPoppinsBlackMedium
                                    .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          // : Container(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 12,
            right: 0,
            left: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HelpAndSupport())),
                      child: Text(
                        "Help and Support",
                        style: ThreeKmTextConstants.tk12PXPoppinsWhiteRegular
                            .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                      ),
                    ),
                    space(width: 16),
                    Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                    space(width: 16),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Text(
                        "Login via OTP",
                        style: ThreeKmTextConstants.tk12PXPoppinsWhiteRegular
                            .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              child: Container(
                width: double.infinity,
                height: 375,
              ),
            ),
          )
        ],
      ),
    );
  }
}
