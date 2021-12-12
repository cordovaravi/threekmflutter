import 'package:flutter/material.dart';

const Color bgColor = Color(0xFF0044CE);

class CustomSnackBar {
  CustomSnackBar(BuildContext context, Widget content,
      {SnackBarAction? snackBarAction, Color backgroundColor = bgColor}) {
    final SnackBar snackBar = SnackBar(
        action: snackBarAction,
        backgroundColor: backgroundColor,
        content: content,
        behavior: SnackBarBehavior.floating);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
