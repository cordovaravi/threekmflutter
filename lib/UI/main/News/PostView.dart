import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threekm/Custom_library/flutter_reaction_button.dart';
import 'package:threekm/UI/main/News/NewsList.dart';
import 'package:threekm/UI/main/News/Widgets/singlePost_Loading.dart';
import 'package:threekm/UI/main/Profile/AuthorProfile.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/commenwidgets/commenwidget.dart';
import 'package:threekm/providers/Global/logged_in_or_not.dart';
import 'package:threekm/providers/localization_Provider/appLanguage_provider.dart';
import 'package:threekm/providers/main/LikeList_Provider.dart';
import 'package:threekm/providers/main/comment_Provider.dart';
import 'package:threekm/providers/main/singlePost_provider.dart';
import 'package:threekm/utils/threekm_textstyles.dart';
import 'package:provider/provider.dart';
import 'package:threekm/widgets/video_widget.dart';
import 'package:threekm/widgets/reactions_assets.dart' as reactionAsset;
import 'package:timelines/timelines.dart';

import 'Widgets/comment_Loading.dart';
import 'Widgets/likes_Loading.dart';

class Postview extends StatefulWidget {
  final String postId;
  final String? image;
  Postview({required this.postId, this.image, Key? key}) : super(key: key);

  @override
  _PostviewState createState() => _PostviewState();
}

class _PostviewState extends State<Postview> {
  ScreenshotController screenshotController = ScreenshotController();
  TextEditingController _commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      context.read<SinglePostProvider>().getPostDetails(
          widget.postId,
          mounted,
          context.read<AppLanguage>().appLocal == Locale("en")
              ? "en"
              : context.read<AppLanguage>().appLocal == Locale("mr")
                  ? "mr"
                  : context.read<AppLanguage>().appLocal == Locale("hi")
                      ? "hi"
                      : _prefs.getString("language_code") ?? "en");
    });
    super.initState();
  }

  @override
  void dispose() {
    SinglePostProvider? _singlepost;
    _singlepost?.resetRefresh();
    super.dispose();
  }

  final _imagKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final postData = context.watch<SinglePostProvider>();
    final newsData = postData.postDetails?.data?.result?.post;
    return postData.isLoading != true
        ? Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text('Post Detail',
                  style: ThreeKmTextConstants.tk16PXPoppinsBlackMedium),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              // decoration: BoxDecoration(
              //   color: Colors.black.withOpacity(0.1),
              // ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(
                  //   height: 44,
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.of(context).pop(false);
                  //     // setState(() => showNewsDetails = !showNewsDetails);
                  //   },
                  //   child: Container(
                  //     height: 40,
                  //     width: 40,
                  //     margin: EdgeInsets.only(left: 18),
                  //     decoration: BoxDecoration(
                  //       shape: BoxShape.circle,
                  //       color: Colors.white.withOpacity(0.8),
                  //     ),
                  //     child: Icon(
                  //       Icons.arrow_back,
                  //       color: Color(0xFF0F0F2D),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 16,
                  // ),
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 15, top: 5, right: 15, bottom: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AuthorProfile(
                                                        authorType: newsData
                                                            ?.authorType,
                                                        id: newsData!
                                                            .author!.id!,
                                                        avatar: newsData
                                                            .author!.image!,
                                                        userName: newsData
                                                            .author!.name!)));
                                      },
                                      child: Container(
                                          margin: EdgeInsets.only(right: 10),
                                          height: 50,
                                          width: 50,
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image:
                                                        CachedNetworkImageProvider(
                                                            newsData!
                                                                .author!.image
                                                                .toString()))),
                                          )),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      //mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: Text(
                                            newsData.author!.name.toString(),
                                            style: ThreeKmTextConstants
                                                .tk14PXPoppinsBlackBold,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                                '${DateFormat('dd MMM yyyy HH:mm a').format(newsData.postCreatedDate!)}'),
                                          ],
                                        )
                                        // Text(newsData.author!.type.toString())
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    // newsData.author. == true
                                    //     ? Image.asset(
                                    //         'assets/verified.png',
                                    //         height: 15,
                                    //         width: 15,
                                    //         fit: BoxFit.cover,
                                    //       )
                                    //     : Container(),
                                    Spacer(),
                                    showPopMenu(
                                        newsData.postId.toString(), newsData)
                                  ],
                                ),
                              ),
                              newsData.images!.length > 1 ||
                                      newsData.videos!.length > 1
                                  ?
                                  //video and image both
                                  Container(
                                      height: 400,
                                      width: 400,
                                      child: PageView.builder(
                                        itemCount: newsData.images!.length +
                                            newsData.videos!.length,
                                        // options: CarouselOptions(
                                        //   // aspectRatio: null,
                                        //   viewportFraction: 0.99,
                                        // ),
                                        itemBuilder: (
                                          context,
                                          index,
                                        ) {
                                          List videoUrls = newsData.videos!
                                              .map((e) => e.src)
                                              .toList();
                                          List templist = List.from(
                                              newsData.images!.toList())
                                            ..addAll(videoUrls);
                                          return templist != null
                                              ? templist[index]
                                                      .toString()
                                                      .contains(".mp4")
                                                  ? SizedBox(
                                                      height: 300,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: VideoWidget(
                                                          isVimeo: newsData
                                                                      .videos?[
                                                                          index]
                                                                      .vimeoUrl !=
                                                                  null
                                                              ? true
                                                              : false,
                                                          thubnail: '',
                                                          url: templist[index]
                                                              .toString(),
                                                          vimeoID: newsData
                                                              .videos?[index]
                                                              .vimeoUrl
                                                              ?.split("/")
                                                              .last,
                                                          play: false),
                                                    )
                                                  : CachedNetworkImage(
                                                      key: _imagKey,
                                                      height: _imagKey
                                                          .currentContext
                                                          ?.size
                                                          ?.height,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      fit: BoxFit.contain,
                                                      imageUrl: templist[index])
                                              : SizedBox(
                                                  child: Text("null"),
                                                );
                                        },
                                      ),
                                    )
                                  // image or video
                                  : Container(
                                      child: newsData.images!.length == 1
                                          ? CachedNetworkImage(
                                              height: _imagKey
                                                  .currentContext?.size?.height,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              fit: BoxFit.fitWidth,
                                              imageUrl:
                                                  '${newsData.images!.first}',
                                            )
                                          : VideoWidget(
                                              isVimeo: newsData.videos?.first
                                                          .vimeoUrl !=
                                                      null
                                                  ? true
                                                  : false,
                                              thubnail: newsData.videos?.first
                                                          .thumbnail !=
                                                      null
                                                  ? newsData
                                                      .videos!.first.thumbnail
                                                      .toString()
                                                  : '',
                                              url: newsData.videos!.first.src
                                                  .toString(),
                                              fromSinglePage: true,
                                              vimeoID: newsData
                                                  .videos?.first.vimeoUrl
                                                  ?.split("/")
                                                  .last,
                                              play: false),
                                    ),
                              newsData.images != null &&
                                          newsData.images!.length > 1 ||
                                      newsData.videos != null &&
                                          newsData.videos!.length > 1
                                  ? Container(
                                      height: 10,
                                      width: MediaQuery.of(context).size.width,
                                      child: Builder(builder: (context) {
                                        List videoUrls = newsData.videos!
                                            .map((e) => e.src)
                                            .toList();
                                        List templist =
                                            List.from(newsData.images!.toList())
                                              ..addAll(videoUrls);
                                        return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: templist
                                                .asMap()
                                                .entries
                                                .map((entry) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 2),
                                                child: DotIndicator(
                                                  size: 8.0,
                                                  color: Colors.grey,
                                                ),
                                              );
                                            }).toList());
                                      }),
                                    )
                                  : SizedBox.shrink(),
                              // if (newsData.images!.isNotEmpty ||
                              //     newsData.images!.length > 0) ...{
                              //   CachedNetworkImage(
                              //     height: 254,
                              //     width:
                              //         MediaQuery.of(context).size.width,
                              //     fit: BoxFit.fitWidth,
                              //     imageUrl: '${newsData.images!.first}',
                              //   )
                              // } else if (newsData.videos!.isNotEmpty ||
                              //     newsData.videos!.length > 0) ...{
                              //   Container(
                              //     // height: 254,
                              //     width:
                              //         MediaQuery.of(context).size.width,
                              //     child: VideoWidget(
                              //       play: true,
                              //       thubnail: newsData
                              //           .videos!.first.thumbnail,
                              //       url: newsData.videos!.first.src
                              //           .toString(),
                              //     ),
                              //   )
                              // },
                              // if (newsData.images != null &&
                              //     newsData.images!.length > 0)
                              //   CachedNetworkImage(
                              //     height: 254,
                              //     width: 338,
                              //     fit: BoxFit.fill,
                              //     imageUrl: '${newsData.images!.first}',
                              //   )
                              // else if (newsData.videos != null ||
                              //     newsData.videos!.length > 0)
                              //   Stack(children: [
                              //     Container(
                              //       height: 254,
                              //       width:
                              //           MediaQuery.of(context).size.width,
                              //       child: VideoWidget(
                              //           thubnail: newsData.videos?.first
                              //                       .thumbnail !=
                              //                   null
                              //               ? newsData
                              //                   .videos!.first.thumbnail
                              //                   .toString()
                              //               : '',
                              //           url: newsData.videos!.first.src
                              //               .toString(),
                              //           play: true),
                              //     ),
                              //   ])
                              // else
                              //   Container(
                              //     child: Text("no data"),
                              //   ),

                              SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 16,
                                ),
                                child: Text(
                                  newsData.submittedHeadline.toString(),
                                  style: ThreeKmTextConstants
                                      .tk14PXPoppinsBlackSemiBold,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, top: 10, bottom: 10
                                    // bottom: MediaQuery.of(context).size.height *
                                    //     0.1
                                    ),
                                child: HtmlWidget(
                                  newsData.story.toString(),
                                  textStyle: TextStyle(),
                                ),
                              ),
                              Row(children: [
                                if (newsData.likes != 0)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: InkWell(
                                      onTap: () {
                                        _showLikedBottomModalSheet(
                                            newsData.postId!.toInt(),
                                            newsData.likes);
                                      },
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        children: [
                                          const Image(
                                              image: AssetImage(
                                                  'assets/like_heart.png')),
                                          Text(
                                            '  ${newsData.likes}',
                                            style: ThreeKmTextConstants
                                                .tk12PXPoppinsBlackSemiBold
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.normal),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                // InkWell(
                                //   onTap: () {
                                //     _showLikedBottomModalSheet(
                                //         newsData.postId!.toInt(),
                                //         newsData.likes);
                                //   },
                                //   child: Padding(
                                //       padding: EdgeInsets.only(
                                //           top: 2, left: 16, bottom: 2),
                                //       child: Text('👍 ❤️ ' +
                                //           newsData.likes.toString() +
                                //           ' Likes')),
                                // ),
                                Spacer(),
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: 2, right: 16, bottom: 2),
                                    child: Row(
                                      children: [
                                        if (newsData.comments!.length > 0)
                                          Text(newsData.comments!.length
                                                  .toString() +
                                              ' Comments'),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(newsData.views.toString() +
                                            ' Views'),
                                      ],
                                    )),
                              ]),
                              SizedBox(
                                height: 5,
                              ),
                              const Divider(
                                thickness: 2,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton.icon(
                                        style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.black)),
                                        onPressed: () async {
                                          if (await getAuthStatus()) {
                                            if (newsData.isLiked == true) {
                                              context
                                                  .read<SinglePostProvider>()
                                                  .postUnLike(newsData.postId
                                                      .toString());
                                            } else {
                                              context
                                                  .read<SinglePostProvider>()
                                                  .postLike(
                                                      newsData.postId
                                                          .toString(),
                                                      null);
                                            }
                                          } else {
                                            NaviagateToLogin(context);
                                          }
                                        },
                                        icon: newsData.isLiked!
                                            ? Image.asset(
                                                "assets/like_icon.png",
                                                width: 22,
                                                height: 19,
                                              )
                                            : Image.asset(
                                                "assets/un_like_icon.png",
                                                width: 22,
                                                height: 19,
                                              ),
                                        label: Text(
                                          'Like',
                                          style: ThreeKmTextConstants
                                              .tk12PXPoppinsBlackSemiBold,
                                        )),
                                    TextButton.icon(
                                        style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.black)),
                                        onPressed: () async {
                                          if (await getAuthStatus()) {
                                            _showCommentsBottomModalSheet(
                                                context,
                                                newsData.postId!.toInt());
                                          } else {
                                            NaviagateToLogin(context);
                                          }
                                        },
                                        icon: Icon(Icons.comment_outlined),
                                        label: Text(
                                          'Comment',
                                          style: ThreeKmTextConstants
                                              .tk12PXPoppinsBlackSemiBold,
                                        )),
                                    TextButton.icon(
                                        style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.black)),
                                        onPressed: () {
                                          String imgUrl = newsData.images !=
                                                      null &&
                                                  newsData.images!.length > 0
                                              ? newsData.images!.first
                                                  .toString()
                                              : newsData.videos!.first.thumbnail
                                                  .toString();
                                          handleShare(
                                              newsData.author!.name.toString(),
                                              newsData.author!.image.toString(),
                                              newsData.headline.toString(),
                                              imgUrl,
                                              DateFormat('yyyy-MM-dd').format(
                                                  newsData.postCreatedDate!),
                                              newsData.postId.toString());
                                        },
                                        icon: Icon(Icons.share_outlined),
                                        label: Text(
                                          'Share',
                                          style: ThreeKmTextConstants
                                              .tk12PXPoppinsBlackSemiBold,
                                        ))
                                  ],
                                ),
                              )
                            ],
                          ),
                        )),
                  ),
                ],
              ),

              // Positioned(
              //   bottom: MediaQuery.of(context).size.height * 0.06,
              //   child: Container(
              //     height: 60,
              //     width: MediaQuery.of(context).size.width,
              //     child: ButtonBar(
              //         alignment: MainAxisAlignment.center,
              //         children: [
              //           Consumer<SinglePostProvider>(
              //               builder: (context, singlePost, _) {
              //             return Container(
              //               height: 60,
              //               width: 60,
              //               child: newsData.isLiked != null
              //                   ? FlutterReactionButtonCheck(
              //                       boxAlignment: Alignment.center,
              //                       boxPosition: Position.TOP,
              //                       onReactionChanged: (reaction, index,
              //                           isChecked) async {
              //                         if (await getAuthStatus()) {
              //                           print(
              //                               'reaction selected index: $index');
              //                           print("is checked $isChecked");
              //                           if (newsData.isLiked == true) {
              //                             print("remove Like");
              //                             context
              //                                 .read<
              //                                     SinglePostProvider>()
              //                                 .postUnLike(newsData
              //                                     .postId
              //                                     .toString());
              //                           } else {
              //                             print("Liked");
              //                             context
              //                                 .read<
              //                                     SinglePostProvider>()
              //                                 .postLike(
              //                                     newsData.postId
              //                                         .toString(),
              //                                     null);
              //                           }
              //                         } else {
              //                           NaviagateToLogin(context);
              //                         }
              //                       },
              //                       reactions: reactionAsset.reactions,
              //                       initialReaction: newsData.isLiked!
              //                           ? Reaction(
              //                               icon: Image.asset(
              //                                   "assets/thumbs_up_red.png"))
              //                           : Reaction(
              //                               icon: Image.asset(
              //                                   "assets/thumbs-up.png")),
              //                       selectedReaction: newsData.isLiked!
              //                           ? Reaction(
              //                               icon: Image.asset(
              //                                   "assets/thumbs_up_red.png"))
              //                           : Reaction(
              //                               icon: Image.asset(
              //                                   "assets/thumbs-up.png")),
              //                     )
              //                   : Container(),
              //               decoration: BoxDecoration(
              //                   color: Colors.white,
              //                   shape: BoxShape.circle,
              //                   boxShadow: [
              //                     BoxShadow(
              //                       color: Colors.black26,
              //                       blurRadius: 8,
              //                     )
              //                   ]),
              //             );
              //           }),
              //           Container(
              //             height: 60,
              //             width: 60,
              //             child: IconButton(
              //                 onPressed: () async {
              //                   if (await getAuthStatus()) {
              //                     _showCommentsBottomModalSheet(context,
              //                         newsData.postId!.toInt());
              //                   } else {
              //                     NaviagateToLogin(context);
              //                   }
              //                 },
              //                 icon: Image.asset(
              //                     'assets/icons-topic.png',
              //                     fit: BoxFit.cover)),
              //             decoration: BoxDecoration(
              //                 color: Colors.white,
              //                 shape: BoxShape.circle,
              //                 boxShadow: [
              //                   BoxShadow(
              //                     color: Colors.black26,
              //                     blurRadius: 8,
              //                   )
              //                 ]),
              //           ),
              //           Container(
              //             height: 60,
              //             width: 60,
              //             child: IconButton(
              //                 onPressed: () {
              //                   String imgUrl = newsData.images !=
              //                               null &&
              //                           newsData.images!.length > 0
              //                       ? newsData.images!.first.toString()
              //                       : newsData.videos!.first.thumbnail
              //                           .toString();
              //                   handleShare(
              //                       newsData.author!.name.toString(),
              //                       newsData.author!.image.toString(),
              //                       newsData.submittedHeadline
              //                           .toString(),
              //                       imgUrl,
              //                       DateFormat('yyyy-MM-dd').format(
              //                           newsData.postCreatedDate!),
              //                       newsData.postId.toString());
              //                 },
              //                 icon: Center(
              //                   child: Image.asset(
              //                       'assets/icons-share.png',
              //                       fit: BoxFit.contain),
              //                 )),
              //             decoration: BoxDecoration(
              //                 color: Colors.white,
              //                 shape: BoxShape.circle,
              //                 boxShadow: [
              //                   BoxShadow(
              //                     color: Colors.black26,
              //                     blurRadius: 8,
              //                   )
              //                 ]),
              //           ),
              //         ]),
              //   ),
              // )
            ),
          )
        : SinglePostLoading();
  }

  _showLikedBottomModalSheet(int postId, totalLikes) {
    context.read<LikeListProvider>().showLikes(context, postId);
    showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        final _likeProvider = context.watch<LikeListProvider>();
        return Padding(
            padding: EdgeInsets.zero,
            child: StatefulBuilder(
              builder: (context, _) {
                return Container(
                  color: Colors.white,
                  height: 192,
                  width: MediaQuery.of(context).size.width,
                  child: _likeProvider.isLoading
                      ? LikesLoding()
                      : Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 24, left: 18, bottom: 34),
                                  child: Text(
                                      "$totalLikes People reacted to this"),
                                ),
                              ],
                            ),
                            Container(
                              height: 90,
                              width: double.infinity,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _likeProvider
                                    .likeList!.data!.result!.users!.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Container(
                                      margin: EdgeInsets.only(
                                        left: 21,
                                      ),
                                      height: 85,
                                      width: 85,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(_likeProvider
                                                  .likeList!
                                                  .data!
                                                  .result!
                                                  .users![index]
                                                  .avatar
                                                  .toString()))),
                                      child: Stack(
                                        children: [
                                          Positioned(
                                              right: 0,
                                              child: Image.asset(
                                                'assets/fblike2x.png',
                                                height: 15,
                                                width: 15,
                                                fit: BoxFit.cover,
                                              )),
                                          _likeProvider
                                                      .likeList!
                                                      .data!
                                                      .result!
                                                      .users![index]
                                                      .isUnknown !=
                                                  null
                                              ? Center(
                                                  child: Text(
                                                      "+${_likeProvider.likeList!.data!.result!.anonymousCount}",
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          color: Colors.white),
                                                      textAlign:
                                                          TextAlign.center),
                                                )
                                              : SizedBox.shrink()
                                        ],
                                      ));
                                },
                              ),
                            ),
                          ],
                        ),
                );
              },
            ));
      },
    );
  }

  PopupMenuButton showPopMenu(String postID, newsData) {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          child: ListTile(
            title: Text('Copy link'),
            onTap: () {
              Clipboard.setData(ClipboardData(
                      text: "https://3km.in/post-detail?id=$postID&lang=en"))
                  .then((value) => CustomSnackBar(
                      context, Text("Link has been coppied to clipboard")))
                  .whenComplete(() => Navigator.pop(context));
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            onTap: () {
              print("entry of share");
              String imgUrl =
                  newsData.images != null && newsData.images!.length > 0
                      ? newsData.images!.first.toString()
                      : newsData.videos!.first.thumbnail.toString();
              handleShare(
                  newsData.author!.name.toString(),
                  newsData.author!.image.toString(),
                  newsData.submittedHeadline.toString(),
                  imgUrl,
                  DateFormat('yyyy-MM-dd').format(newsData.postCreatedDate!),
                  newsData.postId.toString());
            },
            title: Text('Share to..',
                style: ThreeKmTextConstants.tk16PXLatoBlackRegular),
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            onTap: () {
              Navigator.pop(context);
            },
            title: Text(
              'Cancel',
              style: ThreeKmTextConstants.tk16PXPoppinsRedSemiBold,
            ),
          ),
        ),
      ],
    );
  }

  _showCommentsBottomModalSheet(BuildContext context, int postId) {
    //print("this is new :$postId");
    context.read<CommentProvider>().getAllCommentsApi(postId);
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return ClipPath(
                clipper: OvalTopBorderClipper(),
                child: Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height / 2,
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 5,
                        width: 30,
                        color: Colors.grey.shade300,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Container(
                              height: 20,
                              width: 20,
                              child: Image.asset('assets/icons-topic.png')),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          Consumer<CommentProvider>(
                              builder: (context, commentProvider, _) {
                            return commentProvider.commentList?.length != null
                                ? Text(
                                    "${commentProvider.commentList!.length}\tComments",
                                    style: ThreeKmTextConstants
                                        .tk14PXPoppinsBlackSemiBold,
                                  )
                                : Text(
                                    "Comments",
                                    style: ThreeKmTextConstants
                                        .tk14PXPoppinsBlackSemiBold,
                                  );
                          })
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Consumer<CommentProvider>(
                          builder: (context, commentProvider, _) {
                        return context.read<CommentProvider>().commentList !=
                                null
                            ? Expanded(
                                child: commentProvider.isGettingComments == true
                                    ? CommentsLoadingEffects()
                                    : ListView.builder(
                                        physics: BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        primary: true,
                                        itemCount:
                                            commentProvider.commentList!.length,
                                        itemBuilder: (context, commentIndex) {
                                          return Container(
                                            margin: EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                            ),
                                            child: ListTile(
                                              trailing: commentProvider
                                                          .commentList![
                                                              commentIndex]
                                                          .isself ==
                                                      true
                                                  ? IconButton(
                                                      onPressed: () {
                                                        context
                                                            .read<
                                                                CommentProvider>()
                                                            .removeComment(
                                                                commentProvider
                                                                    .commentList![
                                                                        commentIndex]
                                                                    .commentId!,
                                                                postId);
                                                      },
                                                      icon: Icon(Icons.delete))
                                                  : SizedBox(),
                                              leading: Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: CachedNetworkImageProvider(
                                                            commentProvider
                                                                .commentList![
                                                                    commentIndex]
                                                                .avatar
                                                                .toString()))),
                                              ),
                                              title: Text(
                                                commentProvider
                                                    .commentList![commentIndex]
                                                    .username
                                                    .toString(),
                                                style: ThreeKmTextConstants
                                                    .tk14PXPoppinsBlackSemiBold,
                                              ),
                                              subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 4,
                                                    ),
                                                    Text(
                                                      commentProvider
                                                          .commentList![
                                                              commentIndex]
                                                          .comment
                                                          .toString(),
                                                      style: ThreeKmTextConstants
                                                          .tk14PXLatoBlackMedium,
                                                    ),
                                                    SizedBox(
                                                      height: 2,
                                                    ),
                                                    Text(
                                                        commentProvider
                                                            .commentList![
                                                                commentIndex]
                                                            .timeLapsed
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic))
                                                  ]),
                                            ),
                                          );
                                        },
                                      ),
                              )
                            : SizedBox();
                      }),
                      Form(
                        key: _formKey,
                        child: Container(
                          height: 60,
                          width: 338,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20)),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (String? value) {
                              if (value == null) {
                                return "  Comment cant be blank";
                              } else if (value.isEmpty) {
                                return "  Comment cant be blank";
                              }
                            },
                            controller: _commentController,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration:
                                InputDecoration(border: InputBorder.none),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              context
                                  .read<CommentProvider>()
                                  .postCommentApi(
                                      postId, _commentController.text)
                                  .then(
                                      (value) => _commentController.text = "");
                            } else {
                              CustomSnackBar(
                                  context, Text("Comment cant be blank"));
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            height: 36,
                            width: 112,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: ThreeKmTextConstants.blue2),
                            child: Center(child: Consumer<CommentProvider>(
                              builder: (context, _controller, child) {
                                return _controller.isLoading == false
                                    ? Text(
                                        "Submit",
                                        style: ThreeKmTextConstants
                                            .tk14PXPoppinsWhiteMedium,
                                      )
                                    : CupertinoActivityIndicator();
                              },
                            )),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  handleShare(String authorName, String authorProfile, String headLine,
      String thumbnail, date, String postId) async {
    print("entry of handle share");
    showLoading();
    screenshotController
        .captureFromWidget(Container(
      padding: EdgeInsets.only(top: 15, bottom: 15),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.only(right: 10),
                  height: 50,
                  width: 50,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(authorProfile))),
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      authorName,
                      style: ThreeKmTextConstants.tk14PXPoppinsBlackBold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    date.toString(),
                    style: ThreeKmTextConstants.tk12PXLatoBlackBold,
                  )
                ],
              ),
              // SizedBox(
              //   width: 10,
              // ),
            ],
          ),
          Container(
              height: 254,
              width: MediaQuery.of(context).size.width,
              child: CachedNetworkImage(imageUrl: thumbnail)),
          Text(
            headLine,
            style: ThreeKmTextConstants.tk14PXPoppinsBlackBold,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 30,
                  width: 250,
                  child: Image.asset(
                    'assets/playstore.jpg',
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: Container(
                      height: 30,
                      width: 30,
                      child: Image.asset('assets/icon_light.png')),
                )
              ],
            ),
          )
        ],
      ),
    ))
        .then((capturedImage) async {
      try {
        var documentDirectory = Platform.isAndroid
            ? await getExternalStorageDirectory()
            : await getApplicationDocumentsDirectory();
        File file = await File('${documentDirectory!.path}/image.png').create();
        file.writeAsBytesSync(capturedImage);
        Share.shareFiles([file.path],
                text: 'https://3km.in/post-detail?id=$postId&lang=en')
            .then((value) => hideLoading());
      } on Exception catch (e) {
        hideLoading();
      }
    });
  }
}
