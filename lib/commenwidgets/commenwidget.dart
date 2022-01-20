import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../main.dart';

void showLoading() {
  WidgetsBinding.instance?.addPostFrameCallback((_) {
    showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (context) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: Lottie.asset("assets/loading.json",
                        height: 100,
                        fit: BoxFit.cover,
                        alignment: Alignment.center),
                  )
                ],
              ),
            ));
  });
}

void hideLoading() {
  Navigator.pop(navigatorKey.currentContext!);
}

void showMessage(String message) {
  showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => Center(
              child: AlertDialog(
            content: Material(
              color: Colors.white,
              child: Text(message),
            ),
          )));
}
