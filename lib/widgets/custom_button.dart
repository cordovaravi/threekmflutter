import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final double? width;
  final double? height;
  final double? elevation;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final Color? color;
  final Color? shadowColor;
  final BorderRadiusGeometry? borderRadius;
  final BorderRadius? shadowRadius;
  final Widget? child;
  CustomButton({
    this.height,
    this.width,
    this.onTap,
    this.gradient,
    this.color,
    this.borderRadius,
    this.child,
    this.elevation,
    this.shadowRadius,
    this.shadowColor,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: PhysicalModel(
        color: Colors.transparent,
        elevation: elevation ?? 5,
        shadowColor: shadowColor ?? Colors.grey,
        borderRadius: shadowRadius ?? BorderRadius.circular(5),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              gradient: gradient, color: color, borderRadius: borderRadius),
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}

class CustomOutlinedButton extends StatelessWidget {
  final double? width;
  final double? height;
  final double? elevation;
  final VoidCallback? onTap;
  final Color? outlineColor;
  final Color? shadowColor;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;
  final BorderRadius? shadowRadius;
  final Widget? child;
  CustomOutlinedButton({
    this.height,
    this.width,
    this.onTap,
    this.color,
    this.outlineColor,
    this.borderRadius,
    this.child,
    this.elevation,
    this.shadowRadius,
    this.shadowColor,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: PhysicalModel(
        color: color ?? Colors.white,
        elevation: elevation ?? 5,
        shadowColor: shadowColor ?? Colors.grey,
        borderRadius: shadowRadius ?? BorderRadius.circular(5),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: borderRadius,
            border: Border.all(color: outlineColor ?? Colors.transparent),
          ),
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
