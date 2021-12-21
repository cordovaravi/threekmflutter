import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:threekm/utils/screen_util.dart';

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
    return Material(
      elevation: 4,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: Container(
          padding: const EdgeInsets.only(left: 3, right: 3, top: 3),
          margin: const EdgeInsets.all(3),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 190.0,
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
                    height: ThreeKmScreenUtil.screenHeightDp / 1.8,
                    width: ThreeKmScreenUtil.screenWidthDp,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 16, right: 16, top: 13),
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
            ],
          )),
    );
  }
}
