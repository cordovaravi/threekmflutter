import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:threekm/UI/main/Profile/reportProfileAnsKey.dart';
import 'package:threekm/utils/constants.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

class ReportProfile extends StatefulWidget {
  const ReportProfile({Key? key}) : super(key: key);

  @override
  State<ReportProfile> createState() => _ReportProfileState();
}

class _ReportProfileState extends State<ReportProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text('Report Profile'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
       
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'Why are you reporting this account?',
                style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold,
              ),
            ),
            Divider(
              thickness: 2,
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ReportProfileAnsKey(
                              index: 0,
                            )));
              },
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(
                'Suspicious, spam, or fake',
                style: ThreeKmTextConstants.tk14PXPoppinsBlackMedium
                    .copyWith(fontWeight: FontWeight.w400),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            Divider(
              thickness: 2,
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ReportProfileAnsKey(
                              index: 1,
                            )));
              },
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(
                'Harassment or hateful speech',
                style: ThreeKmTextConstants.tk14PXPoppinsBlackMedium
                    .copyWith(fontWeight: FontWeight.w400),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            Divider(
              thickness: 2,
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ReportProfileAnsKey(
                              index: 2,
                            )));
              },
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(
                'Violence or physical harm',
                style: ThreeKmTextConstants.tk14PXPoppinsBlackMedium
                    .copyWith(fontWeight: FontWeight.w400),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            Divider(
              thickness: 2,
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ReportProfileAnsKey(
                              index: 3,
                            )));
              },
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(
                'Adult content',
                style: ThreeKmTextConstants.tk14PXPoppinsBlackMedium
                    .copyWith(fontWeight: FontWeight.w400),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            Divider(
              thickness: 2,
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ReportProfileAnsKey(
                              index: 4,
                            )));
              },
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(
                'Other',
                style: ThreeKmTextConstants.tk14PXPoppinsBlackMedium
                    .copyWith(fontWeight: FontWeight.w400),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      ),
    );
  }
}
