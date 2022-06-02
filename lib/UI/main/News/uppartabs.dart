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
import 'News_FeedPage.dart';
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
                            size: 22,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text("Your Location",
                              //     style: TextStyle(
                              //         color: Colors.blueAccent, fontSize: 15)),
                              Padding(
                                padding: EdgeInsets.only(left: 0, top: 5),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.88,
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