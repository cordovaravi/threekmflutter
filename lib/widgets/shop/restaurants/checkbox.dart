import 'package:flutter/material.dart';

typedef OnClick(bool i);

class CustomCheckBox extends StatefulWidget {
  CustomCheckBox({
    Key? key,
    this.activeColor,
    this.unActiveColor,
    this.backgroundColor,
    this.size,
    required this.label,
    required OnClick this.onClick,
  }) : super(key: key);
  late Color? activeColor;
  late Color? unActiveColor;
  late Color? backgroundColor;
  late double? size;
  late Text label;
  final OnClick onClick;

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool buttonStatus = true;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          buttonStatus = !buttonStatus;
        });
        widget.onClick(buttonStatus);
      },
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 5),
            width: widget.size != null ? widget.size! * 8 : 80,
            height: widget.size != null ? widget.size! * 3 : 30,
            child: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: widget.size != null ? widget.size! * 8 : 80,
                  height: widget.size != null ? widget.size! * 3 : 30,
                  decoration: BoxDecoration(
                      color: widget.backgroundColor ?? Colors.grey[300],
                      border: Border.all(color: Colors.grey[500]!),
                      borderRadius: BorderRadius.circular(20)),
                ),
                AnimatedPositioned(
                  top: -(widget.size! - 3),
                  left: buttonStatus
                      ? widget.size != null
                          ? widget.size! * 4
                          : 40
                      : 0,
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                    width: widget.size != null ? widget.size! * 4 : 40,
                    height: widget.size != null ? widget.size! * 4 : 40,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: buttonStatus
                                ? widget.activeColor ?? Colors.red
                                : widget.unActiveColor ?? Colors.grey[600]!,
                            width: 4),
                        borderRadius: BorderRadius.circular(5)),
                    child: Container(
                      decoration: BoxDecoration(
                          color: buttonStatus
                              ? widget.activeColor ?? Colors.red
                              : widget.unActiveColor ?? Colors.grey[600]!,
                          shape: BoxShape.circle),
                      //width: 20,
                      //height: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          widget.label
        ],
      ),
    );
  }
}
