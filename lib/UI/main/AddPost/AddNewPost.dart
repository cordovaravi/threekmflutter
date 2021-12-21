import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:threekm/utils/utils.dart';

class AddNewPost extends StatefulWidget {
  const AddNewPost({Key? key}) : super(key: key);

  @override
  _AddNewPostState createState() => _AddNewPostState();
}

class _AddNewPostState extends State<AddNewPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text(
        "NEW POST",
        style: ThreeKmTextConstants.tk16PXPoppinsWhiteBold,
      ),
      actions: [
        TextButton(
            onPressed: () {},
            child: Text(
              "Post",
              style: ThreeKmTextConstants.tk14PXPoppinsWhiteMedium,
            ))
      ],
      backgroundColor: Color(0xff0F0F2D),
    ));
  }
}
