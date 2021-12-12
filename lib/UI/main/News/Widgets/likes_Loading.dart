import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LikesLoding extends StatelessWidget {
  const LikesLoding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      enabled: true,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, __) => Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            width: 90,
            height: 90.0,
            decoration:
                BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          ),
        ),
        itemCount: 6,
      ),
    ));
  }
}
