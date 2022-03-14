import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:threekm/UI/Auth/signup/sign_up.dart';
import 'package:threekm/UI/Search/SearchPage.dart';
import 'package:threekm/UI/businesses/businesses_detail.dart';
import 'package:threekm/UI/businesses/view_all_category_biz.dart';
import 'package:threekm/UI/main/navigation.dart';
import 'package:threekm/UI/shop/cart/cart_item_list_modal.dart';
import 'package:threekm/localization/localize.dart';
import 'package:threekm/providers/Location/locattion_Provider.dart';
import 'package:threekm/providers/businesses/businesses_home_provider.dart';
// import 'package:threekm/utils/screen_util.dart';

import 'package:threekm/utils/threekm_textstyles.dart';

import 'package:url_launcher/url_launcher.dart';

class BusinessesHome extends StatefulWidget {
  const BusinessesHome({Key? key}) : super(key: key);

  @override
  State<BusinessesHome> createState() => _BusinessesHomeState();
}

class _BusinessesHomeState extends State<BusinessesHome>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    context.read<BusinessesHomeProvider>().getBusinesses(mounted);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // context.read<BusinessesHomeProvider>().getBusinesses(mounted);
    final businessesHomeProvider = context.watch<BusinessesHomeProvider>();
    final _location = context.read<LocationProvider>().getlocationData;
    return Scaffold(
      // extendBody: true,
      appBar: AppBar(
        elevation: 0,
        title: Text('Businesses'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: RefreshIndicator(
        onRefresh: () {
          var initJson = json.encode({
            "lat": _location?.latitude ?? '',
            "lng": _location?.longitude ?? '',
            "page": 1
          });
          return context
              .read<BusinessesHomeProvider>()
              .onRefresh(initJson, mounted);
        },
        child: Builder(builder: (context) {
          if (businessesHomeProvider.state == 'loading') {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (businessesHomeProvider.state == "error") {
            context.read<BusinessesHomeProvider>().getBusinesses(mounted);
            return Center(child: Text(""));
          } else if (businessesHomeProvider.state == "loaded") {
            return businessesHomeProvider.businessesHomedata != null
                ? Home()
                : Center(child: Text(""));
          }
          return Container();
        }),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final businessesHomeProvider = context.watch<BusinessesHomeProvider>();
    var data = businessesHomeProvider.businessesHomedata;
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          padding: EdgeInsets.only(top: 20),
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.zero,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchPage(
                                          tabNuber: 2,
                                        )));
                          },
                          child: Container(
                            height: 32,
                            width: 250,
                            decoration: BoxDecoration(
                                //color: Colors.white,
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
                                      AppLocalizations.of(context)!.translate(
                                              'Search_Hyperlocal_Business') ??
                                          "Search Hyperlocal Business",
                                      style: ThreeKmTextConstants
                                          .tk12PXLatoBlackBold
                                          .copyWith(color: Colors.grey),
                                    ))
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => viewCart(context, 'shop'),
                          child: Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: Container(
                                height: 32,
                                width: 32,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/shopImg/Group 40724.png")),
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
                                  image: DecorationImage(
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
                ),
                Container(
                  //  padding: EdgeInsets.only(left: 20),
                  height: 350,
                  child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1.35),
                      itemCount: data?.result?.categories?.Result.length,
                      itemBuilder: (context, i) {
                        var category = data?.result?.categories?.Result[i];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ViewAllBiz(
                                          query: '${category?.name}',
                                        )));
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color(0xFFF4F3F8),
                                ),
                                child: Image(
                                  image: NetworkImage('${category?.imageLink}'),
                                  // height: 50,
                                  // width: 50,
                                ),
                              ),
                              Text(
                                '${category?.name}',
                                style: ThreeKmTextConstants
                                    .tk12PXPoppinsBlackSemiBold
                                    .copyWith(height: 2),
                              )
                            ],
                          ),
                        );
                      }),
                ),
                const Divider(
                  color: Color(0xFFF4F3F8),
                  thickness: 8,
                ),
                Container(
                  height: 250,
                  child: ListView.builder(
                      padding: EdgeInsets.all(20),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: data?.result?.advertisements?.length,
                      itemBuilder: (context, i) {
                        var advData = data?.result?.advertisements?[i];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              log('${advData?.imagesWcta?[0].business}');
                              log('${advData?.imagesWcta?[0].product}');
                              log('${advData?.imagesWcta?[0].website}');
                              log('${advData?.imagesWcta?[0].phone}');
                            },
                            child: Material(
                              borderRadius: BorderRadius.circular(10),
                              elevation: 1,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                      imageUrl: '${advData?.images.first}',
                                      width: MediaQuery.of(context).size.width /
                                          1.1888,
                                      // height: ThreeKmScreenUtil.screenHeightDp / 19,
                                      fit: BoxFit.fill,
                                      placeholder: (context, url) =>
                                          Shimmer.fromColors(
                                              baseColor: Colors.grey[700]!,
                                              highlightColor: Colors.grey[100]!,
                                              child: Container()))),
                            ),
                          ),
                        );
                      }),
                ),
                const Divider(
                  color: Color(0xFFF4F3F8),
                  thickness: 8,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data?.result?.businesses?.length,
                    itemBuilder: (context, i) {
                      var business = data?.result?.businesses?[i];
                      return Container(
                        height: 260,
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${business?.name}',
                                    style: ThreeKmTextConstants
                                        .tk16PXPoppinsBlackSemiBold,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => ViewAllBiz(
                                                    query: '${business?.name}',
                                                  )));
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                                  .translate('view_all_text') ??
                                              'View All ',
                                          style: ThreeKmTextConstants
                                              .tk14PXPoppinsGreenSemiBold,
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_rounded,
                                          color: Color(0xff43B978),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 230,
                              child: ListView.builder(
                                  padding: const EdgeInsets.all(20),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: business?.business.length,
                                  itemBuilder: (context, index) {
                                    var singleBusiness =
                                        business?.business[index];
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => BusinessDetail(
                                                      id: singleBusiness
                                                          ?.creatorId,
                                                    )));
                                      },
                                      child: Container(
                                        width: 150,
                                        padding: const EdgeInsets.only(
                                          right: 10,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 130,
                                              height: 130,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Color(0xFFF4F3F8)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Image(
                                                  image: NetworkImage(
                                                      '${singleBusiness?.image}'),
                                                  fit: BoxFit.fill,
                                                  //width: 100,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '${singleBusiness?.businessName}',
                                              overflow: TextOverflow.ellipsis,
                                              style: ThreeKmTextConstants
                                                  .tk14PXLatoBlackSemiBold
                                                  .copyWith(height: 2),
                                            ),
                                            Text(
                                              '${singleBusiness?.tags.join(", ")}',
                                              style: ThreeKmTextConstants
                                                  .tk12PXLatoGreenMedium,
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      );
                    }),
                const Divider(
                  color: Color(0xFFF4F3F8),
                  thickness: 8,
                ),
                Container(
                  height: 250,
                  child: ListView.builder(
                      padding: EdgeInsets.all(20),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: data?.result?.slider?.result?.length,
                      itemBuilder: (context, i) {
                        var advData = data?.result?.slider?.result?[i];
                        return InkWell(
                          onTap: () {
                            advData?.imagesWcta?[0].website != null
                                ? launch('${advData?.imagesWcta?[0].website}')
                                : null;
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(10),
                              elevation: 1,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                      imageUrl: '${advData?.images[0]}',
                                      width: MediaQuery.of(context).size.width /
                                          1.1888,
                                      // height: ThreeKmScreenUtil.screenHeightDp / 19,
                                      fit: BoxFit.fill,
                                      placeholder: (context, url) =>
                                          Shimmer.fromColors(
                                              baseColor: Colors.grey[700]!,
                                              highlightColor: Colors.grey[100]!,
                                              child: Container()))),
                            ),
                          ),
                        );
                      }),
                ),
                const Image(
                  image: AssetImage('assets/BusinessesImg/giveaway@3x.png'),
                )
              ],
            ),
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
