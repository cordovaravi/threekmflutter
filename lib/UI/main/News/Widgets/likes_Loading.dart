import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

@Deprecated("Replaced by LikesListLoading()")
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
            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          ),
        ),
        itemCount: 6,
      ),
    ));
  }
}

class LikesListLoading extends StatelessWidget {
  const LikesListLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      enabled: true,
      child: ListView.builder(
        itemBuilder: (_, __) => ListTile(
          leading: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            alignment: Alignment.topRight,
            // child: Container(
            //     height: 15,
            //     width: 15,
            //     clipBehavior: Clip.antiAlias,
            //     decoration: BoxDecoration(shape: BoxShape.circle)),
          ),
          horizontalTitleGap: 20,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              color: Colors.white,
              height: 20,
              width: 100,
            ),
          ),
        ),
        itemCount: 6,
      ),
    ));
  }
}
