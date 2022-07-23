import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threekm/Custom_library/flutter_reaction_button.dart';
import 'package:threekm/Models/deepLinkPost.dart';
import 'package:threekm/UI/main/EditPost/edit_post.dart';
import 'package:threekm/UI/main/News/Widgets/singlePost_Loading.dart';
import 'package:threekm/UI/main/News/likes_and_comments/like_list.dart';
import 'package:threekm/UI/main/Profile/AuthorProfile.dart';
import 'package:threekm/UI/main/Profile/MyProfilePost.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/commenwidgets/commenwidget.dart';
import 'package:threekm/providers/Global/logged_in_or_not.dart';
import 'package:threekm/providers/localization_Provider/appLanguage_provider.dart';
import 'package:threekm/providers/main/AthorProfile_Provider.dart';
import 'package:threekm/providers/main/EditPost_Provider.dart';
import 'package:threekm/providers/main/NewsFeed_Provider.dart';
import 'package:threekm/providers/main/newsList_provider.dart';
import 'package:threekm/providers/main/singlePost_provider.dart';
import 'package:threekm/utils/Extension/capital.dart';
import 'package:threekm/utils/slugUrl.dart';
import 'package:threekm/utils/threekm_textstyles.dart';
import 'package:threekm/widgets/NewCardUI/card_ui.dart';
import 'package:threekm/widgets/emotion_Button.dart';
import 'package:threekm/widgets/reactions_assets.dart';
import 'package:threekm/widgets/video_widget.dart';
import 'package:timelines/timelines.dart';

import 'likes_and_comments/comment_section.dart';

class PostView extends StatefulWidget {
  final String postId;
  final String? image;

  /// To avoid edit-permission check everywhere, the feature of editing a post has been limited to [PostView] and [CardUI] in [MyProfilePost] only
  final bool isEditable;
  PostView({required this.postId, this.image, Key? key, this.isEditable = false}) : super(key: key);

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  ScreenshotController screenshotController = ScreenshotController();

  // TextEditingController _commentController = TextEditingController();
  // final _formKey = GlobalKey<FormState>();

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
    SinglePostProvider? _singlePost;
    _singlePost?.resetRefresh();
    super.dispose();
  }

  final _imageKey = GlobalKey();

  postlike(label, postId) {
    context.read<SinglePostProvider>().postLike(postId.toString(), label);
    context.read<NewsListProvider>().postLike(postId.toString(), label);
    context.read<NewsFeedProvider>().postLike(postId.toString(), label);
    context.read<AutthorProfileProvider>().postLike(postId.toString(), label);
  }

  void postUnlike(postId) {
    context.read<SinglePostProvider>().postUnLike(postId.toString());
    context.read<NewsListProvider>().postUnLike(postId.toString());
    context.read<NewsFeedProvider>().postUnLike(postId.toString());
    context.read<AutthorProfileProvider>().postUnLike(postId.toString());
  }

  @override
  Widget build(BuildContext context) {
    final SinglePostProvider postData = context.watch<SinglePostProvider>();
    final Post? newsData = postData.postDetails?.data?.result?.post;
    List videoUrls = newsData != null ? newsData.videos!.map((e) => e.src).toList() : [];
    List tempList =
        newsData != null ? (List.from(newsData.images!.toList())..addAll(videoUrls)) : [];
    return postData.isLoading != true && newsData != null
        ? Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text('Post Detail', style: ThreeKmTextConstants.tk16PXPoppinsBlackMedium),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                                padding: EdgeInsets.only(left: 15, top: 5, right: 15, bottom: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => AuthorProfile(
                                                    authorType: newsData.authorType,
                                                    id: newsData.author!.id!,
                                                    avatar: newsData.author!.image!,
                                                    userName: newsData.author!.name!)));
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
                                                    image: CachedNetworkImageProvider(
                                                        newsData.author!.image.toString()))),
                                          )),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      //mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => AuthorProfile(
                                                        authorType: newsData.authorType,
                                                        id: newsData.author!.id!,
                                                        avatar: newsData.author!.image!,
                                                        userName: newsData.author!.name!)));
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context).size.width * 0.4,
                                            child: Text(
                                              newsData.author!.name.toString(),
                                              style: ThreeKmTextConstants.tk14PXPoppinsBlackBold,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),

                                        Row(
                                          children: [
                                            Text(newsData.displayDate.toString()
                                                // '${DateFormat('dd MMM yyyy HH:mm a').format(newsData.postCreatedDate!)}'
                                                ),
                                          ],
                                        )
                                        // Text(newsData.author!.type.toString())
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    // newsData.author. == true
                                    //     ? Image.asset(
                                    //         'assets/verified.png',
                                    //         height: 15,
                                    //         width: 15,
                                    //         fit: BoxFit.cover,
                                    //       )
                                    //     : Container(),
                                    Spacer(),
                                    showPopMenu(newsData.postId.toString(), newsData)
                                  ],
                                ),
                              ),
                              // newsData.images!.length > 1 ||
                              //         newsData.videos!.length > 1
                              tempList.length == 0
                                  ? SizedBox.shrink()
                                  : tempList.length > 1
                                      ?
                                      //video and image both
                                      Container(
                                          height: 400,
                                          width: 400,
                                          child: PageView.builder(
                                            itemCount: tempList.length,
                                            //newsData.images!.length +
                                            //newsData.videos!.length,
                                            // options: CarouselOptions(
                                            //   // aspectRatio: null,
                                            //   viewportFraction: 0.99,
                                            // ),
                                            itemBuilder: (
                                              context,
                                              index,
                                            ) {
                                              // List videoUrls = newsData.videos!
                                              //     .map((e) => e.src)
                                              //     .toList();
                                              // List templist = List.from(
                                              //     newsData.images!.toList())
                                              //   ..addAll(videoUrls);
                                              return tempList[index].toString().contains(".mp4")
                                                  ? SizedBox(
                                                      height: 300,
                                                      width: double.infinity,
                                                      child: VideoWidget(
                                                          isVimeo: false,
                                                          // newsData
                                                          //             .videos?[
                                                          //                 index]
                                                          //             .vimeoUrl !=
                                                          //         null
                                                          //     ? true
                                                          //     : false,
                                                          thubnail: '',
                                                          url: tempList[index].toString(),
                                                          // vimeoID: newsData
                                                          //     .videos?[index]
                                                          //     .vimeoUrl
                                                          //     ?.split("/")
                                                          //     .last,
                                                          play: false),
                                                    )
                                                  : CachedNetworkImage(
                                                      key: _imageKey,
                                                      height: 300,
                                                      width: MediaQuery.of(context).size.width,
                                                      fit: BoxFit.contain,
                                                      imageUrl: tempList[index]);
                                            },
                                          ),
                                        )
                                      // image or video
                                      : Container(
                                          child: newsData.images!.length == 1
                                              ? CachedNetworkImage(
                                                  height: _imageKey.currentContext?.size?.height,
                                                  width: MediaQuery.of(context).size.width,
                                                  fit: BoxFit.fitWidth,
                                                  imageUrl: '${newsData.images!.first}',
                                                )
                                              : VideoWidget(
                                                  isVimeo: newsData.videos?.first.vimeoUrl != null
                                                      ? true
                                                      : false,
                                                  thubnail: newsData.videos?.first.thumbnail != null
                                                      ? newsData.videos!.first.thumbnail.toString()
                                                      : '',
                                                  url: newsData.videos!.first.src.toString(),
                                                  fromSinglePage: true,
                                                  vimeoID: newsData.videos?.first.vimeoUrl
                                                      ?.split("/")
                                                      .last,
                                                  play: false),
                                        ),

                              // newsData.images != null &&
                              //             newsData.images!.length > 1 ||
                              //         newsData.videos != null &&
                              //             newsData.videos!.length > 1
                              tempList.length > 1
                                  ? Container(
                                      height: 10,
                                      width: MediaQuery.of(context).size.width,
                                      child: Builder(builder: (context) {
                                        List videoUrls =
                                            newsData.videos!.map((e) => e.src).toList();
                                        List templist = List.from(newsData.images!.toList())
                                          ..addAll(videoUrls);
                                        return Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: templist.asMap().entries.map((entry) {
                                              return Padding(
                                                padding: const EdgeInsets.only(left: 2),
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
                                  style: ThreeKmTextConstants.tk14PXPoppinsBlackSemiBold,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10
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
                                        // _showLikedBottomModalSheet(
                                        //     newsData.postId!.toInt(),
                                        //     newsData.likes);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LikeList(postId: newsData.postId!)));
                                      },
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        children: [
                                          const Image(image: AssetImage('assets/like_heart.png')),
                                          Text(
                                            '  ${newsData.likes}',
                                            style: ThreeKmTextConstants.tk12PXPoppinsBlackSemiBold
                                                .copyWith(fontWeight: FontWeight.normal),
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
                                    padding: EdgeInsets.only(top: 2, right: 16, bottom: 2),
                                    child: Row(
                                      children: [
                                        if (newsData.comments!.length > 0)
                                          InkWell(
                                              splashFactory: InkRipple.splashFactory,
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => CommentSection(
                                                              postId: newsData.postId!,
                                                            )));
                                              },
                                              child: Text(newsData.comments!.length.toString() +
                                                  ' Comments')),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(newsData.views.toString() + ' Views'),
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
                                padding: const EdgeInsets.only(left: 16, right: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton.icon(
                                      label: Text(
                                        newsData.emotion != null && newsData.emotion != ""
                                            ? newsData.emotion.toString().capitalize()
                                            : 'Like',
                                        style: ThreeKmTextConstants.tk12PXPoppinsBlackSemiBold,
                                      ),
                                      onPressed: () async {
                                        if (await getAuthStatus()) {
                                          if (newsData.isLiked == true) {
                                            postUnlike(newsData.postId);
                                          } else {
                                            postlike("like", newsData.postId);
                                          }
                                        } else {
                                          NaviagateToLogin(context);
                                        }
                                      },
                                      icon: SinglePostEmotionButton(
                                          isLiked: newsData.isLiked ?? false,
                                          initalReaction: newsData.isLiked ?? false
                                              ? newsData.emotion != null && newsData.emotion != ""
                                                  ? Reaction(
                                                      icon: Lottie.asset(
                                                          "assets/lottie/${newsData.emotion}.json",
                                                          width: 30,
                                                          height: 30,
                                                          repeat: false,
                                                          fit: BoxFit.cover),
                                                    )
                                                  : Reaction(
                                                      icon: Lottie.asset("assets/lottie/like.json",
                                                          width: 30, height: 30, repeat: false),
                                                    )
                                              : Reaction(
                                                  icon: Image.asset(
                                                  "assets/un_like_icon.png",
                                                  width: 22,
                                                  height: 19,
                                                )),
                                          selectedReaction: newsData.isLiked!
                                              ? Reaction(
                                                  icon: Image.asset(
                                                  "assets/like_icon.png",
                                                  width: 22,
                                                  height: 19,
                                                ))
                                              : Reaction(
                                                  icon: Image.asset(
                                                  "assets/un_like_icon.png",
                                                  width: 22,
                                                  height: 19,
                                                )),
                                          postId: newsData.postId!.toInt(),
                                          reactions: reactions),
                                    ),
                                    // TextButton.icon(
                                    //     style: ButtonStyle(
                                    //         foregroundColor:
                                    //             MaterialStateProperty.all(Colors.black)),
                                    //     onPressed: () async {
                                    //       if (await getAuthStatus()) {
                                    //         if (newsData.isLiked == true) {
                                    //           context
                                    //               .read<SinglePostProvider>()
                                    //               .postUnLike(newsData.postId.toString());
                                    //         } else {
                                    //           context
                                    //               .read<SinglePostProvider>()
                                    //               .postLike(newsData.postId.toString(), null);
                                    //         }
                                    //       } else {
                                    //         NaviagateToLogin(context);
                                    //       }
                                    //     },
                                    //     icon: newsData.isLiked!
                                    //         ? Image.asset(
                                    //             "assets/like_icon.png",
                                    //             width: 22,
                                    //             height: 19,
                                    //           )
                                    //         : Image.asset(
                                    //             "assets/un_like_icon.png",
                                    //             width: 22,
                                    //             height: 19,
                                    //           ),
                                    //     label: Text(
                                    //       'Like',
                                    //       style: ThreeKmTextConstants.tk12PXPoppinsBlackSemiBold,
                                    //     )),
                                    Container(
                                      height: 15,
                                      width: 2,
                                      color: Colors.grey,
                                    ),
                                    TextButton.icon(
                                        style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateProperty.all(Colors.black)),
                                        onPressed: () async {
                                          if (await getAuthStatus()) {
                                            // _showCommentsBottomModalSheet(
                                            //     context, newsData.postId!.toInt());
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => CommentSection(
                                                          postId: newsData.postId!,
                                                        )));
                                          } else {
                                            NaviagateToLogin(context);
                                          }
                                        },
                                        icon: Icon(Icons.comment_outlined),
                                        label: Text(
                                          'Comment',
                                          style: ThreeKmTextConstants.tk12PXPoppinsBlackSemiBold,
                                        )),
                                    Container(
                                      height: 15,
                                      width: 2,
                                      color: Colors.grey,
                                    ),
                                    TextButton.icon(
                                        style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateProperty.all(Colors.black)),
                                        onPressed: () {
                                          String imgUrl =
                                              newsData.images != null && newsData.images!.length > 0
                                                  ? newsData.images!.first.toString()
                                                  : newsData.videos!.first.thumbnail.toString();
                                          handleShare(
                                              newsData.author!.name.toString(),
                                              newsData.author!.image.toString(),
                                              newsData.slugHeadline ??
                                                  newsData.submittedHeadline.toString(),
                                              imgUrl,
                                              DateFormat('yyyy-MM-dd')
                                                  .format(newsData.postCreatedDate!),
                                              newsData.postId.toString());
                                        },
                                        icon: Icon(Icons.share_outlined),
                                        label: Text(
                                          'Share',
                                          style: ThreeKmTextConstants.tk12PXPoppinsBlackSemiBold,
                                        ))
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 50,
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

  PopupMenuButton showPopMenu(String postID, Post newsData) {
    void _editPost() async {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider<EditPostProvider>(
                    create: (context) => EditPostProvider(),
                    child: EditPost(),
                  )));
    }

    void _copyLink() {
      Clipboard.setData(ClipboardData(
              text:
                  "${slugUrl(headLine: newsData.slugHeadline ?? newsData.submittedHeadline, postId: postID)}"))
          .then((value) => CustomSnackBar(context, Text("Link has been coppied to clipboard")));
    }

    void _share() {
      print("entry of share");
      String imgUrl = newsData.images != null && newsData.images!.length > 0
          ? newsData.images!.first.toString()
          : newsData.videos!.first.thumbnail.toString();
      handleShare(
          newsData.author!.name.toString(),
          newsData.author!.image.toString(),
          newsData.submittedHeadline.toString(),
          imgUrl,
          DateFormat('yyyy-MM-dd').format(newsData.postCreatedDate!),
          newsData.postId.toString());
    }

    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert),
      onSelected: (string) {
        switch (string) {
          case 'edit':
            _editPost();
            break;
          case 'copyLink':
            _copyLink();
            break;
          case 'share':
            _share();
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          if (widget.isEditable) PopupMenuItem<String>(value: 'edit', child: Text('Edit Post')),
          PopupMenuItem<String>(value: 'copyLink', child: Text('Copy link')),
          PopupMenuItem<String>(
              value: 'share',
              child: Text('Share to..', style: ThreeKmTextConstants.tk16PXLatoBlackRegular)),
        ];
      },
    );
  }

  Future<void> handleShare(String authorName, String authorProfile, String headLine,
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
                            fit: BoxFit.cover, image: CachedNetworkImageProvider(authorProfile))),
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
                  child:
                      Container(height: 30, width: 30, child: Image.asset('assets/icon_light.png')),
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
        Share.shareFiles([file.path], text: '${slugUrl(headLine: headLine, postId: postId)}')
            .then((value) => hideLoading());
      } on Exception catch (e) {
        log(e.toString());
        hideLoading();
      }
    });
  }
}
