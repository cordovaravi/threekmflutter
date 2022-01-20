import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:threekm/UI/shop/product/product_details.dart';
import 'package:threekm/providers/Search/Search_Provider.dart';

import 'package:threekm/utils/utils.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  final int tabNuber;
  SearchPage({required this.tabNuber, Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  late TabController controller;
  TextEditingController searchController = TextEditingController();
  //ScrollController bizScrollController = ScrollController();
  ScrollController shopScrollController = ScrollController();
  ScrollController newsScrollController = ScrollController();

  int pageNumber = 1;

  @override
  void initState() {
    super.initState();
    //Get.put(SearchController());
    controller =
        TabController(length: 3, vsync: this, initialIndex: widget.tabNuber);
    shopScrollController.addListener(() {
      if (shopScrollController.position.maxScrollExtent ==
          shopScrollController.position.pixels) {
        pageNumber = pageNumber + 1;
        print("page number is $pageNumber");
        context.read<SearchBarProvider>().getShopSearch(
            query: searchController.text,
            pageNumber: pageNumber,
            isNewCall: false);
      }
    });

    // newsScrollController.addListener(() {
    //   if (newsScrollController.offset >=
    //       newsScrollController.position.maxScrollExtent - 100) {
    //     print("Next posts called");
    //     Get.find<SearchController>().getNextPosts();
    //   }
    // });
  }

  @override
  void dispose() {
    //  Get.delete<SearchController>();
    searchController.dispose();
    // bizScrollController.dispose();
    shopScrollController.dispose();
    newsScrollController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          buildAppBar(context),
          space(height: 25),
          buildTabs(),
          Expanded(
            child: TabBarView(
              controller: controller,
              children: [
                //buildNews(),
                Container(
                  child: Text("news container"),
                ),
                shopTab(),
                buildBiz(),
              ],
            ),
          ),
          // Builder(
          //   builder: (BuildContext context) =>
          //    searchController.text.length > 0
          //       // &&
          //       //         ((_controller.selectedIndex == 0 &&
          //       //                 _controller.news.length > 0) ||
          //       //             (_controller.selectedIndex == 1 &&
          //       //                 _controller.shop.length > 0) ||
          //       //             (_controller.selectedIndex == 2 &&
          //       //                 _controller.biz.length > 0))
          //       ? Container(
          //           height: 100,
          //           decoration:
          //               BoxDecoration(color: Color(0xFFF9FBFE), boxShadow: [
          //             BoxShadow(
          //               color: Color(0x29000000),
          //               offset: Offset(0, -3),
          //               blurRadius: 6,
          //             )
          //           ]),
          //           width: MediaQuery.of(context).size.width,
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //             children: [
          //               //  ElevatedChip("Filters"),
          //               //  ElevatedChip("Sort"),
          //               TextButton(
          //                 onPressed: () {},
          //                 child: Text(
          //                   "Clear Filters".toUpperCase(),
          //                   style: ThreeKmTextConstants
          //                       .tk12PXPoppinsBlackSemiBold
          //                       .copyWith(
          //                     fontWeight: FontWeight.w500,
          //                     color: Color(0xFFFF5858),
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         )
          //       : Container(),
          // ),
        ],
      ),
    );
  }

  TabBar buildTabs() {
    return TabBar(
      tabs: [
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                //color: Colors.grey,
                child: Image.asset(
                  "assets/newspaper.png",
                  height: 18,
                  width: 18,
                ),
              ),
              space(width: 8),
              Text("News")
            ],
          ),
        ),
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Image.asset(
                  "assets/shopping_bag.png",
                  height: 18,
                  width: 18,
                ),
              ),
              space(width: 8),
              Text("Shop")
            ],
          ),
        ),
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Image.asset(
                  "assets/storefront.png",
                  height: 18,
                  width: 18,
                ),
              ),
              space(width: 8),
              Text("Biz")
            ],
          ),
        ),
      ],
      labelColor: Color(0xFF3E7EFF),
      unselectedLabelColor: Color(0xFF979EA4),
      indicatorColor: Color(0xFF3E7EFF),
      indicatorWeight: 3,
      labelStyle:
          GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
      controller: controller,
    );
  }

  Widget buildAppBar(BuildContext context) {
    return Builder(
      builder: (_controller) => Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10),
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            space(width: 18),
            Transform.translate(
              offset: Offset(0, -15),
              child: Icon(
                Icons.arrow_back_outlined,
                size: 20,
                color: Colors.black,
              ).onTap(Navigator.of(context).pop),
            ),
            space(width: 14),
            Expanded(
              child: Container(
                height: 48,
                child: TextFormField(
                  controller: searchController,
                  onFieldSubmitted: (value) {
                    context.read<SearchBarProvider>().getShopSearch(
                        query: value, pageNumber: 1, isNewCall: true);
                    context
                        .read<SearchBarProvider>()
                        .getBusinessSearch(query: value);
                  },
                  maxLines: 1,
                  textAlignVertical: TextAlignVertical.bottom,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F0F2D),
                  ),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: "Start your search here",
                    hintStyle: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F0F2D).withOpacity(0.5),
                    ),
                    filled: true,
                    fillColor: Color(0xFFF4F3F8),
                    prefixIcon: Transform.translate(
                      child: Icon(
                        Icons.search,
                        color: Color(0xFF979EA4),
                      ),
                      offset: Offset(0, 2),
                    ),
                    suffixIcon: Visibility(
                      visible: searchController.text.length > 0,
                      child: Transform.translate(
                        child: GestureDetector(
                          onTap: () {
                            searchController.text = "";
                            // _controller.sink("");
                          },
                          child: Container(
                            child: Icon(
                              Icons.cancel_rounded,
                              color: Colors.red,
                              size: 24,
                            ),
                          ),
                        ),
                        offset: Offset(0, 0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            space(width: 19),
          ],
        ),
      ),
    );
  }

  Widget shopTab() {
    return Consumer<SearchBarProvider>(builder: (context, controller, _) {
      return controller.shopSearchData?.result?.products?.length != null
          ? ListView.builder(
              controller: shopScrollController,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: controller.shopSearchData!.result!.products!.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductDetails(
                                id: controller.shopSearchData!.result!
                                    .products![index].catalogId!
                                    .toInt())));
                  },
                  child: CategoryCardSearch(
                      image: controller
                          .shopSearchData!.result!.products![index].image
                          .toString(),
                      name: controller
                          .shopSearchData!.result!.products![index].name
                          .toString(),
                      by: controller
                          .shopSearchData!.result!.products![index].businessName
                          .toString(),
                      price: controller
                          .shopSearchData!.result!.products![index].price
                          .toString(),
                      id: controller
                          .shopSearchData!.result!.products![index].catalogId!
                          .toInt()),
                );
              })
          : CupertinoActivityIndicator();
    });
    // builder: (_controller) => _controller.shop.length > 0 &&
    //     searchController.text.length > 0
    // ? ListView.builder(
    //     controller: shopScrollController,
    //     shrinkWrap: true,
    //     itemBuilder: (context, i) => InkWell(
    //       onTap: () async {
    //         // await Navigator.of(context).pushNamed(
    //         //   ProductDetailsPage.path,
    //         //   arguments: _controller.shop[i]['catalog_id'],
    //         // );
    //         // _controller.getAllWishlist();
    //       },
    //       child: CategoryCardSearch(
    //           id: _controller.shop[i]['catalog_id'],
    //           image: _controller.shop[i]['image'],
    //           name: _controller.shop[i]['name'],
    //           price: _controller.shop[i]['price'].toString(),
    //           by: _controller.shop[i]['business_name']),
    //     ),
    //     itemCount: _controller.shop.length,
    //   )
    // : searchController.text.length > 0 && _controller.productLoading
    //     ? Center(child: CupertinoActivityIndicator())
    //     : SingleChildScrollView(
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             space(height: 61),
    //             Text(
    //               "Product Categories:",
    //               style: generateStyles(
    //                   type: StylesEnum.POPPINS,
    //                   fontSize: 16,
    //                   fontWeight: FontWeight.bold),
    //             ).paddingX(18).padding(bottom: 24),
    //             GetBuilder<ShopController>(
    //               builder: (_controller) =>
    //                   _controller.shopHome!['Result'] != null
    //                       ? ListView.builder(
    //                           scrollDirection: Axis.horizontal,
    //                           padding: EdgeInsets.only(left: 19),
    //                           itemCount: _controller
    //                               .shopHome!['Result']['trending'].length,
    //                           itemBuilder: (context, i) {
    //                             var data = _controller.shopHome!['Result']
    //                                 ['trending'][i];
    //                             return Column(children: [
    //                               Container(
    //                                 decoration: BoxDecoration(
    //                                   color:
    //                                       ThreeKmTextConstants.lightBlue,
    //                                   shape: BoxShape.circle,
    //                                   image: DecorationImage(
    //                                     image: CachedNetworkImageProvider(
    //                                         data['image']),
    //                                     fit: BoxFit.fill,
    //                                   ),
    //                                 ),
    //                               ).size(
    //                                 height: 80,
    //                                 width: 80,
    //                               ),
    //                               space(
    //                                 height: 8,
    //                               ),
    //                               Text(
    //                                 data['name'],
    //                                 style: ThreeKmTextConstants
    //                                     .tk12PXPoppinsBlackSemiBold,
    //                               )
    //                             ]).padding(right: 24).onTap(() {
    //                               Navigator.of(context).pushNamed(
    //                                 ShopCategoryView.path,
    //                                 arguments: data['name'].toString(),
    //                               );
    //                             });
    //                           },
    //                         ).size(
    //                           width: double.infinity,
    //                           height: 120,
    //                         )
    //                       : Container(),
    //             ),
    //             space(height: 32),
    //             Divider(
    //               color: Color(0xFFF4F3F8),
    //               thickness: 24,
    //             ),
    //             Text(
    //               "Top Selling products",
    //               style: generateStyles(
    //                 type: StylesEnum.POPPINS,
    //                 fontWeight: FontWeight.bold,
    //                 fontSize: 16,
    //                 color: Color(0xFF0F0F2D),
    //               ),
    //             ).padding(
    //               top: 32,
    //               left: 24,
    //               bottom: 20,
    //             ),
    //             GetBuilder<ShopController>(builder: (controller) {
    //               if (controller.shopHome!['Result'] != null) {
    //                 return Column(
    //                   children: (controller.shopHome!['Result']['shops']
    //                           as List)
    //                       .asMap()
    //                       .entries
    //                       .toList()
    //                       .sublist(0, 2)
    //                       .map((e) {
    //                     if (controller.shopHome!['Result']['shops'][e.key]
    //                             ['adv_id'] !=
    //                         null) {
    //                       var e =
    //                           controller.shopHome!['Result']['shops'][1];
    //                       e['products'] = e['products'].sublist(0, 2);
    //                       return ShopGrids(name: e['name'], map: e);
    //                     } else {
    //                       var e =
    //                           controller.shopHome!['Result']['shops'][0];
    //                       return ShopAdSlideDynamic(map: e);
    //                     }
    //                   }).toList(),
    //                 );
    //               } else {
    //                 return Container();
    //               }
    //             }),
    //           ],
    //         ),
    //       ),
    //);
  }

  Widget buildBiz() {
    return Consumer<SearchBarProvider>(builder: (context, controller, _) {
      return controller.BusinessSearchData?.data?.result?.creators?.length !=
              null
          ? ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount:
                  controller.BusinessSearchData!.data!.result!.creators!.length,
              itemBuilder: (context, index) {
                return BizCategoryCardSearch(
                    image: controller.BusinessSearchData!.data!.result!
                        .creators![index].image
                        .toString(),
                    name: controller.BusinessSearchData!.data!.result!
                        .creators![index].businessName
                        .toString(),
                    tags:
                        "${controller.BusinessSearchData!.data!.result!.creators![index].tags!.first.toString()},  ${controller.BusinessSearchData!.data!.result!.creators![index].tags!.last.toString()}",
                    ownername:
                        "${controller.BusinessSearchData!.data!.result!.creators![index].firstname} ${controller.BusinessSearchData!.data!.result!.creators![index].lastname}",
                    id: controller.BusinessSearchData!.data!.result!
                        .creators![index].creatorId!
                        .toInt());
              })
          : CupertinoActivityIndicator();
    });
    // _controller.shop.length > 0 && searchController.text.length > 0
    //     ?
    //           Container(
    //               color: Colors.white,
    //               child: ListView.builder(
    //                 controller: bizScrollController,
    //                 shrinkWrap: true,
    //                 itemBuilder: (context, i) {
    //                 //  String tag = _controller.biz[i]['tags'].toString();
    //                   return InkWell(
    //                     onTap: () async {
    //                       // await Navigator.of(context).pushNamed(
    //                       //   BusinessDetailsPage.path,
    //                       //   arguments: _controller.biz[i]['creator_id'],
    //                       // );
    //                       _controller.getAllWishlist();
    //                     },
    //                     child: BizCategoryCardSearch(
    //                       id: _controller.biz[i]['creator_id'],
    //                       image: _controller.biz[i]['image'],
    //                       name: _controller.biz[i]['business_name'],
    //                       price: "Kothrod(1.4km)",
    //                       tags: tag.substring(1, tag.length - 1),
    //                     ),
    //                   );
    //                 },
    //                 itemCount: _controller.biz.length,
    //               ),
    //             )
    //           : searchController.text.length > 0 && _controller.bizLoading
    //               ? Center(child: CupertinoActivityIndicator())
    //               : SingleChildScrollView(
    //                   child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Text(
    //                         "Business Categories:",
    //                         style: generateStyles(
    //                           type: StylesEnum.POPPINS,
    //                           fontSize: 16,
    //                           fontWeight: FontWeight.bold,
    //                         ),
    //                       ).margin(top: 61, left: 19),
    //                       // BusinessCategorySlide()
    //                       //     .size(height: 280)
    //                       //     .margin(bottom: 32, top: 24),
    //                       Divider(
    //                         color: Color(0xFFF4F3F8),
    //                         thickness: 8,
    //                       ).margin(bottom: 24),
    //                      // BusinessTrendingWidget(),
    //                      // BusinessAdSlide().paddingY(16).color(
    //                      //       Color(0xFFF4F3F8),
    //                      //     )
    //                     ],
    //                   ),
    //                 ),
    // );
  }

  // Widget buildNews() {
  //   return GetBuilder<SearchController>(
  //     builder: (_controller) =>
  //         _controller.news.length > 0 && searchController.text.length > 0
  //             ? buildNewsItems(_controller.news)
  //             : searchController.text.length > 0 && _controller.newsLoading
  //                 ? Center(child: CupertinoActivityIndicator())
  //                 : SingleChildScrollView(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         space(height: 60),
  //                         buildTopics(),
  //                         space(height: 68),
  //                         GetBuilder<NewsController>(
  //                           builder: (_controller) =>
  //                               _controller.result!.categories!
  //                                   .sublist(0, 1)
  //                                   .map((e) {
  //                                     return Column(
  //                                       children: [
  //                                         BaseNewsTwo(
  //                                           title: '${e.name} Posts:',
  //                                           categoryId: e.categoryId!,
  //                                           posts: e.posts ?? [],
  //                                         ),
  //                                         space(height: 48),
  //                                       ],
  //                                     );
  //                                   })
  //                                   .toList()
  //                                   .first,
  //                         ),
  //                         Text(
  //                           "Top Products",
  //                           style: generateStyles(
  //                             type: StylesEnum.POPPINS,
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.bold,
  //                             color: Color(0xFF0F0F2D),
  //                           ),
  //                         ).paddingX(19),
  //                         GetBuilder<ShopController>(builder: (_controller) {
  //                           List<dynamic> data = [];
  //                           (_controller.shopHome!['Result']['shops'] as List)
  //                               .where((e) => e['adv_id'] == null)
  //                               .toList()
  //                               .forEach((e) {
  //                             data.addAll(e['products'].map((i) => i).toList());
  //                           });
  //                           print(data.length);
  //                           return ListView.builder(
  //                             scrollDirection: Axis.horizontal,
  //                             padding: EdgeInsets.only(left: 19, bottom: 8),
  //                             itemBuilder: (context, i) {
  //                               return GestureDetector(
  //                                 onTap: () => Navigator.of(context).pushNamed(
  //                                     ProductDetailsPage.path,
  //                                     arguments: data[i]['catalog_id']),
  //                                 child: ShopGridCardTwo(
  //                                   image: data[i]['image'],
  //                                   price: "${data[i]['price']}",
  //                                   title: data[i]['name'],
  //                                 ),
  //                               );
  //                             },
  //                             itemCount: data.length,
  //                           ).size(height: 201).margin(top: 24, bottom: 54);
  //                         }),
  //                         // ShopGridCard(image: image, title: title, price: price)
  //                         BusinessAdSlide().marginY(16).color(
  //                               Color(0xFFF4F3F8),
  //                             ),
  //                         space(height: 12),
  //                       ],
  //                     ),
  //                   ),
  //   );
  // }

  Widget buildTopics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "News Topics:",
          style: generateStyles(
            type: StylesEnum.POPPINS,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F0F2D),
          ),
        ).paddingX(19).padding(
              bottom: 24,
            ),
        // GetBuilder<NewsController>(
        //   builder: (_controller) => SingleChildScrollView(
        //     scrollDirection: Axis.horizontal,
        //     child: Row(
        //       children: [
        //         ..._controller.tags.map((e) {
        //           return Container(
        //             margin: EdgeInsets.only(right: 8),
        //             decoration: BoxDecoration(
        //               borderRadius: BorderRadius.circular(24),
        //               border: Border.all(
        //                 color: Color(0xFFD5D5D5),
        //               ),
        //             ),
        //             child: Row(
        //               children: [
        //                 Container(width: 24, height: 24),
        //                 space(width: 8),
        //                 Text(
        //                   "$e".capitalizeFirst!,
        //                   style: generateStyles(
        //                     type: StylesEnum.POPPINS,
        //                     fontSize: 16,
        //                     color: Color(0xFF0F0F2D),
        //                   ),
        //                 ),
        //               ],
        //             ).paddingX(12).paddingY(8),
        //           );
        //         })
        //       ],
        //     ).padding(
        //       left: 18,
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget buildNewsItems(List<dynamic> posts) {
    return ListView.builder(
      controller: newsScrollController,
      itemBuilder: (context, i) {
        return Text("data");
        //PostResponse item = posts[i];
        // return GestureDetector(
        //   onTap: () {
        //   //  showDetails(context, item.postId!);
        //   },
        //   child: Stack(
        //     children: [
        //       Container(
        //         clipBehavior: Clip.antiAlias,
        //         decoration: BoxDecoration(
        //           color: Colors.white,
        //           borderRadius: BorderRadius.circular(10),
        //           boxShadow: [
        //             BoxShadow(
        //                 color: Color(0x1A0F0F2D),
        //                 offset: Offset(0, 3),
        //                 blurRadius: 4),
        //           ],
        //         ),
        //         child: Row(
        //           children: [
        //             if (item.images!.length > 0) ...{
        //               Container(s
        //                 clipBehavior: Clip.antiAlias,
        //                 decoration: BoxDecoration(
        //                   color: Colors.white,
        //                   borderRadius: BorderRadius.circular(10),
        //                 ),
        //                 child: CachedNetworkImage(
        //                   imageUrl: item.images?[0] ?? "",
        //                   fit: BoxFit.fill,
        //                 ).size(height: 97, width: 146),
        //               )
        //             } else ...{
        //               if (item.videos!.length > 0) ...{
        //                 FutureBuilder<File?>(
        //                   future: getImageFromPath(item.videos![0]['src']),
        //                   builder: (context, snapshot) {
        //                     if (snapshot.hasData) {
        //                       return Container(
        //                         width: 148,
        //                         height: 98,
        //                         decoration: BoxDecoration(
        //                             color: Colors.orange.withOpacity(0.1),
        //                             borderRadius: BorderRadius.circular(10),
        //                             image: DecorationImage(
        //                               image: FileImage(snapshot.data!),
        //                               fit: BoxFit.fill,
        //                             )),
        //                       );
        //                     }
        //                     if (snapshot.hasError) {
        //                       return Container(
        //                         width: 148,
        //                         height: 98,
        //                         decoration: BoxDecoration(
        //                           color: Colors.orange.withOpacity(0.1),
        //                           borderRadius: BorderRadius.circular(10),
        //                         ),
        //                       );
        //                     }
        //                     return Container(
        //                       width: 148,
        //                       height: 98,
        //                       decoration: BoxDecoration(
        //                         color: Colors.orange.withOpacity(0.1),
        //                         borderRadius: BorderRadius.circular(10),
        //                       ),
        //                     );
        //                   },
        //                 ),
        //               } else ...{
        //                 Container(
        //                   width: 148,
        //                   height: 98,
        //                   decoration: BoxDecoration(
        //                     color: Colors.orange.withOpacity(0.1),
        //                     borderRadius: BorderRadius.circular(10),
        //                   ),
        //                 )
        //               },
        //             },
        //             space(width: 12),
        //             Expanded(
        //               child: Column(
        //                 children: [
        //                   space(height: 12),
        //                   Text(
        //                     "${item.headline}",
        //                     style: generateStyles(
        //                       type: StylesEnum.POPPINS,
        //                       fontSize: 13,
        //                       fontWeight: FontWeight.w600,
        //                       color: Color(0xFF0F0F2D),
        //                     ),
        //                     maxLines: 2,
        //                     overflow: TextOverflow.ellipsis,
        //                   ),
        //                   space(height: 8),
        //                   Text(
        //                     item.story!.isNotEmpty
        //                         ? removeHtml(item.story!)
        //                         : "",
        //                     style: generateStyles(
        //                       type: StylesEnum.LATO,
        //                       fontSize: 12,
        //                       fontWeight: FontWeight.w600,
        //                       color: Color(0xFF0F0F2D),
        //                     ),
        //                     maxLines: 2,
        //                     overflow: TextOverflow.ellipsis,
        //                   )
        //                 ],
        //               ),
        //             ),
        //             space(width: 15),
        //           ],
        //         ),
        //       )
        //           .size(height: 97, width: double.infinity)
        //           .paddingX(18)
        //           .padding(bottom: 24),
        //       Positioned(
        //         top: 0,
        //         left: 18,
        //         child: Container(
        //           padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        //           decoration: BoxDecoration(
        //             color: Colors.black,
        //             borderRadius: BorderRadius.only(
        //               topLeft: Radius.circular(10),
        //               bottomRight: Radius.circular(20),
        //             ),
        //           ),
        //           child: Text(
        //             "${item.createdDate}",
        //             style: generateStyles(
        //               type: StylesEnum.POPPINS,
        //               fontSize: 12,
        //               fontWeight: FontWeight.w500,
        //               color: Colors.white,
        //             ),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // );
      },
      itemCount: posts.length,
    );
  }
}

// class BaseNewsTwo extends StatelessWidget {
//   final String title;
//   final List<Post> posts;
//   final int categoryId;
//   const BaseNewsTwo({
//     Key? key,
//     required this.title,
//     required this.posts,
//     required this.categoryId,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             space(width: 19),
//             Expanded(
//               child: Text(
//                 "$title",
//                 style: GoogleFonts.poppins(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w700,
//                   color: Color(0xFF232629),
//                 ),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 Navigator.of(context).pushNamed(NewsCategoryPage.path,
//                     arguments: {"title": "$title", "id": categoryId});
//               },
//               child: Icon(
//                 Icons.arrow_forward,
//                 color: Color(0xFF3E7EFF),
//                 size: 22,
//               ),
//             ),
//             space(width: 19),
//           ],
//         ),
//         space(height: 12),
//         Container(
//           height: 203,
//           child: ListView.builder(
//             shrinkWrap: true,
//             scrollDirection: Axis.horizontal,
//             padding: EdgeInsets.only(left: 18, bottom: 4),
//             itemBuilder: (context, index) => GestureDetector(
//               onTap: () {
//                 showDetails(context, posts[index].postId!);
//               },
//               child: buildCardList(
//                 image: posts[index].image!,
//                 headline: posts[index].headline ?? "",
//                 time: posts[index].postCreatedDate ?? "",
//                 video: posts[index].video ?? "",
//               ),
//             ),
//             itemCount: posts.length,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget buildCardList(
//       {required String image,
//       required String time,
//       required String headline,
//       required String video}) {
//     return Container(
//       margin: EdgeInsets.only(right: 18),
//       child: Stack(
//         children: [
//           Container(
//             width: 148,
//             height: 230,
//             clipBehavior: Clip.antiAlias,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: [
//                 BoxShadow(
//                     color: Color(0xFF0F0F2D1A),
//                     offset: Offset(0, 3),
//                     blurRadius: 4),
//               ],
//               color: Colors.white,
//             ),
//             child: Column(
//               children: [
//                 if (video.isNotEmpty) ...{
//                   FutureBuilder<File?>(
//                     future: getImageFromPath(video),
//                     builder: (context, snapshot) {
//                       if (snapshot.hasData) {
//                         return Container(
//                           width: 148,
//                           height: 98,
//                           decoration: BoxDecoration(
//                               color: Colors.orange.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(10),
//                               image: DecorationImage(
//                                 image: FileImage(snapshot.data!),
//                                 fit: BoxFit.fill,
//                               )),
//                         );
//                       }
//                       if (snapshot.hasError) {
//                         return Container(
//                           width: 148,
//                           height: 98,
//                           decoration: BoxDecoration(
//                             color: Colors.orange.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         );
//                       }
//                       return Container(
//                         width: 148,
//                         height: 98,
//                         decoration: BoxDecoration(
//                           color: Colors.orange.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       );
//                     },
//                   )
//                 } else if (image.isNotEmpty) ...{
//                   Container(
//                     width: 148,
//                     height: 98,
//                     decoration: BoxDecoration(
//                         color: Colors.orange.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(10),
//                         image: DecorationImage(
//                           image: CachedNetworkImageProvider(image),
//                           fit: BoxFit.fill,
//                         )),
//                   ),
//                 },
//                 space(height: 22),
//                 Container(
//                   margin: EdgeInsets.symmetric(horizontal: 8),
//                   child: Text(
//                     "$headline",
//                     maxLines: 4,
//                     style: GoogleFonts.poppins(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF333333),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             top: 85,
//             left: 0,
//             child: Container(
//               height: 21,
//               padding: EdgeInsets.symmetric(horizontal: 8),
//               decoration: BoxDecoration(
//                 color: Color(0xFF0F0F2D),
//                 borderRadius: BorderRadius.only(
//                   topRight: Radius.circular(10.5),
//                   bottomRight: Radius.circular(10.5),
//                 ),
//               ),
//               child: Center(
//                 child: Text(
//                   "$time",
//                   // textScaleFactor: 0.7,
//                   textAlign: TextAlign.center,
//                   style: GoogleFonts.poppins(
//                     fontWeight: FontWeight.w500,
//                     fontSize: 12,
//                     color: Color(0xFFF4F3F8),
//                   ),
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

class BizCategoryCardSearch extends StatelessWidget {
  final String image;
  final String name;
  final String tags;
  final String ownername;
  final int id;
  BizCategoryCardSearch({
    required this.image,
    required this.name,
    required this.tags,
    required this.ownername,
    required this.id,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 19, vertical: 8),
      child: Container(
        height: 90,
        width: double.infinity,
        padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
        decoration: BoxDecoration(
          color: Color(0xFFF4F3F8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              height: 74,
              width: 74,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                    image: CachedNetworkImageProvider(image), fit: BoxFit.fill),
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 4, bottom: 11),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: generateStyles(
                              type: StylesEnum.LATO,
                              fontSize: 14,
                              color: Color(0xFF0F0F2D),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "$tags",
                            maxLines: 1,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: generateStyles(
                              type: StylesEnum.LATO,
                              fontSize: 12,
                              color: Color(0xFF43B978),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Text(
                        "by $ownername",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: generateStyles(
                          type: StylesEnum.LATO,
                          fontSize: 12,
                          color: Color(0xFF0F0F2D),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CategoryCardSearch extends StatelessWidget {
  final String image;
  final String name;
  final String by;
  final int id;
  final String price;
  CategoryCardSearch({
    required this.image,
    required this.name,
    required this.by,
    required this.price,
    required this.id,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 19, vertical: 24),
      child: PhysicalModel(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        elevation: 10,
        shadowColor: Color(0XFF3B4A7424),
        child: Container(
          height: 122,
          width: double.infinity,
          padding: EdgeInsets.only(left: 4, right: 8, top: 4, bottom: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                height: 114,
                width: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(image),
                      fit: BoxFit.fill),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 4, bottom: 11),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style:
                                  ThreeKmTextConstants.tk14PXPoppinsBlackBold,
                            ),
                            Text(
                              "By $by",
                              maxLines: 1,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: ThreeKmTextConstants.tk14PXLatoGreyRegular
                                  .copyWith(
                                color: Color(0XFF979EA4),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "₹$price",
                              style: ThreeKmTextConstants.tk18PXLatoBlackMedium
                                  .copyWith(color: ThreeKmTextConstants.blue1),
                            ),
                            // Container(
                            //   height: 32,
                            //   width: 32,
                            //   decoration: BoxDecoration(
                            //     shape: BoxShape.circle,
                            //     color: Color(0XFFF4F6F9),
                            //   ),
                            // child: GetBuilder<SearchController>(
                            //   builder: (_controller) => Center(
                            //     child: GestureDetector(
                            //       onTap: () => _controller.addToWishList(id),
                            //       child: Icon(
                            //         _controller.wishlists
                            //                     .where((e) =>
                            //                         e.type == "product")
                            //                     .where((e) => e.id == id)
                            //                     .length >
                            //                 0
                            //             ? CupertinoIcons.heart_fill
                            //             : CupertinoIcons.heart,
                            //         color: Color(0xFFFF5858),
                            //       ),
                            //     ),
                            //   ),
                            //),
                            //)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
