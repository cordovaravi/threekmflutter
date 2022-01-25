import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:threekm/Models/shopModel/restaurants_menu_model.dart';
import 'package:threekm/utils/screen_util.dart';

class RestaurantDetails extends StatefulWidget {
  const RestaurantDetails({Key? key, this.result, this.tags}) : super(key: key);
  final Result? result;
  final List<String>? tags;

  @override
  State<RestaurantDetails> createState() => _RestaurantDetailsState();
}

class _RestaurantDetailsState extends State<RestaurantDetails>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: color),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.only(left: 10),
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: const Icon(Icons.arrow_back_rounded, color: Colors.black87),
          ),
        ),
        actions: [
          Container(
            decoration: const BoxDecoration(
                color: Colors.black45, shape: BoxShape.circle),
            child: IconButton(
                icon: const Icon(
                  Icons.share_outlined,
                  size: 20,
                  color: Colors.white,
                ),
                onPressed: () {}),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 5),
            decoration: const BoxDecoration(
                color: Colors.black45, shape: BoxShape.circle),
            child: IconButton(
                icon: const Icon(
                  Icons.shopping_cart_rounded,
                  size: 20,
                  color: Colors.white,
                ),
                onPressed: () {}),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
              width: ThreeKmScreenUtil.screenWidthDp,
              height: ThreeKmScreenUtil.screenWidthDp / 1.1,
              child: widget.result?.creator.cover != null
                  ?
                  // Image(
                  //     image: NetworkImage('${widget.result?.creator.cover}'),
                  //     fit: BoxFit.fill,
                  //     width: ThreeKmScreenUtil.screenWidthDp / 1.1888,
                  //     height: ThreeKmScreenUtil.screenHeightDp / 4.7,
                  //   )
                  CachedNetworkImage(
                      imageUrl: '${widget.result?.creator.cover}',
                      width: ThreeKmScreenUtil.screenWidthDp / 1.1888,
                      height: ThreeKmScreenUtil.screenHeightDp / 5,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => Transform.scale(
                        scale: 0.5,
                        child: CircularProgressIndicator(
                          color: Colors.grey[400],
                        ),
                      ),
                    )
                  : Image.asset(
                      'assets/shopImg/noImage.jpg',
                      fit: BoxFit.fill,
                      alignment: Alignment.topCenter,
                    )),
          Container(
            height: ThreeKmScreenUtil.screenHeightDp,
            alignment: Alignment.bottomCenter,
            child: Container(
              width: ThreeKmScreenUtil.screenWidthDp,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.grey[300]!, blurRadius: 5)
                  ],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              height: ThreeKmScreenUtil.screenHeightDp / 1.6,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      //color: Colors.white,
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: [
                          // ClipRRect(
                          //   borderRadius: BorderRadius.circular(70),
                          //   child: Image(
                          //     image: NetworkImage(
                          //         '${widget.result?.creator.logo}'),
                          //     width: 80,
                          //     height: 80,
                          //   ),
                          // ),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(70),
                              child: CachedNetworkImage(
                                imageUrl: '${widget.result?.creator.logo}',
                                width: 80,
                                height: 80,
                                fit: BoxFit.fill,
                                placeholder: (context, url) => Transform.scale(
                                  scale: 0.5,
                                  child: CircularProgressIndicator(
                                    color: Colors.grey[400],
                                  ),
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: ThreeKmScreenUtil.screenWidthDp / 1.8,
                                  child: Text(
                                    '${widget.result?.creator.businessName}',
                                    style: const TextStyle(
                                        fontSize: 25, height: 1.2),
                                  ),
                                ),
                                Text(
                                    '${widget.result?.creator.address.serviceArea},${widget.result?.creator.city}')
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(left: 10),
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.tags?.length,
                          itemBuilder: (context, i) {
                            return Container(
                              height: 35,
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, top: 5, bottom: 5),
                              margin: const EdgeInsets.only(
                                  top: 7, bottom: 7, right: 7),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFF555C64)),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(
                                '${widget.tags?[i]}',
                                style: const TextStyle(
                                    fontSize: 17, color: Color(0xFF555C64)),
                              ),
                            );
                          }),
                    ),
                    Container(
                        padding: EdgeInsets.all(10),
                        width: ThreeKmScreenUtil.screenWidthDp / 2,
                        child: Text('About')
                        //  TabBar(
                        //   unselectedLabelColor: Colors.grey,
                        //   labelColor: Colors.black,
                        //   indicatorColor: Colors.black,
                        //   padding: EdgeInsets.zero,
                        //   labelPadding: EdgeInsets.zero,
                        //   tabs: const [
                        //     Tab(
                        //       child: Text(
                        //         'About',
                        //       ),
                        //     ),
                        //     // Tab(
                        //     //   text: 'Shop',
                        //     // ),
                        //     // Tab(
                        //     //   text: 'Gallery',
                        //     // ),
                        //   ],
                        //   controller: _tabController,
                        //   indicatorSize: TabBarIndicatorSize.tab,
                        // ),
                        ),
                    SizedBox(
                      height: ThreeKmScreenUtil.screenHeightDp / 2,
                      child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.deepPurple[400],
                                          shape: BoxShape.circle),
                                      child: const Icon(
                                        Icons.accessibility_new_outlined,
                                        color: Colors.white,
                                      )),
                                  Text(
                                    '${widget.result?.creator.firstname} ${widget.result?.creator.lastname}',
                                    style: const TextStyle(
                                        fontSize: 18, color: Color(0xFF555C64)),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                          color: Color(0xFFFBA924),
                                          shape: BoxShape.circle),
                                      child: const Icon(
                                        Icons.phone,
                                        color: Colors.white,
                                      )),
                                  Text(
                                    '${widget.result?.creator.phoneNo}',
                                    style: const TextStyle(
                                        fontSize: 18, color: Color(0xFF555C64)),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                          color: Color(0xFFFF5858),
                                          shape: BoxShape.circle),
                                      child: const Icon(
                                        Icons.email_rounded,
                                        color: Colors.white,
                                      )),
                                  Text(
                                    '${widget.result?.creator.email}',
                                    style: const TextStyle(
                                        fontSize: 18, color: Color(0xFF555C64)),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                          color: Color(0xFF3E7EFF),
                                          shape: BoxShape.circle),
                                      child: const Icon(
                                        Icons.location_on,
                                        color: Colors.white,
                                      )),
                                  SizedBox(
                                    width:
                                        ThreeKmScreenUtil.screenWidthDp / 1.37,
                                    child: Text(
                                      '${widget.result?.creator.address.area}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: Color(0xFF555C64)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
