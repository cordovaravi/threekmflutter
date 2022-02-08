import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:animated_widgets/animated_widgets.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:threekm/Custom_library/Polls/simple_polls.dart';
import 'package:threekm/Models/home1_model.dart';
import 'package:threekm/UI/Animation/AnimatedSizeRoute.dart';
import 'package:threekm/UI/Search/SearchPage.dart';
import 'package:threekm/UI/main/News/NewsList.dart';
import 'package:threekm/UI/main/News/PostView.dart';
import 'package:threekm/UI/main/Notification/NotificationPage.dart';
import 'package:threekm/UI/main/navigation.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/providers/main/AddPost_Provider.dart';
import 'package:threekm/providers/main/Quiz_Provider.dart';
import 'package:threekm/providers/main/home1_provider.dart';
import 'package:provider/provider.dart';
import 'package:threekm/providers/main/home2_provider.dart';
import 'package:threekm/utils/threekm_textstyles.dart';
import 'package:threekm/widgets/vimeoPlayer.dart';

import 'Widgets/Adspopup.dart';
import 'package:flutter_svg/svg.dart';

class NewsTab extends StatefulWidget {
  final String? deviceId;
  final bool? reload;
  NewsTab({this.reload, this.deviceId});
  @override
  _NewsTabState createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late final AnimationController _controller;
  String? requestJson;
  int? answerIndex;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    if (widget.reload != true) {
      Future.delayed(Duration.zero, () async {
        String token = await ApiProvider().getToken();
        requestJson = json.encode({
          "lat": "",
          "lng": "",
          "ios": Platform.isAndroid ? false : true,
          "lang": "en",
          "device": widget.deviceId ?? "",
          "token": "$token"
        });
        context
            .read<HomefirstProvider>()
            .getNewsfirst(requestJson)
            .then((value) {
          Future.delayed(Duration(milliseconds: 100), () {
            context.read<HomeSecondProvider>().getNewsSecond(requestJson);
          });
        });
        //context.read<HomeSecondProvider>().getNewsSecond(requestJson);
        context.read<AddPostProvider>();
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final addpostProvider = context.watch<AddPostProvider>();
    if (addpostProvider.ispostUploaded != null &&
        addpostProvider.ispostUploaded == true) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      Future.delayed(Duration(seconds: 1), () {
        CustomSnackBar(context, Text("Post has been submmitted"));
      }).then((value) => addpostProvider.removeSnack());
    } else if (addpostProvider.isUploadError) {
      Future.delayed(Duration(seconds: 1), () {
        CustomSnackBar(context, Text("Upload Failed!"));
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    log("main building");
    final newsFirstProvider = context.watch<HomefirstProvider>();
    final newsSecondProvider = context.watch<HomeSecondProvider>();
    return RefreshIndicator(
      onRefresh: () {
        return context
            .read<HomefirstProvider>()
            .onRefresh(requestJson)
            .then((value) {
          context.read<HomeSecondProvider>().onRefresh(requestJson);
        });
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: EdgeInsets.zero,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchPage(
                                      tabNuber: 0,
                                    )));
                      },
                      child: Container(
                        height: 32,
                        width: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(21),
                            border: Border.all(color: Color(0xffDFE5EE))),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Icon(
                                Icons.search_rounded,
                                color: Colors.grey,
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 11),
                                child: Text(
                                  "Search Hyperlocal News",
                                  style: ThreeKmTextConstants
                                      .tk12PXLatoBlackBold
                                      .copyWith(color: Colors.grey),
                                ))
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            AnimatedSizeRoute(page: Notificationpage()));
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/bell.png")),
                              shape: BoxShape.circle,
                              //color: Color(0xff7572ED)
                            )),
                      ),
                    ),
                    InkWell(
                      onTap: () => drawerController.open!(),
                      child: Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/male-user.png")),
                              shape: BoxShape.circle,
                              //color: Color(0xffFF464B)
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // Banner
            if (newsFirstProvider.homeNewsFirst != null)
              ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                primary: true,
                itemCount: newsFirstProvider
                    .homeNewsFirst!.data!.result!.finalposts!.length,
                itemBuilder: (context, index) {
                  final finalPost = newsFirstProvider
                      .homeNewsFirst!.data!.result!.finalposts![index];
                  if (finalPost.type == "banner" &&
                      finalPost.banners != null &&
                      finalPost.banners?.length != 0) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: 1,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        if (finalPost.banners![i].images!.length > 1 &&
                            finalPost.bannertype == "RWC") {
                          return Padding(
                            padding: EdgeInsets.zero,
                            child: Container(
                                child: CarouselSlider(
                              options: CarouselOptions(
                                aspectRatio: 0.8,
                                enlargeCenterPage: true,
                                scrollDirection: Axis.horizontal,
                                autoPlay: true,
                              ),
                              items: finalPost.banners![i].imageswcta!
                                  .map((items) => GestureDetector(
                                        onTap: () => {
                                          showDialog(
                                            context: context,
                                            builder: (_) => AdspopUp(
                                              phoneNumber:
                                                  items.phone.toString(),
                                              url: items.website.toString(),
                                            ),
                                          )
                                        },
                                        child: Container(
                                          child: CachedNetworkImage(
                                            fit: BoxFit.contain,
                                            imageUrl: items.image.toString(),
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            )),
                          );

                          /// ads carousal
                        } else if (finalPost.bannertype == "BWC") {
                          return finalPost.banners?.length != null
                              ? Column(
                                  children: [
                                    CarouselSlider.builder(
                                      itemCount: finalPost.banners!.length,
                                      itemBuilder: (BuildContext context,
                                              int bannerIndex, heroIndex) =>
                                          InkWell(
                                              onTap: () {
                                                if (finalPost
                                                        .banners![bannerIndex]
                                                        .imageswcta!
                                                        .first
                                                        .post !=
                                                    null) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              NewsListPage(
                                                                title: finalPost
                                                                    .banners![
                                                                        bannerIndex]
                                                                    .imageswcta!
                                                                    .first
                                                                    .header
                                                                    .toString(),
                                                                hasPostfromBanner: finalPost
                                                                    .banners![
                                                                        bannerIndex]
                                                                    .imageswcta!
                                                                    .first
                                                                    .post,
                                                              )));
                                                } else if (finalPost
                                                        .banners![bannerIndex]
                                                        .imageswcta!
                                                        .first
                                                        .video !=
                                                    null) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              VimeoPlayerPage(
                                                                  VimeoUri: finalPost
                                                                      .banners![
                                                                          bannerIndex]
                                                                      .imageswcta!
                                                                      .first
                                                                      .vimeoUrl
                                                                      .toString())));
                                                }
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    top: 4, bottom: 4),
                                                decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                          blurRadius: 10.0,
                                                          color: Colors
                                                              .grey.shade200)
                                                    ],
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: CachedNetworkImage(
                                                    fit: BoxFit.contain,
                                                    width: 1000,
                                                    imageUrl: finalPost
                                                        .banners![bannerIndex]
                                                        .images!
                                                        .first
                                                        .toString()),
                                              )),
                                      options: CarouselOptions(
                                          viewportFraction:
                                              finalPost.banners!.length > 1
                                                  ? 0.85
                                                  : 0.99,
                                          scrollPhysics: finalPost
                                                      .banners!.length >
                                                  1
                                              ? ScrollPhysics()
                                              : NeverScrollableScrollPhysics(),
                                          autoPlayAnimationDuration:
                                              const Duration(
                                                  microseconds: 1200),
                                          autoPlay: true,
                                          enlargeCenterPage: true,
                                          initialPage: 0,
                                          autoPlayInterval:
                                              Duration(seconds: 15),
                                          onPageChanged: (index, reason) {
                                            // setState(() {
                                            //   _current = index;
                                            // });
                                          }),
                                    ),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //      MainAxisAlignment.center,
                                    // children:
                                    //     finalPost.banners!.map((banner) {
                                    //   int index = finalPost.banners!
                                    //       .indexOf(banner);
                                    //   return Container(
                                    //     width: 8.0,
                                    //     height: 8.0,
                                    //     margin: EdgeInsets.symmetric(
                                    //         vertical: 10.0,
                                    //         horizontal: 2.0),
                                    //     decoration: BoxDecoration(
                                    //       shape: BoxShape.circle,
                                    //       color: _current == index
                                    //           ? Color.fromRGBO(0, 0, 0, 0.9)
                                    //           : Color.fromRGBO(
                                    //               0, 0, 0, 0.4),
                                    //     ),
                                    //   );
                                    // }).toList(),
                                    // ),
                                  ],
                                )
                              : Container();
                        }
                        //if condiation not true return empty
                        return Container();
                      },
                    );
                  } else if (finalPost.type == "news_cat") {
                    return NewsContainer(finalPost: finalPost);
                  } else {
                    return Container();
                  }
                },
              )
            else
              Container(),
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            // second Api
            if (newsSecondProvider.homeNews != null)
              ListView.builder(
                itemCount: newsSecondProvider
                    .homeNews!.data!.result!.finalposts!.length,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                //primary: true,
                itemBuilder: (context, index) {
                  final finalScondPost = newsSecondProvider
                      .homeNews!.data!.result!.finalposts![index];
                  if (finalScondPost.type == 'news_cat') {
                    return NewsContainer(finalPost: finalScondPost);
                  } else if (finalScondPost.type == "quiz_carousel") {
                    return Container(
                      child: Text("quiz carousal"),
                    );
                  } else if (finalScondPost.type == "quiz" &&
                      finalScondPost.quiz!.type == "quiz") {
                    if (finalScondPost.quiz?.isAnswered == true) {
                      final alreadyAnsIndex = finalScondPost.quiz!.options!
                          .indexWhere((element) =>
                              element.text == finalScondPost.quiz!.answer);
                      log("ans index is $alreadyAnsIndex");
                      final alredaySelectedIndex = finalScondPost.quiz!.options!
                          .indexWhere((element) =>
                              element.text ==
                              finalScondPost.quiz!.selectedOption);
                      log("selected index is$alredaySelectedIndex");
                      if (mounted) {
                        if (context.read<QuizProvider>().isAnswred == false) {
                          Future.microtask(() => context
                              .read<QuizProvider>()
                              .checkAns(alredaySelectedIndex, alreadyAnsIndex));
                        }
                      }
                    }
                    return Consumer2<QuizProvider, HomeSecondProvider>(
                      builder: (context, quizProvider, _controller, _) {
                        return Container(
                          margin: EdgeInsets.only(
                              top: 8, bottom: 8, left: 4, right: 4),
                          height: MediaQuery.of(context).size.height * 0.7,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: CachedNetworkImageProvider(
                                    finalScondPost.quiz!.image.toString())),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 80,
                                right: 30,
                                left: 30,
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade600,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black38,
                                              blurRadius: 0.8)
                                        ]),
                                    child: ShakeAnimatedWidget(
                                      duration: Duration(microseconds: 800),
                                      shakeAngle: Rotation.radians(z: 0.05),
                                      enabled: quizProvider.shake,
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  finalScondPost.quiz!.question
                                                      .toString(),
                                                  style: ThreeKmTextConstants
                                                      .tk16PXPoppinsWhiteBold,
                                                  textAlign: TextAlign.center),
                                            ),
                                            SizedBox(height: 20),
                                            Container(
                                              padding: EdgeInsets.only(top: 10),
                                              decoration: BoxDecoration(
                                                  color: Colors.white),
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount: finalScondPost
                                                    .quiz!.options!.length,
                                                itemBuilder:
                                                    (context, quizIndex) {
                                                  return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 4,
                                                              right: 4),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          if (finalScondPost
                                                                      .quiz
                                                                      ?.isAnswered ==
                                                                  false ||
                                                              finalScondPost
                                                                      .quiz
                                                                      ?.isAnswered ==
                                                                  null) {
                                                            final ansIndex = finalScondPost
                                                                .quiz!.options!
                                                                .indexWhere((element) =>
                                                                    element
                                                                        .text ==
                                                                    finalScondPost
                                                                        .quiz!
                                                                        .answer);
                                                            log("ans index is $ansIndex");
                                                            context
                                                                .read<
                                                                    QuizProvider>()
                                                                .checkAns(
                                                                    quizIndex,
                                                                    ansIndex);
                                                            context
                                                                .read<
                                                                    QuizProvider>()
                                                                .submitQuiz(
                                                                    finalScondPost
                                                                        .quiz!
                                                                        .quizId!
                                                                        .toInt(),
                                                                    finalScondPost
                                                                        .quiz!
                                                                        .options![
                                                                            quizIndex]
                                                                        .text
                                                                        .toString());
                                                            _controller.submitQuiz(
                                                                quizId:
                                                                    finalScondPost
                                                                        .quiz!
                                                                        .quizId!
                                                                        .toInt());
                                                          }
                                                        },
                                                        child: Container(
                                                            height: 50,
                                                            margin:
                                                                EdgeInsets.all(
                                                                    10),
                                                            decoration:
                                                                BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15),
                                                                    color: Colors
                                                                        .white,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                          color: Colors
                                                                              .black45,
                                                                          blurRadius:
                                                                              8.0)
                                                                    ],
                                                                    border: Border.all(
                                                                        color: quizProvider.isAnswred
                                                                            ? quizIndex == quizProvider.answredIndex
                                                                                ? Colors.green
                                                                                : quizIndex == quizProvider.selectedIndex
                                                                                    ? Colors.red
                                                                                    : Colors.white
                                                                            : Colors.white,
                                                                        width: 2)),
                                                            padding: EdgeInsets.only(left: 15),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  finalScondPost
                                                                      .quiz!
                                                                      .options![
                                                                          quizIndex]
                                                                      .text
                                                                      .toString(),
                                                                  style: ThreeKmTextConstants
                                                                      .tk16PXLatoBlackRegular,
                                                                ),
                                                                if (quizProvider
                                                                    .isAnswred)
                                                                  quizIndex ==
                                                                          quizProvider
                                                                              .answredIndex
                                                                      ? IconConatiner(
                                                                          icon: Icons
                                                                              .check_circle,
                                                                          iconColor: Colors
                                                                              .green)
                                                                      : quizIndex ==
                                                                              quizProvider
                                                                                  .selectedIndex
                                                                          ? IconConatiner(
                                                                              icon: Icons.clear_rounded,
                                                                              iconColor: Colors.redAccent)
                                                                          : SizedBox.shrink()
                                                              ],
                                                            )),
                                                      )
                                                      //  Option(
                                                      //   selectedOptionIndex: finalScondPost
                                                      //               .quiz!
                                                      //               .selectedOption
                                                      //               .toString() ==
                                                      //           finalScondPost
                                                      //               .quiz!
                                                      //               .options![
                                                      //                   quizIndex]
                                                      //               .text
                                                      //       ? quizIndex
                                                      //       : 100,
                                                      //   isAnswred: finalScondPost
                                                      //       .quiz!.isAnswered!,
                                                      //   quizId: finalScondPost
                                                      //       .quiz!.quizId,
                                                      //   text: finalScondPost
                                                      //       .quiz!
                                                      //       .options![quizIndex]
                                                      //       .bullets
                                                      //       .toString(),
                                                      //   index: quizIndex,
                                                      //   option: finalScondPost
                                                      //       .quiz!
                                                      //       .options![quizIndex]
                                                      //       .text
                                                      //       .toString(),
                                                      //   correctAnsIndex: finalScondPost
                                                      //               .quiz!.answer
                                                      //               .toString() ==
                                                      //           finalScondPost
                                                      //               .quiz!
                                                      //               .options![
                                                      //                   quizIndex]
                                                      //               .text
                                                      //       ? quizIndex
                                                      //       : 100,
                                                      // ),
                                                      );
                                                },
                                              ),
                                            )
                                          ]),
                                    )),
                              ),
                              quizProvider.showBlast
                                  ? Positioned(
                                      bottom: 80,
                                      right: 30,
                                      left: 30,
                                      child: Lottie.asset(
                                        'assets/blast.json',
                                      ),
                                    )
                                  : SizedBox.shrink(),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (finalScondPost.type == "quiz" &&
                      finalScondPost.quiz?.type == "poll") {
                    return Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: CachedNetworkImageProvider(
                                  finalScondPost.quiz!.image.toString())),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Spacer(),
                            ClipRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: 10.0, sigmaY: 10.0),
                                child: SimplePollsWidget(
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xffFFFFFF).withOpacity(0.4),
                                  ),
                                  onSelection: (PollFrameModel model,
                                      PollOptions selectedOptionModel) {
                                    context
                                        .read<QuizProvider>()
                                        .submitPollAnswer(
                                            answer: selectedOptionModel.label,
                                            quizId: finalScondPost.quiz!.id!
                                                .toInt());
                                    print('Now total polls are : ' +
                                        model.totalPolls.toString());
                                    print('Selected option has label : ' +
                                        selectedOptionModel.label);
                                  },

                                  optionsBorderShape:
                                      StadiumBorder(), //Its Default so its not necessary to write this line
                                  model: PollFrameModel(
                                      title: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                            finalScondPost.quiz!.question
                                                .toString(),
                                            style: ThreeKmTextConstants
                                                .tk14PXPoppinsBlackBold),
                                      ),
                                      totalPolls: 100,
                                      endTime: DateTime.now()
                                          .toUtc()
                                          .add(Duration(days: 10)),
                                      hasVoted:
                                          finalScondPost.quiz!.isAnswered!,
                                      editablePoll: false,
                                      options: finalScondPost.quiz!.options!
                                          .map((option) {
                                        print(option.dPercent.toString());
                                        print(option.percent);
                                        print(option.count);
                                        return PollOptions(
                                            netWorkPersentage: option.percent,
                                            label: option.text.toString(),
                                            pollsCount: option.percent != 0 &&
                                                    option.percent != null
                                                ? option.percent!.toInt()
                                                : 0,
                                            id: UniqueKey());
                                      }).toList()),
                                ),
                              ),
                            )
                          ],
                        ));
                  }
                  // else if (finalScondPost.type == "product") {
                  //   return Container(
                  //     padding: EdgeInsets.only(
                  //         left: 10, right: 10, top: 15, bottom: 20),
                  //     margin: EdgeInsets.all(8),
                  //     decoration: BoxDecoration(
                  //         color: Colors.black,
                  //         borderRadius: BorderRadius.circular(20)),
                  //     child: Column(
                  //       children: [
                  //         Text("3km Exclusive Products",
                  //             style:
                  //                 ThreeKmTextConstants.tk16PXPoppinsWhiteBold),
                  //         SizedBox(
                  //           height: 10,
                  //         ),
                  //         Text(
                  //             "Get exclusive product delivered\n at your doorsteps",
                  //             textAlign: TextAlign.center,
                  //             style: ThreeKmTextConstants
                  //                 .tk12PXPoppinsWhiteRegular),
                  //         Container(
                  //           //color: Colors.amber,
                  //           width: double.infinity,
                  //           height: 300,
                  //           child: ListView.builder(
                  //             physics: BouncingScrollPhysics(),
                  //             shrinkWrap: true,
                  //             scrollDirection: Axis.horizontal,
                  //             itemCount: finalScondPost.products!.length,
                  //             itemBuilder: (context, productIndex) {
                  //               return Container(
                  //                 margin: EdgeInsets.all(10),
                  //                 //height: 250,
                  //                 width: 200,
                  //                 decoration: BoxDecoration(
                  //                     color: Colors.white,
                  //                     borderRadius:
                  //                         BorderRadius.all(Radius.circular(7)),
                  //                     boxShadow: [
                  //                       BoxShadow(
                  //                           color: Colors.black26,
                  //                           blurRadius: 10.0,
                  //                           offset: Offset(0.0, 10.0))
                  //                     ]),
                  //                 child: Column(children: [
                  //                   Flexible(
                  //                     flex: 8,
                  //                     child: CachedNetworkImage(
                  //                         imageUrl: finalScondPost
                  //                             .products![productIndex].image
                  //                             .toString()),
                  //                   ),
                  //                   Flexible(
                  //                       flex: 2,
                  //                       child: Text(finalScondPost
                  //                           .products![productIndex].name
                  //                           .toString()))
                  //                 ]),
                  //               );
                  //             },
                  //           ),
                  //         ),
                  //         MaterialButton(
                  //           color: Colors.redAccent,
                  //           onPressed: () {},
                  //           child: Text("Shop 3km Exclusive",
                  //               style: ThreeKmTextConstants
                  //                   .tk14PXWorkSansWhiteMedium),
                  //         )
                  //       ],
                  //     ),
                  //   );
                  // }
                  else if (finalScondPost.type == "bod") {
                    return //Text("dob");
                        //  HtmlWidget(
                        //     finalScondPost.business!.submittedStory.toString());
                        Container(
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xff645AFF),
                              Color(0xffA573FF)
                            ],
                            begin: FractionalOffset(0.0, 0.0),
                            end: FractionalOffset(1.0, 1.0),
                            stops: <double>[0.0, 1.0],
                            tileMode: TileMode.clamp),
                      ),
                      padding: EdgeInsets.all(15),
                      width: MediaQuery.of(context).size.width,
                      // margin: EdgeInsets.all(15),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Highlight",
                              style:
                                  ThreeKmTextConstants.tk16PXPoppinsWhiteBold,
                            ),
                            SizedBox(height: 50),
                            Container(
                              height: 347,
                              width: 247,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.white),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    height: 215,
                                    width: 215,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              finalScondPost.business!.videos!
                                                  .first.thumbnail
                                                  .toString()),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    // child: Stack(
                                    //   children: [
                                    //     Positioned(
                                    //       bottom: 38,
                                    //       left: 45,
                                    //       top: 153,
                                    //       right: 146,
                                    //       child: Container(
                                    //           child: Center(
                                    //             child: Icon(Icons
                                    //                 .arrow_forward_rounded),
                                    //           ),
                                    //           height: 24,
                                    //           width: 24,
                                    //           decoration: BoxDecoration(
                                    //               shape: BoxShape.circle,
                                    //               color: Colors.white)),
                                    //     )
                                    //   ],
                                    // ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    finalScondPost.business!.author!.name
                                        .toString(),
                                    style: ThreeKmTextConstants
                                        .tk18PXLatoBlackMedium,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    finalScondPost.business?.headline
                                            .toString() ??
                                        "",
                                    style:
                                        ThreeKmTextConstants.tk11PXLatoGreyBold,
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            AnimatedSizeRoute(
                                                page: Postview(
                                                    postId: finalScondPost
                                                        .business!.postId
                                                        .toString())));
                                      },
                                      child: Text("Read More"))
                                ],
                              ),
                            )
                          ]),
                    );
                  }
                  return Container();
                },
              )
            else
              Container()
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class IconConatiner extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  IconConatiner({Key? key, required this.icon, required this.iconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(right: 18),
        height: 24,
        width: 24,
        child: Icon(icon, color: iconColor),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ));
  }
}

/// Custom Container to show News card
class NewsContainer extends StatelessWidget {
  final Finalpost finalPost;

  NewsContainer({required this.finalPost, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 5),
        height: 280,
        // width: double.infinity,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.zero,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: this.finalPost.category?.icon != null
                                  ? NetworkImage(
                                      this.finalPost.category!.icon.toString())
                                  : NetworkImage(
                                      "https://png.pngitem.com/pimgs/s/378-3788573_white-circle-fade-transparent-png-download-white-fade.png"))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: finalPost.category?.name != null
                        ? Text(finalPost.category!.name.toString(),
                            style:
                                ThreeKmTextConstants.tk16PXPoppinsBlackMedium)
                        : Text(""),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.of(context).push(NewsListRoute(
                              title: finalPost.category!.name.toString()));
                        },
                        icon: Icon(
                          Icons.arrow_forward,
                          color: Colors.blue,
                        )),
                  )
                ],
              ),
            ),
            Container(
              height: 220,
              width: double.infinity,
              color: Colors.white,
              child: finalPost.category?.posts != null
                  ? ListView.builder(
                      cacheExtent: 9999,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: finalPost.category!.posts!.length,
                      itemBuilder: (context, postIndex) {
                        final contentPost = finalPost.category!.posts;
                        return InkWell(
                          onTap: () {
                            log("ontap Created date value ${contentPost![postIndex].postCreatedDate}");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Postview(
                                        image: contentPost[postIndex]
                                            .image
                                            .toString(),
                                        postId: contentPost[postIndex]
                                            .postId
                                            .toString())));
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 13),
                            child: Container(
                                height: 195,
                                width: 147,
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.shade300,
                                          blurRadius: 8)
                                    ]),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                          height: 100,
                                          width: 157,
                                          margin: EdgeInsets.only(top: 2),
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              boxShadow: [
                                                BoxShadow(
                                                    // blurStyle: BlurStyle.outer,
                                                    color: Colors.black26,
                                                    blurRadius: 0.8)
                                              ],
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight:
                                                      Radius.circular(10)),
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image:
                                                      CachedNetworkImageProvider(
                                                          contentPost![
                                                                  postIndex]
                                                              .image
                                                              .toString()))),
                                          child: Stack(
                                            children: [
                                              contentPost[postIndex]
                                                          .postCreatedDate !=
                                                      ""
                                                  ? Positioned(
                                                      bottom: 0,
                                                      child: Container(
                                                          height: 21,
                                                          width: 75,
                                                          decoration: BoxDecoration(
                                                              color: Color(
                                                                  0xff0F0F2D),
                                                              borderRadius: BorderRadius.only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          10))),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 4),
                                                            child: Text(
                                                              contentPost[
                                                                      postIndex]
                                                                  .postCreatedDate
                                                                  .toString(),
                                                              style: ThreeKmTextConstants
                                                                  .tk12PXPoppinsWhiteRegular,
                                                            ),
                                                          )),
                                                    )
                                                  : SizedBox(),
                                              contentPost[postIndex]
                                                          .video
                                                          .toString() !=
                                                      ""
                                                  ? Center(
                                                      child: Container(
                                                        child: SvgPicture.asset(
                                                          "assets/playicon.svg",
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox.shrink()
                                            ],
                                          )),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 95,
                                        width: 150,
                                        padding:
                                            EdgeInsets.only(left: 8, right: 8),
                                        child: Text(
                                            contentPost[postIndex]
                                                .headline
                                                .toString(),
                                            overflow: TextOverflow.fade,
                                            style: ThreeKmTextConstants
                                                .tk14PXPoppinsBlackSemiBold),
                                      ),
                                    ])),
                          ),
                        );
                      },
                    )
                  : Container(),
            )
          ],
        ));
  }
}

class NewsListRoute extends CupertinoPageRoute {
  final String title;
  NewsListRoute({required this.title})
      : super(
            builder: (BuildContext context) => new NewsListPage(title: title));

  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(
        opacity: animation, child: NewsListPage(title: title));
  }
}

// class Option extends StatelessWidget {
//   const Option(
//       {required this.text,
//       required this.index,
//       required this.option,
//       required this.quizId,
//       required this.isAnswred,
//       required this.selectedOptionIndex,
//       //required this.rightAnswer,
//       this.correctAnsIndex});
//   final String option;
//   final String text;
//   final int index;
//   final int? correctAnsIndex;
//   final int? quizId;
//   final bool isAnswred;
//   final int selectedOptionIndex;
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<QuizProvider>(builder: (context, model, _) {
//       Color getTheRightColor() {
//         if (model.isAnswred) {
//           if (model.answredIndex == model.selectedIndex &&
//               index == correctAnsIndex) {
//             return Colors.green;
//           } else if (index == model.selectedIndex) {
//             return Colors.red;
//           }
//         }
//         return Colors.grey;
//       }

//       Color GetColorAlreadyAnwer(
//           {required int answerIndex,
//           required int index,
//           required int selectedIndex}) {
//         if (index == answerIndex && index == selectedIndex) {
//           return Colors.green;
//         } else if (index == selectedIndex) {
//           return Colors.red;
//         }
//         return Colors.grey;
//       }

//       return GestureDetector(
//         onTap: this.isAnswred == null || this.isAnswred == false
//             ? () {
//                 context.read<QuizProvider>().checkAns(index, correctAnsIndex!);
//                 print(index);
//                 print(this.option);
//                 context.read<QuizProvider>().submitQuiz(quizId!, this.option);
//                 context.read<HomefirstProvider>().submitQuiz(quizId: quizId!);
//               }
//             : null,
//         child: Padding(
//           padding: const EdgeInsets.only(bottom: 8),
//           child: Container(
//             padding: EdgeInsets.all(3),
//             decoration: BoxDecoration(
//                 border: Border.all(
//                     color: this.isAnswred == true
//                         ? GetColorAlreadyAnwer(
//                             selectedIndex: this.selectedOptionIndex,
//                             index: this.index,
//                             answerIndex: this.correctAnsIndex!)
//                         : getTheRightColor(),
//                     width: 1),
//                 borderRadius: BorderRadius.circular(20),
//                 color: Colors.white),
//             child: Row(children: [
//               Container(
//                 height: 30,
//                 width: 30,
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                       color: this.isAnswred == true
//                           ? GetColorAlreadyAnwer(
//                               selectedIndex: this.selectedOptionIndex,
//                               index: this.index,
//                               answerIndex: this.correctAnsIndex!)
//                           : getTheRightColor()),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Center(
//                   child: Text(this.text),
//                 ),
//               ),
//               Container(
//                   child: Padding(
//                 padding: const EdgeInsets.only(left: 8),
//                 child: Text(this.option),
//               ))
//             ]),
//           ),
//         ),
//       );
//     });
//   }
// }
