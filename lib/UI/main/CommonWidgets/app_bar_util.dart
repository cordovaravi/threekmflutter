import 'package:flutter/material.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

class AppBarUtil {
  AppBarUtil._();
  static addEditPostAppBar({List<Widget>? actions}) => AppBar(
        title: Text(
          "Edit Post",
          style: ThreeKmTextConstants.appBarTitleTextStyle,
        ),
        titleSpacing: 0,
        actions: actions,
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black,
      );
}
