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
import 'package:threekm/UI/Search/SearchPage.dart';
import 'package:threekm/UI/main/News/NewsList.dart';
import 'package:threekm/UI/main/News/PostView.dart';
import 'package:threekm/UI/main/navigation.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/providers/main/AddPost_Provider.dart';
import 'package:threekm/providers/main/AthorProfile_Provider.dart';
import 'package:threekm/providers/main/Quiz_Provider.dart';
import 'package:threekm/providers/main/home1_provider.dart';
import 'package:provider/provider.dart';
import 'package:threekm/providers/main/home2_provider.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

import 'Widgets/Adspopup.dart';

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
    final addpostProvider = context.watch<AddPostProvider>();
    if (addpostProvider.ispostUploaded != null &&
        addpostProvider.ispostUploaded == true) {
      Future.delayed(Duration(seconds: 1), () {
        CustomSnackBar(context, Text("Post has been submmitted"));
      }).then((value) => addpostProvider.removeSnack());
    } else if (addpostProvider.isUploadError) {
      Future.delayed(Duration(seconds: 1), () {
        CustomSnackBar(context, Text("Upload Failed!"));
      });
    }
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
                    Padding(
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
                                          GestureDetector(
                                              child: Container(
                                        //BouncingWidget(
                                        // scaleFactor: 1.5,
                                        // onPressed: () {
                                        //   print("ontap");
                                        // },
                                        child: CachedNetworkImage(
                                            fit: BoxFit.cover,
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
                    //return Container(child: Text("quiz"));
                    return Consumer<QuizProvider>(
                      builder: (context, quizProvider, _) {
                        // print(quizProvider.shake);
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
                                    //padding: EdgeInsets.all(10),
                                    //height: 300,
                                    //width: 250,
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
                                                  // print(finalScondPost
                                                  //     .quiz!.selectedOption);
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 4, right: 4),
                                                    child: Option(
                                                      selectedOptionIndex: finalScondPost
                                                                  .quiz!
                                                                  .selectedOption
                                                                  .toString() ==
                                                              finalScondPost
                                                                  .quiz!
                                                                  .options![
                                                                      quizIndex]
                                                                  .text
                                                          ? quizIndex
                                                          : 100,
                                                      // finalScondPost.quiz!
                                                      //             .answer
                                                      //             .toString() ==
                                                      //         finalScondPost
                                                      //             .quiz!
                                                      //             .selectedOption
                                                      //     ? quizIndex
                                                      //     : 100,
                                                      isAnswred: finalScondPost
                                                          .quiz!.isAnswered!,
                                                      quizId: finalScondPost
                                                          .quiz!.quizId,
                                                      text: finalScondPost
                                                          .quiz!
                                                          .options![quizIndex]
                                                          .bullets
                                                          .toString(),
                                                      index: quizIndex,
                                                      option: finalScondPost
                                                          .quiz!
                                                          .options![quizIndex]
                                                          .text
                                                          .toString(),
                                                      correctAnsIndex: finalScondPost
                                                                  .quiz!.answer
                                                                  .toString() ==
                                                              finalScondPost
                                                                  .quiz!
                                                                  .options![
                                                                      quizIndex]
                                                                  .text
                                                          ? quizIndex
                                                          : 100,
                                                      //rightAnswer: finalScondPost.quiz!.answer.toString()
                                                    ),
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
                            SimplePollsWidget(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(17),
                                  color: Colors.white),
                              onSelection: (PollFrameModel model,
                                  PollOptions selectedOptionModel) {
                                context.read<QuizProvider>().submitPollAnswer(
                                    answer: selectedOptionModel.label,
                                    quizId: finalScondPost.quiz!.id!.toInt());
                                print('Now total polls are : ' +
                                    model.totalPolls.toString());
                                print('Selected option has label : ' +
                                    selectedOptionModel.label);
                              },

                              optionsBorderShape:
                                  StadiumBorder(), //Its Default so its not necessary to write this line
                              model: PollFrameModel(
                                  title: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      finalScondPost.quiz!.question.toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  totalPolls: 100,
                                  endTime: DateTime.now()
                                      .toUtc()
                                      .add(Duration(days: 10)),
                                  hasVoted: finalScondPost.quiz!.isAnswered!,
                                  editablePoll: false,
                                  options: finalScondPost.quiz!.options!
                                      .map((option) {
                                    print(option.dPercent.toString());
                                    print(option.percent);
                                    print(option.count);
                                    return PollOptions(
                                        label: option.text.toString(),
                                        pollsCount: option.percent != 0 &&
                                                option.percent != null
                                            ? option.percent!.toInt()
                                            : 0,
                                        id: UniqueKey());
                                  }).toList()),
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
                              "Business of the Day",
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
                                                  .toString())),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          bottom: 38,
                                          left: 45,
                                          top: 153,
                                          right: 146,
                                          child: Container(
                                              child: Center(
                                                child: Icon(Icons
                                                    .arrow_forward_rounded),
                                              ),
                                              height: 24,
                                              width: 24,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white)),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
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
                                    finalScondPost.business?.tags!
                                            .sublist(2)
                                            .join(", ")
                                            .toString() ??
                                        "",
                                    style:
                                        ThreeKmTextConstants.tk11PXLatoGreyBold,
                                  )
                                ],
                              ),
                            )
                          ]),
                      // child: Column(
                      //   mainAxisSize: MainAxisSize.min,
                      //   children: [
                      //     Row(
                      //       children: [
                      //         Padding(
                      //           padding: const EdgeInsets.only(left: 8),
                      //           child: Container(
                      //             height: 30,
                      //             width: 30,
                      //             decoration: BoxDecoration(
                      //                 shape: BoxShape.circle,
                      //                 image: DecorationImage(
                      //                     image: CachedNetworkImageProvider(
                      //                         finalScondPost
                      //                             .business!.author!.image
                      //                             .toString()))),
                      //           ),
                      //         ),
                      //         Padding(
                      //             padding: EdgeInsets.only(left: 8),
                      //             child: Text(
                      //               finalScondPost.business!.author!.name
                      //                   .toString(),
                      //               style: ThreeKmTextConstants
                      //                   .tk14PXPoppinsBlackMedium,
                      //             ))
                      //       ],
                      //     ),
                      //     Padding(
                      //       padding: EdgeInsets.all(8),
                      //       child: HtmlWidget(finalScondPost
                      //           .business!.submittedStory
                      //           .toString()),
                      //     ),
                      //     CachedNetworkImage(
                      //         imageUrl: finalScondPost
                      //             .business!.videos!.first.thumbnail
                      //             .toString())
                      //   ],
                      // ),
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
              //margin: EdgeInsets.only(bottom: 12),
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Postview(
                                        image: contentPost![postIndex]
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
                                          decoration: BoxDecoration(
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
                                                          null ||
                                                      contentPost[postIndex]
                                                          .postCreatedDate!
                                                          .isNotEmpty
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

class Option extends StatelessWidget {
  const Option(
      {required this.text,
      required this.index,
      required this.option,
      required this.quizId,
      required this.isAnswred,
      required this.selectedOptionIndex,
      //required this.rightAnswer,
      this.correctAnsIndex});
  final String option;
  final String text;
  final int index;
  final int? correctAnsIndex;
  final int? quizId;
  final bool isAnswred;
  final int selectedOptionIndex;
  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(builder: (context, model, _) {
      Color getTheRightColor() {
        if (model.isAnswred) {
          if (model.answredIndex == model.selectedIndex &&
              index == correctAnsIndex) {
            return Colors.green;
          } else if (index == model.selectedIndex) {
            return Colors.red;
          }
        }
        return Colors.grey;
      }

      Color GetColorAlreadyAnwer(
          {required int answerIndex,
          required int index,
          required int selectedIndex}) {
        if (index == answerIndex && index == selectedIndex) {
          return Colors.green;
        } else if (index == selectedIndex) {
          return Colors.red;
        }
        return Colors.grey;
      }

      return GestureDetector(
        onTap: this.isAnswred == null || this.isAnswred == false
            ? () {
                context.read<QuizProvider>().checkAns(index, correctAnsIndex!);
                print(index);
                print(this.option);
                context.read<QuizProvider>().submitQuiz(quizId!, this.option);
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
                border: Border.all(
                    color: this.isAnswred == true
                        ? GetColorAlreadyAnwer(
                            selectedIndex: this.selectedOptionIndex,
                            index: this.index,
                            answerIndex: this.correctAnsIndex!)
                        : getTheRightColor(),
                    width: 1),
                borderRadius: BorderRadius.circular(20),
                color: Colors.white),
            child: Row(children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: this.isAnswred == true
                          ? GetColorAlreadyAnwer(
                              selectedIndex: this.selectedOptionIndex,
                              index: this.index,
                              answerIndex: this.correctAnsIndex!)
                          : getTheRightColor()),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(this.text),
                ),
              ),
              Container(
                  child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(this.option),
              ))
            ]),
          ),
        ),
      );
    });
  }
}
