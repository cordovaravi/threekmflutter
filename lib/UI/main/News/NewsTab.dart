import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:threekm/Custom_library/BouncingWidget.dart';
import 'package:threekm/Models/home1_model.dart';
import 'package:threekm/UI/main/News/NewsList.dart';
import 'package:threekm/UI/main/News/PostView.dart';
import 'package:threekm/providers/main/Quiz_Provider.dart';
import 'package:threekm/providers/main/home1_provider.dart';
import 'package:provider/provider.dart';
import 'package:threekm/providers/main/home2_provider.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

import 'Widgets/Adspopup.dart';

class NewsTab extends StatefulWidget {
  final String? deviceId;
  NewsTab({this.deviceId});
  @override
  _NewsTabState createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> with AutomaticKeepAliveClientMixin {
  String? requestJson;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      requestJson = json.encode({
        "lat": "",
        "lng": "",
        "ios": Platform.isAndroid ? false : true,
        "lang": "en",
        "device": widget.deviceId ?? ""
      });
      context.read<HomefirstProvider>().getNewsfirst(requestJson).then((value) {
        Future.delayed(Duration(milliseconds: 100), () {
          context.read<HomeSecondProvider>().getNewsSecond(requestJson);
        });
      });
      //context.read<HomeSecondProvider>().getNewsSecond(requestJson);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                  return finalPost.type == "banner"
                      ? ListView.builder(
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
                                                imageUrl:
                                                    items.image.toString(),
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
                              return Column(
                                children: [
                                  CarouselSlider.builder(
                                    itemCount: finalPost.banners!.length,
                                    itemBuilder: (BuildContext context,
                                            int bannerIndex, heroIndex) =>
                                        GestureDetector(
                                            child: BouncingWidget(
                                      scaleFactor: 1.5,
                                      onPressed: () {
                                        print("ontap");
                                      },
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
                                                : 0.95,
                                        scrollPhysics: finalPost
                                                    .banners!.length >
                                                1
                                            ? ScrollPhysics()
                                            : NeverScrollableScrollPhysics(),
                                        autoPlayAnimationDuration:
                                            const Duration(microseconds: 1200),
                                        autoPlay: true,
                                        enlargeCenterPage: true,
                                        initialPage: 0,
                                        autoPlayInterval: Duration(seconds: 15),
                                        onPageChanged: (index, reason) {
                                          setState(() {
                                            _current = index;
                                          });
                                        }),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: finalPost.banners!.map((banner) {
                                      int index =
                                          finalPost.banners!.indexOf(banner);
                                      return Container(
                                        width: 8.0,
                                        height: 8.0,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 2.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: _current == index
                                              ? Color.fromRGBO(0, 0, 0, 0.9)
                                              : Color.fromRGBO(0, 0, 0, 0.4),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              );
                            }
                            //if condiation not true return empty
                            return Container();
                          },
                        )
                      // news container
                      : NewsContainer(finalPost: finalPost);
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
                  } else if (finalScondPost.type == "quiz") {
                    //return Container(child: Text("quiz"));
                    return Consumer<QuizProvider>(
                      builder: (context, quizProvider, _) {
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
                                    padding: EdgeInsets.all(10),
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
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                              finalScondPost.quiz!.question
                                                  .toString(),
                                              style: ThreeKmTextConstants
                                                  .tk16PXPoppinsWhiteBold,
                                              textAlign: TextAlign.center),
                                          SizedBox(height: 20),
                                          Container(
                                            padding: EdgeInsets.only(top: 10),
                                            decoration: BoxDecoration(),
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: finalScondPost
                                                  .quiz!.options!.length,
                                              itemBuilder:
                                                  (context, quizIndex) {
                                                return Option(
                                                  text: finalScondPost
                                                      .quiz!
                                                      .options![quizIndex]
                                                      .bullets
                                                      .toString(),
                                                  index: quizIndex,
                                                  option: finalScondPost.quiz!
                                                      .options![quizIndex].text
                                                      .toString(),
                                                  correctAnsIndex:
                                                      finalScondPost
                                                                  .quiz!.answer
                                                                  .toString() ==
                                                              finalScondPost
                                                                  .quiz!
                                                                  .options![
                                                                      quizIndex]
                                                                  .text
                                                          ? quizIndex
                                                          : 100,
                                                );
                                                // return GestureDetector(
                                                //   onTap: () {

                                                //   },
                                                //   child: Padding(
                                                //     padding:
                                                //         const EdgeInsets.only(
                                                //             bottom: 8),
                                                //     child: Container(
                                                //       padding: EdgeInsets.all(3),
                                                //       decoration: BoxDecoration(
                                                //           borderRadius:
                                                //               BorderRadius
                                                //                   .circular(20),
                                                //           color: quizProvider
                                                //               .provideColor),
                                                //       child: Row(children: [
                                                //         Container(
                                                //           height: 30,
                                                //           width: 30,
                                                //           decoration:
                                                //               BoxDecoration(
                                                //             border: Border.all(
                                                //                 color:
                                                //                     Colors.black),
                                                //             shape:
                                                //                 BoxShape.circle,
                                                //           ),
                                                //           child: Center(
                                                //             child: Text(
                                                //                 finalScondPost
                                                //                     .quiz!
                                                //                     .options![
                                                //                         quizIndex]
                                                //                     .bullets
                                                //                     .toString()),
                                                //           ),
                                                //         ),
                                                //         Container(
                                                //             child: Padding(
                                                //           padding:
                                                //               const EdgeInsets
                                                //                   .only(left: 8),
                                                //           child: Text(
                                                //               finalScondPost
                                                //                   .quiz!
                                                //                   .options![
                                                //                       quizIndex]
                                                //                   .text
                                                //                   .toString()),
                                                //         ))
                                                //       ]),
                                                //     ),
                                                //   ),
                                                // );
                                              },
                                            ),
                                          )
                                        ])),
                              )
                            ],
                          ),
                        );
                      },
                    );
                    // if (finalScondPost.quiz!.type == "poll") {
                    //   return Container(
                    //     height: MediaQuery.of(context).size.height * 0.6,
                    //     width: MediaQuery.of(context).size.width,
                    //     decoration: BoxDecoration(
                    //         image: DecorationImage(
                    //             fit: BoxFit.cover,
                    //             image: CachedNetworkImageProvider(
                    //                 finalScondPost.quiz!.image.toString()))),
                    //     child: Stack(
                    //       children: [
                    //         Positioned(
                    //           bottom: 20,
                    //           left: 20,
                    //           right: 20,
                    //           child: Container(
                    //             height: 150,
                    //             width: 300,
                    //             //color: Colors.amber,
                    //             child: Column(
                    //                 mainAxisAlignment: MainAxisAlignment.start,
                    //                 children: [
                    //                   Text(
                    //                     finalScondPost.quiz!.question
                    //                         .toString(),
                    //                     textAlign: TextAlign.center,
                    //                     style: ThreeKmTextConstants
                    //                         .tk16PXPoppinsWhiteBold,
                    //                   ),
                    //                   Container(
                    //                     child: Row(
                    //                       children: [
                    //                         Flexible(
                    //                             fit: FlexFit.tight,
                    //                             flex: 1,
                    //                             child: Container(
                    //                               decoration: BoxDecoration(
                    //                                   borderRadius:
                    //                                       BorderRadius.circular(
                    //                                           20)),
                    //                               height: 60,
                    //                               //color: Colors.black12,
                    //                               child: Center(
                    //                                 child: Text(
                    //                                   finalScondPost.quiz!
                    //                                       .options!.first.text
                    //                                       .toString(),
                    //                                   style: ThreeKmTextConstants
                    //                                       .tk12PXPoppinsWhiteRegular,
                    //                                 ),
                    //                               ),
                    //                             )),
                    //                         Flexible(
                    //                             fit: FlexFit.tight,
                    //                             flex: 1,
                    //                             child: Container(
                    //                               height: 60,
                    //                               child: Center(
                    //                                 child: Text(
                    //                                   finalScondPost.quiz!
                    //                                       .options!.last.text
                    //                                       .toString(),
                    //                                   style: ThreeKmTextConstants
                    //                                       .tk12PXPoppinsWhiteRegular,
                    //                                 ),
                    //                               ),
                    //                             ))
                    //                       ],
                    //                     ),
                    //                   )
                    //                   // Polls(children: [
                    //                   //   Poll
                    //                   // ],
                    //                   // question: Text( finalScondPost.quiz!.question
                    //                   //       .toString()),
                    //                   // voteData: voteData,
                    //                   // currentUser: currentUser,
                    //                   // creatorID: creatorID)
                    //                 ]),
                    //           ),
                    //         )
                    //       ],
                    //     ),
                    //   );
                    // }
                    //else
                    // if (finalScondPost.quiz!.type == "quiz") {
                    //   return Container(
                    //     height: MediaQuery.of(context).size.height * 0.6,
                    //     width: MediaQuery.of(context).size.width,
                    //     decoration: BoxDecoration(
                    //       image: DecorationImage(
                    //           image: CachedNetworkImageProvider(
                    //               finalScondPost.quiz!.image.toString())),
                    //     ),
                    //     child: Stack(
                    //       children: [
                    //         Positioned(
                    //           bottom: 80,
                    //           right: 30,
                    //           left: 30,
                    //           child: Container(
                    //               padding: EdgeInsets.all(10),
                    //               //height: 300,
                    //               //width: 250,
                    //               decoration: BoxDecoration(
                    //                   color: Colors.grey.shade600,
                    //                   borderRadius: BorderRadius.circular(20),
                    //                   boxShadow: [
                    //                     BoxShadow(
                    //                         color: Colors.black38,
                    //                         blurRadius: 0.8)
                    //                   ]),
                    //               child: Column(
                    //                   mainAxisSize: MainAxisSize.min,
                    //                   children: [
                    //                     Text(
                    //                       finalScondPost.quiz!.question
                    //                           .toString(),
                    //                       style: ThreeKmTextConstants
                    //                           .tk16PXPoppinsWhiteBold,
                    //                     ),
                    //                     SizedBox(height: 20),
                    //                     ListView.builder(
                    //                       shrinkWrap: true,
                    //                       physics:
                    //                           NeverScrollableScrollPhysics(),
                    //                       itemCount: finalScondPost
                    //                           .quiz!.options!.length,
                    //                       itemBuilder: (context, quizIndex) {
                    //                         return Padding(
                    //                           padding: const EdgeInsets.only(
                    //                               bottom: 8),
                    //                           child: Container(
                    //                             padding: EdgeInsets.all(3),
                    //                             decoration: BoxDecoration(
                    //                                 borderRadius:
                    //                                     BorderRadius.circular(
                    //                                         20),
                    //                                 color: Colors.white),
                    //                             child: Row(children: [
                    //                               Container(
                    //                                 height: 30,
                    //                                 width: 30,
                    //                                 decoration: BoxDecoration(
                    //                                   border: Border.all(
                    //                                       color: Colors.black),
                    //                                   shape: BoxShape.circle,
                    //                                 ),
                    //                                 child: Center(
                    //                                   child: Text(finalScondPost
                    //                                       .quiz!
                    //                                       .options![quizIndex]
                    //                                       .bullets
                    //                                       .toString()),
                    //                                 ),
                    //                               ),
                    //                               Container(
                    //                                   child: Padding(
                    //                                 padding:
                    //                                     const EdgeInsets.only(
                    //                                         left: 8),
                    //                                 child: Text(finalScondPost
                    //                                     .quiz!
                    //                                     .options![quizIndex]
                    //                                     .text
                    //                                     .toString()),
                    //                               ))
                    //                             ]),
                    //                           ),
                    //                         );
                    //                       },
                    //                     )
                    //                   ])),
                    //         )
                    //       ],
                    //     ),
                    //   );
                    // }
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
        height: 210,
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  this.finalPost.category!.icon.toString()))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(finalPost.category!.name.toString()),
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
              height: 150,
              width: double.infinity,
              child: ListView.builder(
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
                                  image:
                                      contentPost![postIndex].image.toString(),
                                  postId: contentPost[postIndex]
                                      .postId
                                      .toString())));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 145,
                          width: 150,
                          child: Column(children: [
                            Container(
                              height: 100,
                              width: 150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(
                                          contentPost![postIndex]
                                              .image
                                              .toString()))),
                              child: Stack(
                                children: [],
                              ),
                            ),
                            Container(
                              height: 34,
                              width: 150,
                              child: Text(
                                  contentPost[postIndex].headline.toString()),
                            ),
                          ])),
                    ),
                  );
                },
              ),
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
      this.correctAnsIndex});
  final String option;
  final String text;
  final int index;
  final int? correctAnsIndex;
  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(builder: (context, model, _) {
      Color getTheRightColor() {
        if (model.isAnswred) {
          if (model.answredIndex == model.selectedIndex &&
              index == correctAnsIndex) {
            return Colors.green;
          } else if (index == model.selectedIndex &&
              index != model.answredIndex) {
            return Colors.red;
          }
        }
        return Colors.white;
      }

      return GestureDetector(
        onTap: () {
          context.read<QuizProvider>().checkAns(index, correctAnsIndex!);
          print(index);
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
                border: Border.all(color: getTheRightColor(), width: 1),
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey),
            child: Row(children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  border: Border.all(color: getTheRightColor()),
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
    // return GetBuilder<QuestionController>(
    //     init: QuestionController(),
    //     builder: (qnController) {
    //       Color getTheRightColor() {
    //         if (qnController.isAnswered) {
    //           if (index == qnController.correctAns) {
    //             return kGreenColor;
    //           } else if (index == qnController.selectedAns &&
    //               qnController.selectedAns != qnController.correctAns) {
    //             return kRedColor;
    //           }
    //         }
    //         return kGrayColor;
    //       }

    //       IconData getTheRightIcon() {
    //         return getTheRightColor() == kRedColor ? Icons.close : Icons.done;
    //       }

    //       return InkWell(
    //         onTap: press,
    //         child: Container(
    //           margin: EdgeInsets.only(top: kDefaultPadding),
    //           padding: EdgeInsets.all(kDefaultPadding),
    //           decoration: BoxDecoration(
    //             border: Border.all(color: getTheRightColor()),
    //             borderRadius: BorderRadius.circular(15),
    //           ),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               Text(
    //                 "${index + 1}. $text",
    //                 style: TextStyle(color: getTheRightColor(), fontSize: 16),
    //               ),
    //               Container(
    //                 height: 26,
    //                 width: 26,
    //                 decoration: BoxDecoration(
    //                   color: getTheRightColor() == kGrayColor
    //                       ? Colors.transparent
    //                       : getTheRightColor(),
    //                   borderRadius: BorderRadius.circular(50),
    //                   border: Border.all(color: getTheRightColor()),
    //                 ),
    //                 child: getTheRightColor() == kGrayColor
    //                     ? null
    //                     : Icon(getTheRightIcon(), size: 16),
    //               )
    //             ],
    //           ),
    //         ),
    //       );
    //     });
  }
}
