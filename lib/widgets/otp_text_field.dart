// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';
// import 'package:sms_autofill/sms_autofill.dart';
// import 'package:threekm/models/auth_controller.dart';
// import 'package:threekm/models/profile_controller.dart';
// import 'package:threekm/utils/threekm_textstyles.dart';

// class OTPTextField extends StatefulWidget {
//   final Color? fillColor;
//   final Color? borderColor;
//   final double? borderRadius;
//   final FocusNode? node1;
//   final FocusNode? node2;
//   final FocusNode? node3;
//   final FocusNode? node4;
//   final TextEditingController? controller1;
//   final TextEditingController? controller2;
//   final TextEditingController? controller3;
//   final TextEditingController? controller4;
//   final TextStyle? style;
//   final double? height;
//   final double? width;
//   final double? textFieldWidth;

//   OTPTextField(
//       {this.fillColor,
//       this.borderRadius,
//       this.style,
//       this.node1,
//       this.height,
//       this.width,
//       this.textFieldWidth,
//       this.controller1,
//       this.node2,
//       this.node3,
//       this.node4,
//       this.controller2,
//       this.controller3,
//       this.controller4,
//       this.borderColor});

//   @override
//   _OTPTextFieldState createState() => _OTPTextFieldState();
// }

// class _OTPTextFieldState extends State<OTPTextField> with CodeAutoFill {
//   String data = "";
//   final controller = Get.find<AuthController>();

//   @override
//   void initState() {
//     super.initState();
//     print("init code auto-fill");
//     this.listenForCode();
//   }

//   @override
//   void dispose() {
//     this.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: widget.height,
//       width: MediaQuery.of(context).size.width,
//       child: GetBuilder<AuthController>(
//         id: "text_field",
//         builder: (controller) => Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             buildTextField(
//               node: widget.node1!,
//               nextNode: widget.node2!,
//               textController: widget.controller1,
//             ),
//             buildSpace(width: 12),
//             buildTextField(
//               node: widget.node2!,
//               nextNode: widget.node3!,
//               prevNode: widget.node1,
//               textController: widget.controller2,
//             ),
//             buildSpace(width: 12),
//             buildTextField(
//               node: widget.node3!,
//               nextNode: widget.node4!,
//               prevNode: widget.node2,
//               textController: widget.controller3,
//             ),
//             buildSpace(width: 12),
//             buildTextField(
//               node: widget.node4!,
//               prevNode: widget.node3!,
//               textController: widget.controller4,
//             ),
//             buildSpace(width: 12),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildSpace({double? width, double? height}) {
//     return SizedBox(
//       width: width,
//       height: height,
//     );
//   }

//   Widget buildTextField(
//       {required FocusNode node,
//       FocusNode? nextNode,
//       FocusNode? prevNode,
//       TextEditingController? textController}) {
//     return Container(
//       padding: EdgeInsets.all(4),
//       decoration: BoxDecoration(
//         color: Colors.transparent,
//         border: Border.all(color: widget.borderColor ?? Colors.transparent),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Container(
//         height: widget.height! - 8,
//         width: 52,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: TextField(
//           controller: textController,
//           focusNode: node,
//           enableInteractiveSelection: false,
//           autofillHints: [AutofillHints.oneTimeCode],
//           keyboardType: TextInputType.number,
//           textAlign: TextAlign.center,
//           textAlignVertical: TextAlignVertical.center,
//           inputFormatters: [
//             FilteringTextInputFormatter.allow(RegExp("[0-9]")),
//             FilteringTextInputFormatter.deny(RegExp("[\\.|\\,]")),
//             LengthLimitingTextInputFormatter(1)
//           ],
//           style: ThreeKmTextConstants.tk12PXPoppinsWhiteRegular.copyWith(
//             fontSize: 24,
//             fontWeight: FontWeight.w700,
//             color: Color(0xFF0F0F2D),
//           ),
//           onChanged: (v) {
//             print(v);
//             if (v.length == 1) {
//               if (textController == widget.controller1) {
//                 controller.changeOTPStatus(OTPCHECKSTATUS.UNDETERMINED);
//               }
//               if (nextNode != null) {
//                 nextNode.requestFocus();
//               }
//             } else if (v.length == 0) {
//               if (textController == widget.controller1) {
//                 controller.changeOTPStatus(OTPCHECKSTATUS.NONE);
//               }
//               if (prevNode != null) {
//                 prevNode.requestFocus();
//               }
//             }
//             controller.setOtp(v);
//           },
//           decoration: InputDecoration(
//             contentPadding: EdgeInsets.symmetric(vertical: 12),
//             hintText: "X",
//             hintStyle: ThreeKmTextConstants.tk12PXPoppinsWhiteRegular.copyWith(
//               fontSize: 24,
//               color: Color(0xFFD5D5D5),
//             ),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void codeUpdated() {
//     print("code changed");
//     print(code);
//     widget.controller1!.text = code[0];
//     widget.controller2!.text = code[1];
//     widget.controller3!.text = code[2];
//     widget.controller4!.text = code[3];
//     controller.setOtp(code);
//     print(controller.data);
//     setState(() {});
//   }
// }

// class OTPProfileTextField extends StatefulWidget {
//   final Color? fillColor;
//   final Color? borderColor;
//   final double? borderRadius;
//   final FocusNode? node1;
//   final FocusNode? node2;
//   final FocusNode? node3;
//   final FocusNode? node4;
//   final TextEditingController? controller1;
//   final TextEditingController? controller2;
//   final TextEditingController? controller3;
//   final TextEditingController? controller4;
//   final TextStyle? style;
//   final double? height;
//   final double? width;
//   final double? textFieldWidth;

//   OTPProfileTextField(
//       {this.fillColor,
//       this.borderRadius,
//       this.style,
//       this.node1,
//       this.height,
//       this.width,
//       this.textFieldWidth,
//       this.controller1,
//       this.node2,
//       this.node3,
//       this.node4,
//       this.controller2,
//       this.controller3,
//       this.controller4,
//       this.borderColor});

//   @override
//   _OTPProfileTextFieldState createState() => _OTPProfileTextFieldState();
// }

// class _OTPProfileTextFieldState extends State<OTPProfileTextField>
//     with CodeAutoFill {
//   String data = "";
//   final controller = Get.find<ProfileController>();

//   @override
//   void initState() {
//     super.initState();
//     print("init code auto-fill");
//     this.listenForCode();
//   }

//   @override
//   void dispose() {
//     this.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: widget.height,
//       width: double.infinity,
//       child: GetBuilder<ProfileController>(
//         id: "text_field",
//         builder: (controller) => Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             buildTextField(
//               node: widget.node1!,
//               nextNode: widget.node2!,
//               textController: widget.controller1,
//             ),
//             buildSpace(width: 12),
//             buildTextField(
//               node: widget.node2!,
//               nextNode: widget.node3!,
//               prevNode: widget.node1,
//               textController: widget.controller2,
//             ),
//             buildSpace(width: 12),
//             buildTextField(
//               node: widget.node3!,
//               nextNode: widget.node4!,
//               prevNode: widget.node2,
//               textController: widget.controller3,
//             ),
//             buildSpace(width: 12),
//             buildTextField(
//               node: widget.node4!,
//               prevNode: widget.node3!,
//               textController: widget.controller4,
//             ),
//             buildSpace(width: 12),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildSpace({double? width, double? height}) {
//     return SizedBox(
//       width: width,
//       height: height,
//     );
//   }

//   Widget buildTextField(
//       {required FocusNode node,
//       FocusNode? nextNode,
//       FocusNode? prevNode,
//       TextEditingController? textController}) {
//     return Stack(
//       children: [
//         Container(
//           padding: EdgeInsets.all(4),
//           decoration: BoxDecoration(
//             color: Colors.transparent,
//             border: Border.all(color: widget.borderColor ?? Colors.transparent),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Container(
//             height: widget.height,
//             width: widget.width,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Center(
//               child: TextField(
//                 controller: textController,
//                 focusNode: node,
//                 enableInteractiveSelection: false,
//                 autofillHints: [AutofillHints.oneTimeCode],
//                 keyboardType: TextInputType.number,
//                 textAlign: TextAlign.center,
//                 textAlignVertical: TextAlignVertical.center,
//                 inputFormatters: [
//                   FilteringTextInputFormatter.allow(RegExp("[0-9]")),
//                   FilteringTextInputFormatter.deny(RegExp("[\\.|\\,]")),
//                   LengthLimitingTextInputFormatter(1)
//                 ],
//                 style: ThreeKmTextConstants.tk12PXPoppinsWhiteRegular.copyWith(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w700,
//                   color: Color(0xFF0F0F2D),
//                 ),
//                 onChanged: (v) {
//                   if (v.length == 1) {
//                     if (textController == widget.controller1) {
//                       controller.changeOTPStatus(OTPCHECKSTATUS.UNDETERMINED);
//                     }
//                     if (nextNode != null) {
//                       nextNode.requestFocus();
//                     }
//                   } else if (v.length == 0) {
//                     if (textController == widget.controller1) {
//                       controller.changeOTPStatus(OTPCHECKSTATUS.NONE);
//                     }
//                     if (prevNode != null) {
//                       prevNode.requestFocus();
//                     }
//                   }
//                   controller.setOtp(v);
//                 },
//                 decoration: InputDecoration(
//                   contentPadding: EdgeInsets.symmetric(vertical: 12),
//                   hintText: "X",
//                   hintStyle:
//                       ThreeKmTextConstants.tk12PXPoppinsWhiteRegular.copyWith(
//                     fontSize: 24,
//                     color: Color(0xFFD5D5D5),
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   void codeUpdated() {
//     print("code changed");
//     print(code);
//     widget.controller1!.text = code[0];
//     widget.controller2!.text = code[1];
//     widget.controller3!.text = code[2];
//     widget.controller4!.text = code[3];
//     controller.setOtp(code);
//     print(controller.data);
//     setState(() {});
//   }
// }
