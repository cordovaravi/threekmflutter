import 'package:flutter/material.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

class AppBarUtil {
  AppBarUtil._();
  static addEditPostAppBar({List<Widget>? actions, bool isEditing = false}) => AppBar(
        title: Text(
          "${isEditing ? "Edit" : "Add"} Post",
          style: ThreeKmTextConstants.appBarTitleTextStyle,
        ),
        titleSpacing: 0,
        actions: actions,
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black,
      );
}
