import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:threekm/providers/auth/signUp_Provider.dart';
import 'package:threekm/utils/intl.dart';
import 'package:threekm/utils/spacings.dart';
import 'package:threekm/utils/threekm_textstyles.dart';
import 'package:threekm/widgets/custom_button.dart';
import 'package:threekm/widgets/text_field.dart';

class SignUpConfirmLastSteps extends StatefulWidget {
  final String phoneNumber;
  SignUpConfirmLastSteps({required this.phoneNumber});
  @override
  _SignUpConfirmLastStepsState createState() => _SignUpConfirmLastStepsState();
}

class _SignUpConfirmLastStepsState extends State<SignUpConfirmLastSteps> {
  S? intl;
  bool valid = false;
  bool? fnameValid;
  bool lnameValid = false;
  bool passwordNotVisible = true;
  bool passwordNotVisible2 = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController? _firstNameController = TextEditingController();
  final TextEditingController? _lastNameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordController2 = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController!.dispose();
    _lastNameController!.dispose();
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
              height: MediaQuery.of(context).size.height * 0.61,
              padding: EdgeInsets.only(left: 24, right: 24, top: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Yay! Last step!",
                      style: ThreeKmTextConstants.tk40PXWorkSansBoldBlack,
                    ),
                    verticalSpacing(height: 29),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.name,
                            maxLines: 1,
                            decoration: InputDecoration(
                                fillColor: ThreeKmTextConstants.white,
                                border: OutlineInputBorder(),
                                hintText: "Enter first name",
                                hintStyle:
                                    ThreeKmTextConstants.tk14PXLatoGreyRegular),
                            controller: _firstNameController,
                            style: ThreeKmTextConstants.tk14PXLatoBlackRegular,
                            validator: (String? val) {
                              if (val!.isEmpty || val == null) {
                                return "First name is empty";
                              } else if (val.length < 3) {
                                return "Please enter valid name";
                              } else if (val.contains(" ")) {
                                return "Space is not allowed";
                              } else if (val.contains(".")) {
                                return "Please enter valid name";
                              }
                            },
                          ),
                        ),
                        horizontalSpacing(width: 16),
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.name,
                            maxLines: 1,
                            decoration: InputDecoration(
                                fillColor: ThreeKmTextConstants.white,
                                border: OutlineInputBorder(),
                                hintText: "Enter last name",
                                hintStyle:
                                    ThreeKmTextConstants.tk14PXLatoGreyRegular),
                            controller: _lastNameController,
                            style: ThreeKmTextConstants.tk14PXLatoBlackRegular,
                            validator: (String? val) {
                              if (val!.isEmpty || val == null) {
                                return "last name is empty";
                              } else if (val.length < 3) {
                                return "Please enter valid surename";
                              } else if (val.contains(" ")) {
                                return "Space is not allowed";
                              } else if (val.contains(".")) {
                                return "Please enter valid name";
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    verticalSpacing(height: 16),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: passwordNotVisible,
                      decoration: InputDecoration(
                          fillColor: ThreeKmTextConstants.white,
                          border: OutlineInputBorder(),
                          hintText: "Create password",
                          suffixIcon: GestureDetector(
                            onTap: () => setState(
                                () => passwordNotVisible = !passwordNotVisible),
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
                    // Form(
                    //   key: _formKey,
                    //   autovalidateMode: AutovalidateMode.onUserInteraction,
                    //   onChanged: () {
                    //     setState(() {
                    //       if (passwordController2.text ==
                    //           passwordController.text) {
                    //         valid = true;
                    //       } else {
                    //         valid = false;
                    //       }
                    //     });
                    //   },
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       CustomTextField(
                    //         border: true,
                    //         password: passwordNotVisible,
                    //         valid: valid,
                    //         maxLines: passwordNotVisible ? 1 : null,
                    //         controller: passwordController,
                    //         suffix: GestureDetector(
                    //           onTap: () => setState(
                    //               () => passwordNotVisible = !passwordNotVisible),
                    //           child: Icon(
                    //             passwordNotVisible
                    //                 ? FeatherIcons.eye
                    //                 : FeatherIcons.eyeOff,
                    //             color: !passwordNotVisible
                    //                 ? ThreeKmTextConstants.blue1
                    //                 : Colors.black54,
                    //           ),
                    //         ),
                    //         fillColor: ThreeKmTextConstants.white,
                    //         height: 54,
                    //         hint: "Create Password",
                    //         hintStyle: ThreeKmTextConstants.tk14PXLatoGreyRegular,
                    //         style: ThreeKmTextConstants.tk14PXLatoBlackRegular,
                    //         borderRadius: 5,
                    //       ),
                    //       Visibility(
                    //         visible: !valid,
                    //         child: Text(
                    //           "Passwords do not match",
                    //           style: ThreeKmTextConstants.tk14PXLatoGreyRegular
                    //               .copyWith(color: ThreeKmTextConstants.red1),
                    //         ),
                    //       ),
                    //       verticalSpacing(height: 16),
                    //       CustomTextField(
                    //         border: true,
                    //         maxLines: passwordNotVisible2 ? 1 : null,
                    //         valid: valid,
                    //         fillColor: ThreeKmTextConstants.white,
                    //         password: passwordNotVisible2,
                    //         suffix: IconButton(
                    //           icon: Icon(
                    //             passwordNotVisible2
                    //                 ? FeatherIcons.eye
                    //                 : FeatherIcons.eyeOff,
                    //             color: !passwordNotVisible2
                    //                 ? ThreeKmTextConstants.blue1
                    //                 : Colors.black54,
                    //           ),
                    //           onPressed: () => setState(() =>
                    //               passwordNotVisible2 = !passwordNotVisible2),
                    //         ),
                    //         controller: passwordController2,
                    //         height: 54,
                    //         hint: "Confirm Password",
                    //         hintStyle: ThreeKmTextConstants.tk14PXLatoGreyRegular,
                    //         style: ThreeKmTextConstants.tk14PXLatoBlackRegular,
                    //         borderRadius: 5,
                    //       ),
                    //       Visibility(
                    //         visible: !valid,
                    //         child: Text(
                    //           "Passwords do not match",
                    //           style: ThreeKmTextConstants.tk14PXLatoGreyRegular
                    //               .copyWith(color: ThreeKmTextConstants.red1),
                    //         ),
                    //       ),
                    //       verticalSpacing(height: 16),
                    //     ],
                    //   ),
                    // ),
                    CustomButton(
                      color: ThreeKmTextConstants.blue1,
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          // register Flow
                          String requestJson = json.encode({
                            "firstname": _firstNameController!.text,
                            "lastname": _lastNameController!.text,
                            "phone_no": widget.phoneNumber,
                            "password": passwordController.text
                          });
                          print(requestJson);
                          context
                              .read<SignUpProvider>()
                              .registerUser(requestJson, context);
                        } else {
                          Fluttertoast.showToast(
                              msg: "Please Validate Above Fileds");
                        }
                      },
                      width: 120,
                      height: 48,
                      borderRadius: BorderRadius.circular(5),
                      child: Text(
                        "Next",
                        style: ThreeKmTextConstants.tk14PXWorkSansWhiteMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
