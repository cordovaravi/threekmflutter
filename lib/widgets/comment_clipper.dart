import 'package:flutter/material.dart';

class CommentClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 60);
    path.lineTo((size.width / 2) - 60, 60);
    path.quadraticBezierTo(size.width / 2, 0, (size.width / 2) + 60, 60);
    path.lineTo(size.width, 60);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 60);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
