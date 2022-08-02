import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter/widgets.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';

import 'package:threekm/Models/ProfilePostModel.dart';
import 'package:threekm/UI/main/Profile/reportProfile.dart';
import 'package:threekm/commenwidgets/fullImage.dart';

import 'package:threekm/providers/Global/logged_in_or_not.dart';
import 'package:threekm/providers/localization_Provider/appLanguage_provider.dart';
import 'package:threekm/providers/main/AthorProfile_Provider.dart';

import 'package:threekm/widgets/NewCardUI/card_ui.dart';

import 'package:threekm/utils/utils.dart';

class AuthorProfile extends StatefulWidget {
  final int id;
  final String avatar;
  final String? authorType;
  final String userName;
  //final int page;
  AuthorProfile({
    Key? key,
    //required this.page,
    required this.authorType,
    required this.id,
    required this.avatar,
    required this.userName,
  }) : super(key: key);

  @override
  _AuthorProfileState createState() => _AuthorProfileState();
}

class _AuthorProfileState extends State<AuthorProfile>
    with TickerProviderStateMixin {
  late TabController _tabController;

  int index = 0;
  int pageCount = 1;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    if (mounted) {
      Future.microtask(() {
        context
            .read<AutthorProfileProvider>()
            .getAuthorProfile(pageCount, false,
                authorId: widget.id,
                authorType: widget.authorType,
                language: context.read<AppLanguage>().appLocal == Locale("en")
                    ? "en"
                    : context.read<AppLanguage>().appLocal == Locale("mr")
                        ? "mr"
                        : "hi");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selfProfile = context.watch<AutthorProfileProvider>();
    var authorProfile = selfProfile.authorProfilePostData;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (_) {
                      return ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          color: Colors.white,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Share Profile',
                                    style: ThreeKmTextConstants
                                        .tk14PXPoppinsBlackMedium
                                        .copyWith(fontWeight: FontWeight.w400),
                                  )),
                              TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Copy Profile Link',
                                    style: ThreeKmTextConstants
                                        .tk14PXPoppinsBlackMedium
                                        .copyWith(fontWeight: FontWeight.w400),
                                  )),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => ReportProfile()));
                                  },
                                  child: Text(
                                    'Report Profile',
                                    style: ThreeKmTextConstants
                                        .tk14PXPoppinsBlackMedium
                                        .copyWith(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w400),
                                  )),
                              TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Cancel',
                                    style: ThreeKmTextConstants
                                        .tk14PXPoppinsBlackMedium
                                        .copyWith(fontWeight: FontWeight.w400),
                                  )),
                            ],
                          ),
                        ),
                      );
                    });
              },
              icon: Icon(Icons.more_vert))
        ],
      ),
      body: selfProfile.gettingAuthorprofile == true
          ? Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: Center(child: CircularProgressIndicator()),
            )
          : Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                selfProfile.authorProfilePostData != null
                    ? Expanded(
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            ),
                          ),
                          child: Stack(
                            children: [
                              LazyLoadScrollView(
                                onEndOfPage: () {
                                  pageCount++;
                                  context
                                      .read<AutthorProfileProvider>()
                                      .getAuthorProfile(pageCount, true,
                                          authorId: widget.id,
                                          authorType: widget.authorType,
                                          language: context
                                                      .read<AppLanguage>()
                                                      .appLocal ==
                                                  Locale("en")
                                              ? "en"
                                              : context
                                                          .read<AppLanguage>()
                                                          .appLocal ==
                                                      Locale("mr")
                                                  ? "mr"
                                                  : "hi");
                                },
                                child: CustomScrollView(
                                  //    controller: _controller,
                                  slivers: [
                                    SliverAppBar(
                                      collapsedHeight: 0,
                                      expandedHeight: 310,
                                      // widget.isFromSelfProfileNavigate != true ? 250 : 300,
                                      toolbarHeight: 0,
                                      backgroundColor: Colors.white,
                                      flexibleSpace: FlexibleSpaceBar(
                                        background: Column(
                                          children: [
                                            buildAvatar,
                                            //space(height: 68),
                                            Container(
                                              //width: MediaQuery.of(context).size.width * 0.65,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 32),
                                              child: Center(
                                                child: Text(
                                                  "${widget.userName}",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: ThreeKmTextConstants
                                                      .tk14PXPoppinsBlackSemiBold
                                                      .copyWith(fontSize: 24),
                                                ),
                                              ),
                                            ),
                                            Container(
                                                //width: 298,
                                                child: authorProfile
                                                            ?.data
                                                            .result!
                                                            .author!
                                                            .about
                                                            .toString() !=
                                                        "null"
                                                    ? Column(
                                                        children: [
                                                          Text(
                                                            "${authorProfile?.data.result!.author!.about}",
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: ThreeKmTextConstants
                                                                .tk14PXPoppinsBlackSemiBold
                                                                .copyWith(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 8,
                                                          ),
                                                          // about text
                                                          // Container(),
                                                          // buildFollowing(context)
                                                        ],
                                                      )
                                                    : SizedBox()),
                                            // Column(
                                            //   children: [
                                            //     //space(height: 32),
                                            //     buildFollowing(context),
                                            //     //space(height: 32),
                                            //     buildFollowingButton,
                                            //     //buildFollowingButton,
                                            //   ],
                                            // ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8, horizontal: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(
                                                          authorProfile
                                                                  ?.data
                                                                  .result
                                                                  ?.author
                                                                  ?.followers
                                                                  .toString() ??
                                                              "",
                                                          style:
                                                              GoogleFonts.poppins(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize:
                                                                      18)),
                                                      Text(
                                                        "Followers",
                                                        style: ThreeKmTextConstants
                                                            .tk14PXPoppinsBlackSemiBold
                                                            .copyWith(
                                                                color: Color(
                                                                    0xff979EA4)),
                                                      )
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                          authorProfile
                                                                  ?.data
                                                                  .result
                                                                  ?.author
                                                                  ?.totalPosts
                                                                  .toString() ??
                                                              "",
                                                          style:
                                                              GoogleFonts.poppins(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize:
                                                                      18)),
                                                      Text(
                                                        "Posts",
                                                        style: ThreeKmTextConstants
                                                            .tk14PXPoppinsBlackSemiBold
                                                            .copyWith(
                                                                color: Color(
                                                                    0xff979EA4)),
                                                      )
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                          authorProfile
                                                                  ?.data
                                                                  .result
                                                                  ?.author
                                                                  ?.following
                                                                  .toString() ??
                                                              "",
                                                          style:
                                                              GoogleFonts.poppins(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize:
                                                                      18)),
                                                      Text(
                                                        "Following",
                                                        style: ThreeKmTextConstants
                                                            .tk14PXPoppinsBlackSemiBold
                                                            .copyWith(
                                                                color: Color(
                                                                    0xff979EA4)),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            space(height: 10),
                                            buildFollowingButton(
                                                isLoading:
                                                    selfProfile.followLoading,
                                                authorId: authorProfile?.data
                                                        .result?.author?.id ??
                                                    0,
                                                isFollowed: authorProfile
                                                        ?.data
                                                        .result
                                                        ?.author
                                                        ?.isFollowed ??
                                                    false)
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (index == 0 &&
                                        authorProfile != null) ...{
                                      SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                          (context, _index) {
                                            return ListView.builder(
                                              physics: BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: authorProfile.data
                                                      .result!.posts!.length +
                                                  1,
                                              itemBuilder: (context, _) {
                                                return _ <
                                                        authorProfile
                                                            .data
                                                            .result!
                                                            .posts!
                                                            .length
                                                    ? NewsCard(
                                                        key: Key(
                                                            _index.toString()),
                                                        avtar: widget.avatar,
                                                        authorName:
                                                            widget.userName,
                                                        authorProfileModel:
                                                            authorProfile,
                                                        index: _)
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Center(
                                                          child: SizedBox(
                                                            height: 30,
                                                            width: 30,
                                                            child:
                                                                CircularProgressIndicator(),
                                                          ),
                                                        ),
                                                      );
                                              },
                                            );
                                          },
                                          findChildIndexCallback: (key) {
                                            log(key.toString());
                                          },
                                          childCount: 1,
                                        ),
                                      ),
                                    } else ...{
                                      Center(
                                        child: Text("Saved posts"),
                                      )
                                    },
                                    SliverToBoxAdapter(
                                        child: SizedBox(
                                      height: 10,
                                    ))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height / 2,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: Center(
                          child: Transform.translate(
                            offset: Offset(0, 0),
                            child: CupertinoActivityIndicator(),
                          ),
                        ),
                      )
              ],
            ),
    );
  }

  Widget buildFollowingButton(
      {required bool isFollowed,
      required int authorId,
      required bool isLoading}) {
    return GestureDetector(
      onTap: () async {
        if (await getAuthStatus()) {
          if (isFollowed) {
            context.read<AutthorProfileProvider>().unfollowAuthor(authorId);
          } else {
            context.read<AutthorProfileProvider>().followAuthor(authorId);
          }
        } else {
          NaviagateToLogin(context);
        }
      },
      child: Container(
        height: 48, //: 44,
        width: 224, //: 184,
        decoration: BoxDecoration(
          color: //_controller.followed ?
              Colors.green, //: Color(0xFF3E7EFF),
          borderRadius: BorderRadius.circular(24),
        ),
        child: isLoading
            ? CupertinoActivityIndicator()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isFollowed) ...{
                    Icon(
                      Icons.done,
                      color: Colors.white,
                    ),
                    space(width: 8),
                    Text(
                      "Following", //: "Follow".toUpperCase(),
                      style: ThreeKmTextConstants.tk14PXPoppinsBlackSemiBold
                          .copyWith(
                              color: Colors.white, fontWeight: FontWeight.w500),
                    )
                  } else ...{
                    Text(
                      "Follow", //: "Follow".toUpperCase(),
                      style: ThreeKmTextConstants.tk14PXPoppinsBlackSemiBold
                          .copyWith(
                              color: Colors.white, fontWeight: FontWeight.w500),
                    )
                  }
                ],
              ),
      ),
    );
  }

  Widget get buildTabBar {
    return Container(
      height: 48,
      width: double.infinity,
      padding: EdgeInsets.all(4),
      margin: EdgeInsets.symmetric(horizontal: 28),
      // .add(
      //   EdgeInsets.only(bottom: 24),
      // ),
      decoration: BoxDecoration(
        color: Color(0xFFF4F3F8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TabBar(
        labelColor: Colors.blue,
        unselectedLabelColor: Colors.black,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        tabs: [
          Tab(
            icon: Icon(CupertinoIcons.rectangle_grid_1x2_fill),
          ),
          // Tab(
          //   child: Icon(CupertinoIcons.rectangle_grid_2x2_fill),
          // ),
        ],
        controller: _tabController,
      ),
    );
  }

  Widget buildFollowingItem({required String text, required String value}) {
    return Column(
      children: [
        Text(
          value,
          style: ThreeKmTextConstants.tk14PXPoppinsBlackSemiBold
              .copyWith(fontSize: 18),
        ),
        Text(
          text,
          style: ThreeKmTextConstants.tk14PXPoppinsBlackSemiBold.copyWith(
            fontWeight: FontWeight.w400,
            color: Color(0xFF979EA4),
          ),
        ),
      ],
    );
  }

  Widget buildFollowing(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // buildFollowingItem(
        //     text: "Followers", //value: "${_controller.followers}"
        //     ),
        // buildFollowingItem(text: "Post", //value: "${_controller.totalPosts}"
        // ),
        // buildFollowingItem(
        //     text: "Following", //value: "${_controller.following}"
        //     ),
      ],
    );
  }

  Widget buildBackButton(context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 104,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 12),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: Navigator.of(context).pop,
            ),
          )
        ],
      ),
    );
  }

  Widget get buildAvatar {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.avatar != null || widget.avatar != "")
          Material(
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ProfileFullImage(
                              src: widget.avatar,
                              Imagetag: "AuthorPhoto",
                            )));
              },
              child: Container(
                height: 120,
                width: 120,
                //margin: EdgeInsets.only(top: 44),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.avatar),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class NewsCard extends StatefulWidget {
  final ProfilePostModel authorProfileModel;
  final int index;
  final String avtar;
  final String authorName;
  NewsCard(
      {required this.authorProfileModel,
      required this.index,
      required this.avtar,
      required this.authorName,
      Key? key})
      : super(key: key);

  @override
  _NewsCardState createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  @override
  Widget build(BuildContext context) {
    final newsData = widget.authorProfileModel.data.result;
    return CardUI(
      data: newsData?.posts?[widget.index],
      providerType: 'AutthorProfileProvider2',
    );
  }
}
