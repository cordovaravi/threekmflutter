import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const Color bgColor = Color(0xFF0044CE);
const Color uploadColor = Color(0xff0F0F2D);

class CustomSnackBar {
  CustomSnackBar(BuildContext context, Widget content,
      {SnackBarAction? snackBarAction,
      Color backgroundColor = bgColor,
      Duration? duration}) {
    final SnackBar snackBar = SnackBar(
        action: snackBarAction,
        backgroundColor: backgroundColor,
        content: content,
        duration: duration ?? Duration(seconds: 3),
        behavior: SnackBarBehavior.floating);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class UploadingSnackBar {
  UploadingSnackBar(BuildContext context, Widget content,
      {SnackBarAction? snackBarAction, Color backgroundColor = uploadColor}) {
    final SnackBar snackBar = SnackBar(
        action: snackBarAction,
        backgroundColor: backgroundColor,
        content: content,
        duration: Duration(days: 100),
        behavior: SnackBarBehavior.fixed);
    // ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class CustomToast {
  CustomToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    );
  }
}
