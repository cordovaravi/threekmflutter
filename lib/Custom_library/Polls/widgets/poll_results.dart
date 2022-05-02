/// This file contains the results widget.
import 'package:flutter/material.dart';
import 'package:threekm/utils/utils.dart';
import '../models/poll_models.dart';
import 'progress_widget.dart';

class PollResultsWidget extends StatelessWidget {
  /// This widget will show the results of poll.
  final double percentage;
  final PollOptions optionModel;
  final TextStyle? optionsStyle;
  final bool isVoated;
  const PollResultsWidget({
    Key? key,
    required this.percentage,
    required this.optionModel,
    required this.isVoated,
    this.optionsStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      dense: true,
      title: Stack(
        alignment: Alignment.centerLeft,
        children: [
          /// CustomLinearProgressBar is a widget that works like a progress bar but will be static.
          CustomLinearProgressBar(
            value: percentage,
            color: Color(0xffD5D5D5),
          ),

          Positioned(
            right: 10,
            child: Text(
                double.parse((percentage * 100).toStringAsFixed(1)).toString() +
                    '%',
                overflow: TextOverflow.ellipsis,
                style: ThreeKmTextConstants.tk14PXLatoBlackRegular
                    .copyWith(fontWeight: FontWeight.bold)),
          ),

          /// This will create the label of the option in results screen.
          Row(
            children: [
              Flexible(
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(optionModel.label,
                      overflow: TextOverflow.ellipsis,
                      style: optionsStyle ??
                          ThreeKmTextConstants.tk14PXLatoBlackMedium
                      // TextStyle(
                      //   fontSize: 16,
                      //   color: Colors.black,
                      //   fontWeight: FontWeight.w600,
                      // ),
                      ),
                ),
              ),

              /// If [optionModel.isSelected] is true a circle with tick will appear after that label,which indicates the selected of that particular option.
              if (optionModel.isSelected == true)
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 18,
                  ),
                ),
            ],
          ),
        ],
      ),

      /// Trailing portion will show the percentage of polls for each option.
      //trailing:
    );
  }
}
