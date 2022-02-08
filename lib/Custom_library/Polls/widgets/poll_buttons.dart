/// This file contains the actual option widget used.
import 'package:flutter/material.dart';
import 'package:threekm/utils/utils.dart';
import '../models/poll_models.dart';

class PollButtonsWidget extends StatelessWidget {
  /// This class does not have state that's why created as stateless.
  final PollOptions optionModel;
  final TextStyle? optionsStyle;
  final Function onPressed;
  final OutlinedBorder borderShape;
  const PollButtonsWidget({
    Key? key,
    required this.optionModel,
    required this.onPressed,
    this.optionsStyle,
    this.borderShape = const StadiumBorder(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: EdgeInsets.only(bottom: 8),
      child: OutlinedButton(
        onPressed: () {
          /// Calls the passed callback to capture response.
          onPressed();
        },
        child: Text(
          optionModel.label,
          overflow: TextOverflow.ellipsis,
        ),
        style: OutlinedButton.styleFrom(
            primary: Colors.black,
            backgroundColor: Colors.white,
            shape: borderShape,
            side: BorderSide(
              color: Colors.white,
              width: 1.5,
            ),

            /// Custom theme will be applied here.
            /// First it checks the passed parameter , if [optionsStyle] is null the default theme will be applied.
            textStyle: ThreeKmTextConstants.tk16PXLatoBlackRegular),
      ),
    );
  }
}
