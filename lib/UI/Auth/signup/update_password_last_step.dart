import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:threekm/providers/auth/Forgetpassword_provider.dart';
import 'package:threekm/utils/spacings.dart';
import 'package:threekm/utils/threekm_textstyles.dart';
import 'package:threekm/widgets/custom_button.dart';

class UpdatePasswordLastSteps extends StatefulWidget {
  final String phoneNumber;
  final String otp;
  UpdatePasswordLastSteps({required this.otp, required this.phoneNumber});
  @override
  _UpdatePasswordLastStepsState createState() =>
      _UpdatePasswordLastStepsState();
}

class _UpdatePasswordLastStepsState extends State<UpdatePasswordLastSteps> {
  bool valid = false;
  bool fnameValid = false;
  bool lnameValid = false;
  bool passwordNotVisible = true;
  bool passwordNotVisible2 = true;
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final passwordController2 = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    passwordController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                "assets/background-image.png",
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.51,
              padding: EdgeInsets.only(left: 24, right: 24, top: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Yay! Last step!",
                    style: ThreeKmTextConstants.tk40PXWorkSansBoldBlack,
                  ),
                  //verticalSpacing(height: 29),

                  verticalSpacing(height: 16),
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: passwordNotVisible,
                          decoration: InputDecoration(
                              fillColor: ThreeKmTextConstants.white,
                              border: OutlineInputBorder(),
                              hintText: "Create password",
                              suffixIcon: GestureDetector(
                                onTap: () => setState(() =>
                                    passwordNotVisible = !passwordNotVisible),
                                child: Icon(
                                  passwordNotVisible
                                      ? FeatherIcons.eyeOff
                                      : FeatherIcons.eye,
                                  color: !passwordNotVisible
                                      ? ThreeKmTextConstants.blue1
                                      : Colors.black54,
                                ),
                              ),
                              hintStyle:
                                  ThreeKmTextConstants.tk14PXLatoGreyRegular),
                          controller: passwordController,
                          style: ThreeKmTextConstants.tk14PXLatoBlackRegular,
                          validator: (String? val) {
                            if (val!.isEmpty || val == null) {
                              return "Password  is empty";
                            } else if (val.length < 6) {
                              return "Password is too short.";
                            } else if (val.contains(" ")) {
                              return "Space is not allowed";
                            }
                          },
                        ),
                        verticalSpacing(height: 16),
                        TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: passwordNotVisible2,
                          decoration: InputDecoration(
                              fillColor: ThreeKmTextConstants.white,
                              border: OutlineInputBorder(),
                              hintText: "Confirm password",
                              suffixIcon: GestureDetector(
                                onTap: () => setState(() =>
                                    passwordNotVisible2 = !passwordNotVisible2),
                                child: Icon(
                                  passwordNotVisible2
                                      ? FeatherIcons.eyeOff
                                      : FeatherIcons.eye,
                                  color: !passwordNotVisible
                                      ? ThreeKmTextConstants.blue1
                                      : Colors.black54,
                                ),
                              ),
                              hintStyle:
                                  ThreeKmTextConstants.tk14PXLatoGreyRegular),
                          controller: passwordController2,
                          style: ThreeKmTextConstants.tk14PXLatoBlackRegular,
                          validator: (val) {
                            if (val!.isEmpty || val == null) {
                              return "Password  is empty";
                            } else if (val.length < 6) {
                              return "Password is too short.";
                            } else if (val != passwordController.text) {
                              return "Password Missmatch";
                            } else if (val.contains(" ")) {
                              return "Space is not allowed";
                            }
                          },
                        ),
                        verticalSpacing(height: 16),
                      ],
                    ),
                  ),
                  CustomButton(
                    color: ThreeKmTextConstants.blue1,
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        //update password flow
                        String requestJson = json.encode({
                          "phone_no": widget.phoneNumber,
                          "otp": widget.otp,
                          "password": passwordController.text
                        });
                        context
                            .read<ForgetPasswordProvider>()
                            .updatePassword(requestJson, context);
                      } else {
                        Fluttertoast.showToast(msg: "Please Enter Password");
                      }
                    },
                    width: 160,
                    height: 48,
                    borderRadius: BorderRadius.circular(5),
                    child: Text(
                      "Update password",
                      style: ThreeKmTextConstants.tk14PXWorkSansWhiteMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
