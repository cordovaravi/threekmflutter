/// This file contains a custom linear progress indicator.
import 'package:flutter/material.dart';

class CustomLinearProgressBar extends StatelessWidget {
  /// This class will return a widget that will show the percentage of polls of each options in bar representation.
  final double value;
  final Color? color;
  final double height;
  const CustomLinearProgressBar({
    Key? key,
    this.value = 0,
    this.color,
    this.height = 38,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Container(
        //padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Color(0xffD5D5D5)),
            borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15)),

                /// If [color] of bar is null default color will be applied.
                color: color ?? Colors.grey[300],
              ),
              height: height,

              /// constraint.maxWidth * value will return the width that shows the bar.
              /// For Example : on a 400px available space and value = 0.25, bar will take 25% of the 400px available.
              width: constraint.maxWidth * value,
            ),
            ////---------- self comment
            // Container(
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(3),
            //     color: Colors.white,
            //   ),
            //   height: 37,

            //   /// constraint.maxWidth * (1 - value) will fill the remanining space with white background container.
            //   /// For Example : on a 400px available space and value = 0.25, bar will take 75% of the 400px available.
            //   width: constraint.maxWidth * (1 - value),
            // ),
          ],
        ),
      );
    });
  }
}
