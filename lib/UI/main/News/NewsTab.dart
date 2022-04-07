import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:animated_widgets/animated_widgets.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:threekm/Custom_library/GooleMapsWidget/google_maps_place_picker.dart';
import 'package:threekm/Custom_library/Polls/simple_polls.dart';
import 'package:threekm/Models/FeedPost/HomenewsBottomModel.dart';
import 'package:threekm/Models/home1_model.dart';
import 'package:threekm/UI/Animation/AnimatedSizeRoute.dart';
import 'package:threekm/UI/Auth/signup/sign_up.dart';
import 'package:threekm/UI/Search/SearchPage.dart';
import 'package:threekm/UI/main/News/NewsList.dart';
import 'package:threekm/UI/main/News/PostView.dart';
import 'package:threekm/UI/main/News/Widgets/HeighLightPost.dart';
import 'package:threekm/UI/main/News/poll_page.dart';
import 'package:threekm/UI/main/Notification/NotificationPage.dart';
import 'package:threekm/UI/main/navigation.dart';
import 'package:threekm/localization/localize.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/providers/Global/logged_in_or_not.dart';
import 'package:threekm/providers/Location/locattion_Provider.dart';
import 'package:threekm/providers/ProfileInfo/ProfileInfo_Provider.dart';
import 'package:threekm/providers/localization_Provider/appLanguage_provider.dart';
import 'package:threekm/providers/main/AddPost_Provider.dart';
import 'package:threekm/providers/main/NewsFeed_Provider.dart';
import 'package:threekm/providers/main/Quiz_Provider.dart';
import 'package:threekm/providers/main/home1_provider.dart';
import 'package:provider/provider.dart';
import 'package:threekm/providers/main/home2_provider.dart';
import 'package:threekm/utils/api_paths.dart';
import 'package:threekm/utils/threekm_textstyles.dart';
import 'package:threekm/widgets/video_widget.dart';
import 'package:threekm/widgets/vimeoPlayer.dart';

import 'Widgets/Adspopup.dart';
import 'package:flutter_svg/svg.dart';

class NewsTab extends StatefulWidget {
  final String? deviceId;
  final bool? reload;
  final bool? isPostUploaded;
  final Locale? appLanguage;
  NewsTab({this.reload, this.deviceId, this.isPostUploaded, this.appLanguage});
  @override
  _NewsTabState createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late final AnimationController _controller;
  String? requestJson;
  int? answerIndex;
  String? _selecetdAddress;
  //int _current = 0;

  final List<GlobalKey> imgkey = List.generate(1000, (index) => GlobalKey());

  ///panel
  PanelController _slidingUpPanelcontroller = PanelController();

  ///scroll of main
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    Future.microtask(() => context.read<LocationProvider>().getLocation());
    Future.microtask(() => context.read<AppLanguage>().fetchLocale());
    if (widget.reload != true) {
      Future.delayed(Duration.zero, () async {
        String? token = await ApiProvider().getToken() ?? "";
        requestJson = json.encode({
          "lat": "",
          "lng": "",
          "ios": Platform.isAndroid ? false : true,
          "lang": context.read<AppLanguage>().appLocal == Locale("mr")
              ? "mr"
              : context.read<AppLanguage>().appLocal == Locale("en")
                  ? "en"
                  : "hi",

          //"${appLanguage.appLocal}",
          "device": widget.deviceId ?? "",
          "token": token ?? ""
        });
        context
            .read<HomefirstProvider>()
            .getNewsfirst(requestJson)
            .then((value) {
          Future.delayed(Duration(milliseconds: 100), () {
            context.read<HomeSecondProvider>().getNewsSecond(requestJson);
          }).whenComplete(() => checkUpdate());
        });
        Future.microtask(() => context.read<NewsFeedProvider>().getBottomFeed(
              languageCode: context.read<AppLanguage>().appLocal == Locale("mr")
                  ? "mr"
                  : context.read<AppLanguage>().appLocal == Locale("en")
                      ? "en"
                      : "hi",
            ));
        context.read<AddPostProvider>();
      });
    }
    if (widget.isPostUploaded ?? false) {
      // Future.delayed(Duration(seconds: 1), () {
      //   CustomSnackBar(context, Text("Post has been submmitted"));
      // });
      Fluttertoast.showToast(
          msg: "Post has been Submitted", backgroundColor: Color(0xFF0044CE));
    }

    ///fcm call back
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('A new onMessageOpenedApp event ${message.notification?.body}');
    }).onData((data) {
      log(data.notification?.title.toString() ?? "");
      Future.delayed(Duration(seconds: 1), () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Postview(postId: data.data["post_id"])));
      });
    });
    Future.delayed(Duration(seconds: 2), () {
      _slidingUpPanelcontroller.hide();
    });
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        _slidingUpPanelcontroller.show();
      } else {
        _slidingUpPanelcontroller.hide();
      }
    });
  }

  void checkUpdate() {
    if (Platform.isAndroid) {
      Future.delayed(Duration(seconds: 2), () {
        InAppUpdate.checkForUpdate().then((info) async {
          if (info.updateAvailability == UpdateAvailability.updateAvailable) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('New Version is deteted.!'),
                action: SnackBarAction(
                    label: "Update",
                    onPressed: () async {
                      log("update call");
                      await InAppUpdate.performImmediateUpdate()
                          .catchError((e) => log(e.toString()));
                    }),
              ),
            );
            // await InAppUpdate.performImmediateUpdate()
            //     .catchError((e) => log(e.toString()));
          }
        }).catchError((e) {
          log(e.toString());
        });
      });
    }
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        log("message from firebase is $message");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Postview(postId: message.data["post_id"])));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  getAddrress(double lat, double long) async {
    final address = await placemarkFromCoordinates(lat, long);
    setState(() {
      _selecetdAddress = "${address.first.locality} ${address.first.locality}";
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    log("main building");
    final locationProvider = context.watch<LocationProvider>();
    final newsFirstProvider = context.watch<HomefirstProvider>();
    final newsSecondProvider = context.watch<HomeSecondProvider>();
    final profileProvider = context.watch<ProfileInfoProvider>();
    final newsFeedProvider = context.watch<NewsFeedProvider>();
    return SlidingUpPanel(
      minHeight: 50,
      maxHeight: MediaQuery.of(context).size.height,
      parallaxEnabled: true,
      controller: _slidingUpPanelcontroller,
      // header: Container(
      //   height: 40,
      //   width: MediaQuery.of(context).size.width,
      //   child: Row(
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       Text("Explore more here"),
      //       IconButton(
      //           onPressed: () {
      //             _slidingUpPanelcontroller.close();
      //             log("closing panel");
      //           },
      //           icon: Icon(
      //             Icons.highlight_remove_outlined,
      //             color: Colors.grey,
      //           ))
      //     ],
      //   ),
      // ),
      collapsed: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
        ),
        child: Center(child: Text("Slide up For more News")),
      ),
      panel: Container(
          child: newsFeedProvider
                          .newsFeedBottomModel?.data?.result?.posts?.length !=
                      0 &&
                  newsFeedProvider.newsFeedBottomModel?.data?.result?.posts !=
                      null
              ? Scaffold(
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(20.0),
                    child: AppBar(
                      automaticallyImplyLeading: false,
                      primary: false,
                      backgroundColor: Colors.white,
                      title: Text(
                        "Explore more here",
                        style: ThreeKmTextConstants.tk14PXLatoBlackBold,
                      ),
                      // actions: [
                      //   IconButton(
                      //       onPressed: () {
                      //         _slidingUpPanelcontroller.close();
                      //         log("closing panel");
                      //       },
                      //       icon: Icon(
                      //         Icons.highlight_remove_outlined,
                      //         color: Colors.grey,
                      //       ))
                      //],
                    ),
                  ),
                  body: ListView.builder(
                    cacheExtent: 999,
                    primary: true,
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: newsFeedProvider
                        .newsFeedBottomModel!.data!.result!.posts!.length,
                    itemBuilder: (context, index) {
                      final post = newsFeedProvider
                          .newsFeedBottomModel!.data!.result!.posts![index];

                      return Container(
                        //color: Colors.amber,
                        height: 370,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 8.0)
                            ],
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10))),
                        child: Column(children: [
                          Container(
                              height: 250,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  // color: Colors.black,
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10))),
                              child: post.images != null &&
                                      post.images?.length != 0
                                  ? CachedNetworkImage(
                                      imageUrl: post.images!.first,
                                      fit: BoxFit.fill)
                                  : CachedNetworkImage(
                                      imageUrl: post.videos!.first.thumbnail
                                          .toString(),
                                      fit: BoxFit.fill)),
                          Row(children: [
                            Padding(
                                padding:
                                    EdgeInsets.only(top: 5, left: 5, bottom: 2),
                                child: InkWell(
                                  onTap: () {},
                                  child: post.likes != 0
                                      ? Row(
                                          children: [
                                            Text('👍❤️'),
                                            Container(
                                              child: Center(
                                                  child: Text('+' +
                                                      post.likes.toString())),
                                            )
                                          ],
                                        )
                                      : SizedBox.shrink(),
                                )),
                            Spacer(),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: 5, right: 5, bottom: 2),
                                child: Text(post.views.toString() + ' Views'))
                          ]),
                          Spacer(),
                          Text(
                            post.headline.toString(),
                            maxLines: 2,
                            style: ThreeKmTextConstants.tk14PXLatoBlackMedium,
                            textAlign: TextAlign.center,
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    AnimatedSizeRoute(
                                        page: Postview(
                                            postId: post.postId.toString())));
                              },
                              child: Text(
                                "Read More",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              )),
                          Spacer()
                        ]),
                      );
                    },
                  ),
                )
              : SizedBox.shrink()),
      body: RefreshIndicator(
        onRefresh: () {
          return context
              .read<HomefirstProvider>()
              .onRefresh(requestJson)
              .then((value) {
            context.read<HomeSecondProvider>().onRefresh(requestJson);
          });
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
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
                                    builder: (context) => PlacePicker(
                                      apiKey: GMap_Api_Key,
                                      // initialMapType: MapType.satellite,
                                      onPlacePicked: (result) {
                                        //print(result.formattedAddress);
                                        setState(() {
                                          _selecetdAddress =
                                              result.formattedAddress;
                                          print(result.geometry!.toJson());
                                          //  _geometry = result.geometry;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      initialPosition: kInitialPosition,
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
                      icon: Icon(
                        Icons.location_on_outlined,
                        color: Colors.redAccent,
                      )),
                  Padding(
                    padding: EdgeInsets.only(left: 0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
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
                                      builder: (context) => PlacePicker(
                                        apiKey: GMap_Api_Key,
                                        // initialMapType: MapType.satellite,
                                        onPlacePicked: (result) {
                                          //print(result.formattedAddress);
                                          setState(() {
                                            _selecetdAddress =
                                                result.formattedAddress;
                                            print(result.geometry!.toJson());
                                            //  _geometry = result.geometry;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        initialPosition: kInitialPosition,
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
                                locationProvider.AddressFromCordinate ??
                                "",
                            style:
                                ThreeKmTextConstants.tk12PXPoppinsBlackSemiBold,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
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
                        width: MediaQuery.of(context).size.width * 0.7,
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
                                  AppLocalizations.of(context)
                                          ?.translate("search_news") ??
                                      "",
                                  style: ThreeKmTextConstants
                                      .tk12PXLatoBlackBold
                                      .copyWith(color: Colors.grey),
                                ))
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            AnimatedSizeRoute(page: Notificationpage()));
                      },
                      child: Padding(
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
                    ),
                    InkWell(
                      onTap: () async {
                        SharedPreferences _pref =
                            await SharedPreferences.getInstance();

                        var token = _pref.getString("token");
                        token != null
                            ? drawerController.open!()
                            : Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => SignUp()),
                                (route) => false);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                              image: profileProvider.Avatar != null
                                  ? DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          profileProvider.Avatar.toString()))
                                  : DecorationImage(
                                      image:
                                          AssetImage("assets/male-user.png")),
                              shape: BoxShape.circle,
                              //color: Color(0xffFF464B)
                            )),
                      ),
                    )
                  ],
                ),
              ),
              //Add baner lokamanya Banner
              if (newsFirstProvider.homeNewsFirst != null)
                ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  primary: true,
                  padding: EdgeInsets.zero,
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
                            return Container(
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
                            ));

                            /// ads carousal top
                          } else if (finalPost.bannertype == "BWC") {
                            return finalPost.banners?.length != null
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CarouselSlider.builder(
                                        itemCount: finalPost.banners!.length,
                                        itemBuilder: (BuildContext context,
                                                int bannerIndex, heroIndex) =>
                                            InkWell(
                                                onTap: () {
                                                  if (finalPost
                                                          .banners![bannerIndex]
                                                          .imageswcta!
                                                          .first
                                                          .post !=
                                                      null) {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                NewsListPage(
                                                                  title: finalPost
                                                                      .banners![
                                                                          bannerIndex]
                                                                      .imageswcta!
                                                                      .first
                                                                      .header
                                                                      .toString(),
                                                                  hasPostfromBanner: finalPost
                                                                      .banners![
                                                                          bannerIndex]
                                                                      .imageswcta!
                                                                      .first
                                                                      .post,
                                                                )));
                                                  } else if (finalPost
                                                          .banners![bannerIndex]
                                                          .imageswcta!
                                                          .first
                                                          .video !=
                                                      null) {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => LocalPlayer(
                                                                VideoURI: finalPost
                                                                    .banners![
                                                                        bannerIndex]
                                                                    .imageswcta!
                                                                    .first
                                                                    .video
                                                                    .toString())
                                                            // VimeoPlayerPage(
                                                            //     VimeoUri: finalPost
                                                            //         .banners![
                                                            //             bannerIndex]
                                                            //         .imageswcta!
                                                            //         .first
                                                            //         .vimeoUrl
                                                            //         .toString())
                                                            ));
                                                  }
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      top: 0, bottom: 4),
                                                  decoration: BoxDecoration(
                                                      boxShadow: [
                                                        // BoxShadow(
                                                        //     blurRadius: 10.0,
                                                        //     color: Colors
                                                        //         .grey.shade200)
                                                      ],
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  child: CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      // width: 1000,
                                                      imageUrl: finalPost
                                                          .banners![bannerIndex]
                                                          .images!
                                                          .first
                                                          .toString()),
                                                )),
                                        options: CarouselOptions(
                                            viewportFraction:
                                                finalPost.banners!.length > 1
                                                    ? 0.99
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
                                            enlargeCenterPage: false,
                                            aspectRatio: 2.3,
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
                                      //       MainAxisAlignment.center,
                                      //   children:
                                      //       finalPost.banners!.map((banner) {
                                      //     int index =
                                      //         finalPost.banners!.indexOf(banner);
                                      //     return Container(
                                      //       width: 8.0,
                                      //       height: 8.0,
                                      //       margin: EdgeInsets.symmetric(
                                      //           vertical: 10.0, horizontal: 2.0),
                                      //       decoration: BoxDecoration(
                                      //         shape: BoxShape.circle,
                                      //         color: _current == index
                                      //             ? Color.fromRGBO(0, 0, 0, 0.9)
                                      //             : Color.fromRGBO(0, 0, 0, 0.4),
                                      //       ),
                                      //     );
                                      //   }).toList(),
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
                      return Container(child: SizedBox.shrink()
                          //Text("quiz carousal"),
                          );
                    } else if (finalScondPost.type == "quiz" &&
                        finalScondPost.quiz!.type == "quiz") {
                      if (finalScondPost.quiz?.isAnswered == true) {
                        final alreadyAnsIndex = finalScondPost.quiz!.options!
                            .indexWhere((element) =>
                                element.text == finalScondPost.quiz!.answer);
                        log("ans index is $alreadyAnsIndex");
                        final alredaySelectedIndex = finalScondPost
                            .quiz!.options!
                            .indexWhere((element) =>
                                element.text ==
                                finalScondPost.quiz!.selectedOption);
                        log("selected index is$alredaySelectedIndex");
                        if (mounted) {
                          if (context.read<QuizProvider>().isAnswred == false) {
                            Future.microtask(() => context
                                .read<QuizProvider>()
                                .checkAns(
                                    alredaySelectedIndex, alreadyAnsIndex));
                          }
                        }
                      }
                      return Consumer2<QuizProvider, HomeSecondProvider>(
                        builder: (context, quizProvider, _controller, _) {
                          return Container(
                            margin: EdgeInsets.only(
                                bottom: 8, left: 4, right: 4, top: 0),
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
                                                    finalScondPost
                                                        .quiz!.question
                                                        .toString(),
                                                    style: ThreeKmTextConstants
                                                        .tk16PXPoppinsWhiteBold,
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                              SizedBox(height: 20),
                                              Container(
                                                padding:
                                                    EdgeInsets.only(top: 10),
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
                                                    return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 4,
                                                                right: 4),
                                                        child: GestureDetector(
                                                          onTap: () async {
                                                            if (await getAuthStatus()) {
                                                              if (finalScondPost
                                                                          .quiz
                                                                          ?.isAnswered ==
                                                                      false ||
                                                                  finalScondPost
                                                                          .quiz
                                                                          ?.isAnswered ==
                                                                      null) {
                                                                final ansIndex = finalScondPost
                                                                    .quiz!
                                                                    .options!
                                                                    .indexWhere((element) =>
                                                                        element
                                                                            .text ==
                                                                        finalScondPost
                                                                            .quiz!
                                                                            .answer);
                                                                log("ans index is $ansIndex");
                                                                context
                                                                    .read<
                                                                        QuizProvider>()
                                                                    .checkAns(
                                                                        quizIndex,
                                                                        ansIndex);
                                                                context.read<QuizProvider>().submitQuiz(
                                                                    finalScondPost
                                                                        .quiz!
                                                                        .quizId!
                                                                        .toInt(),
                                                                    finalScondPost
                                                                        .quiz!
                                                                        .options![
                                                                            quizIndex]
                                                                        .text
                                                                        .toString());
                                                                _controller.submitQuiz(
                                                                    quizId: finalScondPost
                                                                        .quiz!
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
                                                              margin: EdgeInsets
                                                                  .all(10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                      color: Colors
                                                                          .white,
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                            color:
                                                                                Colors.black45,
                                                                            blurRadius: 8.0)
                                                                      ],
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
                                                                        .quiz!
                                                                        .options![
                                                                            quizIndex]
                                                                        .text
                                                                        .toString(),
                                                                    style: ThreeKmTextConstants
                                                                        .tk16PXLatoBlackRegular,
                                                                  ),
                                                                  if (quizProvider
                                                                      .isAnswred)
                                                                    quizIndex ==
                                                                            quizProvider
                                                                                .answredIndex
                                                                        ? IconConatiner(
                                                                            icon:
                                                                                Icons.check_circle,
                                                                            iconColor: Colors.green)
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
                    } else if (finalScondPost.type == "quiz" &&
                        finalScondPost.quiz?.type == "poll") {
                      return Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(
                                    finalScondPost.quiz!.image!)),
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
                                                answer:
                                                    selectedOptionModel.label,
                                                quizId: finalScondPost.quiz!.id!
                                                    .toInt());
                                        context
                                            .read<HomeSecondProvider>()
                                            .pollSubmitted(
                                                pollId: finalScondPost.quiz!.id!
                                                    .toInt(),
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
                                              finalScondPost.quiz!.question
                                                  .toString(),
                                              style: ThreeKmTextConstants
                                                  .tk14PXPoppinsBlackBold),
                                        ),
                                        totalPolls: 100,
                                        endTime: DateTime.now()
                                            .toUtc()
                                            .add(Duration(days: 10)),
                                        hasVoted:
                                            finalScondPost.quiz!.isAnswered!,
                                        editablePoll: false,
                                        options: finalScondPost.quiz!.options!
                                            .map((option) {
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
                                "Highlight",
                                style:
                                    ThreeKmTextConstants.tk16PXPoppinsWhiteBold,
                              ),
                              SizedBox(height: 50),
                              HeighlightPost(business: finalScondPost.business!)
                              // Container(
                              //   height: 347,
                              //   width: 247,
                              //   decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(50),
                              //       color: Colors.white),
                              //   child: Column(
                              //     children: [
                              //       SizedBox(
                              //         height: 20,
                              //       ),
                              //       Container(
                              //         height: 215,
                              //         width: 215,
                              //         decoration: BoxDecoration(
                              //           image: DecorationImage(
                              //               image: CachedNetworkImageProvider(
                              //                   finalScondPost.business!.videos!
                              //                       .first.thumbnail
                              //                       .toString()),
                              //               fit: BoxFit.cover),
                              //           borderRadius: BorderRadius.circular(50),
                              //         ),
                              //         // child: Stack(
                              //         //   children: [
                              //         //     Positioned(
                              //         //       bottom: 38,
                              //         //       left: 45,
                              //         //       top: 153,
                              //         //       right: 146,
                              //         //       child: Container(
                              //         //           child: Center(
                              //         //             child: Icon(Icons
                              //         //                 .arrow_forward_rounded),
                              //         //           ),
                              //         //           height: 24,
                              //         //           width: 24,
                              //         //           decoration: BoxDecoration(
                              //         //               shape: BoxShape.circle,
                              //         //               color: Colors.white)),
                              //         //     )
                              //         //   ],
                              //         // ),
                              //       ),
                              //       SizedBox(height: 10),
                              //       Text(
                              //         finalScondPost.business!.author!.name
                              //             .toString(),
                              //         style: ThreeKmTextConstants
                              //             .tk18PXLatoBlackMedium,
                              //       ),
                              //       SizedBox(
                              //         height: 15,
                              //       ),
                              //       Text(
                              //         finalScondPost.business?.headline
                              //                 .toString() ??
                              //             "",
                              //         style:
                              //             ThreeKmTextConstants.tk11PXLatoGreyBold,
                              //       ),
                              //       TextButton(
                              //           onPressed: () {
                              //             Navigator.push(
                              //                 context,
                              //                 AnimatedSizeRoute(
                              //                     page: Postview(
                              //                         postId: finalScondPost
                              //                             .business!.postId
                              //                             .toString())));
                              //           },
                              //           child: Text("Read More"))
                              //     ],
                              //   ),
                              // )
                            ]),
                      );
                    }
                    return Container();
                  },
                )
              else
                Container(),
              SizedBox(
                height: 150,
              )

              // Consumer<NewsFeedProvider>(
              //   builder: (context, controller, _) {
              //     // return Container(height: 100, width: 200);
              //     return ListView.builder(
              //       primary: true,
              //       physics: ScrollPhysics(),
              //       shrinkWrap: true,
              //       itemCount: controller
              //           .newsFeedBottomModel?.data?.result?.posts?.length,
              //       itemBuilder: (context, index) {
              //         return Container(child: Text("i am post"));
              //       },
              //     );
              //   },
              // )
              // FutureBuilder<NewsFeedBottomModel?>(
              //   future: NewsFeedProvider().getBottomFeed(
              //       languageCode:
              //           context.read<AppLanguage>().appLocal == Locale("mr")
              //               ? "mr"
              //               : context.read<AppLanguage>().appLocal == Locale("en")
              //                   ? "en"
              //                   : "hi"),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.none &&
              //         snapshot.hasData == null) {
              //       //print('project snapshot data is: ${projectSnap.data}');
              //       return Container(
              //         child: Text("wating.."),
              //       );
              //     }
              //     return ListView.builder(
              //       shrinkWrap: true,
              //       itemCount: snapshot.data?.data?.result?.posts?.length,
              //       itemBuilder: (context, index) {
              //         return Container(child: Text("i am post"));
              //       },
              //     );
              //   },
              // )
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class IconConatiner extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  IconConatiner({Key? key, required this.icon, required this.iconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(right: 18),
        height: 24,
        width: 24,
        child: Icon(icon, color: iconColor),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ));
  }
}

/// Custom Container to show News card
class NewsContainer extends StatelessWidget {
  final Finalpost finalPost;

  NewsContainer({required this.finalPost, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 5),
        height: 250,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                          style: ThreeKmTextConstants.tk16PXPoppinsBlackMedium)
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
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.white,
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
                            log("ontap Created date value ${contentPost![postIndex].postCreatedDate}");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Postview(
                                        image: contentPost[postIndex]
                                            .image
                                            .toString(),
                                        postId: contentPost[postIndex]
                                            .postId
                                            .toString())));
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 13),
                            child: Container(
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
                                    //mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                          height: 100,
                                          width: 157,
                                          margin: EdgeInsets.only(top: 2),
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              boxShadow: [
                                                BoxShadow(
                                                    // blurStyle: BlurStyle.outer,
                                                    color: Colors.black26,
                                                    blurRadius: 0.8)
                                              ],
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight:
                                                      Radius.circular(10)),
                                              image: DecorationImage(
                                                  fit: BoxFit.fill,
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
                                                      ""
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
                                              contentPost[postIndex]
                                                          .video
                                                          .toString() !=
                                                      ""
                                                  ? Center(
                                                      child: Container(
                                                        child: SvgPicture.asset(
                                                          "assets/playicon.svg",
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox.shrink()
                                            ],
                                          )),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 40,
                                        width: 150,
                                        padding:
                                            EdgeInsets.only(left: 8, right: 8),
                                        child: Text(
                                            contentPost[postIndex]
                                                .headline
                                                .toString(),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: ThreeKmTextConstants
                                                .tk12PXPoppinsBlackSemiBold),
                                      ),
                                      Container(
                                        height: 18,
                                        width: 150,
                                        padding:
                                            EdgeInsets.only(left: 8, right: 8),
                                        child: Text(
                                          contentPost[postIndex]
                                              .author!
                                              .name
                                              .toString(),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                        ),
                                      )
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

// class Option extends StatelessWidget {
//   const Option(
//       {required this.text,
//       required this.index,
//       required this.option,
//       required this.quizId,
//       required this.isAnswred,
//       required this.selectedOptionIndex,
//       //required this.rightAnswer,
//       this.correctAnsIndex});
//   final String option;
//   final String text;
//   final int index;
//   final int? correctAnsIndex;
//   final int? quizId;
//   final bool isAnswred;
//   final int selectedOptionIndex;
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<QuizProvider>(builder: (context, model, _) {
//       Color getTheRightColor() {
//         if (model.isAnswred) {
//           if (model.answredIndex == model.selectedIndex &&
//               index == correctAnsIndex) {
//             return Colors.green;
//           } else if (index == model.selectedIndex) {
//             return Colors.red;
//           }
//         }
//         return Colors.grey;
//       }

//       Color GetColorAlreadyAnwer(
//           {required int answerIndex,
//           required int index,
//           required int selectedIndex}) {
//         if (index == answerIndex && index == selectedIndex) {
//           return Colors.green;
//         } else if (index == selectedIndex) {
//           return Colors.red;
//         }
//         return Colors.grey;
//       }

//       return GestureDetector(
//         onTap: this.isAnswred == null || this.isAnswred == false
//             ? () {
//                 context.read<QuizProvider>().checkAns(index, correctAnsIndex!);
//                 print(index);
//                 print(this.option);
//                 context.read<QuizProvider>().submitQuiz(quizId!, this.option);
//                 context.read<HomefirstProvider>().submitQuiz(quizId: quizId!);
//               }
//             : null,
//         child: Padding(
//           padding: const EdgeInsets.only(bottom: 8),
//           child: Container(
//             padding: EdgeInsets.all(3),
//             decoration: BoxDecoration(
//                 border: Border.all(
//                     color: this.isAnswred == true
//                         ? GetColorAlreadyAnwer(
//                             selectedIndex: this.selectedOptionIndex,
//                             index: this.index,
//                             answerIndex: this.correctAnsIndex!)
//                         : getTheRightColor(),
//                     width: 1),
//                 borderRadius: BorderRadius.circular(20),
//                 color: Colors.white),
//             child: Row(children: [
//               Container(
//                 height: 30,
//                 width: 30,
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                       color: this.isAnswred == true
//                           ? GetColorAlreadyAnwer(
//                               selectedIndex: this.selectedOptionIndex,
//                               index: this.index,
//                               answerIndex: this.correctAnsIndex!)
//                           : getTheRightColor()),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Center(
//                   child: Text(this.text),
//                 ),
//               ),
//               Container(
//                   child: Padding(
//                 padding: const EdgeInsets.only(left: 8),
//                 child: Text(this.option),
//               ))
//             ]),
//           ),
//         ),
//       );
//     });
//   }
// }
