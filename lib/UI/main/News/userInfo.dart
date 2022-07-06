import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as materialDegin;
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/src/provider.dart';

import 'package:threekm/Models/getUserInfoModel.dart';
import 'package:threekm/UI/main/News/Widgets/gradiant_button.dart';
import 'package:threekm/providers/Global/logged_in_or_not.dart';

import 'package:threekm/providers/ProfileInfo/ProfileInfo_Provider.dart';
import 'package:rive/rive.dart';

import 'dart:developer';

import 'package:threekm/providers/userKyc/verify_credential.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key, this.authUserDetails}) : super(key: key);
  final GetUserInfoModel? authUserDetails;
  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  void _togglePlay(i) {
    setState(() {
      _controller!.isActive = true;
      _selectedIndex = i;
    });
  }

  /// Tracks if the animation is playing by whether controller is running.
  bool get isPlaying => _controller?.isActive ?? false;

  Artboard? _riveArtboard;
  // Artboard? _riveArtboard1;
  RiveAnimationController? _controller;

  List<String> bloodGroup = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"];
  int? _selectedIndex;
  String? gender;
  bool isGenderChanged = false;

  List<String> month = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "June",
    "July",
    "Aug",
    "Sept",
    "Oct",
    "Nov",
    "Dec"
  ];

  List<String> Lang = [
    "assets/images/hindi.png",
    "assets/images/english.png",
    "assets/images/marathi.png",
    "assets/images/gujrati.png",
    "assets/images/kannada.png",
    "assets/images/malayalam.png",
    "assets/images/punjabi.png",
    "assets/images/tamil.png",
    "assets/images/telugu.png",
    "assets/images/bengali.png",
    "assets/images/urdu.png",
    "assets/images/other.png",
  ];
  List<String> Langcode = [
    "hi",
    "en",
    "mr",
    "gu",
    "kn",
    "ml",
    "pa",
    "ta",
    "te",
    "bn",
    "ur",
    "other"
  ];

  List<int> _selectedLangIndex = [];
  List<String> _selectedLang = [];
  bool _viewall = false;
  List<bool> _isSkip = [true, true, true, true];
  //AuthUserDetailsModel? _authUserDetails;
  int previousPageViewIndex = 0;

  var list = List<int>.generate(30, (i) => i + 1);
  var yearlist =
      List<int>.generate(90, (i) => DateTime.now().year - i - 1).reversed;

  var selectedYear;
  var selectedMonth;
  var selectedDate;

  @override
  void initState() {
    super.initState();
    log('user info =======================================');
    // context.read<AuthUserDetailsProvider>().getAuthUserDetails().whenComplete(
    //     () => _authUserDetails =
    //         context.read<AuthUserDetailsProvider>().authUserDetails);

    // Load the animation file from the bundle, note that you could also
    // download this. The RiveFile just expects a list of bytes.
    rootBundle.load('assets/images/blood_bank.riv').then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);
        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;
        // Add a controller to play back a known animation on the main/default
        // artboard.We store a reference to it so we can toggle playback.
        artboard.addController(_controller = SimpleAnimation('bloodAnimation'));
        setState(() {
          _riveArtboard = artboard;
          _controller?.isActive = false;
        });
      },
    );
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted)
        setState(() {
          _isSkip[0] = false;
        });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  List<int> checkUserData() {
    var data =
        context.watch<VerifyKYCCredential>().userProfileInfo.data?.result;
    if (data != null) {
      List<String> emptyData = [];
      List<int> emptyDataint = [];
      if (data.bloodGroup == null || data.bloodGroup == "") {
        emptyData.add('bloodGroup');
        emptyDataint.add(0);
      }
      if (data.gender == null || data.gender == "") {
        emptyData.add('gender');
        emptyDataint.add(1);
      }
      if (data.dob == null || data.dob == "") {
        emptyData.add('dob');
        emptyDataint.add(2);
      }
      if (data.languages.isEmpty == true) {
        emptyData.add('languages');
        emptyDataint.add(3);
      }
      log(emptyData.toString());
      return emptyDataint;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final PageController controller = PageController(initialPage: 0);
    log('${checkUserData().toString()}+++++++++++++++++++++++++++++++');
    return checkUserData().length != 0
        ? Container(
            margin: EdgeInsets.only(top: 20),
            height: size.height / 1.4,
            child: PageView.builder(
                controller: controller,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: checkUserData().length,
                onPageChanged: (index) {
                  setState(() {
                    previousPageViewIndex = index;
                    Future.delayed(const Duration(seconds: 5), () {
                      setState(() {
                        _isSkip[index] = false;
                      });
                    });
                  });
                },
                itemBuilder: (_, i) {
                  return Center(
                    child: SizedBox(
                      width: size.width,
                      height: size.height / 1.3,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        fit: StackFit.loose,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 40),
                            height: size.height / 1.5,
                            decoration: BoxDecoration(
                              // color: Colors.red,
                              image: DecorationImage(
                                alignment: Alignment.bottomCenter,
                                image: AssetImage(
                                  i == 0
                                      ? "assets/images/BG.png"
                                      : i == 1
                                          ? 'assets/images/BG1.png'
                                          : 'assets/images/BG.png',
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: Column(
                              // mainAxisSize: MainAxisSize.min,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //i == 0 &&
                                checkUserData().contains(0) &&
                                        checkUserData().elementAt(i) == 0
                                    ? Container(
                                        margin: const EdgeInsets.only(top: 80),
                                        width: size.width,
                                        //height: size.height / 1.1,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            BloodBank(
                                                riveArtboard: _riveArtboard,
                                                size: size),
                                            SizedBox(
                                              //width: 100,
                                              height: 150,
                                              child: GridView.builder(
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 2,
                                                          //childAspectRatio: 1.2,
                                                          mainAxisExtent: 75,
                                                          crossAxisSpacing: 10,
                                                          mainAxisSpacing: 10),
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  shrinkWrap: true,
                                                  itemCount: bloodGroup.length,
                                                  itemBuilder: (_, i) {
                                                    return InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          _selectedIndex = i;
                                                        });
                                                        log(bloodGroup[i]);
                                                        _togglePlay(i);
                                                      },
                                                      child: Container(
                                                          width: 63,
                                                          height: 50,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              border: Border.all(
                                                                  color: _selectedIndex == i
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .white,
                                                                  width: 3),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12)),
                                                          child:
                                                              // _selectedIndex != i

                                                              Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Image(
                                                                image: AssetImage(
                                                                    'assets/images/${bloodGroup[i]}.png'),
                                                                width: 35,
                                                                height: 50,
                                                              ),
                                                              //Text(bloodGroup[i])
                                                            ],
                                                          )),
                                                    );
                                                  }),
                                            ),
                                            Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: SizedBox(
                                                      width: 150,
                                                      child:
                                                          RaisedGradientButton(
                                                        colors: const [
                                                          Color(0xFF0E17FF),
                                                          Color(0xFFFF0000)
                                                        ],
                                                        onPressed: () async {
                                                          // log('????????????');
                                                          if (await getAuthStatus()) {
                                                            if (_selectedIndex !=
                                                                null) {
                                                              // controller.nextPage(
                                                              //     duration:
                                                              //         const Duration(
                                                              //             seconds:
                                                              //                 1),
                                                              //     curve: Curves
                                                              //         .easeInOut);

                                                              context
                                                                  .read<
                                                                      ProfileInfoProvider>()
                                                                  .updateProfileInfo(
                                                                      bloodGroup:
                                                                          bloodGroup[
                                                                              _selectedIndex!])
                                                                  .whenComplete(
                                                                      () {
                                                                context
                                                                    .read<
                                                                        VerifyKYCCredential>()
                                                                    .getUserProfileInfo()
                                                                    .whenComplete(() =>
                                                                        setState(
                                                                            () {}));
                                                              });
                                                            } else {
                                                              Fluttertoast
                                                                  .showToast(
                                                                msg:
                                                                    "Please select a bloodGroup",
                                                              );
                                                            }
                                                          } else {
                                                            NaviagateToLogin(
                                                                context);
                                                          }
                                                        },
                                                        child: context
                                                                .read<
                                                                    ProfileInfoProvider>()
                                                                .isUpdating
                                                            ? CircularProgressIndicator
                                                                .adaptive()
                                                            : Text(
                                                                "Next",
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                      )),
                                                ))
                                          ],
                                        ),
                                      )
                                    :
                                    //i == 1 &&
                                    checkUserData().contains(1) &&
                                            checkUserData().elementAt(i) == 1
                                        ? Container(
                                            margin:
                                                const EdgeInsets.only(top: 110),
                                            height: size.height / 2.2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      bottom: 80),
                                                  width: 130,
                                                  height: 130,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: const Color(
                                                              0xffD5FFF7),
                                                          width: 7),
                                                      color: Colors.white,
                                                      shape: BoxShape.circle),
                                                  child: AnimatedSwitcher(
                                                    reverseDuration:
                                                        const Duration(
                                                            seconds: 1),
                                                    duration: const Duration(
                                                        seconds: 1),
                                                    transitionBuilder:
                                                        (_, animation) =>
                                                            ScaleTransition(
                                                      child: _,
                                                      scale: animation,
                                                    ),
                                                    child: gender != null
                                                        ? ClipRRect(
                                                            key: ValueKey(
                                                                gender),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        70),
                                                            child: Image(
                                                                image: AssetImage(
                                                                    'assets/images/$gender.gif')),
                                                          )
                                                        : Container(),
                                                  ),
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              gender = 'male';
                                                            });
                                                          },
                                                          child:
                                                              const GenderOptions(
                                                            imageUrl:
                                                                'assets/images/male.gif',
                                                            label: 'Male',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          gender = 'female';
                                                        });
                                                      },
                                                      child:
                                                          const GenderOptions(
                                                        imageUrl:
                                                            'assets/images/female.gif',
                                                        label: 'Female',
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          gender = 'other';
                                                        });
                                                      },
                                                      child:
                                                          const GenderOptions(
                                                        imageUrl:
                                                            'assets/images/other.gif',
                                                        label: 'Other',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const Spacer(),
                                                Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      child: SizedBox(
                                                          width: 150,
                                                          child:
                                                              RaisedGradientButton(
                                                            colors: const [
                                                              Color(0xFF0E17FF),
                                                              Color(0xFFFF0000)
                                                            ],
                                                            onPressed:
                                                                () async {
                                                              if (await getAuthStatus()) {
                                                                if (gender !=
                                                                    null) {
                                                                  // controller.nextPage(
                                                                  //     duration: const Duration(
                                                                  //         seconds:
                                                                  //             1),
                                                                  //     curve: Curves
                                                                  //         .easeInOut);
                                                                  context
                                                                      .read<
                                                                          ProfileInfoProvider>()
                                                                      .updateProfileInfo(
                                                                          Gender:
                                                                              gender)
                                                                      .whenComplete(
                                                                          () {
                                                                    context
                                                                        .read<
                                                                            VerifyKYCCredential>()
                                                                        .getUserProfileInfo()
                                                                        .whenComplete(() =>
                                                                            setState(() {}));
                                                                    ;
                                                                  });
                                                                } else {
                                                                  Fluttertoast
                                                                      .showToast(
                                                                          msg:
                                                                              "Please Select your gender");
                                                                }
                                                              } else {
                                                                NaviagateToLogin(
                                                                    context);
                                                              }
                                                            },
                                                            child: context
                                                                    .read<
                                                                        ProfileInfoProvider>()
                                                                    .isUpdating
                                                                ? CircularProgressIndicator
                                                                    .adaptive()
                                                                : Text(
                                                                    "Next",
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                          )),
                                                    ))
                                              ],
                                            ),
                                          )
                                        :
                                        //i == 2 &&
                                        checkUserData().contains(2) &&
                                                checkUserData().elementAt(i) ==
                                                    2
                                            ? Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Spacer(),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              // top: 190,
                                                              left: 30,
                                                              right: 30),
                                                      height: 231,
                                                      width: 328,
                                                      decoration: BoxDecoration(
                                                        // color: Colors.white,
                                                        border: Border.all(
                                                            width: 2,
                                                            color:
                                                                Colors.white),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                              blurRadius: 4,
                                                              color: Color(
                                                                  0x40000040),
                                                              offset:
                                                                  Offset(0, 4))
                                                        ],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                        gradient: const materialDegin
                                                                .LinearGradient(
                                                            stops: [0.1, 1],
                                                            begin:
                                                                FractionalOffset(
                                                                    0.0, 0.0),
                                                            end:
                                                                FractionalOffset(
                                                                    0.1, 2.0),
                                                            colors: [
                                                              Color(0xFF4D0EFF),
                                                              Color(0xFFFFFFFF)
                                                            ]),
                                                        // border: Border.all(color: const Color(0xFFA7ABAD))
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          SizedBox(
                                                            height: 240,
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
                                                                    selectedDate =
                                                                        list.elementAt(
                                                                            i);
                                                                  });
                                                                },
                                                                children: list
                                                                    .map((e) => Container(
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            border:
                                                                                Border(
                                                                              bottom: BorderSide(color: Colors.white),
                                                                              // top: BorderSide(),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              e.toString(),
                                                                              style: ThreeKmTextConstants.tk18PXPoppinsBlackMedium.copyWith(color: Colors.white),
                                                                            ),
                                                                          ),
                                                                        ))
                                                                    .toList()),
                                                          ),
                                                          SizedBox(
                                                            height: 240,
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
                                                                    selectedMonth =
                                                                        month.elementAt(
                                                                            i);
                                                                  });
                                                                },
                                                                children: month
                                                                    .map((e) => Container(
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            border:
                                                                                Border(
                                                                              bottom: BorderSide(color: Colors.white),
                                                                              // top: BorderSide(),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              e,
                                                                              style: ThreeKmTextConstants.tk18PXPoppinsBlackMedium.copyWith(color: Colors.white),
                                                                            ),
                                                                          ),
                                                                        ))
                                                                    .toList()),
                                                          ),
                                                          SizedBox(
                                                            height: 240,
                                                            width: 80,
                                                            child: ListWheelScrollView(
                                                                // clipBehavior: Clip.none,
                                                                // renderChildrenOutsideViewport: true,
                                                                physics: const FixedExtentScrollPhysics(),
                                                                itemExtent: 90,
                                                                perspective: 0.01,
                                                                overAndUnderCenterOpacity: 0.3,
                                                                onSelectedItemChanged: (i) {
                                                                  log("$i ${yearlist.elementAt(i)} year");
                                                                  setState(() {
                                                                    selectedYear =
                                                                        yearlist
                                                                            .elementAt(i);
                                                                  });
                                                                },
                                                                children: yearlist
                                                                    .map((e) => Container(
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            border:
                                                                                Border(
                                                                              bottom: BorderSide(color: Colors.white),
                                                                              // top: BorderSide(),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              e.toString(),
                                                                              style: ThreeKmTextConstants.tk18PXPoppinsBlackMedium.copyWith(color: Colors.white),
                                                                            ),
                                                                          ),
                                                                        ))
                                                                    .toList()),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Align(
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 30),
                                                          child: SizedBox(
                                                              width: 150,
                                                              child:
                                                                  RaisedGradientButton(
                                                                colors: const [
                                                                  Color(
                                                                      0xFF0E17FF),
                                                                  Color(
                                                                      0xFFFF0000)
                                                                ],
                                                                onPressed:
                                                                    () async {
                                                                  if (await getAuthStatus()) {
                                                                    if (selectedDate != null &&
                                                                        selectedMonth !=
                                                                            null &&
                                                                        selectedYear !=
                                                                            null) {
                                                                      // controller.nextPage(
                                                                      //     duration: const Duration(
                                                                      //         seconds:
                                                                      //             1),
                                                                      //     curve: Curves
                                                                      //         .easeInOut);
                                                                      String
                                                                          strDt =
                                                                          "$selectedYear-${selectedMonth}-$selectedDate";
                                                                      DateFormat
                                                                          formatter =
                                                                          new DateFormat(
                                                                              'yyyy-MMM-dd');
                                                                      DateTime
                                                                          parseDt =
                                                                          formatter
                                                                              .parse(strDt);

                                                                      context
                                                                          .read<
                                                                              ProfileInfoProvider>()
                                                                          .updateProfileInfo(
                                                                              dob:
                                                                                  parseDt)
                                                                          .whenComplete(
                                                                              () {
                                                                        context
                                                                            .read<VerifyKYCCredential>()
                                                                            .getUserProfileInfo();

                                                                        setState(
                                                                            () {});
                                                                      });
                                                                    } else {
                                                                      Fluttertoast
                                                                          .showToast(
                                                                        msg:
                                                                            "Please select your date of birth",
                                                                      );
                                                                    }
                                                                  } else {
                                                                    NaviagateToLogin(
                                                                        context);
                                                                  }
                                                                },
                                                                child: context
                                                                        .read<
                                                                            ProfileInfoProvider>()
                                                                        .isUpdating
                                                                    ? CircularProgressIndicator
                                                                        .adaptive()
                                                                    : Text(
                                                                        "Next",
                                                                        style:
                                                                            const TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                              )),
                                                        ))
                                                  ],
                                                ),
                                              )
                                            :
                                            // i == 3 &&
                                            checkUserData().contains(3) &&
                                                    checkUserData()
                                                            .elementAt(i) ==
                                                        3
                                                ? Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 100, left: 30),
                                                    height: size.height / 2,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          constraints:
                                                              BoxConstraints(
                                                                  maxHeight:
                                                                      size.height /
                                                                          2.9,
                                                                  minHeight:
                                                                      100),
                                                          child:
                                                              GridView.builder(
                                                                  scrollDirection:
                                                                      Axis
                                                                          .vertical,
                                                                  itemCount:
                                                                      _viewall
                                                                          ? Lang
                                                                              .length
                                                                          : 3,
                                                                  shrinkWrap:
                                                                      true,
                                                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                                      crossAxisCount:
                                                                          3,
                                                                      childAspectRatio:
                                                                          1.6,
                                                                      crossAxisSpacing:
                                                                          5,
                                                                      mainAxisSpacing:
                                                                          29),
                                                                  itemBuilder:
                                                                      (_, i) {
                                                                    return InkWell(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          if (_selectedLangIndex
                                                                              .contains(i)) {
                                                                            _selectedLangIndex.remove(i);
                                                                          } else {
                                                                            _selectedLangIndex.add(i);
                                                                            _selectedLang.add(Langcode[i]);
                                                                          }
                                                                        });
                                                                      },
                                                                      child:
                                                                          Stack(
                                                                        clipBehavior:
                                                                            Clip.none,
                                                                        children: [
                                                                          Image(
                                                                              image: AssetImage('${Lang[i]}')),
                                                                          if (_selectedLangIndex
                                                                              .contains(i))
                                                                            Positioned(
                                                                              top: -13,
                                                                              right: 13,
                                                                              child: Lottie.asset("assets/images/check-green.json", height: 50, repeat: false, fit: BoxFit.cover, alignment: Alignment.center),
                                                                            ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  }),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 20),
                                                            child: TextButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    _viewall =
                                                                        !_viewall;
                                                                  });
                                                                },
                                                                child: Text(
                                                                  _viewall
                                                                      ? 'View less'
                                                                      : 'View All',
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                )),
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        Align(
                                                            alignment: Alignment
                                                                .bottomCenter,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      15.0),
                                                              child: SizedBox(
                                                                  width: 150,
                                                                  child:
                                                                      RaisedGradientButton(
                                                                    colors: const [
                                                                      Color(
                                                                          0xFF0E17FF),
                                                                      Color(
                                                                          0xFFFF0000)
                                                                    ],
                                                                    onPressed:
                                                                        () async {
                                                                      if (await getAuthStatus()) {
                                                                        if (_selectedLang
                                                                            .isNotEmpty) {
                                                                          context
                                                                              .read<ProfileInfoProvider>()
                                                                              .updateProfileInfo(language: _selectedLang)
                                                                              .whenComplete(() {
                                                                            context.read<VerifyKYCCredential>().getUserProfileInfo().whenComplete(() =>
                                                                                setState(() {}));
                                                                          });
                                                                        }
                                                                      } else {
                                                                        NaviagateToLogin(
                                                                            context);
                                                                      }
                                                                    },
                                                                    child: Text(
                                                                      "Done",
                                                                      style:
                                                                          const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  )),
                                                            ))
                                                      ],
                                                    ),
                                                  )
                                                : Container(),
                              ],
                            ),
                          ),
                          Container(
                            width: size.width / 1.4,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                image: const DecorationImage(
                                    image: AssetImage(
                                        'assets/images/radialBG.png'),
                                    fit: BoxFit.fill),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  checkUserData().contains(0) &&
                                          checkUserData().elementAt(i) == 0
                                      ? 'Become a life saver for someone in your neighbourhood'
                                      : checkUserData().contains(1) &&
                                              checkUserData().elementAt(i) == 1
                                          ? 'We will create content & shopping experience accordingly'
                                          : checkUserData().contains(2) &&
                                                  checkUserData()
                                                          .elementAt(i) ==
                                                      2
                                              ? 'We will wish you & gift you something exciting'
                                              : checkUserData().contains(3) &&
                                                      checkUserData()
                                                              .elementAt(i) ==
                                                          3
                                                  ? 'Which languages are you Comfortable with'
                                                  : '',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  checkUserData().contains(0) &&
                                          checkUserData().elementAt(i) == 0
                                      ? 'Share your blood group'
                                      : checkUserData().contains(1) &&
                                              checkUserData().elementAt(i) == 1
                                          ? 'Tell us your Gender'
                                          : checkUserData().contains(2) &&
                                                  checkUserData()
                                                          .elementAt(i) ==
                                                      2
                                              ? 'Tell Us Your Birthdate'
                                              : checkUserData().contains(3) &&
                                                      checkUserData()
                                                              .elementAt(i) ==
                                                          3
                                                  ? 'Important notifications will follow your preference'
                                                  : '',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      height: 2),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          )
        : Container();
  }
}

class GenderOptions extends StatelessWidget {
  const GenderOptions({Key? key, required this.imageUrl, required this.label})
      : super(key: key);
  final String imageUrl;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffD5FFF7), width: 7),
              color: Colors.white,
              shape: BoxShape.circle),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image(
              image: AssetImage(imageUrl),
              width: 80,
              height: 80,
            ),
          ),
        ),
        Text(label)
      ],
    );
  }
}

class BloodBank extends StatelessWidget {
  const BloodBank({
    Key? key,
    required Artboard? riveArtboard,
    required this.size,
  })  : _riveArtboard = riveArtboard,
        super(key: key);

  final Artboard? _riveArtboard;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _riveArtboard == null
          ? const SizedBox()
          : Column(
              children: [
                SizedBox(
                    height: size.height / 4,
                    width: size.width / 2,
                    child: Rive(artboard: _riveArtboard!)),
                const SizedBox(
                  height: 10,
                )
                // if (_selectedIndex != null)
                //   Text(
                //     bloodGroup[_selectedIndex!],
                //     style: const TextStyle(
                //         color: Colors.white, fontSize: 40),
                //   )
              ],
            ),
    );
  }
}
