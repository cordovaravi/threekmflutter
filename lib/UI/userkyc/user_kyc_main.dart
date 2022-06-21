import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:threekm/UI/userkyc/mobile_verification.dart';

class UserKycMain extends StatefulWidget {
  const UserKycMain({Key? key}) : super(key: key);

  @override
  State<UserKycMain> createState() => _UserKycMainState();
}

class _UserKycMainState extends State<UserKycMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: VerifyAccount(),
      body: MobileVerification(),
    );
  }
}

class OtpBox extends StatelessWidget {
  const OtpBox({
    Key? key,
    required this.i,
    required this.focusNode,
    required this.controller,
  }) : super(key: key);
  final int i;
  final List<FocusNode> focusNode;
  final List<TextEditingController> controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 75,
      child: TextFormField(
          controller: controller[i],
          focusNode: focusNode[i],
          maxLength: 1,
          inputFormatters: [
            LengthLimitingTextInputFormatter(10),
            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
            FilteringTextInputFormatter.deny(RegExp("[\\.|\\,]")),
          ],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          //readOnly: true,
          decoration: const InputDecoration(
            counterText: "",
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
          ),
          maxLines: 1,
          textInputAction: TextInputAction.next,
          onChanged: (text) {
            print('$i----------- $text');

            if (text.isEmpty) {
              i == 0 ? null : focusNode[i - 1].requestFocus();
            } else {
              i == 3
                  ? FocusScope.of(context).unfocus()
                  : focusNode[i + 1].requestFocus();
            }

            // FocusScope.of(context).requestFocus(focusNode[i + 1]);
          }),
    );
  }
}
