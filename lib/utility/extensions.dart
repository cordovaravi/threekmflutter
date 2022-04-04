import 'package:flutter/material.dart';

extension ContextController on BuildContext {
  void to(Widget page) {
    Navigator.of(this).push(MaterialPageRoute(
      builder: (context) => page,
    ));
  }

  void toBaseNamed(String route, {dynamic args}) {
    Navigator.of(this)
        .pushNamedAndRemoveUntil(route, (route) => false, arguments: args);
  }

  void toNamed(String route, {dynamic args}) {
    Navigator.of(this).pushNamed(route, arguments: args);
  }

  dynamic pop() {
    Navigator.of(this).pop();
  }
}

extension StringExtension on String {
  String capitalize() {
    var data = "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
    return data;
  }
}
