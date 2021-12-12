import 'package:flutter/material.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

class TopNews extends StatelessWidget {
  final String? text;
  final String? authorClassification;
  final String? backgroundImage;
  final Color? color;
  TopNews(
      {required this.text,
      this.authorClassification,
      this.backgroundImage,
      this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      padding: EdgeInsets.symmetric(/* vertical: 12 ,*/ horizontal: 16),
      margin: EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: Text(
              text!,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: ThreeKmTextConstants.tk16PXPoppinsWhiteBold,
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(backgroundImage!),
                  radius: 48 / 2.0,
                  backgroundColor: Colors.white,
                ),
                Text(
                  authorClassification!,
                  style: ThreeKmTextConstants.tk12PXPoppinsWhiteRegular,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
