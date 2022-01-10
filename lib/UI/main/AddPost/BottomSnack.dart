import 'dart:io';

import 'package:flutter/material.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/utils/utils.dart';

showUploadingSnackbar(context, File imageFile) {
  return UploadingSnackBar(
    context,
    Container(
      height: 45,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.zero,
            child: Container(
                height: 40,
                width: 40,
                child: Image.file(
                  imageFile,
                  fit: BoxFit.cover,
                )),
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            "Uploading Post",
            style: ThreeKmTextConstants.tk14PXPoppinsWhiteMedium,
          ),
          SizedBox(height: 8, width: 20),
          Container(
            height: 25,
            width: 25,
            child: CircularProgressIndicator(
              strokeWidth: 3.0,
            ),
          ),
        ],
      ),
    ),
  );
}

void hideCurrentSnackBar(context) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
}
