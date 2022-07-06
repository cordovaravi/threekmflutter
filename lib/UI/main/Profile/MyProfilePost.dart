import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:threekm/Models/SelfProfile_Model.dart';
import 'package:threekm/Models/getUserInfoModel.dart' as UserInfoModel;
import 'package:threekm/UI/Animation/AnimatedSizeRoute.dart';
import 'package:threekm/UI/DayZero/DayZeroforTabs.dart';
import 'package:threekm/UI/Help_Supportpage.dart';
import 'package:threekm/UI/main/AddPost/AddNewPost.dart';

import 'package:threekm/UI/main/News/NewsList.dart';
import 'package:threekm/UI/main/News/Widgets/comment_Loading.dart';
import 'package:threekm/UI/main/News/Widgets/likes_Loading.dart';
import 'package:threekm/UI/shop/product/full_image.dart';
import 'package:threekm/UI/userkyc/user_kyc_main.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/commenwidgets/commenwidget.dart';
import 'package:threekm/commenwidgets/fullImage.dart';
import 'package:threekm/providers/main/AddPost_Provider.dart';
import 'package:threekm/providers/main/AthorProfile_Provider.dart';
import 'package:threekm/providers/main/LikeList_Provider.dart';
import 'package:threekm/providers/main/comment_Provider.dart';
import 'package:threekm/providers/userKyc/verify_credential.dart';
import 'package:threekm/widgets/NewCardUI/card_ui.dart';

import 'package:threekm/utils/utils.dart';

class MyProfilePost extends StatefulWidget {
  final int id;
  final String avatar;
  final String authorType;
  final String userName;
  final int page;
  final bool isFromSelfProfileNavigate;
  MyProfilePost({
    Key? key,
    required this.isFromSelfProfileNavigate,
    required this.page,
    required this.authorType,
    required this.id,
    required this.avatar,
    required this.userName,
  }) : super(key: key);

  @override
  _MyProfilePostState createState() => _MyProfilePostState();
}

class _MyProfilePostState extends State<MyProfilePost>
    with TickerProviderStateMixin {
  ScrollController controller = ScrollController();

  int index = 0;
  bool addingAbout = false;
  int aboutCount = 0;
  TextEditingController _aboutTextController = TextEditingController();

  List<String> questions = [
    "What can you share/post on 3km?",
    "What can you share/post on 3km?",
    "What not to share/Post on 3km?"
  ];
  List<String> subtitle = ["As a citizen..", "As a Business..", ""];
  List<dynamic> As_a_Business = [
    {
      "title": "New Launches",
      "subtitle": "Products, Franchises, Services",
    },
    {
      "title": "Business Offers",
      "subtitle": "Any special offers, sale on your goods & services",
    },
    {
      "title": "Hiring Requirement",
      "subtitle": "Job Descriptions",
    },

    {
      "title": "Business specialities",
      "subtitle": "Notable custom products made by you",
    },
    {
      "title": "Business Events",
      "subtitle": "Invitation for seminars, camps, competitions",
    },
    {
      "title": "Business News",
      "subtitle": "Industry news, market news,",
    },
    // {
    //   "title": "Business Facts",
    //   "subtitle":
    //       "Facts related to Business, Educational content related to business",
    // },
    {
      "title": "Startups News",
      "subtitle": "Success stories, New events",
    }
  ];
  List<dynamic> As_a_citizen = [
    {"title": "Report", "subtitle": "Accidents, Crime, Utility failure, Scam"},
    {
      "title": "Informative Post",
      "subtitle": "Food & Product Reviews, Quick Tutorials"
    },
    {
      "title": "Events",
      "subtitle": "Invites, Marathons, Competitions, Sports, Flea Markets"
    },
    {"title": "Ask help", "subtitle": "Blood Requirement, Find Missing Pet"},
    {"title": "Showcase your talent", "subtitle": "Dance, Music, Baking etc"},
    {"title": "Entertainment", "subtitle": "One-Act Plays, Poems"},
    {
      "title": "Cityscape",
      "subtitle": "Good photos of the city and its moods."
    },
  ];

  List<dynamic> not_to_Share = [
    {
      "title": "No Selfies/ Personal photos",
      "subtitle": "Personal Photos(Unless you are a professional model)"
    },
    {
      "title": "No Greetings ",
      "subtitle": "No Good Morning, Birthday and Anniversary wishes"
    },
    {
      "title": "Quotes Posts",
      "subtitle": "No Inspirational / Motivational Quotes"
    },
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<AutthorProfileProvider>().getSelfProfile();
      context.read<VerifyKYCCredential>().getUserProfileInfo();
    });
  }

  @override
  void didUpdateWidget(MyProfilePost oldWidget) {
    context.read<AutthorProfileProvider>().getSelfProfile();
    context.read<VerifyKYCCredential>().getUserProfileInfo();
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  showKycMessage(context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                'To post on your wall you have to do one time verification',
                textAlign: TextAlign.center,
              ),
            ),
            actions: [
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF3E7EFF),
                      onPrimary: Colors.white,
                      shadowColor: Colors.blueAccent,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                      minimumSize: Size(100, 40), //////// HERE
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => UserKycMain()));
                    },
                    child: Text('Continue')),
              ),
              Align(
                  alignment: Alignment.center,
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'))),
            ],
            actionsOverflowDirection: VerticalDirection.down,
            actionsAlignment: MainAxisAlignment.center,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final selfProfile = context.watch<AutthorProfileProvider>();
    final userInfo = context.watch<VerifyKYCCredential>().userProfileInfo;
    var data = userInfo.data?.result;
    var selfProfileModel = selfProfile.selfProfile;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.0,
        title: Text(
          "My posts",
          style: ThreeKmTextConstants.tk18PXLatoBlackMedium,
        ),

        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //                 builder: (context) => SearchPage(tabNuber: 0)));
        //       },
        //       icon: Icon(
        //         Icons.search,
        //         color: Colors.black,
        //       ))
        // ],
      ),
      body:
          selfProfile.isGettingSelfProfile == true &&
                  selfProfile.selfProfile?.data == null
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Center(
                    child: Transform.translate(
                      offset: Offset(0, 0),
                      child: CupertinoActivityIndicator(),
                    ),
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    //  buildBackButton(context),
                    selfProfile.selfProfile != null
                        ? Expanded(
                            child: Container(
                              //clipBehavior: Clip.antiAlias,
                              width: MediaQuery.of(context).size.width,
                              //padding: EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                // borderRadius: BorderRadius.only(
                                //   topLeft: Radius.circular(40),
                                //   topRight: Radius.circular(40),
                                // ),
                              ),
                              child: Stack(
                                children: [
                                  CustomScrollView(
                                    controller: controller,
                                    slivers: [
                                      SliverAppBar(
                                        title: Text(""),
                                        collapsedHeight: 0,
                                        expandedHeight: 450,
                                        // addingAbout == true &&
                                        //         selfProfileModel!.data!.result!.author!.about == null
                                        //     ? 340
                                        //     : 290,
                                        // widget.isFromSelfProfileNavigate != true
                                        //     ? (addingAbout != true ? 250 : 300)
                                        //     : 250,
                                        toolbarHeight: 0,
                                        backgroundColor: Colors.white,
                                        flexibleSpace: FlexibleSpaceBar(
                                          background: Column(
                                            children: [
                                              buildAvatar(selfProfileModel!),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Center(
                                                child: Text(
                                                  "${selfProfileModel.data!.result!.author!.name}",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: ThreeKmTextConstants
                                                      .tk14PXPoppinsBlackSemiBold
                                                      .copyWith(fontSize: 18),
                                                ),
                                              ),
                                              // if (addingAbout &&
                                              //     selfProfileModel.data!.result!.author!.about ==
                                              //         null) ...{
                                              //   Container(
                                              //     margin: EdgeInsets.only(),
                                              //     child: TextFormField(
                                              //       controller: _aboutTextController,
                                              //       maxLines: 1,
                                              //       minLines: null,
                                              //       expands: false,
                                              //       maxLength: 35,
                                              //       textAlignVertical: TextAlignVertical.top,
                                              //       maxLengthEnforcement:
                                              //           MaxLengthEnforcement.enforced,
                                              //       decoration: InputDecoration(
                                              //         border: InputBorder.none,
                                              //       ),
                                              //       validator: (String? about) {
                                              //         if (about == null) {
                                              //           return "Please add About!";
                                              //         }
                                              //       },
                                              //       buildCounter: (context,
                                              //           {required currentLength,
                                              //           required isFocused,
                                              //           maxLength}) {
                                              //         WidgetsBinding.instance!
                                              //             .addPostFrameCallback((timeStamp) {
                                              //           setState(() {
                                              //             aboutCount = currentLength;
                                              //           });
                                              //         });
                                              //         return Text(
                                              //           "($aboutCount/35)",
                                              //           style: ThreeKmTextConstants
                                              //               .tk12PXPoppinsWhiteRegular
                                              //               .copyWith(
                                              //             fontSize: 10.5,
                                              //             fontWeight: FontWeight.w700,
                                              //             color: Color(0xFF979EA4),
                                              //           ),
                                              //         );
                                              //       },
                                              //       style: ThreeKmTextConstants.tk16PXLatoBlackRegular
                                              //           .copyWith(
                                              //         color: Color(0xFF0F0F2D),
                                              //         fontWeight: FontWeight.w500,
                                              //       ),
                                              //     ),
                                              //     width: 335,
                                              //     height: 68,
                                              //     decoration: BoxDecoration(
                                              //         color: Color(0xffF4F3F8),
                                              //         border: Border.all(color: Color(0xffD5D5D5)),
                                              //         borderRadius: BorderRadius.circular(15)),
                                              //   ),
                                              //   SizedBox(
                                              //     height: 8,
                                              //   ),
                                              //   Consumer<AutthorProfileProvider>(
                                              //     builder: (context, controller, _) {
                                              //       return GestureDetector(
                                              //         onTap: () {
                                              //           controller.updateAbout(
                                              //               context: context,
                                              //               about: _aboutTextController.text);
                                              //         },
                                              //         child: Container(
                                              //             height: 37,
                                              //             width: 67,
                                              //             decoration: BoxDecoration(
                                              //                 borderRadius: BorderRadius.circular(18),
                                              //                 color:
                                              //                     Color(0xff3E7EFF).withOpacity(0.1)),
                                              //             child: Center(
                                              //               child: controller.updateLoading != true
                                              //                   ? Text(
                                              //                       "Save",
                                              //                       style: ThreeKmTextConstants
                                              //                           .tk14PXPoppinsBlackSemiBold
                                              //                           .copyWith(
                                              //                               color: Color(0xff3E7EFF)),
                                              //                     )
                                              //                   : CupertinoActivityIndicator(),
                                              //             )),
                                              //       );
                                              //     },
                                              //   )
                                              // },
                                              widget.isFromSelfProfileNavigate ==
                                                      false
                                                  ? Column(
                                                      children: [
                                                        space(height: 32),
                                                        buildFollowing(context),
                                                        space(height: 32),
                                                        buildFollowingButton,
                                                        buildFollowingButton,
                                                      ],
                                                    )
                                                  : Container(),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 18,
                                                    horizontal: 55),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text(
                                                            selfProfileModel
                                                                .data!
                                                                .result!
                                                                .author!
                                                                .totalPosts
                                                                .toString(),
                                                            style: GoogleFonts.poppins(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 18)),
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
                                                            selfProfileModel
                                                                .data!
                                                                .result!
                                                                .author!
                                                                .followers
                                                                .toString(),
                                                            style: GoogleFonts
                                                                .poppins(
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
                                                            selfProfileModel
                                                                .data!
                                                                .result!
                                                                .author!
                                                                .following
                                                                .toString(),
                                                            style: GoogleFonts
                                                                .poppins(
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
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              // InkWell(
                                              //   onTap: null,
                                              //   //  () {
                                              //   //   // Navigator.push(
                                              //   //   //     context,
                                              //   //   //     MaterialPageRoute(
                                              //   //   //         builder: (_) => UserKycMain()));
                                              //   //   // showKycMessage(context);
                                              //   //   // Navigator.push(
                                              //   //   //     context,
                                              //   //   //     MaterialPageRoute(
                                              //   //   //         builder: (context) =>
                                              //   //   //             //VideoCompress()
                                              //   //   //             AddNewPost()));
                                              //   // },
                                              //   child: Container(
                                              //     height: 47,
                                              //     alignment: Alignment.center,
                                              //     width: MediaQuery.of(context).size.width,
                                              //     margin: EdgeInsets.only(left: 16, right: 16),
                                              //     decoration: BoxDecoration(
                                              //         color: Color(0xff3E7EFF),
                                              //         borderRadius: BorderRadius.circular(28)),
                                              //     child: Text(
                                              //       "Add Post",
                                              //       style: TextStyle(color: Colors.white),
                                              //     ),
                                              //   ),
                                              // ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: 16, right: 16),
                                                width: size.width,
                                                height: 50,
                                                child: ElevatedButton(
                                                  style: ButtonStyle(
                                                      shape: MaterialStateProperty
                                                          .all(StadiumBorder()),
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .resolveWith<
                                                                  Color>(
                                                        (Set<MaterialState>
                                                            states) {
                                                          if (states.contains(
                                                              MaterialState
                                                                  .pressed))
                                                            return Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary
                                                                .withOpacity(
                                                                    0.5);
                                                          else if (states
                                                              .contains(
                                                                  MaterialState
                                                                      .disabled))
                                                            return Colors
                                                                .grey[300]!;
                                                          return Color(
                                                              0xFF3E7EFF); // Use the component's default.
                                                        },
                                                      ),
                                                      foregroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                                  Colors.black),
                                                      enableFeedback: true,
                                                      padding:
                                                          MaterialStateProperty
                                                              .all(
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 30,
                                                                      right: 30,
                                                                      top: 15,
                                                                      bottom:
                                                                          15))),
                                                  child: Text(
                                                    'Add Post',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  onPressed: data != null &&
                                                          data.isVerified
                                                      ? () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      //VideoCompress()
                                                                      AddNewPost()));
                                                        }
                                                      : null,
                                                ),
                                              ),
                                              if (data != null)
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: 16,
                                                      right: 16,
                                                      top: 24),
                                                  padding: EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFFF8F8F8),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child:
                                                      data.isDocumentUploaded ==
                                                              false
                                                          ? Column(
                                                              children: [
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Image(
                                                                      image: AssetImage(
                                                                          'assets/verified3.png'),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 11,
                                                                    ),
                                                                    SizedBox(
                                                                      width: size
                                                                              .width /
                                                                          1.4,
                                                                      child:
                                                                          InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (_) => UserKycMain()));
                                                                        },
                                                                        child:
                                                                            RichText(
                                                                          maxLines:
                                                                              2,
                                                                          softWrap:
                                                                              true,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          text:
                                                                              TextSpan(children: [
                                                                            TextSpan(
                                                                                text: data != null && data.isVerified ? 'Stay connected with the community by sharing posts with them' : 'To share post on your wall you need a basic verification',
                                                                                style: ThreeKmTextConstants.tk14PXPoppinsBlackMedium),
                                                                            TextSpan(
                                                                                text: ' -Know more',
                                                                                style: ThreeKmTextConstants.tk14PXPoppinsBlueMedium)
                                                                          ]),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 16,
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (_) =>
                                                                                UserKycMain()));
                                                                    // showKycMessage(context);
                                                                    // Navigator.push(
                                                                    //     context,
                                                                    //     MaterialPageRoute(
                                                                    //         builder: (context) =>
                                                                    //             //VideoCompress()
                                                                    //             AddNewPost()));
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height: 47,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    margin: EdgeInsets.only(
                                                                        left:
                                                                            16,
                                                                        right:
                                                                            16),
                                                                    decoration: BoxDecoration(
                                                                        color: Color(
                                                                            0xff3E7EFF),
                                                                        borderRadius:
                                                                            BorderRadius.circular(28)),
                                                                    child: Text(
                                                                      data != null &&
                                                                              data.isVerified
                                                                          ? "Identity verification"
                                                                          : "Start verification",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : Column(
                                                              children: [
                                                                RichText(
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    text: TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                              text: 'We Received your documents our team is reviewing it ',
                                                                              style: ThreeKmTextConstants.tk16PXPoppinsBlackMedium),
                                                                          WidgetSpan(
                                                                              child: Image.asset(
                                                                                "assets/3kmVerify.png",
                                                                                width: 15,
                                                                                height: 15,
                                                                              ),
                                                                              baseline: TextBaseline.ideographic,
                                                                              alignment: PlaceholderAlignment.baseline),
                                                                        ])),
                                                                SizedBox(
                                                                    height: 11),
                                                                Text(
                                                                  'Our team will verify your documents soon',
                                                                  style: ThreeKmTextConstants
                                                                      .tk14PXPoppinsBlackMedium
                                                                      .copyWith(
                                                                          color:
                                                                              Color(0xFFA7ABAD)),
                                                                )
                                                              ],
                                                            ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      //////////// tabs widget
                                      // SliverPersistentHeader(
                                      //   delegate: PersistentHeader(
                                      //     widget: buildTabBar,
                                      //   ),
                                      //   pinned: true,
                                      // ),
                                      SliverToBoxAdapter(
                                        child: Container(
                                          height: 36,
                                        ),
                                      ),
                                      if (index == 0) ...{
                                        selfProfileModel.data!.result!.posts!
                                                    .length !=
                                                0
                                            ? SliverList(
                                                delegate:
                                                    SliverChildBuilderDelegate(
                                                  (context, _index) {
                                                    return NewsCard(
                                                        selfProfileModel:
                                                            selfProfileModel,
                                                        index: _index);
                                                  },
                                                  childCount: selfProfileModel
                                                      .data!
                                                      .result!
                                                      .posts!
                                                      .length,
                                                ),
                                              )
                                            : SliverToBoxAdapter(
                                                child: SizedBox(
                                                  height: 650,
                                                  child: ListView.builder(
                                                    padding: EdgeInsets.only(
                                                        left: 16, right: 16),
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount: 3,
                                                    itemBuilder:
                                                        (context, indexQ) {
                                                      return Container(
                                                          // height: 600,
                                                          width:
                                                              size.width / 1.14,
                                                          margin: EdgeInsets.only(
                                                              right: 10),
                                                          padding: EdgeInsets.all(
                                                              10),
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color:
                                                                      Colors.grey[
                                                                          100]!,
                                                                  width: 1),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      10),
                                                              image: DecorationImage(
                                                                  alignment: Alignment
                                                                      .topCenter,
                                                                  image: AssetImage(
                                                                      'assets/postNull.png'),
                                                                  fit: BoxFit
                                                                      .fitWidth)),
                                                          child: Column(
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                        questions[
                                                                            indexQ],
                                                                        style: ThreeKmTextConstants
                                                                            .tk16PXPoppinsBlackSemiBold
                                                                            .copyWith(color: Colors.white)),
                                                                    Text(
                                                                        subtitle[
                                                                            indexQ],
                                                                        style: ThreeKmTextConstants
                                                                            .tk16PXPoppinsBlackSemiBold
                                                                            .copyWith(color: Colors.white)),
                                                                    SizedBox(
                                                                      height:
                                                                          30,
                                                                    ),
                                                                    ListView.builder(
                                                                        physics: NeverScrollableScrollPhysics(),
                                                                        shrinkWrap: true,
                                                                        itemCount: indexQ == 0
                                                                            ? As_a_citizen.length
                                                                            : indexQ == 1
                                                                                ? As_a_Business.length
                                                                                : not_to_Share.length + 1,
                                                                        itemBuilder: (context, i) {
                                                                          if (indexQ == 2 &&
                                                                              not_to_Share.length == i) {
                                                                            return Container(
                                                                              color: Color(0xFFF8F8F8),
                                                                              padding: EdgeInsets.all(15),
                                                                              child: Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: Image(
                                                                                      image: AssetImage('assets/stop.png'),
                                                                                      height: 35,
                                                                                      width: 35,
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: MediaQuery.of(context).size.width / 1.7,
                                                                                    child: Text(
                                                                                      'Violation of 3km community Rules and Regulations will lead to Account Suspension.',
                                                                                      style: ThreeKmTextConstants.tk14PXPoppinsBlackMedium,
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            );
                                                                          }
                                                                          return ListTile(
                                                                            minLeadingWidth:
                                                                                20,
                                                                            leading:
                                                                                Text("\u2022"),
                                                                            title: indexQ == 0
                                                                                ? Text(As_a_citizen[i]['title'])
                                                                                : indexQ == 1
                                                                                    ? Text(As_a_Business[i]['title'])
                                                                                    : Text(not_to_Share[i]['title']),
                                                                            subtitle: indexQ == 0
                                                                                ? Text(As_a_citizen[i]['subtitle'])
                                                                                : indexQ == 1
                                                                                    ? Text(As_a_Business[i]['subtitle'])
                                                                                    : Text(not_to_Share[i]['subtitle']),
                                                                            contentPadding:
                                                                                EdgeInsets.zero,
                                                                            enableFeedback:
                                                                                true,
                                                                            horizontalTitleGap:
                                                                                0,
                                                                          );
                                                                        })
                                                                  ],
                                                                )
                                                              ]));
                                                    },
                                                  ),
                                                ),
                                              )
                                      } else ...{
                                        Center(
                                          child: Text("Saved posts"),
                                        )
                                      }
                                      // else ...{
                                      //   SliverGrid(
                                      //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      //       crossAxisCount: 3,
                                      //       mainAxisSpacing: 8,
                                      //       crossAxisSpacing: 8,
                                      //     ),
                                      //     delegate: SliverChildBuilderDelegate((context, index) {
                                      //       return Container(
                                      //           decoration: BoxDecoration(
                                      //             borderRadius: BorderRadius.circular(10),
                                      //             color: ThreeKmTextConstants.lightBlue,
                                      //             // image: DecorationImage(
                                      //             //   fit: BoxFit.fill,
                                      //             //   image: CachedNetworkImageProvider(
                                      //             //     _controller.posts
                                      //             //         .where((e) => e.images!.length > 0)
                                      //             //         .toList()[index]
                                      //             //         .images!
                                      //             //         .first,
                                      //             //   ),
                                      //             // ),
                                      //           ),

                                      //       );
                                      //     },
                                      //         childCount: 5,
                                      //   )
                                      // }
                                    ],
                                  ),

                                  // NestedScrollView(
                                  //   controller: controller,
                                  //   body: index == 0
                                  //       ? GetBuilder<AuthorProfileController>(
                                  //           builder: (_controller) => ListView.builder(
                                  //             itemBuilder: (context, _index) {
                                  //               return Container(
                                  //                 height: 580,
                                  //                 padding: EdgeInsets.symmetric(horizontal: 18),
                                  //                 child: NewsCardDetail(
                                  //                   _controller.posts[_index],
                                  //                   index: _index,
                                  //                 ),
                                  //               );
                                  //             },
                                  //             itemCount: _controller.posts.length,
                                  //           ),
                                  //         )
                                  //       : Container(
                                  //           width: MediaQuery.of(context).size.width,
                                  //           child: GetBuilder<AuthorProfileController>(
                                  //             builder: (_controller) => GridView.builder(
                                  //               gridDelegate:
                                  //                   SliverGridDelegateWithFixedCrossAxisCount(
                                  //                 crossAxisCount: 3,
                                  //                 mainAxisSpacing: 8,
                                  //                 crossAxisSpacing: 8,
                                  //               ),
                                  //               itemBuilder: (context, index) {
                                  //                 return Container(
                                  //                   decoration: BoxDecoration(
                                  //                       borderRadius: BorderRadius.circular(10),
                                  //                       color: ThreeKmTextConstants.lightBlue,
                                  //                       image: DecorationImage(
                                  //                           fit: BoxFit.fill,
                                  //                           image: CachedNetworkImageProvider(
                                  //                             _controller.posts
                                  //                                 .where((e) => e.images!.length > 0)
                                  //                                 .toList()[index]
                                  //                                 .images!
                                  //                                 .first,
                                  //                           ))),
                                  //                 );
                                  //               },
                                  //               itemCount: _controller.posts
                                  //                   .where((e) => e.images!.length > 0)
                                  //                   .toList()
                                  //                   .length,
                                  //               padding: EdgeInsets.only(
                                  //                   top: 24, bottom: 32, left: 18, right: 18),
                                  //               shrinkWrap: true,
                                  //             ),
                                  //           ),
                                  //         ),
                                  // ),
                                  // Center(
                                  //   child: Transform.translate(
                                  //     offset: Offset(0, 100),
                                  //     child: CupertinoActivityIndicator(),
                                  //   ),
                                  // )
                                  //: Container(),
                                  // ),
                                ],
                              ),
                            ),
                          )
                        : Center(
                            child: Text("Some error while getting data"),
                          )
                  ],
                ),
    );
  }

  Widget get buildFollowingButton {
    return GestureDetector(
      //onTap: () => _controller.changeFollowedStatus(!_controller.followed),
      child: Container(
        height: 48, //: 44,
        width: 224, //: 184,
        decoration: BoxDecoration(
          color: //_controller.followed ?
              Colors.green, //: Color(0xFF3E7EFF),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // if (_controller.followed) ...{
            //   Icon(
            //     Icons.done,
            //     color: Colors.white,
            //   ),
            // },
            // space(width: 8),
            Text(
              "Following", //: "Follow".toUpperCase(),
              style: ThreeKmTextConstants.tk14PXPoppinsBlackSemiBold
                  .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }

  // Widget get buildTabBar {
  //   return Container(
  //     height: 48,
  //     width: double.infinity,
  //     padding: EdgeInsets.all(4),
  //     margin: EdgeInsets.symmetric(horizontal: 28),
  //     // .add(
  //     //   EdgeInsets.only(bottom: 24),
  //     // ),
  //     decoration: BoxDecoration(
  //       color: Color(0xFFF4F3F8),
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     child: TabBar(
  //       labelColor: Colors.blue,
  //       unselectedLabelColor: Colors.black,
  //       indicatorSize: TabBarIndicatorSize.tab,
  //       indicator: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(8),
  //       ),
  //       tabs: [
  //         Tab(
  //           icon: Icon(CupertinoIcons.rectangle_grid_1x2_fill),
  //         ),
  //         // Tab(
  //         //   child: Icon(CupertinoIcons.rectangle_grid_2x2_fill),
  //         // ),
  //       ],
  //       controller: _tabController,
  //     ),
  //   );
  // }

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
                color: Colors.white,
              ),
              onPressed: Navigator.of(context).pop,
            ),
          )
        ],
      ),
    );
  }

  Widget buildAvatar(SelfProfileModel selfProfileModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        selfProfileModel.data!.result!.author!.image != null
            ? Hero(
                tag: "profilePhoto",
                child: Material(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfileFullImage(
                                    src: selfProfileModel
                                        .data!.result!.author!.image!,
                                    Imagetag: "profilePhoto",
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
                          image: CachedNetworkImageProvider(
                              selfProfileModel.data!.result!.author!.image!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : Container(
                width: 120,
                height: 120,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
              ),
      ],
    );
  }
}

class NewsCard extends StatefulWidget {
  final SelfProfileModel selfProfileModel;
  final int index;
  NewsCard({required this.selfProfileModel, required this.index, Key? key})
      : super(key: key);

  @override
  _NewsCardState createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  TextEditingController _commentController = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    final newsData = widget.selfProfileModel.data!.result;
    return Stack(alignment: AlignmentDirectional.center, children: [
      CardUI(
        data: newsData!.posts![widget.index],
        isfollow: false,
        providerType: 'AutthorProfileProvider',
      ),
      if (newsData.posts![widget.index].status == "rejected")
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Color(0xff0F0F2D).withOpacity(0.75),
          ),
          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
          width: double.infinity,
          height: 600,
        ),
      // Padding(
      //   padding: EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
      //   child: Column(mainAxisSize: MainAxisSize.min, children: [
      //     Container(
      //       margin: EdgeInsets.only(bottom: 10),
      //       decoration: BoxDecoration(
      //           color: Colors.white,
      //           boxShadow: [
      //             BoxShadow(color: Color(0xff32335E26), blurRadius: 8),
      //           ],
      //           borderRadius: BorderRadius.circular(10)),
      //       child: Container(
      //           decoration: BoxDecoration(
      //               color: newsData!.posts![widget.index].status == "rejected"
      //                   ? Color(0xff0F0F2D).withOpacity(0.75)
      //                   : Colors.white,
      //               borderRadius: BorderRadius.circular(10)),
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.start,
      //             children: [
      //               Padding(
      //                 padding: const EdgeInsets.all(10.0),
      //                 child: Row(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: [
      //                     Container(
      //                         margin: EdgeInsets.only(right: 10),
      //                         height: 50,
      //                         width: 50,
      //                         child: Container(
      //                             height: 50,
      //                             width: 50,
      //                             decoration: BoxDecoration(
      //                                 shape: BoxShape.circle,
      //                                 image: DecorationImage(
      //                                     fit: BoxFit.cover,
      //                                     image: CachedNetworkImageProvider(
      //                                         newsData.author!.image.toString())
      //                                     //newsData.author!.image.toString())
      //                                     )),
      //                             child:
      //                                 //newsData.isVerified == true
      //                                 Stack(
      //                               alignment: AlignmentDirectional.center,
      //                               children: [
      //                                 // newsData.author!.isVerified == true
      //                                 //     ? Positioned(
      //                                 //         left: -10,
      //                                 //         child: Image.asset(
      //                                 //           'assets/verified.png',
      //                                 //           height: 15,
      //                                 //           width: 15,
      //                                 //           fit: BoxFit.cover,
      //                                 //         ))
      //                                 //     : SizedBox.shrink(),
      //                                 newsData.posts![widget.index].status ==
      //                                         "rejected"
      //                                     ? Container(
      //                                         height: 50,
      //                                         width: 50,
      //                                         decoration: BoxDecoration(
      //                                           shape: BoxShape.circle,
      //                                           color: Color(0xff0F0F2D)
      //                                               .withOpacity(0.75),
      //                                         ),
      //                                       )
      //                                     : SizedBox.shrink()
      //                               ],
      //                             )
      //                             //: Container(),
      //                             )),
      //                     Column(
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       //mainAxisAlignment: MainAxisAlignment.center,
      //                       children: [
      //                         Container(
      //                           width: MediaQuery.of(context).size.width * 0.35,
      //                           child: Text(
      //                             newsData.author!.name.toString(),
      //                             style: ThreeKmTextConstants
      //                                 .tk14PXPoppinsBlackBold,
      //                             overflow: TextOverflow.ellipsis,
      //                           ),
      //                         ),
      //                         Text(newsData.posts![widget.index].createdDate
      //                                 .toString()
      //                             //newsData.createdDate.toString()
      //                             )
      //                       ],
      //                     ),
      //                     SizedBox(
      //                       width: 10,
      //                     ),
      //                     Spacer(),
      //                     showPopMenu(
      //                         newsData.posts![widget.index].postId.toString(),
      //                         newsData)
      //                   ],
      //                 ),
      //               ),
      //               //pic
      //               if (newsData.posts![widget.index].images != null &&
      //                   newsData.posts![widget.index].images!.length > 0)
      //                 CachedNetworkImage(
      //                   color:
      //                       newsData.posts![widget.index].status == "rejected"
      //                           ? Color(0xff0F0F2D).withOpacity(0.75)
      //                           : null,
      //                   height: 254,
      //                   width: 338,
      //                   fit: BoxFit.fill,
      //                   imageUrl:
      //                       '${newsData.posts![widget.index].images!.first}',
      //                 )
      //               else if (newsData.posts![widget.index].videos != null &&
      //                   newsData.posts![widget.index].videos!.length > 0)
      //                 Stack(children: [
      //                   Container(
      //                     height: 254,
      //                     width: MediaQuery.of(context).size.width,
      //                     color: Color(0xff0F0F2D).withOpacity(0.75),
      //                   ),
      //                 ]),
      //               Row(children: [
      //                 newsData.posts![widget.index].status != "rejected" &&
      //                         newsData.posts![widget.index].likes != 0
      //                     ? Padding(
      //                         padding:
      //                             EdgeInsets.only(top: 5, left: 5, bottom: 2),
      //                         child: InkWell(
      //                           onTap: () {
      //                             _showLikedBottomModalSheet(
      //                                 newsData.posts![widget.index].postId!
      //                                     .toInt(),
      //                                 newsData.posts![widget.index].likes);
      //                           },
      //                           child: Row(
      //                             children: [
      //                               Text('👍 ❤️ '),
      //                               Container(
      //                                 height: 30,
      //                                 width: 30,
      //                                 decoration: BoxDecoration(
      //                                     shape: BoxShape.circle,
      //                                     color: Color(0xffFC5E6A)),
      //                                 child: Center(
      //                                     child: Text('+' +
      //                                         newsData
      //                                             .posts![widget.index].likes
      //                                             .toString())),
      //                               )
      //                             ],
      //                           ),
      //                         ))
      //                     : SizedBox.shrink(),
      //                 Spacer(),
      //                 Padding(
      //                     padding: EdgeInsets.only(top: 5, right: 5, bottom: 2),
      //                     child: Text(
      //                         newsData.posts![widget.index].views.toString() +
      //                             ' Views'))
      //               ]),
      //               Text(
      //                 newsData.posts![widget.index].submittedHeadline
      //                     .toString(),
      //                 style: ThreeKmTextConstants.tk14PXLatoBlackMedium,
      //                 textAlign: TextAlign.center,
      //               ),
      //               SizedBox(
      //                 height: 8,
      //               ),
      //               Padding(
      //                 padding: const EdgeInsets.all(16.0),
      //                 child: HtmlWidget(newsData
      //                     .posts![widget.index].submittedStory
      //                     .toString()),
      //               ),

      //               SizedBox(
      //                 height: 35,
      //               ),
      //             ],
      //           )),
      //     )
      //   ]),
      // ),
      // newsData.posts![widget.index].status != "rejected"
      //     ? Positioned(
      //         bottom: 0,
      //         child: Container(
      //           height: 60,
      //           width: 230,
      //           child: ButtonBar(children: [
      //             Container(
      //               height: 60,
      //               width: 60,
      //               child: AuthorEmotionButton(
      //                   isLiked: newsData.posts![widget.index].isLiked!,
      //                   initalReaction: newsData.posts![widget.index].isLiked!
      //                       ? Reaction(
      //                           icon: Image.asset("assets/thumbs_up_red.png"))
      //                       : Reaction(
      //                           icon: Image.asset("assets/thumbs-up.png")),
      //                   selectedReaction: newsData.posts![widget.index].isLiked!
      //                       ? Reaction(
      //                           icon: Image.asset("assets/thumbs_up_red.png"))
      //                       : Reaction(
      //                           icon: Image.asset("assets/thumbs-up.png")),
      //                   postId: newsData.posts![widget.index].postId!.toInt(),
      //                   reactions: reactionAssets.reactions),
      //               decoration: BoxDecoration(
      //                   color: Colors.white,
      //                   shape: BoxShape.circle,
      //                   boxShadow: [
      //                     BoxShadow(
      //                       color: Colors.black26,
      //                       blurRadius: 8,
      //                     )
      //                   ]),
      //             ),
      //             Container(
      //               height: 60,
      //               width: 60,
      //               child: IconButton(
      //                   onPressed: () {
      //                     _showCommentsBottomModalSheet(context,
      //                         newsData.posts![widget.index].postId!.toInt());
      //                   },
      //                   icon: Image.asset('assets/icons-topic.png',
      //                       fit: BoxFit.cover)),
      //               decoration: BoxDecoration(
      //                   color: Colors.white,
      //                   shape: BoxShape.circle,
      //                   boxShadow: [
      //                     BoxShadow(
      //                       color: Colors.black26,
      //                       blurRadius: 8,
      //                     )
      //                   ]),
      //             ),
      //             Container(
      //               height: 60,
      //               width: 60,
      //               child: IconButton(
      //                   onPressed: () async {
      //                     // showLoading();
      //                     String imgUrl =
      //                         newsData.posts![widget.index].images != null &&
      //                                 newsData.posts![widget.index].images!
      //                                         .length >
      //                                     0
      //                             ? newsData.posts![widget.index].images!.first
      //                                 .toString()
      //                             : newsData.posts![widget.index].videos!.first
      //                                 .thumbnail
      //                                 .toString();
      //                     handleShare(
      //                         newsData.author!.name.toString(),
      //                         newsData.author!.image.toString(),
      //                         newsData.posts![widget.index].submittedHeadline
      //                             .toString(),
      //                         imgUrl,
      //                         newsData.posts![widget.index].createdDate
      //                             .toString(),
      //                         newsData.posts![widget.index].postId.toString());
      //                   },
      //                   icon: Center(
      //                     child: Image.asset('assets/icons-share.png',
      //                         fit: BoxFit.contain),
      //                   )),
      //               decoration: BoxDecoration(
      //                   color: Colors.white,
      //                   shape: BoxShape.circle,
      //                   boxShadow: [
      //                     BoxShadow(
      //                       color: Colors.black26,
      //                       blurRadius: 8,
      //                     )
      //                   ]),
      //             ),
      //           ]),
      //         ))
      //     : SizedBox.shrink(),
      newsData.posts![widget.index].status == "rejected"
          ? Container(
              width: 235,
              height: 170,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.assignment_late_outlined,
                    color: Colors.redAccent,
                  ),
                  Text(
                    "This Post was rejected by the admin",
                    style: ThreeKmTextConstants.tk14PXPoppinsBlackSemiBold,
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: EdgeInsets.zero,
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              AnimatedSizeRoute(page: HelpAndSupport()));
                        },
                        child: Text(
                          "Get Help",
                          style: ThreeKmTextConstants.tk14PXLatoBlueRegular,
                        )),
                  )
                ],
              ),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
            )
          : SizedBox.shrink()
    ]);
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
                            return commentProvider.commentList.length != null
                                ? Text(
                                    "${commentProvider.commentList.length}\tComments",
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
                                            commentProvider.commentList.length,
                                        itemBuilder: (context, commentIndex) {
                                          return Container(
                                            margin: EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                            ),
                                            child: ListTile(
                                              trailing: commentProvider
                                                          .commentList[
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
                                                                    .commentList[
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
                                                                .commentList[
                                                                    commentIndex]
                                                                .avatar
                                                                .toString()))),
                                              ),
                                              title: Text(
                                                commentProvider
                                                    .commentList[commentIndex]
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
                                                          .commentList[
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
                                                            .commentList[
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
                      Container(
                        height: 116,
                        width: 338,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20)),
                        child: TextFormField(
                          controller: _commentController,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(border: InputBorder.none),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () {
                            context
                                .read<CommentProvider>()
                                .postCommentApi(postId, _commentController.text)
                                .then((value) => _commentController.clear());
                          },
                          child: Container(
                            height: 36,
                            width: 112,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: ThreeKmTextConstants.blue2),
                            child: Center(
                              child: Text(
                                "Submit",
                                style: ThreeKmTextConstants
                                    .tk14PXPoppinsWhiteMedium,
                              ),
                            ),
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

  PopupMenuButton showPopMenu(String postID, Result newsData) {
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
        // PopupMenuItem(
        //   child: ListTile(
        //     onTap: () {
        //       String imgUrl =
        //           newsData.images != null && newsData.images!.length > 0
        //               ? newsData.images!.first.toString()
        //               : newsData.videos!.first.thumbnail.toString();
        //       handleShare(
        //           newsData.author!.name.toString(),
        //           newsData.author!.image.toString(),
        //           newsData.submittedHeadline.toString(),
        //           imgUrl,
        //           newsData.createdDate,
        //           newsData.postId.toString());
        //     },
        //     title: Text('Share to..',
        //         style: ThreeKmTextConstants.tk16PXLatoBlackRegular),
        //   ),
        // ),
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

  // previous param String imgUrl, String name, String newsHeadLine, int index
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
