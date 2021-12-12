import 'package:flutter/material.dart';

class PersistentHeader extends SliverPersistentHeaderDelegate {
  final Widget widget;
  final double height;
  PersistentHeader({required this.widget, this.height = 56});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      width: double.infinity,
      height: 56,
      child: Card(
        margin: EdgeInsets.all(0),
        color: Colors.white,
        elevation: 0,
        child: Center(child: widget),
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => 56.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
