import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/src/provider.dart';

import 'package:threekm/Models/getUserInfoModel.dart';
import 'package:threekm/UI/main/News/Widgets/gradiant_button.dart';

import 'package:threekm/providers/ProfileInfo/ProfileInfo_Provider.dart';
import 'package:rive/rive.dart';

import 'dart:developer';

import 'package:threekm/providers/userKyc/verify_credential.dart';

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

  int _date = 1;
  int _month = 0;
  int _year = DateTime.now().year - 100;
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

  List<int> _selectedLangIndex = [1];
  List<String> _selectedLang = ["en"];
  bool _viewall = false;
  List<bool> _isSkip = [true, true, true, true];
  //AuthUserDetailsModel? _authUserDetails;
  int previousPageViewIndex = 0;
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
    if (widget.authUserDetails != null) {
      var data = widget.authUserDetails?.data?.result;
      List<String> emptyData = [];
      List<int> emptyDataint = [];
      if (data?.bloodGroup == null || data?.bloodGroup == "") {
        emptyData.add('bloodGroup');
        emptyDataint.add(0);
      }
      if (data?.gender == null || data?.gender == "") {
        emptyData.add('gender');
        emptyDataint.add(1);
      }
      if (data?.dob == null || data?.dob == "") {
        emptyData.add('dob');
        emptyDataint.add(2);
      }
      if (data?.languages.isEmpty == true) {
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
                                                        onPressed: () {
                                                          // log('????????????');
                                                          if (!_isSkip[i] &&
                                                              _selectedIndex !=
                                                                  null) {
                                                            controller.nextPage(
                                                                duration:
                                                                    const Duration(
                                                                        seconds:
                                                                            1),
                                                                curve: Curves
                                                                    .easeInOut);

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
                                                                      AuthUserDetailsProvider>()
                                                                  .getAuthUserDetails()
                                                                  .whenComplete(() =>
                                                                      setState(
                                                                          () {}));
                                                            });
                                                            log('????????????');
                                                          } else if (_isSkip[
                                                              i]) {
                                                            controller.nextPage(
                                                                duration:
                                                                    const Duration(
                                                                        seconds:
                                                                            1),
                                                                curve: Curves
                                                                    .easeInOut);
                                                            log('+++++++++++');
                                                          }
                                                        },
                                                        child: Text(
                                                          _isSkip[i]
                                                              ? 'Skip For Now'
                                                              : "Next",
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
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
                                                            onPressed: () {
                                                              if (!_isSkip[i] &&
                                                                  gender !=
                                                                      null) {
                                                                controller.nextPage(
                                                                    duration: const Duration(
                                                                        seconds:
                                                                            1),
                                                                    curve: Curves
                                                                        .easeInOut);
                                                              } else if (_isSkip[
                                                                  i]) {
                                                                controller.nextPage(
                                                                    duration: const Duration(
                                                                        seconds:
                                                                            1),
                                                                    curve: Curves
                                                                        .easeInOut);
                                                                if (gender !=
                                                                    null)
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
                                                              }
                                                            },
                                                            child: Text(
                                                              _isSkip[i]
                                                                  ? 'Skip For Now'
                                                                  : "Next",
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
                                            ? Container(
                                                margin: const EdgeInsets.only(
                                                    top: 150),
                                                padding: const EdgeInsets.only(
                                                    left: 30),
                                                height: size.height / 2.3,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 20,
                                                                  right: 20),
                                                          child: Text(
                                                            'Date',
                                                            style: TextStyle(
                                                                height: 0,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        WaveSlider(
                                                          color: Colors.white,
                                                          sliderWidth:
                                                              size.width / 1.8,
                                                          onChanged:
                                                              (double val) {
                                                            setState(() {
                                                              _date = ((val * 100) /
                                                                              3.3)
                                                                          .round() ==
                                                                      0
                                                                  ? 1
                                                                  : ((val * 100) /
                                                                          3.3)
                                                                      .round();
                                                            });
                                                            // year log('${(DateTime.now().year - 100 + ((val * 100)).round())}');
                                                          },
                                                          onChangeEnd:
                                                              (double value) {},
                                                          onChangeStart:
                                                              (double value) {},
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20),
                                                          width: 40,
                                                          height: 40,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            color: Colors.white,
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              _date.toString(),
                                                              style:
                                                                  const TextStyle(
                                                                      //height: 0,
                                                                      color: Colors
                                                                          .grey),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 80,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 20,
                                                                  right: 10),
                                                          child: Text(
                                                            'Month',
                                                            style: TextStyle(
                                                                height: 0,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        WaveSlider(
                                                          color: Colors.white,
                                                          sliderWidth:
                                                              size.width / 1.8,
                                                          onChanged:
                                                              (double val) {
                                                            setState(() {
                                                              _month = ((val * 100) /
                                                                              8.3)
                                                                          .round() >
                                                                      11
                                                                  ? 11
                                                                  : ((val * 100) /
                                                                          8.3)
                                                                      .round();
                                                            });
                                                            // year log('${(DateTime.now().year - 100 + ((val * 100)).round())}');
                                                          },
                                                          onChangeEnd:
                                                              (double value) {},
                                                          onChangeStart:
                                                              (double value) {},
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20),
                                                          width: 40,
                                                          height: 40,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            color: Colors.white,
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              month[_month],
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 80,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 20,
                                                                  right: 20),
                                                          child: Text(
                                                            'Year',
                                                            style: TextStyle(
                                                                height: 0,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        WaveSlider(
                                                          color: Colors.white,
                                                          sliderWidth:
                                                              size.width / 1.8,
                                                          onChanged:
                                                              (double val) {
                                                            setState(() {
                                                              _year = (DateTime
                                                                          .now()
                                                                      .year -
                                                                  100 +
                                                                  ((val * 100))
                                                                      .round());
                                                            });
                                                            // year log('${(DateTime.now().year - 100 + ((val * 100)).round())}');
                                                          },
                                                          onChangeEnd:
                                                              (double value) {},
                                                          onChangeStart:
                                                              (double value) {},
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            color: Colors.white,
                                                          ),
                                                          width: 40,
                                                          height: 40,
                                                          child: Center(
                                                            child: Text(
                                                              _year.toString(),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    const Spacer(),
                                                    Align(
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(15.0),
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
                                                                onPressed: () {
                                                                  controller.nextPage(
                                                                      duration: const Duration(
                                                                          seconds:
                                                                              1),
                                                                      curve: Curves
                                                                          .easeInOut);
                                                                  // context
                                                                  //     .read<
                                                                  //         ProfileInfoProvider>()
                                                                  //     .updateProfileInfo(
                                                                  //         dob: DateTime.parse(''))
                                                                  //     .whenComplete(
                                                                  //         () {
                                                                  //   context
                                                                  //       .read<
                                                                  //           AuthUserDetailsProvider>()
                                                                  //       .getAuthUserDetails()
                                                                  //       .whenComplete(() =>
                                                                  //           setState(() {}));
                                                                  // });
                                                                },
                                                                child: Text(
                                                                  _isSkip[i]
                                                                      ? 'Skip For Now'
                                                                      : "Next",
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
                                                                        () {
                                                                      controller.nextPage(
                                                                          duration: const Duration(
                                                                              seconds:
                                                                                  1),
                                                                          curve:
                                                                              Curves.easeInOut);
                                                                      if (_selectedIndex !=
                                                                          null)
                                                                        context
                                                                            .read<ProfileInfoProvider>()
                                                                            .updateProfileInfo(language: _selectedLang)
                                                                            .whenComplete(() {
                                                                          context
                                                                              .read<VerifyKYCCredential>()
                                                                              .getUserProfileInfo()
                                                                              .whenComplete(() => setState(() {}));
                                                                        });
                                                                    },
                                                                    child: Text(
                                                                      _isSkip[i]
                                                                          ? 'Skip For Now'
                                                                          : "Next",
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
                                          ? 'We will curate content & shopping experience accordingly'
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
                                              ? 'Tell Us Your BIrthdate'
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
