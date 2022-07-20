import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';
import 'package:threekm/UI/main/navigation.dart';
import 'package:threekm/UI/userkyc/confirm_info.dart';
import 'package:threekm/providers/ProfileInfo/ProfileInfo_Provider.dart';
import 'package:threekm/utils/constants.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

class BirthDate extends StatefulWidget {
  BirthDate({Key? key}) : super(key: key);

  @override
  State<BirthDate> createState() => _BirthDateState();
}

class _BirthDateState extends State<BirthDate> {
  var list = List<int>.generate(31, (i) => i + 1);

  var yearlist =
      List<int>.generate(80, (i) => DateTime.now().year - i - 1).reversed;
  List<String> month = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  FixedExtentScrollController? yearController = FixedExtentScrollController();
  var selectedYear;
  String selectedMonth = "Jan";
  int selectedDate = 1;
  initListData(_) async {
    log('dfdfhshgdjdhtyt');
    yearController?.animateToItem(40,
        duration: Duration(milliseconds: 1000), curve: Curves.easeInCirc);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback(initListData);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Step 5/6',
                  style: ThreeKmTextConstants.tk18PXPoppinsBlackMedium,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Birthdate',
                      style: ThreeKmTextConstants.tk18PXPoppinsBlackMedium,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => TabBarNavigation(
                                    bottomIndex: 3,
                                  )),
                          (route) => false);
                    },
                    child: Text(
                      'Cancel',
                      style: ThreeKmTextConstants.tk18PXPoppinsBlackMedium,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size(context).height / 33,
              ),
              LinearProgressIndicator(
                valueColor: const AlwaysStoppedAnimation(Color(0xFF3E7EFF)),
                minHeight: 3,
                color: Colors.amber[400],
                backgroundColor: const Color(0xFFE7E7E7),
                value: 0.6,
                semanticsLabel: 'Linear progress indicator',
              ),
              SizedBox(
                height: size(context).height / 25,
              ),
              Text(
                'Please enter your Birthdate',
                style: ThreeKmTextConstants.tk20PXPoppinsRedBold
                    .copyWith(color: Colors.black, fontSize: 24, height: 1),
                textAlign: TextAlign.center,
              ),
              Text(
                'This should be the date of birth of the person using the account.',
                style: ThreeKmTextConstants.tk14PXPoppinsBlackMedium
                    .copyWith(color: const Color(0xFFA7ABAD)),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: size(context).height / 39,
              ),
              Container(
                height: size(context).height / 3.4,
                width: 358,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                        blurRadius: 4,
                        color: Color(0x40000040),
                        offset: Offset(0, 4))
                  ],
                  borderRadius: BorderRadius.circular(4),
                  // border: Border.all(color: const Color(0xFFA7ABAD))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: size(context).height / 3.6,
                      width: 80,
                      child: ListWheelScrollView(
                          // clipBehavior: Clip.none,
                          // renderChildrenOutsideViewport: true,
                          physics: const FixedExtentScrollPhysics(),
                          itemExtent: 90,
                          perspective: 0.01,
                          overAndUnderCenterOpacity: 0.3,
                          onSelectedItemChanged: (i) {
                            log("$i ${list.elementAt(i)} days");
                            setState(() {
                              selectedDate = list.elementAt(i);
                            });
                          },
                          children: list
                              .map((e) => Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(),
                                        // top: BorderSide(),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        e.toString(),
                                        style: ThreeKmTextConstants
                                            .tk18PXPoppinsBlackMedium,
                                      ),
                                    ),
                                  ))
                              .toList()),
                    ),
                    SizedBox(
                      height: size(context).height / 3.6,
                      width: 80,
                      child: ListWheelScrollView(
                          // clipBehavior: Clip.none,
                          // renderChildrenOutsideViewport: true,
                          physics: const FixedExtentScrollPhysics(),
                          itemExtent: 90,
                          perspective: 0.01,
                          overAndUnderCenterOpacity: 0.3,
                          onSelectedItemChanged: (i) {
                            log("$i ${month.elementAt(i)} month");
                            setState(() {
                              selectedMonth = month.elementAt(i);
                            });
                          },
                          children: month
                              .map((e) => Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(),
                                        // top: BorderSide(),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        e,
                                        style: ThreeKmTextConstants
                                            .tk18PXPoppinsBlackMedium,
                                      ),
                                    ),
                                  ))
                              .toList()),
                    ),
                    SizedBox(
                      height: size(context).height / 3.6,
                      width: 80,
                      child: ListWheelScrollView(
                          // clipBehavior: Clip.none,
                          // renderChildrenOutsideViewport: true,
                          controller: yearController,
                          physics: const FixedExtentScrollPhysics(),
                          itemExtent: 90,
                          perspective: 0.01,
                          overAndUnderCenterOpacity: 0.3,
                          onSelectedItemChanged: (i) {
                            log("$i ${yearlist.elementAt(i)} year");
                            setState(() {
                              selectedYear = yearlist.elementAt(i);
                            });
                          },
                          children: yearlist
                              .map((e) => Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(),
                                        // top: BorderSide(),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        e.toString(),
                                        style: ThreeKmTextConstants
                                            .tk18PXPoppinsBlackMedium,
                                      ),
                                    ),
                                  ))
                              .toList()),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    selectedYear != null
                        ? Text(
                            'You’re ${DateTime.now().year - selectedYear} years-old. please make sure that’s correct before pressing next',
                            style: ThreeKmTextConstants.tk14PXPoppinsBlackMedium
                                .copyWith(color: Color(0xFF979EA4)),
                            textAlign: TextAlign.center,
                          )
                        : Text(""),
                    Container(
                        margin: EdgeInsets.only(top: 20),
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
                                        StadiumBorder())),
                            onPressed: () {
                              if (selectedDate != null &&
                                  selectedMonth != null &&
                                  selectedYear != null) {
                                String strDt =
                                    "$selectedYear-${selectedMonth}-$selectedDate";
                                DateFormat formatter =
                                    new DateFormat('yyyy-MMM-dd');
                                DateTime parseDt = formatter.parse(strDt);
                                log(strDt);
                                log(parseDt.toString());
                                context
                                    .read<ProfileInfoProvider>()
                                    .updateProfileInfo(dob: parseDt)
                                    .whenComplete(() => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => ConfirmInfo())));
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                'Next',
                                style:
                                    ThreeKmTextConstants.tk16PXPoppinsWhiteBold,
                              ),
                            )))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
