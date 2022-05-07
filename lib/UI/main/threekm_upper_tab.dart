import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:threekm/UI/businesses/businesses_home.dart';
import 'package:threekm/UI/shop/home_3km.dart';
import 'package:threekm/UI/shop/restaurants/restaurants_home_page.dart';
import 'package:threekm/providers/localization_Provider/appLanguage_provider.dart';
import 'package:threekm/utils/constants.dart';

import 'News/NewsTab.dart';

class ThreeKMUpperTab extends StatelessWidget {
  const ThreeKMUpperTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<AppLanguage>();
    return DefaultTabController(
        length: 5,
        child: Material(
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  width: size(context).width,
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
                  child: TabBarView(children: [
                    //Container(),
                    //Container(),
                    NewsTab(
                      reload: false, //widget.redirectedFromPost
                      isPostUploaded: false, // widget.isPostUploaded,
                      appLanguage: languageProvider.appLocal,
                    ),
                    Container(),
                    //Container(),
                    RestaurantsHome(),
                    Home3KM(),
                    BusinessesHome(),
                  ]),
                )
              ],
            ),
          ),
        ));
  }
}
