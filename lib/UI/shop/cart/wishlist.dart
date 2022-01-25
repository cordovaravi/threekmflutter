import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:threekm/Models/shopModel/cart_hive_model.dart';
import 'package:threekm/UI/shop/cart/cart_item_list_modal.dart';
import 'package:threekm/utils/screen_util.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

class WishList extends StatefulWidget {
  const WishList({Key? key}) : super(key: key);

  @override
  State<WishList> createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  String filterLabel = 'Products';

  @override
  void initState() {
    getWishBoxData();
    super.initState();
  }

  getWishBoxData() async {
    await Hive.openBox('shopWishListBox');
  }

  @override
  void didChangeDependencies() {
    ThreeKmScreenUtil.getInstance();
    ThreeKmScreenUtil.instance.init(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    getWishBoxData();
    var wishbox = Hive.box('shopWishListBox');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Text(
            'MY WISHLIST',
          ),
          titleTextStyle: const TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          actions: [
            Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                    color: Colors.grey[200], shape: BoxShape.circle),
                child: IconButton(
                    onPressed: () {
                      viewCart(context, 'shop');
                    },
                    icon: const Icon(
                      Icons.shopping_cart_rounded,
                      size: 30,
                    )))
          ],
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/shopImg/wishlistImg.png'),
                width: 233,
                height: 181,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  'Click on the Heart Symbol on products and businesses to save them here for later.',
                  textAlign: TextAlign.center,
                  style: ThreeKmTextConstants.tk14PXPoppinsBlackSemiBold,
                ),
              ),
              FittedBox(
                child: Container(
                  width: ThreeKmScreenUtil.screenWidthDp / 1.2,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFFF4F3F8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    filterLabel = 'Products';
                                  });
                                },
                                child: Text('Products',
                                    style: ThreeKmTextConstants
                                        .tk14PXPoppinsBlackSemiBold)),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    filterLabel = 'Businesses';
                                  });
                                },
                                child: Text('Businesses',
                                    style: ThreeKmTextConstants
                                        .tk14PXPoppinsBlackSemiBold))
                          ],
                        ),
                      ),
                      AnimatedAlign(
                        alignment: filterLabel == 'Products'
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        duration: const Duration(milliseconds: 500),
                        child: Container(
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 10,
                                    offset: Offset(0, 3),
                                    color: Color(0xFF0F0F2D33))
                              ]),
                          width: 150,
                          height: 45,
                          child: Center(
                            child: Text(
                              filterLabel,
                              style: ThreeKmTextConstants
                                  .tk14PXPoppinsBlackSemiBold
                                  .copyWith(color: Color(0xFF3E7EFF)),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.69,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemCount: wishbox.length,
                  itemBuilder: (_, i) {
                    CartHiveModel data = wishbox.getAt(i);
                    return Container(
                        height: 200,
                        width: 100,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xFF32335E26),
                                  blurRadius: 10,
                                  // spreadRadius: 5,
                                  offset: Offset(0, 6))
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 1,
                              child: SizedBox(
                                height: 160.0,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  child: CachedNetworkImage(
                                    alignment: Alignment.topCenter,
                                    placeholder: (context, url) =>
                                        Transform.scale(
                                      scale: 0.5,
                                      child: CircularProgressIndicator(
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                    imageUrl: '${data.image}',
                                    // height: ThreeKmScreenUtil.screenHeightDp / 3,
                                    // width: ThreeKmScreenUtil.screenWidthDp,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, top: 5),
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${data.name}',
                                      maxLines: 2,
                                      style: ThreeKmTextConstants
                                          .tk14PXPoppinsBlackBold,
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          '₹${data.price}',
                                          style: ThreeKmTextConstants
                                              .tk14PXLatoBlackBold
                                              .copyWith(
                                                  color: Color(0xFFFC8338)),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
