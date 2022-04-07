import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:threekm/Custom_library/Polls/models/poll_models.dart';
import 'package:threekm/Custom_library/Polls/widgets/polls_widget.dart';
import 'package:threekm/UI/main/News/NewsTab.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/providers/Global/logged_in_or_not.dart';
import 'package:threekm/providers/main/Quiz_Provider.dart';
import 'package:threekm/providers/main/home2_provider.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

class PollPage extends StatefulWidget {
  final String PollId;
  const PollPage({required this.PollId, Key? key}) : super(key: key);

  @override
  _PollPageState createState() => _PollPageState();
}

class _PollPageState extends State<PollPage> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      context.read<HomeSecondProvider>().getActivePoll(pollId: widget.PollId);
      log("Feaching request");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final newsSecondProvider = context.watch<HomeSecondProvider>();
    final finalScondPost = newsSecondProvider.singlePollModel?.result?.quiz;
    log(finalScondPost?.options?[0].toString() ?? " reult is null from api");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: newsSecondProvider.isLoadingPoll == true
            ? Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(),
                child: finalScondPost?.type == "poll"
                    ? Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                  finalScondPost!.image!)),
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
                                      PollOptions selectedOptionModel) async {
                                    if (await getAuthStatus()) {
                                      context
                                          .read<QuizProvider>()
                                          .submitPollAnswer(
                                              answer: selectedOptionModel.label,
                                              quizId:
                                                  finalScondPost.id!.toInt());
                                      context
                                          .read<HomeSecondProvider>()
                                          .pollSubmitted(
                                              pollId:
                                                  finalScondPost.id!.toInt(),
                                              answer:
                                                  selectedOptionModel.label);
                                    } else {
                                      NaviagateToLogin(context);
                                    }
                                  },
                                  optionsBorderShape:
                                      StadiumBorder(), //Its Default so its not necessary to write this line
                                  model: PollFrameModel(
                                      title: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                            finalScondPost.question.toString(),
                                            style: ThreeKmTextConstants
                                                .tk14PXPoppinsBlackBold),
                                      ),
                                      totalPolls: 100,
                                      endTime: DateTime.now()
                                          .toUtc()
                                          .add(Duration(days: 10)),
                                      hasVoted: finalScondPost.isAnswered!,
                                      editablePoll: false,
                                      options:
                                          finalScondPost.options!.map((option) {
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
                        ))
                    : finalScondPost?.type == "quiz"
                        ? Builder(builder: (context) {
                            if (finalScondPost?.isAnswered == true) {
                              final alreadyAnsIndex = finalScondPost!.options!
                                  .indexWhere((element) =>
                                      element.text == finalScondPost.answer);
                              log("ans index is $alreadyAnsIndex");
                              final alredaySelectedIndex = finalScondPost
                                  .options!
                                  .indexWhere((element) =>
                                      element.text ==
                                      finalScondPost.selectedOption);
                              log("selected index is$alredaySelectedIndex");
                              if (mounted) {
                                if (context.read<QuizProvider>().isAnswred ==
                                    false) {
                                  Future.microtask(() => context
                                      .read<QuizProvider>()
                                      .checkAns(alredaySelectedIndex,
                                          alreadyAnsIndex));
                                }
                              }
                            }
                            return Consumer2<QuizProvider, HomeSecondProvider>(
                              builder: (context, quizProvider, _controller, _) {
                                return Container(
                                  margin: EdgeInsets.only(),
                                  height:
                                      MediaQuery.of(context).size.height * 0.7,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    // borderRadius: BorderRadius.circular(16),
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: CachedNetworkImageProvider(
                                            finalScondPost!.image.toString())),
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
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black38,
                                                      blurRadius: 0.8)
                                                ]),
                                            child: ShakeAnimatedWidget(
                                              duration:
                                                  Duration(microseconds: 800),
                                              shakeAngle:
                                                  Rotation.radians(z: 0.05),
                                              enabled: quizProvider.shake,
                                              child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                          finalScondPost
                                                              .question
                                                              .toString(),
                                                          style: ThreeKmTextConstants
                                                              .tk16PXPoppinsWhiteBold,
                                                          textAlign:
                                                              TextAlign.center),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          top: 10),
                                                      decoration: BoxDecoration(
                                                          color: Colors.white),
                                                      child: ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        itemCount:
                                                            finalScondPost
                                                                .options!
                                                                .length,
                                                        itemBuilder: (context,
                                                            quizIndex) {
                                                          return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 4,
                                                                      right: 4),
                                                              child:
                                                                  GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  if (await getAuthStatus()) {
                                                                    if (finalScondPost.isAnswered ==
                                                                            false ||
                                                                        finalScondPost.isAnswered ==
                                                                            null) {
                                                                      final ansIndex = finalScondPost
                                                                          .options!
                                                                          .indexWhere((element) =>
                                                                              element.text ==
                                                                              finalScondPost.answer);
                                                                      log("ans index is $ansIndex");
                                                                      context
                                                                          .read<
                                                                              QuizProvider>()
                                                                          .checkAns(
                                                                              quizIndex,
                                                                              ansIndex);
                                                                      context.read<QuizProvider>().submitQuiz(
                                                                          finalScondPost
                                                                              .quizId!
                                                                              .toInt(),
                                                                          finalScondPost
                                                                              .options![quizIndex]
                                                                              .text
                                                                              .toString());
                                                                      _controller.submitQuiz(
                                                                          quizId: finalScondPost
                                                                              .quizId!
                                                                              .toInt());
                                                                    }
                                                                  } else {
                                                                    NaviagateToLogin(
                                                                        context);
                                                                  }
                                                                },
                                                                child: Container(
                                                                    height: 50,
                                                                    margin: EdgeInsets.all(10),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(15),
                                                                        color: Colors.white,
                                                                        boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 8.0)],
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
                                                                              .options![quizIndex]
                                                                              .text
                                                                              .toString(),
                                                                          style:
                                                                              ThreeKmTextConstants.tk16PXLatoBlackRegular,
                                                                          overflow:
                                                                              TextOverflow.fade,
                                                                        ),
                                                                        if (quizProvider
                                                                            .isAnswred)
                                                                          quizIndex == quizProvider.answredIndex
                                                                              ? IconConatiner(icon: Icons.check_circle, iconColor: Colors.green)
                                                                              : quizIndex == quizProvider.selectedIndex
                                                                                  ? IconConatiner(icon: Icons.clear_rounded, iconColor: Colors.redAccent)
                                                                                  : SizedBox.shrink()
                                                                      ],
                                                                    )),
                                                              ));
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
                          })
                        : SizedBox.shrink(
                            child: Text("null"),
                          )),
      ),
    );
  }
}
