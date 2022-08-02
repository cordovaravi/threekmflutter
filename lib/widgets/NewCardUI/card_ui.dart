import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:threekm/Custom_library/BoldText/Text_chunking.dart';
import 'package:threekm/Custom_library/src/reaction.dart';
import 'package:threekm/UI/main/EditPost/edit_post.dart';
import 'package:threekm/UI/main/News/PostView.dart';
import 'package:threekm/UI/main/Profile/AuthorProfile.dart';
import 'package:threekm/UI/main/Profile/MyProfilePost.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/commenwidgets/commenwidget.dart';
import 'package:threekm/providers/Global/logged_in_or_not.dart';
import 'package:threekm/providers/ProfileInfo/ProfileInfo_Provider.dart';
import 'package:threekm/providers/main/AthorProfile_Provider.dart';
import 'package:threekm/providers/main/NewsFeed_Provider.dart';
import 'package:threekm/providers/main/newsList_provider.dart';
import 'package:threekm/utils/Extension/capital.dart';
import 'package:threekm/utils/slugUrl.dart';
import 'package:threekm/utils/threekm_textstyles.dart';
import 'package:threekm/widgets/NewCardUI/image_layout.dart';
import 'package:threekm/widgets/reactions_assets.dart' as reactionAssets;

import '../../UI/main/News/likes_and_comments/comment_section.dart';
import '../../UI/main/News/likes_and_comments/like_list.dart';
import '../emotion_Button.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class CardUI extends StatefulWidget {
  final providerType;

  const CardUI(
      {Key? key,
      required this.data,
      this.isfollow,
      required this.providerType,
      this.isEditable = false})
      : super(key: key);
  final data;
  final isfollow;
  final bool isEditable;

  @override
  State<CardUI> createState() => _CardUIState();
}

class _CardUIState extends State<CardUI> {
  // final _formKey = GlobalKey<FormState>();
  // TextEditingController _commentController = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();

  postlike(label, postId) {
    context.read<NewsListProvider>().postLike(postId.toString(), label);
    context.read<NewsFeedProvider>().postLike(postId.toString(), label);
    context.read<AutthorProfileProvider>().postLike(postId.toString(), label);
  }

  void postUnlike(postId) {
    context.read<NewsListProvider>().postUnLike(postId.toString());
    context.read<NewsFeedProvider>().postUnLike(postId.toString());
    context.read<AutthorProfileProvider>().postUnLike(postId.toString());
  }

  @override
  Widget build(BuildContext context) {
    final newsFeedProvider = context.watch<NewsFeedProvider>();
    var data = widget.data;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(blurRadius: 40, offset: Offset(0, 8), color: Color(0x29092C4C))
          ],
          borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: InkWell(
        onTap: () {
          Navigator.push<bool>(context, MaterialPageRoute(builder: (BuildContext context) {
            return PostView(
              isEditable: widget.isEditable,
              postId: data.postId.toString(),
            );
          })).then((isPostChanged) {
            // refresh MyProfilePost after editing
            if (widget.isEditable && (isPostChanged ?? false)) {
              if (widget.providerType == "AutthorProfileProvider") {
                context.read<AutthorProfileProvider>().getSelfProfile();
              }
            }
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data.preheaderLike != "" && data.preheaderComment == "")
              // Text(
              //   '${data.preheaderLike}',
              // ),
              TextChunkStyling(
                text: '${data.preheaderLike}',
                highlightText: ['${data.preaheaderLikeUser}'],
                multiTextStyles: const [
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ],
              ),
            if (data.preheaderLike != "" && data.preheaderComment == "")
              Divider(
                thickness: 2,
              ),
            if (data.preheaderComment != "")
              TextChunkStyling(
                text: '${data.preheaderComment}',
                highlightText: ['${data.preheaderCommentUSer}'],
                multiTextStyles: const [
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ],
              ),
            //Text('${data.preheaderComment}'),
            if (data.preheaderComment != "")
              Divider(
                thickness: 2,
              ),
            Row(
              children: [
                data.author?.image != null
                    ? InkWell(
                        onTap: () {
                          if (context.read<ProfileInfoProvider>().UserName != data.author!.name!) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AuthorProfile(
                                        authorType: data.authorType,
                                        // page: 1,
                                        // authorType:
                                        //     "user",
                                        id: data.author!.id!,
                                        avatar: data.author!.image!,
                                        userName: data.author!.name!)));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyProfilePost(
                                        isFromSelfProfileNavigate: true,
                                        page: 1,
                                        authorType: "",
                                        id: data.author!.id!,
                                        avatar: "",
                                        userName: data.author!.name!)));
                          }
                        },
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(80),
                            child: Image(
                              image: CachedNetworkImageProvider('${data.author?.image}'),
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 48,
                                  height: 48,
                                  color: Colors.grey,
                                );
                              },
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            )),
                      )
                    : Container(
                        width: 48,
                        height: 48,
                        color: Colors.grey,
                      ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AuthorProfile(
                                    authorType: data.authorType,
                                    // page: 1,
                                    // authorType:
                                    //     "user",
                                    id: data.author!.id!,
                                    avatar: data.author!.image!,
                                    userName: data.author!.name!)));
                      },
                      child: Text(
                        '${data.author?.name}',
                        style: ThreeKmTextConstants.tk14PXPoppinsBlackMedium,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${data.createdDate}',
                          style: ThreeKmTextConstants.tk12PXPoppinsBlackSemiBold
                              .copyWith(fontWeight: FontWeight.normal),
                        ),
                        Center(
                          child: Container(
                            margin: const EdgeInsets.only(left: 5, right: 5),
                            height: 4,
                            width: 4,
                            decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                          ),
                        ),
                        if (widget.isfollow != false)
                          InkWell(
                            onTap: () async {
                              // if (data.author!.isFollowed == true) {
                              //   // print("is followed: true");
                              //   // newsFeedProvider
                              //   //     .unfollowUser(data.author!.id!.toInt());
                              // } else
                              if (await getAuthStatus()) {
                                // if (data.author!.isFollowed == false ||
                                //     data.author!.isFollowed == null) {
                                newsFeedProvider
                                    .followUser(
                                      data.author!.id!.toInt(),
                                    )
                                    .whenComplete(() => setState(() {
                                          data.author?.isFollowed = true;
                                        }));
                                // }
                              } else {
                                NaviagateToLogin(
                                  context,
                                );
                              }
                            },
                            child: Text(data.author?.isFollowed == true ? 'Following' : 'Follow',
                                style: data.author?.isFollowed == true
                                    ? ThreeKmTextConstants.tk14PXPoppinsBlackMedium
                                        .copyWith(color: Colors.grey)
                                    : ThreeKmTextConstants.tk14PXPoppinsBlueMedium),
                          )
                      ],
                    )
                  ],
                ),
                const Spacer(),
                showPopMenu(data.postId.toString(), data),
                // InkWell(
                //     onTap: () {
                //       showPopMenu(data.postId.toString(), data);
                //     },
                //     child: const Image(image: AssetImage('assets/kebab.png')))
              ],
            ),
            const SizedBox(
              height: 23,
            ),
            InkWell(
              onTap: () async {
                bool? isPostChanged = await Navigator.push<bool>(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return PostView(
                    isEditable: widget.isEditable,
                    postId: data.postId.toString(),
                  );
                }));
                if (widget.isEditable && (isPostChanged ?? false)) {
                  if (widget.providerType == "AutthorProfileProvider") {
                    context.read<AutthorProfileProvider>().getSelfProfile();
                  }
                }
              },
              child: ImageLayout(
                images: data.images ?? [],
                video: data.videos ?? [],
                // images: imgdemo,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              data.submittedHeadline!.length > 80
                  ? '${data.submittedHeadline?.substring(0, 80)}. . . . .'
                  : '${data.submittedHeadline}',
              style: ThreeKmTextConstants.tk14PXPoppinsBlackSemiBold,
              textAlign: TextAlign.left,
            ),
            data.submittedStory!.length > 170
                ? HtmlWidget(
                    '${data.submittedStory!.substring(0, 170)}<a id="seemore" href="#"> ....See More</a>',
                    onTapUrl: (string) async {
                      bool? isPostChanged = await Navigator.push<bool>(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return PostView(
                          isEditable: widget.isEditable,
                          postId: data.postId.toString(),
                        );
                      }));
                      if (widget.isEditable && (isPostChanged ?? false)) {
                        if (widget.providerType == "AutthorProfileProvider") {
                          context.read<AutthorProfileProvider>().getSelfProfile();
                        }
                      }

                      return true;
                    },
                  )
                : HtmlWidget(
                    '${data.submittedStory}',
                  ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                data.likes != 0
                    ? TextButton.icon(
                        style: TextButton.styleFrom(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LikeList(postId: data.postId!)));
                        },
                        icon: const Image(image: AssetImage('assets/like_heart.png')),
                        label: Text(
                          '  ${data.likes}',
                          style: ThreeKmTextConstants.tk12PXPoppinsBlackSemiBold
                              .copyWith(fontWeight: FontWeight.normal),
                        ),
                      )
                    : SizedBox(),
                Text('${data.views ?? 0} views',
                    style: ThreeKmTextConstants.tk12PXPoppinsBlackSemiBold
                        .copyWith(fontWeight: FontWeight.normal))
              ],
            ),
            const Divider(
              thickness: 2,
            ),
            if (data.status != "rejected")
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      if (await getAuthStatus()) {
                        if (data.isLiked == true) {
                          //newsFeedProvider.postUnLike(data.postId.toString());
                          postUnlike(data.postId.toString());
                        } else {
                          // newsFeedProvider
                          //     .postLike(data.postId.toString(), "like")
                          //     .whenComplete(() => setState(() {
                          //           data.isLiked = true;
                          //         }));
                          postlike('like', data.postId.toString());
                        }
                      } else {
                        NaviagateToLogin(context);
                      }
                    },
                    label: Text(
                      data.emotion != null && data.emotion != ""
                          ? '${data.emotion.toString().capitalize()}'
                          : 'Like',
                      style: ThreeKmTextConstants.tk12PXPoppinsBlackSemiBold,
                    ),
                    icon: EmotionButton(
                        providerType: widget.providerType,
                        isLiked: data.isLiked ?? false,
                        initalReaction: data.isLiked!
                            ? data.emotion != null &&
                                    data.emotion != "" &&
                                    data.emotion != null &&
                                    data.emotion != "null"
                                ? Reaction(
                                    icon: Lottie.asset("assets/lottie/${data.emotion}.json",
                                        width: 35, height: 35, fit: BoxFit.cover, repeat: false),
                                  )
                                : Reaction(
                                    icon: Lottie.asset("assets/lottie/like.json",
                                        width: 35, height: 35, repeat: false),
                                  )
                            : Reaction(
                                icon: Image.asset(
                                "assets/un_like_icon.png",
                                width: 22,
                                height: 19,
                              )),
                        selectedReaction: data.isLiked!
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
                        postId: data.postId!.toInt(),
                        reactions: reactionAssets.reactions),
                  ),
                  // TextButton.icon(
                  //     style: ButtonStyle(
                  //         foregroundColor:
                  //             MaterialStateProperty.all(Colors.black)),
                  //     onPressed: () async {
                  //       if (await getAuthStatus()) {
                  //         if (data.isLiked == true) {
                  //           newsFeedProvider.postUnLike(data.postId.toString());
                  //         } else {
                  //           newsFeedProvider
                  //               .postLike(data.postId.toString(), null)
                  //               .whenComplete(() => setState(() {
                  //                     data.isLiked = true;
                  //                   }));
                  //         }
                  //       } else {
                  //         NaviagateToLogin(context);
                  //       }
                  //     },
                  //     icon: EmotionButton(
                  //         providerType: widget.providerType,
                  //         isLiked: data.isLiked!,
                  //         initalReaction: data.isLiked!
                  //             ? data.emotion != null && data.emotion != ""
                  //                 ? Reaction(
                  //                     icon: Image.asset(
                  //                       "assets/${data.emotion}.png",
                  //                       width: 22,
                  //                       height: 19,
                  //                     ),
                  //                   )
                  //                 : Reaction(
                  //                     icon: Image.asset(
                  //                       "assets/like_icon.png",
                  //                       width: 22,
                  //                       height: 19,
                  //                     ),
                  //                   )
                  //             : Reaction(
                  //                 icon: Image.asset(
                  //                 "assets/un_like_icon.png",
                  //                 width: 22,
                  //                 height: 19,
                  //               )),
                  //         selectedReaction: data.isLiked!
                  //             ? Reaction(
                  //                 icon: Image.asset(
                  //                 "assets/like_icon.png",
                  //                 width: 22,
                  //                 height: 19,
                  //               ))
                  //             : Reaction(
                  //                 icon: Image.asset(
                  //                 "assets/un_like_icon.png",
                  //                 width: 22,
                  //                 height: 19,
                  //               )),
                  //         postId: data.postId!.toInt(),
                  //         reactions: reactionAssets.reactions),
                  //     // data.isLiked!
                  //     //     ? Image.asset(
                  //     //         "assets/like_icon.png",
                  //     //         width: 22,
                  //     //         height: 19,
                  //     //       )
                  //     //     : Image.asset(
                  //     //         "assets/un_like_icon.png",
                  //     //         width: 22,
                  //     //         height: 19,
                  //     //       ),
                  //     label: Text(
                  //       data.emotion != null && data.emotion != ""
                  //           ? '${data.emotion}'
                  //           : 'Like',
                  //       style: ThreeKmTextConstants.tk12PXPoppinsBlackSemiBold,
                  //     )),
                  Container(
                    height: 15,
                    width: 2,
                    color: Colors.grey,
                  ),
                  TextButton.icon(
                      style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.black)),
                      onPressed: () async {
                        if (await getAuthStatus()) {
                          // showCommentsBottomModalSheet(context, data.postId!.toInt());
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CommentSection(
                                        postId: data.postId!,
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
                      style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.black)),
                      onPressed: () {
                        String? imgUrl = data.images != null && data.images.isNotEmpty
                            ? data.images?.first.toString()
                            : data.videos?.first.thumbnail.toString();
                        if (imgUrl != null) {
                          handleShare(
                              data.author!.name.toString(),
                              data.author!.image.toString(),
                              data.slugHeadline != null || data.slugHeadline != ""
                                  ? data.slugHeadline ?? " "
                                  : data.submittedHeadline,
                              imgUrl,
                              data.createdDate,
                              data.postId.toString());
                        } else {
                          CustomSnackBar(context, Text("Can't share post with no images"));
                        }
                      },
                      icon: Icon(Icons.share_outlined),
                      label: Text(
                        'Share',
                        style: ThreeKmTextConstants.tk12PXPoppinsBlackSemiBold,
                      )),
                ],
              ),
            if (data.comments > 0) Text('${data.comments} comments'),
            if (data.comments > 0 && data.latestComment != null && data.latestComment.user != null)
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CommentSection(postId: data.postId!)));
                },
                splashFactory: InkRipple.splashFactory,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image(
                          image: CachedNetworkImageProvider('${data.latestComment.user.avatar}'),
                          width: 48,
                          height: 48,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
                          decoration: BoxDecoration(
                              color: Color(0xFFF4F4F4), borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${data.latestComment.user.name}',
                                style: ThreeKmTextConstants.tk14PXPoppinsBlackBold,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  '${data.latestComment.comment}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  // @Deprecated('Replaced by CommentSection() screen.')
  // showCommentsBottomModalSheet(BuildContext context, int postId) {
  //   //print("this is new :$postId");
  //   context.read<CommentProvider>().getAllCommentsApi(postId);
  //   showModalBottomSheet<void>(
  //     backgroundColor: Colors.transparent,
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (BuildContext context) {
  //       return Padding(
  //         padding: MediaQuery.of(context).viewInsets,
  //         child: StatefulBuilder(
  //           builder: (BuildContext context, StateSetter setModalState) {
  //             return ClipPath(
  //               clipper: OvalTopBorderClipper(),
  //               child: Container(
  //                 color: Colors.white,
  //                 height: MediaQuery.of(context).size.height / 2,
  //                 padding: const EdgeInsets.all(15.0),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: <Widget>[
  //                     Container(
  //                       height: 5,
  //                       width: 30,
  //                       color: Colors.grey.shade300,
  //                     ),
  //                     SizedBox(
  //                       height: 10,
  //                     ),
  //                     Row(
  //                       children: [
  //                         Container(
  //                             height: 20, width: 20, child: Image.asset('assets/icons-topic.png')),
  //                         Padding(padding: EdgeInsets.only(left: 10)),
  //                         Consumer<CommentProvider>(builder: (context, commentProvider, _) {
  //                           return commentProvider.commentList.length != null
  //                               ? Text(
  //                                   "${commentProvider.commentList.length}\tComments",
  //                                   style: ThreeKmTextConstants.tk14PXPoppinsBlackSemiBold,
  //                                 )
  //                               : Text(
  //                                   "Comments",
  //                                   style: ThreeKmTextConstants.tk14PXPoppinsBlackSemiBold,
  //                                 );
  //                         })
  //                       ],
  //                     ),
  //                     SizedBox(
  //                       height: 10,
  //                     ),
  //                     Consumer<CommentProvider>(builder: (context, commentProvider, _) {
  //                       return context.read<CommentProvider>().commentList != null
  //                           ? Expanded(
  //                               child: commentProvider.isGettingComments == true
  //                                   ? CommentsLoadingEffects()
  //                                   : ListView.builder(
  //                                       physics: BouncingScrollPhysics(),
  //                                       shrinkWrap: true,
  //                                       primary: true,
  //                                       itemCount: commentProvider.commentList!.length,
  //                                       itemBuilder: (context, commentIndex) {
  //                                         return Container(
  //                                           margin: EdgeInsets.all(1),
  //                                           decoration: BoxDecoration(
  //                                             color: Colors.white,
  //                                           ),
  //                                           child: ListTile(
  //                                             trailing: commentProvider
  //                                                         .commentList![commentIndex].isself ==
  //                                                     true
  //                                                 ? IconButton(
  //                                                     onPressed: () {
  //                                                       context
  //                                                           .read<CommentProvider>()
  //                                                           .removeComment(
  //                                                               commentProvider
  //                                                                   .commentList![commentIndex]
  //                                                                   .commentId!,
  //                                                               postId);
  //                                                     },
  //                                                     icon: Icon(Icons.delete))
  //                                                 : SizedBox(),
  //                                             leading: Container(
  //                                               height: 40,
  //                                               width: 40,
  //                                               decoration: BoxDecoration(
  //                                                   image: DecorationImage(
  //                                                       image: CachedNetworkImageProvider(
  //                                                           commentProvider
  //                                                               .commentList![commentIndex].avatar
  //                                                               .toString()))),
  //                                             ),
  //                                             title: Text(
  //                                               commentProvider.commentList![commentIndex].username
  //                                                   .toString(),
  //                                               style:
  //                                                   ThreeKmTextConstants.tk14PXPoppinsBlackSemiBold,
  //                                             ),
  //                                             subtitle: Column(
  //                                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                                 children: [
  //                                                   SizedBox(
  //                                                     height: 4,
  //                                                   ),
  //                                                   Text(
  //                                                     commentProvider
  //                                                         .commentList![commentIndex].comment
  //                                                         .toString(),
  //                                                     style: ThreeKmTextConstants
  //                                                         .tk14PXLatoBlackMedium,
  //                                                   ),
  //                                                   SizedBox(
  //                                                     height: 2,
  //                                                   ),
  //                                                   Text(
  //                                                       commentProvider
  //                                                           .commentList![commentIndex].timeLapsed
  //                                                           .toString(),
  //                                                       style:
  //                                                           TextStyle(fontStyle: FontStyle.italic))
  //                                                 ]),
  //                                           ),
  //                                         );
  //                                       },
  //                                     ),
  //                             )
  //                           : SizedBox();
  //                     }),
  //                     Form(
  //                       key: _formKey,
  //                       child: Container(
  //                         height: 50,
  //                         width: 338,
  //                         decoration: BoxDecoration(
  //                             color: Colors.grey.shade200, borderRadius: BorderRadius.circular(20)),
  //                         child: TextFormField(
  //                           autovalidateMode: AutovalidateMode.onUserInteraction,
  //                           validator: (String? value) {
  //                             if (value == null) {
  //                               return "  Comment cant be blank";
  //                             } else if (value.isEmpty) {
  //                               return "  Comment cant be blank";
  //                             }
  //                           },
  //                           controller: _commentController,
  //                           maxLines: null,
  //                           keyboardType: TextInputType.multiline,
  //                           decoration: InputDecoration(border: InputBorder.none),
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       height: 10,
  //                     ),
  //                     Align(
  //                       alignment: Alignment.centerLeft,
  //                       child: InkWell(
  //                         onTap: () {
  //                           if (_formKey.currentState!.validate() &&
  //                               context.read<CommentProvider>().isLoading == false) {
  //                             context
  //                                 .read<CommentProvider>()
  //                                 .postCommentApi(postId, _commentController.text)
  //                                 .then((value) => _commentController.clear());
  //                           }
  //                         },
  //                         child: Container(
  //                           margin: EdgeInsets.only(left: 10),
  //                           height: 36,
  //                           width: 112,
  //                           decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(18),
  //                               color: ThreeKmTextConstants.blue2),
  //                           child: Center(child: Consumer<CommentProvider>(
  //                             builder: (context, _controller, child) {
  //                               return _controller.isLoading == false
  //                                   ? Text(
  //                                       "Submit",
  //                                       style: ThreeKmTextConstants.tk14PXPoppinsWhiteMedium,
  //                                     )
  //                                   : CupertinoActivityIndicator();
  //                             },
  //                           )),
  //                         ),
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  // @Deprecated('Replaced by Likelist() screen.')
  // _showLikedBottomModalSheet(int postId, totalLikes) {
  //   context.read<LikeListProvider>().showLikes(context, postId);
  //   showModalBottomSheet<void>(
  //     backgroundColor: Colors.white,
  //     context: context,
  //     builder: (BuildContext context) {
  //       final _likeProvider = context.watch<LikeListProvider>();
  //       return Padding(
  //           padding: EdgeInsets.zero,
  //           child: StatefulBuilder(
  //             builder: (context, _) {
  //               return Container(
  //                 color: Colors.white,
  //                 height: 192,
  //                 width: MediaQuery.of(context).size.width,
  //                 child: _likeProvider.isLoading
  //                     ? LikesLoding()
  //                     : Column(
  //                         mainAxisSize: MainAxisSize.max,
  //                         children: [
  //                           Row(
  //                             children: [
  //                               Padding(
  //                                 padding: EdgeInsets.only(top: 24, left: 18, bottom: 34),
  //                                 child: Text("$totalLikes People reacted to this"),
  //                               ),
  //                             ],
  //                           ),
  //                           Container(
  //                             height: 90,
  //                             width: double.infinity,
  //                             child: ListView.builder(
  //                               scrollDirection: Axis.horizontal,
  //                               itemCount: _likeProvider.likeList!.data!.result!.users!.length,
  //                               shrinkWrap: true,
  //                               itemBuilder: (context, index) {
  //                                 return Container(
  //                                     margin: EdgeInsets.only(
  //                                       left: 21,
  //                                     ),
  //                                     height: 85,
  //                                     width: 85,
  //                                     decoration: BoxDecoration(
  //                                         shape: BoxShape.circle,
  //                                         image: DecorationImage(
  //                                             fit: BoxFit.cover,
  //                                             image: NetworkImage(_likeProvider
  //                                                 .likeList!.data!.result!.users![index].avatar
  //                                                 .toString()))),
  //                                     child: Stack(
  //                                       children: [
  //                                         Positioned(
  //                                             right: 0,
  //                                             child: Image.asset(
  //                                               'assets/fblike2x.png',
  //                                               height: 15,
  //                                               width: 15,
  //                                               fit: BoxFit.cover,
  //                                             )),
  //                                         _likeProvider.likeList!.data!.result!.users![index]
  //                                                     .isUnknown !=
  //                                                 null
  //                                             ? Center(
  //                                                 child: Text(
  //                                                     "+${_likeProvider.likeList!.data!.result!.anonymousCount}",
  //                                                     style: TextStyle(
  //                                                         fontSize: 17, color: Colors.white),
  //                                                     textAlign: TextAlign.center),
  //                                               )
  //                                             : SizedBox.shrink()
  //                                       ],
  //                                     ));
  //                               },
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //               );
  //             },
  //           ));
  //     },
  //   );
  // }

  PopupMenuButton showPopMenu(String postID, newsData) {
    void _editPost() async {
      Navigator.push<bool>(
              context, MaterialPageRoute(builder: (context) => EditPost(postId: newsData.postId)))
          .then((value) {
        if (value ?? false) {
          if (widget.providerType == "AutthorProfileProvider") {
            context.read<AutthorProfileProvider>().getSelfProfile();
          }
        }
      });
    }

    void _copyLink() {
      Clipboard.setData(ClipboardData(
              text:
                  "${slugUrl(headLine: newsData.slugHeadline ?? newsData.submittedHeadline, postId: postID)}"))
          .then((value) => CustomSnackBar(context, Text("Link has been coppied to clipboard")));
    }

    void _share() {
      String imgUrl = newsData.images != null && newsData.images!.length > 0
          ? newsData.images!.first.toString()
          : newsData.videos!.first.thumbnail.toString();
      handleShare(
          newsData.author!.name.toString(),
          newsData.author!.image.toString(),
          newsData.slugHeadline != null || newsData.slugHeadline != ""
              ? newsData.slugHeadline
              : newsData.submittedHeadline,
          imgUrl,
          newsData.createdDate,
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

  handleShare(String authorName, String authorProfile, String headLine, String thumbnail, date,
      String postId) async {
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
                    date,
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
        log(slugUrl(headLine: headLine, postId: postId));
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
