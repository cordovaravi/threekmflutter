import 'dart:ui';

import 'package:flutter/material.dart';

class PaintLine extends CustomClipper<Path> {
  final double index;
  double? radius;
  PaintLine({required this.index, this.radius});

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width - 100, 0);
    path.quadraticBezierTo(
        size.width, size.height / 2, size.width - 100, size.height);
    path.lineTo(size.width - 104, size.height);
    path.quadraticBezierTo(
        (size.width - 6), size.height / 2, size.width - 104, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class PaintLine2 extends CustomPainter {
  final double index;
  double? radius;
  double? percent;
  PaintLine2({required this.index, this.radius, this.percent});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paintCircle = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8;

    Paint paintCircleOutline = Paint()
      ..color = Colors.white38
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8;

    canvas.drawCircle(
        Offset(size.width - 5, (size.height * percent!)), 10, paintCircle);
    canvas.drawCircle(Offset(size.width - 5, (size.height * percent!)),
        20 * radius!, paintCircleOutline);
  }
  // canvas.drawCircle(
  //     Offset((size.width / 2) + 60, (size.height) - 32), 10, paintCircle);
  // canvas.drawCircle(Offset((size.width / 2) + 48, (size.height) - 32), 16,
  //     paintCircleOutline);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
