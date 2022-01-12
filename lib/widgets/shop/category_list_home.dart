import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:threekm_test/Models/shopModel/shop_home_model.dart';
import 'package:threekm_test/utils/screen_util.dart';
import 'package:threekm_test/utils/spacing_util.dart';
import 'package:threekm_test/utils/threekm_textstyles.dart';
import 'package:threekm_test/widget/shop/all_categorylist.dart';
import 'package:threekm_test/widget/shop/product_listing.dart';

import '../../constant.dart';

class CategoryListHome extends StatelessWidget {
  const CategoryListHome({Key? key, required this.category}) : super(key: key);
  final List<Trending> category;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 3),
      padding: const EdgeInsets.only(top: 20),
      color: Colors.white,
      child: Column(
        children: [
          Container(
            width: ThreeKmScreenUtil.screenWidthDp,
            height: ThreeKmScreenUtil.screenHeightDp / 2.9,
            child: GridView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: ThreeKmSpacing.spacing_32,
                    // mainAxisExtent: 80,
                    //mainAxisSpacing: 0,
                    childAspectRatio: 1.1),
                itemCount: category.length,
                itemBuilder: (context, i) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                  pageBuilder:
                                      (context, animaton, secondaryAnimation) {
                                    return ProductListing(
                                      productData: '${category[i].name}',
                                    );
                                  },
                                  transitionDuration:
                                      const Duration(milliseconds: 800),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    animation = CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeInOut);
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  }));
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                              color: Colors.grey[350], shape: BoxShape.circle
                              // borderRadius:const BorderRadius.all(Radius.circular(50))
                              ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(55),
                            child: CachedNetworkImage(
                              alignment: Alignment.topCenter,
                              placeholder: (context, url) => Transform.scale(
                                scale: 0.5,
                                child: CircularProgressIndicator(
                                  color: Colors.grey[400],
                                ),
                              ),
                              imageUrl: category[i].image,
                              height: ThreeKmScreenUtil.screenHeightDp / 1.8,
                              width: ThreeKmScreenUtil.screenWidthDp,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "${category[i].name}",
                        style: ThreeKmTextConstants.tk12PXPoppinsBlackSemiBold,
                      )
                    ],
                  );
                }),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                  child: Text(
                    "View all Categories",
                    style: ThreeKmTextConstants.tk14PXPoppinsRedSemiBold,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AllCategoryList()));
                  },
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all<double>(0),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red))))),
            ),
          )
        ],
      ),
    );
  }
}
