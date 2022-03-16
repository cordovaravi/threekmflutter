import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:threekm/utils/threekm_textstyles.dart';

class BuildCard extends StatelessWidget {
  const BuildCard(
      {Key? key,
      required this.cardImage,
      required this.context,
      required this.heading,
      required this.subHeading,
      this.discountType = '',
      this.discountValue = 0,
      this.hasDiscount = false})
      : super(key: key);

  final String cardImage;
  final Text heading;
  final Text subHeading;
  final BuildContext context;
  final String discountType;
  final num discountValue;
  final bool hasDiscount;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 3, right: 3, top: 3),
        margin: const EdgeInsets.all(3),
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
            SizedBox(
              height: 160.0,
              width: double.infinity,
              child: Stack(
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: CachedNetworkImage(
                        alignment: Alignment.topCenter,
                        placeholder: (context, url) => Transform.scale(
                          alignment: Alignment.center,
                          scale: 0.1,
                          child: CircularProgressIndicator(
                            color: Colors.grey[400],
                          ),
                        ),
                        imageUrl: cardImage,
                        // height: ThreeKmScreenUtil.screenHeightDp / 3,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  if (hasDiscount)
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)
                              )),
                      child: Text(
                        '${discountType == 'percentage' || discountType == "percent" ? "" : "₹"}${discountValue}${discountType == 'percentage' || discountType == "percent" ? '%' : ''} Off',
                        style: ThreeKmTextConstants.tk12PXPoppinsWhiteRegular,
                      ),
                    ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 5),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    heading,
                    Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: subHeading)
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
