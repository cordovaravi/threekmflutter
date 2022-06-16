import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LikesLoding extends StatelessWidget {
  @Deprecated(
      'Like list bottom sheet was replaced by Like list screen. Use LikesLoadingNew() instead.')
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

class LikesLoadingNew extends StatelessWidget {
  const LikesLoadingNew({Key? key}) : super(key: key);

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
            width: 45,
            height: 45,
            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          ),
          title: Container(
              width: 40,
              height: 25,
              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.rectangle)),
        ),
        itemCount: 6,
      ),
    ));
  }
}
