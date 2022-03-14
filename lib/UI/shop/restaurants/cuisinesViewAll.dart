import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:threekm/UI/shop/restaurants/restaurant_cuisines.dart';
import 'package:threekm/UI/shop/restaurants/restaurants_menu.dart';
import 'package:threekm/providers/shop/restaurant_menu_provider.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

class CuisinesViewAll extends StatefulWidget {
  final String query;
  const CuisinesViewAll({Key? key, required this.query}) : super(key: key);

  @override
  State<CuisinesViewAll> createState() => _CuisinesViewAllState();
}

class _CuisinesViewAllState extends State<CuisinesViewAll> {
  @override
  void initState() {
    context.read<RestaurantMenuProvider>().cuisinesClick(mounted, widget.query);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var state = context.watch<RestaurantMenuProvider>().state;
    var restaurantdata = context
        .watch<RestaurantMenuProvider>()
        .cuisinesRestroListData
        .data
        ?.result
        .data;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
          title: Text(widget.query),
        ),
        body: state == 'loaded'
            ? ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: context
                    .watch<RestaurantMenuProvider>()
                    .cuisinesRestroListData
                    .data
                    ?.result
                    .data
                    .length,
                itemBuilder: (_, i) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => RestaurantCuisinesMenu(
                                    data: restaurantdata?[i],
                                  )));
                    },
                    child: Container(
                      // padding: EdgeInsets.all(20),
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Color(0xFFE2E4E6))),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            height: MediaQuery.of(context).size.height / 4,
                            child: Stack(
                              alignment: Alignment.topLeft,
                              fit: StackFit.loose,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                  child: ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                        restaurantdata?[i].status !=
                                                false
                                            ? Colors.transparent
                                            : Colors.grey,
                                        //Colors.transparent,
                                        BlendMode.color),
                                    child: CachedNetworkImage(
                                      alignment: Alignment.center,
                                      placeholder: (context, url) =>
                                          Container(color: Colors.grey),
                                      imageUrl: '${restaurantdata?[i].cover}',
                                      //height: ThreeKmScreenUtil.screenHeightDp / 5,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                // Row(
                                //   children: [
                                //     Container(
                                //       padding: EdgeInsets.all(10),
                                //       margin: EdgeInsets.all(10),
                                //       decoration: BoxDecoration(
                                //           borderRadius: BorderRadius.circular(15),
                                //           color: Colors.white),
                                //       child: Text(
                                //         'Best Safety',
                                //         style: ThreeKmTextConstants
                                //             .tk14PXPoppinsBlueMedium,
                                //       ),
                                //     ),
                                //     Container(
                                //       padding: EdgeInsets.all(9),
                                //       margin: EdgeInsets.all(10),
                                //       decoration: BoxDecoration(
                                //           borderRadius: BorderRadius.circular(15),
                                //           gradient: const LinearGradient(colors: [
                                //             Color(0xFFFF5C3D),
                                //             Color(0xFFFF2A5F)
                                //           ])),
                                //       child: Text(
                                //         '50% off',
                                //         style: ThreeKmTextConstants
                                //             .tk12PXPoppinsWhiteRegular,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${restaurantdata?[i].businessName}',
                              style: ThreeKmTextConstants
                                  .tk16PXPoppinsBlackSemiBold,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 1.9,
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  '${restaurantdata?[i].cuisines.join(", ")}',
                                  maxLines: 1,
                                  style: ThreeKmTextConstants
                                      .tk14PXPoppinsBlueMedium,
                                ),
                              ),
                              if (restaurantdata?[i].address.serviceArea !=
                                  null)
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                      '${restaurantdata?[i].address.serviceArea}'),
                                )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                })
            : Container());
  }
}
