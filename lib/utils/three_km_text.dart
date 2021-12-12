import 'package:flutter/material.dart';

import 'utils.dart';

enum SpTextType {
  DEFAULT,
  HEADING1,
  HEADING2,
  HEADING3,
  HEADING4,
  HEADING5,
  HEADING6,
  HEADING7,
  HEADING8,
  HEADING9,
  HEADING9U,
  HEADING10,
  UPPERLINE,
  BODY1,
  BODY2,
  BODY3,
  BODY4,
  BODY5,
  BODY6B,
  BODY6,
  BODY7,
  BODY8U,
  BODY9,
  BODY10
}

class ThreeKmTextFix extends StatelessWidget {
  const ThreeKmTextFix(this.text,
      {this.maxLine,
      this.textType,
      this.overflow = false,
      this.color,
      this.fontScaling = false,
      this.fontScalingForLowerRange = false,
      this.textAlign = TextAlign.left});
  final String text;
  final int? maxLine;
  final bool overflow;
  final Color? color;
  final bool fontScaling;
  final SpTextType? textType;
  final bool fontScalingForLowerRange;
  final TextAlign textAlign;
  @override
  Widget build(BuildContext context) {
    TextStyle style = ThreeKmTextConstants.spSf24PXRegular;
    String textLocal = this.text;
    switch (this.textType) {
      case SpTextType.DEFAULT:
        break;

      default:
        break;
    }
    if (color != null) {
      style = style.copyWith(
          fontSize: style.fontSize,
          height: style.height,
          fontFamily: style.fontFamily,
          fontWeight: style.fontWeight,
          color: color);
    }
    if (fontScaling) {
      style = style.copyWith(
          fontSize:
              ThreeKmScreenUtil.getInstance().setSp(style.fontSize!.toInt()),
          height: style.height,
          fontFamily: style.fontFamily,
          fontWeight: style.fontWeight,
          color: color);
    }
    if (fontScalingForLowerRange) {
      style = style.copyWith(
          fontSize: spFontScalingForLowerRanger(style.fontSize!),
          height: style.height,
          fontFamily: style.fontFamily,
          fontWeight: style.fontWeight,
          color: color);
    }
    return Text(
      textLocal,
      overflow: overflow ? TextOverflow.ellipsis : TextOverflow.clip,
      maxLines: maxLine,
      style: style,
      textAlign: textAlign,
      softWrap: true,
    );
  }
}

double spScaleWidth(double value) {
  return ThreeKmScreenUtil.getInstance().scaleWidth * value;
}

double spScaleHeight(double value) {
  return ThreeKmScreenUtil.getInstance().scaleHeight * value;
}

//scale height only for range lower then standard design height.
double spScaleHeightForRangeLower(double value) {
  if (ThreeKmScreenUtil.screenHeight < 1200)
    return ThreeKmScreenUtil.getInstance().scaleHeight * value;
  else
    return value;
}

double spRelativeWidth(double value) {
  print(ThreeKmScreenUtil.screenWidthDp * value / 100);

  return ThreeKmScreenUtil.screenWidthDp * value / 100;
}

//scale height only for range lower then standard design height.
double spScaleWidthForLowerRanger(double value) {
  if (ThreeKmScreenUtil.screenWidthDp < 375) {
    print("spScaleWidthForLowerRanger");
    print(ThreeKmScreenUtil.getInstance().scaleWidth * value);
    return ThreeKmScreenUtil.getInstance().scaleWidth * value;
  } else
    return value;
}

//scale height only for range lower then standard design height.
double spFontScalingForLowerRanger(double value) {
  if (ThreeKmScreenUtil.screenWidthDp < 375)
    return ThreeKmScreenUtil.getInstance().setSp(value.toInt());
  else
    return value;
}

EdgeInsets spEdgeInsets(double value) {
  return EdgeInsets.symmetric(
      horizontal: spScaleWidth(value), vertical: spScaleHeight(value));
}

EdgeInsets spEdgeInsetsExceptButtom(double value) {
  return EdgeInsets.fromLTRB(
      spScaleWidth(value), spScaleHeight(value), spScaleWidth(value), 0);
}
