import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PredictionListLoading extends StatelessWidget {
  const PredictionListLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      enabled: true,
      child: ListView.builder(
        itemBuilder: (_, __) => ListTile(
          leading: Icon(Icons.location_on_rounded, color: Colors.white),
          title: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              color: Colors.white,
              height: 14,
              width: 100,
            ),
          ),
          subtitle: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              color: Colors.white,
              height: 12,
              width: 200,
            ),
          ),
        ),
        itemCount: 6,
      ),
    ));
  }
}
