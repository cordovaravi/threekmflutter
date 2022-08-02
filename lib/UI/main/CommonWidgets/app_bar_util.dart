import 'package:flutter/material.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

class AppBarUtil {
  AppBarUtil._();
  static appBar({required String title, Widget? primaryActionWidget}) => AppBar(
        title: Text(
          title,
          style: ThreeKmTextConstants.appBarTitleTextStyle,
        ),
        titleSpacing: 0,
        actions: [primaryActionWidget ?? SizedBox.shrink(), SizedBox(width: 6)],
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black,
      );
}
