import 'package:flutter/material.dart';
import 'package:threekm/Models/reportProfileQuestionModel.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

class ReportProfileAnsKey extends StatefulWidget {
  final int index;

  ReportProfileAnsKey({Key? key, required this.index}) : super(key: key);

  @override
  State<ReportProfileAnsKey> createState() => _ReportProfileAnsKeyState();
}

class _ReportProfileAnsKeyState extends State<ReportProfileAnsKey> {
  int selected_answer = 0;

  @override
  Widget build(BuildContext context) {
    final ReportQuestion finaldata = ReportQuestion.fromJson(questions);
    var data = finaldata.data[widget.index];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text('Report Profile'),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                '${data.question}',
                style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold,
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: data.answer.length,
                itemBuilder: (_, i) {
                  return ListTile(
                    onTap: () {
                      setState(() {
                        selected_answer = i;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    horizontalTitleGap: 0.5,
                    title: Text(
                      '${data.answer[i].ansTitle}',
                      style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold
                          .copyWith(fontWeight: FontWeight.w400),
                    ),
                    subtitle: Text('${data.answer[i].ansSubtitle}'),
                    leading: Container(
                      height: 20,
                      width: 20,
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, border: Border.all(width: 2)),
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selected_answer == i
                                ? Colors.black
                                : Colors.white),
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
