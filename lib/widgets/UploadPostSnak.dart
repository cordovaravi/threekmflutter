import 'dart:io';

import 'package:flutter/material.dart';
import 'package:threekm/utils/utils.dart';

class UploadPostSnackContent extends StatelessWidget {
  final File imageFile;
  UploadPostSnackContent({required this.imageFile, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 12, right: 12, left: 18, bottom: 12),
            child: Container(
              height: 48,
              width: 48,
              child: Image.file(this.imageFile),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12, bottom: 12),
            child: Column(
              children: [
                Text(
                  "Uploading Post",
                  style: ThreeKmTextConstants.tk14PXPoppinsBlackSemiBold,
                ),
                SizedBox(
                  height: 8,
                ),
                // Container(
                //   child: LinearProgressIndicator(),
                // )
              ],
            ),
          )
        ],
      ),
    );
  }
}
