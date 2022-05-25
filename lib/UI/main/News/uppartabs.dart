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
import 'package:threekm/widgets/video_widget.dart';
import 'package:timelines/timelines.dart';

import 'NewsList.dart';
import 'Widgets/comment_Loading.dart';
import 'Widgets/likes_Loading.dart';

ValueNotifier<bool> showAppBarGlobalSC = ValueNotifier(true);

class ThreeKMUpperTab extends StatefulWidget {
  const ThreeKMUpperTab({Key? key}) : super(key: key);

  @override
  State<ThreeKMUpperTab> createState() => _ThreeKMUpperTabState();
}

class _ThreeKMUpperTabState extends State<ThreeKMUpperTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String? _selecetdAddress;
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<LocationProvider>().getLocation());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final locationProvider = context.watch<LocationProvider>();
    final languageProvider = context.watch<AppLanguage>();
    return Scaffold(
      body: DefaultTabController(
          length: 5,
          child: NestedScrollView(
              headerSliverBuilder: (context, value) {
                return [
                  SliverAppBar(
                    floating: true,
                    //pinned: true,
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.white,
                    elevation: 0.0,
                    titleSpacing: 0,
                    bottom: PreferredSize(
                        child: Container(
                          padding: EdgeInsets.only(
                            left: 10,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    top: 8, right: 8, bottom: 8),
                                height: 45,
                                width: 50,
                                child: Image.asset("assets/icon_light.png"),
                              ),
                              Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.8,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    color: Color(0xffFAFAFA)),
                                child: InkWell(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SearchPage(tabNuber: 0))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.search,
                                            color: Color(0xffA7A6A6),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "Start your search here",
                                            style: TextStyle(
                                              color: Color(0xffA7A6A6),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                        preferredSize: Size.fromHeight(30)),
                    title: Container(
                      padding: EdgeInsets.only(top: 0, left: 10),
                      //color: Colors.amber,
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: Colors.blueAccent,
                            size: 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Your Location",
                                  style: TextStyle(
                                      color: Colors.blueAccent, fontSize: 15)),
                              Padding(
                                padding: EdgeInsets.only(left: 0, top: 5),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  child: GestureDetector(
                                    onTap: () {
                                      Future.delayed(Duration.zero, () {
                                        context
                                            .read<LocationProvider>()
                                            .getLocation()
                                            .whenComplete(() {
                                          final _locationProvider = context
                                              .read<LocationProvider>()
                                              .getlocationData;
                                          final kInitialPosition = LatLng(
                                              _locationProvider!.latitude!,
                                              _locationProvider.longitude!);
                                          if (_locationProvider != null) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PlacePicker(
                                                    apiKey: GMap_Api_Key,
                                                    // initialMapType: MapType.satellite,
                                                    onPlacePicked: (result) {
                                                      //print(result.formattedAddress);
                                                      setState(() {
                                                        _selecetdAddress = result
                                                            .formattedAddress;
                                                        print(result.geometry!
                                                            .toJson());
                                                        //  _geometry = result.geometry;
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    initialPosition:
                                                        kInitialPosition,
                                                    useCurrentLocation: true,
                                                    selectInitialPosition: true,
                                                    usePinPointingSearch: true,
                                                    usePlaceDetailSearch: true,
                                                  ),
                                                ));
                                          }
                                        });
                                      });
                                    },
                                    child: Text(
                                        _selecetdAddress ??
                                            locationProvider
                                                .AddressFromCordinate ??
                                            "",
                                        style: ThreeKmTextConstants
                                            .tk12PXPoppinsBlackSemiBold
                                            .copyWith(color: Color(0xffABABAB)),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ];
              },
              body: Material(
                child: Container(
                  // margin: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      Container(
                        // margin: EdgeInsets.only(bottom: 5),
                        width: MediaQuery.of(context).size.width,
                        child: const TabBar(
                            isScrollable: true,
                            labelColor: Colors.black,
                            indicatorColor: Color(0xFF000000),
                            labelStyle: TextStyle(fontSize: 20),
                            unselectedLabelColor: Color(0xFFABABAB),
                            tabs: [
                              Tab(
                                text: "Home",
                              ),
                              Tab(
                                text: "Feed",
                              ),
                              Tab(
                                text: "Food",
                              ),
                              Tab(
                                text: "Shop",
                              ),
                              Tab(
                                text: "Business",
                              ),
                            ]),
                      ),
                      Flexible(
                        child: TabBarView(
                            dragStartBehavior: DragStartBehavior.down,
                            children: [
                              NewsTab(
                                reload: false, //widget.redirectedFromPost
                                isPostUploaded: false, // widget.isPostUploaded,
                                appLanguage: languageProvider.appLocal,
                              ),
                              FeedPage(),
                              //Container(),
                              RestaurantsHome(),
                              Home3KM(),
                              BusinessesHome(),
                            ]),
                      )
                    ],
                  ),
                ),
              ))),
    );
  }
}

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
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
    final newsFeedProvider = context.watch<NewsFeedProvider>();
    return SingleChildScrollView(
      child: Column(
        children: [
          if (newsFeedProvider
                      .newsFeedBottomModel?.data?.result?.posts?.length !=
                  0 &&
              newsFeedProvider.newsFeedBottomModel?.data?.result?.posts !=
                  null) ...{
            ListView.builder(
              cacheExtent: 999,
              primary: true,
              physics: ScrollPhysics(),
              shrinkWrap: true,
              // itemCount: newsFeedProvider
              //     .newsFeedBottomModel!.data!.result!.posts!.length,
              itemCount: postCount,
              itemBuilder: (context, index) {
                final newsData = newsFeedProvider
                    .newsFeedBottomModel!.data!.result!.posts![index];

                return Stack(alignment: AlignmentDirectional.center, children: [
                  Padding(
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xff32335E26), blurRadius: 8),
                            ],
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(right: 10),
                                      height: 50,
                                      width: 50,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AuthorProfile(
                                                          authorType: newsData
                                                              .authorType,
                                                          // page: 1,
                                                          // authorType:
                                                          //     "user",
                                                          id: newsData
                                                              .author!.id!,
                                                          avatar: newsData
                                                              .author!.image!,
                                                          userName: newsData
                                                              .author!.name!)));
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image:
                                                      CachedNetworkImageProvider(
                                                          newsData.author!.image
                                                              .toString()))),
                                          child: newsData.isVerified == true
                                              ? Stack(
                                                  children: [
                                                    Positioned(
                                                        left: 0,
                                                        child: Image.asset(
                                                          'assets/verified.png',
                                                          height: 15,
                                                          width: 15,
                                                          fit: BoxFit.cover,
                                                        ))
                                                  ],
                                                )
                                              : Container(),
                                        ),
                                      )),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    //mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.55,
                                        child: Text(
                                          newsData.author!.name.toString(),
                                          style: ThreeKmTextConstants
                                              .tk14PXPoppinsBlackBold,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(newsData.createdDate.toString()),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Consumer<NewsListProvider>(builder:
                                              (context, newsProvider, _) {
                                            return GestureDetector(
                                                onTap: () {
                                                  if (newsData
                                                          .author!.isFollowed ==
                                                      true) {
                                                    print("is followed: true");
                                                    newsFeedProvider
                                                        .unfollowUser(newsData
                                                            .author!.id!
                                                            .toInt());
                                                  } else if (newsData.author!
                                                              .isFollowed ==
                                                          false ||
                                                      newsData.author!
                                                              .isFollowed ==
                                                          null) {
                                                    newsFeedProvider.followUser(
                                                      newsData.author!.id!
                                                          .toInt(),
                                                    );
                                                  }
                                                },
                                                child: newsData.author!
                                                            .isFollowed ==
                                                        true
                                                    ? Text("Following",
                                                        style: ThreeKmTextConstants
                                                            .tk11PXLatoGreyBold)
                                                    : Text("Follow",
                                                        style: ThreeKmTextConstants
                                                            .tk14PXPoppinsBlueMedium));
                                          }),
                                        ],
                                      )
                                    ],
                                  ),
                                  Spacer(),
                                  showPopMenu(
                                      newsData.postId.toString(), newsData)
                                  // IconButton(
                                  //     onPressed: () {}, icon: Icon(Icons.more_vert))
                                ],
                              ),
                            ),
                            //both pics and images is present

                            newsData.images!.length > 1 ||
                                    newsData.videos!.length > 1
                                ?
                                //video and image both
                                Container(
                                    height: 400,
                                    width: 400,
                                    decoration:
                                        BoxDecoration(color: Colors.black26),
                                    child: PageView.builder(
                                      itemCount: newsData.images!.length +
                                          newsData.videos!.length,
                                      itemBuilder: (
                                        context,
                                        index,
                                      ) {
                                        List<String?> videoUrls = newsData
                                            .videos!
                                            .map((e) => e.src)
                                            .toList();
                                        List<String?> imgList = List.from(
                                            newsData.images!.toList());
                                        List<String?> templist =
                                            videoUrls + imgList;
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
                                                        thubnail: '',
                                                        url: templist[index]
                                                            .toString(),
                                                        play: false),
                                                  )
                                                : CachedNetworkImage(
                                                    height: 254,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    fit: BoxFit.contain,
                                                    imageUrl: templist[index]
                                                        .toString())
                                            : SizedBox(
                                                child: Text("null"),
                                              );
                                      },
                                    ),
                                  )
                                // image or video single

                                : newsData.images != null &&
                                        newsData.videos != null
                                    ? Container(
                                        child: newsData.images!.length == 1
                                            ? CachedNetworkImage(
                                                height: 254,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                fit: BoxFit.contain,
                                                imageUrl:
                                                    '${newsData.images!.first}',
                                              )
                                            : newsData.videos!.length > 0
                                                ? VideoWidget(
                                                    thubnail: newsData
                                                                .videos
                                                                ?.first
                                                                .thumbnail !=
                                                            null
                                                        ? newsData.videos!.first
                                                            .thumbnail
                                                            .toString()
                                                        : '',
                                                    url: newsData
                                                        .videos!.first.src
                                                        .toString(),
                                                    fromSinglePage: true,
                                                    play: false)
                                                : Container(),
                                      )
                                    : SizedBox.shrink(),
                            SizedBox(
                              height: 5,
                            ),
                            newsData.images != null &&
                                        newsData.images!.length > 1 &&
                                        newsData.images!.length != 1 ||
                                    newsData.videos != null &&
                                        newsData.videos!.length > 1 &&
                                        newsData.videos!.length != 1
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

                            Row(children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: 5, left: 5, bottom: 2),
                                  child: InkWell(
                                    onTap: () {
                                      _showLikedBottomModalSheet(
                                          newsData.postId!.toInt(),
                                          newsData.likes);
                                    },
                                    child: newsData.likes != 0
                                        ? Row(
                                            children: [
                                              Text('👍❤️'),
                                              Container(
                                                child: Center(
                                                    child: Text('+' +
                                                        newsData.likes
                                                            .toString())),
                                              )
                                            ],
                                          )
                                        : SizedBox.shrink(),
                                  )),
                              Spacer(),
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: 5, right: 5, bottom: 2),
                                  child: Text(
                                      newsData.views.toString() + ' Views'))
                            ]),
                            Text(
                              newsData.headline.toString(),
                              style: ThreeKmTextConstants.tk14PXLatoBlackMedium,
                              textAlign: TextAlign.center,
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return Postview(
                                      postId: newsData.postId.toString(),
                                    );
                                  }));
                                },
                                child: Text(
                                  "Read More",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                )),
                            SizedBox(
                              height: 35,
                            ),
                          ],
                        )),
                      )
                    ]),
                  ),
                  Positioned(
                      bottom: 0,
                      child: Container(
                        height: 60,
                        width: 230,
                        child: ButtonBar(children: [
                          Container(
                            height: 60,
                            width: 60,
                            child: InkWell(
                              onTap: () async {
                                if (await getAuthStatus()) {
                                  if (newsData.isLiked == true) {
                                    newsFeedProvider
                                        .postUnLike(newsData.postId.toString());
                                  } else {
                                    newsFeedProvider.postLike(
                                        newsData.postId.toString(), null);
                                  }
                                } else {
                                  NaviagateToLogin(context);
                                }
                              },
                              child: newsData.isLiked!
                                  ? Image.asset("assets/thumbs_up_red.png")
                                  : Image.asset("assets/thumbs-up.png"),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 8,
                                  )
                                ]),
                          ),
                          Container(
                            height: 60,
                            width: 60,
                            child: IconButton(
                                onPressed: () async {
                                  if (await getAuthStatus()) {
                                    _showCommentsBottomModalSheet(
                                        context, newsData.postId!.toInt());
                                  } else {
                                    NaviagateToLogin(context);
                                  }
                                },
                                icon: Image.asset('assets/icons-topic.png',
                                    fit: BoxFit.cover)),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 8,
                                  )
                                ]),
                          ),
                          Container(
                            height: 60,
                            width: 60,
                            child: IconButton(
                                onPressed: () async {
                                  // showLoading();
                                  String imgUrl = newsData.images != null &&
                                          newsData.images!.length > 0
                                      ? newsData.images!.first.toString()
                                      : newsData.videos!.first.thumbnail
                                          .toString();
                                  handleShare(
                                      newsData.author!.name.toString(),
                                      newsData.author!.image.toString(),
                                      newsData.headline.toString(),
                                      imgUrl,
                                      newsData.createdDate,
                                      newsData.postId.toString());
                                },
                                icon: Center(
                                  child: Image.asset('assets/icons-share.png',
                                      fit: BoxFit.contain),
                                )),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 8,
                                  )
                                ]),
                          ),
                        ]),
                      )),
                ]);
              },
            ),
          }
        ],
      ),
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
                          height: 50,
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
                            if (_formKey.currentState!.validate() &&
                                context.read<CommentProvider>().isLoading ==
                                    false) {
                              context
                                  .read<CommentProvider>()
                                  .postCommentApi(
                                      postId, _commentController.text)
                                  .then((value) => _commentController.clear());
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
              String imgUrl =
                  newsData.images != null && newsData.images!.length > 0
                      ? newsData.images!.first.toString()
                      : newsData.videos!.first.thumbnail.toString();
              handleShare(
                  newsData.author!.name.toString(),
                  newsData.author!.image.toString(),
                  newsData.submittedHeadline.toString(),
                  imgUrl,
                  newsData.createdDate,
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

  handleShare(String authorName, String authorProfile, String headLine,
      String thumbnail, date, String postId) async {
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
