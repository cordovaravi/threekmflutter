import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:threekm/Custom_library/GooleMapsWidget/src/place_picker.dart';
import 'package:threekm/UI/Search/SearchPage.dart';
import 'package:threekm/UI/businesses/businesses_home.dart';
import 'package:threekm/UI/main/News/NewsTab.dart';
import 'package:threekm/UI/main/News/PostView.dart';
import 'package:threekm/UI/main/Profile/AuthorProfile.dart';
import 'package:threekm/UI/shop/home_3km.dart';
import 'package:threekm/UI/shop/restaurants/restaurants_home_page.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/commenwidgets/commenwidget.dart';
import 'package:threekm/providers/Global/logged_in_or_not.dart';
import 'package:threekm/providers/Location/locattion_Provider.dart';
import 'package:threekm/providers/localization_Provider/appLanguage_provider.dart';
import 'package:threekm/providers/main/LikeList_Provider.dart';
import 'package:threekm/providers/main/NewsFeed_Provider.dart';
import 'package:threekm/providers/main/comment_Provider.dart';
import 'package:threekm/providers/main/newsList_provider.dart';
import 'package:threekm/utils/api_paths.dart';
import 'package:threekm/utils/constants.dart';
import 'package:threekm/utils/threekm_textstyles.dart';
import 'package:threekm/widgets/NewCardUI/card_ui.dart';
import 'package:threekm/widgets/video_widget.dart';
import 'package:timelines/timelines.dart';

import 'NewsList.dart';
import 'Widgets/comment_Loading.dart';
import 'Widgets/likes_Loading.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage>
    with AutomaticKeepAliveClientMixin {
  int postCount = 10;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _commentController = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    Future.microtask(() => context.read<NewsFeedProvider>().getBottomFeed(
          languageCode: context.read<AppLanguage>().appLocal == Locale("mr")
              ? "mr"
              : context.read<AppLanguage>().appLocal == Locale("en")
                  ? "en"
                  : "hi",
        ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final newsFeedProvider = context.watch<NewsFeedProvider>();
    final newsData = newsFeedProvider.newsFeedBottomModel != null
        ? newsFeedProvider.newsFeedBottomModel!.data!.result!.posts!
        : null;
    return newsFeedProvider.isLoading == true
        ? Container(child: FeedPostLoadingWidget())
        : newsFeedProvider.newsFeedBottomModel?.data?.result?.posts?.length !=
                    0 &&
                newsFeedProvider.newsFeedBottomModel?.data?.result?.posts !=
                    null
            ? ListView.builder(
                cacheExtent: 50,

                primary: true,
                physics: ScrollPhysics(),
                shrinkWrap: true,
                // itemCount: newsFeedProvider
                //     .newsFeedBottomModel!.data!.result!.posts!.length,
                itemCount: newsData?.length, //postCount,
                itemBuilder: (context, index) {
                  var newData = newsData?[index];
                  if (postCount == index - 1) {
                    WidgetsBinding.instance?.addPostFrameCallback((_) {
                      setState(() {
                        postCount += 10;
                      });
                    });
                  }
                  return newData != null
                      ? CardUI(
                          data: newData,
                        )
                      : Container();
                  // return Stack(
                  //     alignment: AlignmentDirectional.center,
                  //     children: [
                  //       Padding(
                  //         padding: EdgeInsets.only(
                  //             left: 10, right: 10, top: 8, bottom: 8),
                  //         child: Column(
                  //             mainAxisSize: MainAxisSize.min,
                  //             children: [
                  //               Container(
                  //                 margin: EdgeInsets.only(bottom: 10),
                  //                 decoration: BoxDecoration(
                  //                     color: Colors.white,
                  //                     boxShadow: [
                  //                       BoxShadow(
                  //                           color: Color(0xff32335E26),
                  //                           blurRadius: 8),
                  //                     ],
                  //                     borderRadius:
                  //                         BorderRadius.circular(10)),
                  //                 child: Container(
                  //                     child: Column(
                  //                   mainAxisAlignment:
                  //                       MainAxisAlignment.start,
                  //                   children: [
                  //                     Padding(
                  //                       padding: const EdgeInsets.all(10.0),
                  //                       child: Row(
                  //                         crossAxisAlignment:
                  //                             CrossAxisAlignment.start,
                  //                         children: [
                  //                           Container(
                  //                               margin: EdgeInsets.only(
                  //                                   right: 10),
                  //                               height: 50,
                  //                               width: 50,
                  //                               child: GestureDetector(
                  //                                 onTap: () {
                  //                                   Navigator.push(
                  //                                       context,
                  //                                       MaterialPageRoute(
                  //                                           builder: (context) =>
                  //                                               AuthorProfile(
                  //                                                   authorType:
                  //                                                       newsData
                  //                                                           .authorType,
                  //                                                   // page: 1,
                  //                                                   // authorType:
                  //                                                   //     "user",
                  //                                                   id: newsData
                  //                                                       .author!
                  //                                                       .id!,
                  //                                                   avatar: newsData
                  //                                                       .author!
                  //                                                       .image!,
                  //                                                   userName: newsData
                  //                                                       .author!
                  //                                                       .name!)));
                  //                                 },
                  //                                 child: Container(
                  //                                   height: 50,
                  //                                   width: 50,
                  //                                   decoration: BoxDecoration(
                  //                                       shape:
                  //                                           BoxShape.circle,
                  //                                       image: DecorationImage(
                  //                                           fit: BoxFit
                  //                                               .cover,
                  //                                           image: CachedNetworkImageProvider(
                  //                                               newsData
                  //                                                   .author!
                  //                                                   .image
                  //                                                   .toString()))),
                  //                                   child:
                  //                                       newsData.isVerified ==
                  //                                               true
                  //                                           ? Stack(
                  //                                               children: [
                  //                                                 Positioned(
                  //                                                     left:
                  //                                                         0,
                  //                                                     child:
                  //                                                         Image.asset(
                  //                                                       'assets/verified.png',
                  //                                                       height:
                  //                                                           15,
                  //                                                       width:
                  //                                                           15,
                  //                                                       fit:
                  //                                                           BoxFit.cover,
                  //                                                     ))
                  //                                               ],
                  //                                             )
                  //                                           : Container(),
                  //                                 ),
                  //                               )),
                  //                           Column(
                  //                             crossAxisAlignment:
                  //                                 CrossAxisAlignment.start,
                  //                             //mainAxisAlignment: MainAxisAlignment.center,
                  //                             children: [
                  //                               Container(
                  //                                 width:
                  //                                     MediaQuery.of(context)
                  //                                             .size
                  //                                             .width *
                  //                                         0.55,
                  //                                 child: Text(
                  //                                   newsData.author!.name
                  //                                       .toString(),
                  //                                   style: ThreeKmTextConstants
                  //                                       .tk14PXPoppinsBlackBold,
                  //                                   overflow: TextOverflow
                  //                                       .ellipsis,
                  //                                 ),
                  //                               ),
                  //                               Row(
                  //                                 children: [
                  //                                   Text(newsData
                  //                                       .createdDate
                  //                                       .toString()),
                  //                                   SizedBox(
                  //                                     width: 8,
                  //                                   ),
                  //                                   Consumer<
                  //                                           NewsListProvider>(
                  //                                       builder: (context,
                  //                                           newsProvider,
                  //                                           _) {
                  //                                     return GestureDetector(
                  //                                         onTap: () {
                  //                                           if (newsData
                  //                                                   .author!
                  //                                                   .isFollowed ==
                  //                                               true) {
                  //                                             print(
                  //                                                 "is followed: true");
                  //                                             newsFeedProvider
                  //                                                 .unfollowUser(newsData
                  //                                                     .author!
                  //                                                     .id!
                  //                                                     .toInt());
                  //                                           } else if (newsData
                  //                                                       .author!
                  //                                                       .isFollowed ==
                  //                                                   false ||
                  //                                               newsData.author!
                  //                                                       .isFollowed ==
                  //                                                   null) {
                  //                                             newsFeedProvider
                  //                                                 .followUser(
                  //                                               newsData
                  //                                                   .author!
                  //                                                   .id!
                  //                                                   .toInt(),
                  //                                             );
                  //                                           }
                  //                                         },
                  //                                         child: newsData
                  //                                                     .author!
                  //                                                     .isFollowed ==
                  //                                                 true
                  //                                             ? Text(
                  //                                                 "Following",
                  //                                                 style: ThreeKmTextConstants
                  //                                                     .tk11PXLatoGreyBold)
                  //                                             : Text(
                  //                                                 "Follow",
                  //                                                 style: ThreeKmTextConstants
                  //                                                     .tk14PXPoppinsBlueMedium));
                  //                                   }),
                  //                                 ],
                  //                               )
                  //                             ],
                  //                           ),
                  //                           Spacer(),
                  //                           showPopMenu(
                  //                               newsData.postId.toString(),
                  //                               newsData)
                  //                           // IconButton(
                  //                           //     onPressed: () {}, icon: Icon(Icons.more_vert))
                  //                         ],
                  //                       ),
                  //                     ),
                  //                     //both pics and images is present

                  //                     newsData.images!.length > 1 ||
                  //                             newsData.videos!.length > 1
                  //                         ?
                  //                         //video and image both
                  //                         Container(
                  //                             height: 400,
                  //                             width: 400,
                  //                             decoration: BoxDecoration(
                  //                                 color: Colors.black26),
                  //                             child: PageView.builder(
                  //                               itemCount: newsData
                  //                                       .images!.length +
                  //                                   newsData.videos!.length,
                  //                               itemBuilder: (
                  //                                 context,
                  //                                 index,
                  //                               ) {
                  //                                 List<String?> videoUrls =
                  //                                     newsData.videos!
                  //                                         .map((e) => e.src)
                  //                                         .toList();
                  //                                 List<String?> imgList =
                  //                                     List.from(newsData
                  //                                         .images!
                  //                                         .toList());
                  //                                 List<String?> templist =
                  //                                     videoUrls + imgList;
                  //                                 return templist != null
                  //                                     ? templist[index]
                  //                                             .toString()
                  //                                             .contains(
                  //                                                 ".mp4")
                  //                                         ? SizedBox(
                  //                                             height: 300,
                  //                                             width: MediaQuery.of(
                  //                                                     context)
                  //                                                 .size
                  //                                                 .width,
                  //                                             child: VideoWidget(
                  //                                                 thubnail:
                  //                                                     '',
                  //                                                 url: templist[
                  //                                                         index]
                  //                                                     .toString(),
                  //                                                 play:
                  //                                                     false),
                  //                                           )
                  //                                         : CachedNetworkImage(
                  //                                             height: 254,
                  //                                             width: MediaQuery.of(
                  //                                                     context)
                  //                                                 .size
                  //                                                 .width,
                  //                                             fit: BoxFit
                  //                                                 .contain,
                  //                                             imageUrl: templist[
                  //                                                     index]
                  //                                                 .toString())
                  //                                     : SizedBox(
                  //                                         child:
                  //                                             Text("null"),
                  //                                       );
                  //                               },
                  //                             ),
                  //                           )
                  //                         // image or video single

                  //                         : newsData.images != null &&
                  //                                 newsData.videos != null
                  //                             ? Container(
                  //                                 child: newsData.images!
                  //                                             .length ==
                  //                                         1
                  //                                     ? CachedNetworkImage(
                  //                                         height: 254,
                  //                                         width:
                  //                                             MediaQuery.of(
                  //                                                     context)
                  //                                                 .size
                  //                                                 .width,
                  //                                         fit: BoxFit
                  //                                             .contain,
                  //                                         imageUrl:
                  //                                             '${newsData.images!.first}',
                  //                                       )
                  //                                     : newsData.videos!.length >
                  //                                             0
                  //                                         ? VideoWidget(
                  //                                             thubnail: newsData.videos?.first.thumbnail !=
                  //                                                     null
                  //                                                 ? newsData
                  //                                                     .videos!
                  //                                                     .first
                  //                                                     .thumbnail
                  //                                                     .toString()
                  //                                                 : '',
                  //                                             url: newsData
                  //                                                 .videos!
                  //                                                 .first
                  //                                                 .src
                  //                                                 .toString(),
                  //                                             fromSinglePage:
                  //                                                 true,
                  //                                             play: false)
                  //                                         : Container(),
                  //                               )
                  //                             : SizedBox.shrink(),
                  //                     SizedBox(
                  //                       height: 5,
                  //                     ),
                  //                     newsData.images != null &&
                  //                                 newsData.images!.length >
                  //                                     1 &&
                  //                                 newsData.images!.length !=
                  //                                     1 ||
                  //                             newsData.videos != null &&
                  //                                 newsData.videos!.length >
                  //                                     1 &&
                  //                                 newsData.videos!.length !=
                  //                                     1
                  //                         ? Container(
                  //                             height: 10,
                  //                             width: MediaQuery.of(context)
                  //                                 .size
                  //                                 .width,
                  //                             child: Builder(
                  //                                 builder: (context) {
                  //                               List videoUrls = newsData
                  //                                   .videos!
                  //                                   .map((e) => e.src)
                  //                                   .toList();
                  //                               List templist = List.from(
                  //                                   newsData.images!
                  //                                       .toList())
                  //                                 ..addAll(videoUrls);
                  //                               return Row(
                  //                                   mainAxisAlignment:
                  //                                       MainAxisAlignment
                  //                                           .center,
                  //                                   children: templist
                  //                                       .asMap()
                  //                                       .entries
                  //                                       .map((entry) {
                  //                                     return Padding(
                  //                                       padding:
                  //                                           const EdgeInsets
                  //                                                   .only(
                  //                                               left: 2),
                  //                                       child: DotIndicator(
                  //                                         size: 8.0,
                  //                                         color:
                  //                                             Colors.grey,
                  //                                       ),
                  //                                     );
                  //                                   }).toList());
                  //                             }),
                  //                           )
                  //                         : SizedBox.shrink(),

                  //                     Row(children: [
                  //                       Padding(
                  //                           padding: EdgeInsets.only(
                  //                               top: 5, left: 5, bottom: 2),
                  //                           child: InkWell(
                  //                             onTap: () {
                  //                               _showLikedBottomModalSheet(
                  //                                   newsData.postId!
                  //                                       .toInt(),
                  //                                   newsData.likes);
                  //                             },
                  //                             child: newsData.likes != 0
                  //                                 ? Row(
                  //                                     children: [
                  //                                       Text('👍❤️'),
                  //                                       Container(
                  //                                         child: Center(
                  //                                             child: Text('+' +
                  //                                                 newsData
                  //                                                     .likes
                  //                                                     .toString())),
                  //                                       )
                  //                                     ],
                  //                                   )
                  //                                 : SizedBox.shrink(),
                  //                           )),
                  //                       Spacer(),
                  //                       Padding(
                  //                           padding: EdgeInsets.only(
                  //                               top: 5,
                  //                               right: 5,
                  //                               bottom: 2),
                  //                           child: Text(
                  //                               newsData.views.toString() +
                  //                                   ' Views'))
                  //                     ]),
                  //                     Text(
                  //                       newsData.headline.toString(),
                  //                       style: ThreeKmTextConstants
                  //                           .tk14PXLatoBlackMedium,
                  //                       textAlign: TextAlign.center,
                  //                     ),
                  //                     TextButton(
                  //                         onPressed: () {
                  //                           Navigator.push(context,
                  //                               MaterialPageRoute(builder:
                  //                                   (BuildContext context) {
                  //                             return Postview(
                  //                               postId: newsData.postId
                  //                                   .toString(),
                  //                             );
                  //                           }));
                  //                         },
                  //                         child: Text(
                  //                           "Read More",
                  //                           style: TextStyle(
                  //                               fontSize: 14,
                  //                               fontWeight: FontWeight.bold,
                  //                               color: Colors.blue),
                  //                         )),
                  //                     SizedBox(
                  //                       height: 35,
                  //                     ),
                  //                   ],
                  //                 )),
                  //               )
                  //             ]),
                  //       ),
                  //       Positioned(
                  //           bottom: 0,
                  //           child: Container(
                  //             height: 60,
                  //             width: 230,
                  //             child: ButtonBar(children: [
                  //               Container(
                  //                 height: 60,
                  //                 width: 60,
                  //                 child: InkWell(
                  //                   onTap: () async {
                  //                     if (await getAuthStatus()) {
                  //                       if (newsData.isLiked == true) {
                  //                         newsFeedProvider.postUnLike(
                  //                             newsData.postId.toString());
                  //                       } else {
                  //                         newsFeedProvider.postLike(
                  //                             newsData.postId.toString(),
                  //                             null);
                  //                       }
                  //                     } else {
                  //                       NaviagateToLogin(context);
                  //                     }
                  //                   },
                  //                   child: newsData.isLiked!
                  //                       ? Image.asset(
                  //                           "assets/thumbs_up_red.png")
                  //                       : Image.asset(
                  //                           "assets/thumbs-up.png"),
                  //                 ),
                  //                 decoration: BoxDecoration(
                  //                     color: Colors.white,
                  //                     shape: BoxShape.circle,
                  //                     boxShadow: [
                  //                       BoxShadow(
                  //                         color: Colors.black26,
                  //                         blurRadius: 8,
                  //                       )
                  //                     ]),
                  //               ),
                  //               Container(
                  //                 height: 60,
                  //                 width: 60,
                  //                 child: IconButton(
                  //                     onPressed: () async {
                  //                       if (await getAuthStatus()) {
                  //                         _showCommentsBottomModalSheet(
                  //                             context,
                  //                             newsData.postId!.toInt());
                  //                       } else {
                  //                         NaviagateToLogin(context);
                  //                       }
                  //                     },
                  //                     icon: Image.asset(
                  //                         'assets/icons-topic.png',
                  //                         fit: BoxFit.cover)),
                  //                 decoration: BoxDecoration(
                  //                     color: Colors.white,
                  //                     shape: BoxShape.circle,
                  //                     boxShadow: [
                  //                       BoxShadow(
                  //                         color: Colors.black26,
                  //                         blurRadius: 8,
                  //                       )
                  //                     ]),
                  //               ),
                  //               Container(
                  //                 height: 60,
                  //                 width: 60,
                  //                 child: IconButton(
                  //                     onPressed: () async {
                  //                       // showLoading();
                  //                       String imgUrl = newsData.images !=
                  //                                   null &&
                  //                               newsData.images!.length > 0
                  //                           ? newsData.images!.first
                  //                               .toString()
                  //                           : newsData
                  //                               .videos!.first.thumbnail
                  //                               .toString();
                  //                       handleShare(
                  //                           newsData.author!.name
                  //                               .toString(),
                  //                           newsData.author!.image
                  //                               .toString(),
                  //                           newsData.headline.toString(),
                  //                           imgUrl,
                  //                           newsData.createdDate,
                  //                           newsData.postId.toString());
                  //                     },
                  //                     icon: Center(
                  //                       child: Image.asset(
                  //                           'assets/icons-share.png',
                  //                           fit: BoxFit.contain),
                  //                     )),
                  //                 decoration: BoxDecoration(
                  //                     color: Colors.white,
                  //                     shape: BoxShape.circle,
                  //                     boxShadow: [
                  //                       BoxShadow(
                  //                         color: Colors.black26,
                  //                         blurRadius: 8,
                  //                       )
                  //                     ]),
                  //               ),
                  //             ]),
                  //           )),
                  //     ]);
                },
              )
            : Container();
  }

  @override
  bool get wantKeepAlive => true;
}
