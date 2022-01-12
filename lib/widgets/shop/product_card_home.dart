import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:threekm_test/utils/screen_util.dart';

class BuildCard extends StatelessWidget {
  const BuildCard({
    Key? key,
    required this.cardImage,
    required this.context,
    required this.heading,
    required this.subHeading,
  }) : super(key: key);

  final String cardImage;
  final Text heading;
  final Text subHeading;
  final BuildContext context;

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
            Flexible(
              flex: 1,
              child: SizedBox(
                height: 160.0,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: CachedNetworkImage(
                    alignment: Alignment.topCenter,
                    placeholder: (context, url) => Transform.scale(
                      scale: 0.5,
                      child: CircularProgressIndicator(
                        color: Colors.grey[400],
                      ),
                    ),
                    imageUrl: cardImage,
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
