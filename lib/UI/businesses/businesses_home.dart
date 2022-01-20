import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/src/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:threekm/UI/businesses/businesses_detail.dart';
import 'package:threekm/UI/shop/cart/cart_item_list_modal.dart';
import 'package:threekm/providers/businesses/businesses_home_provider.dart';
import 'package:threekm/utils/screen_util.dart';

import 'package:threekm/utils/threekm_textstyles.dart';

import 'package:url_launcher/url_launcher.dart';

class BusinessesHome extends StatefulWidget {
  const BusinessesHome({Key? key}) : super(key: key);

  @override
  State<BusinessesHome> createState() => _BusinessesHomeState();
}

class _BusinessesHomeState extends State<BusinessesHome> {
  @override
  void initState() {
    context.read<BusinessesHomeProvider>().getBusinesses(mounted);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    ThreeKmScreenUtil.getInstance();
    ThreeKmScreenUtil.instance.init(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // context.read<BusinessesHomeProvider>().getBusinesses(mounted);
    final businessesHomeProvider = context.watch<BusinessesHomeProvider>();
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          var initJson = json.encode({"lat": '', "lng": '', "page": 1});
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
            return Center(child: Text("error"));
          } else if (businessesHomeProvider.state == "loaded") {
            return businessesHomeProvider.businessesHomedata != null
                ? Home()
                : Center(child: Text("null"));
          }
          return Container();
        }),
      ),
    );
  }
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
          width: ThreeKmScreenUtil.screenWidthDp,
          height: ThreeKmScreenUtil.screenHeightDp,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: ThreeKmScreenUtil.screenWidthDp / 1.5,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          validator: (val) {},
                          autofocus: false,
                          decoration: InputDecoration(
                            hintText: 'Search for a store/item',
                            hintStyle:
                                ThreeKmTextConstants.tk14PXLatoGreyRegular,
                            counterText: '',
                            filled: true,
                            prefixIcon: const Icon(Icons.search,
                                color: Color(0xFF0F0F2D)),
                            fillColor: Colors.grey[200],
                            //isDense: true,
                            contentPadding:
                                const EdgeInsets.fromLTRB(10, 13, 10, 13),
                            // enabledBorder: OutlineInputBorder(
                            //     borderSide: BorderSide(color: Colors.grey[400])),
                            // focusedBorder: OutlineInputBorder(
                            //     borderSide: BorderSide(color: Colors.grey[400])),
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: const Image(
                            image: AssetImage(
                                'assets/shopImg/icons8-male-user-4.png'),
                            width: 40),
                      ),
                      InkWell(
                        onTap: () {
                          viewCart(context, 'shop');
                        },
                        child: const Image(
                            image: AssetImage('assets/shopImg/Group 40724.png'),
                            width: 40),
                      )
                    ],
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
                        return Column(
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
                          child: Material(
                            borderRadius: BorderRadius.circular(10),
                            elevation: 1,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                    imageUrl: '${advData?.images.first}',
                                    width: ThreeKmScreenUtil.screenWidthDp /
                                        1.1888,
                                    // height: ThreeKmScreenUtil.screenHeightDp / 19,
                                    fit: BoxFit.fill,
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                            baseColor: Colors.grey[700]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Container()))),
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
                                    onTap: () {},
                                    child: Row(
                                      children: [
                                        Text(
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
                                      width: ThreeKmScreenUtil.screenWidthDp /
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
}
