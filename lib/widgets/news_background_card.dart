import 'package:flutter/material.dart';

class NewsBackgroundCard extends StatelessWidget {
  final Widget child;
  final double height;
  final double radius;
  final bool shadow;
  NewsBackgroundCard(
      {required this.child,
      required this.height,
      required this.radius,
      required this.shadow});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(boxShadow: [
        if (shadow) ...{
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset(0, 10),
              blurRadius: 50,
              spreadRadius: 3)
        }
      ]),
      child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius)),
          child: child),
    );
  }
}
