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
