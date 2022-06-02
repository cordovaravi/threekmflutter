import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:threekm/utils/constants.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

class ImageLayout extends StatelessWidget {
  final List<String> images;
  final List video;

  const ImageLayout({Key? key, required this.images, required this.video})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var imagesList = images;

    List imagesList = [...images, ...video];

    if (images.length > 5) {
      return SizedBox(
          height: 250,
          width: size(context).width,
          child: LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                SizedBox(
                  height: constraints.maxHeight / 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        children: [
                          // Image(
                          //   image: NetworkImage(imagesList[0] is String
                          //       ? images[0]
                          //       : imagesList[0].thumbnail),
                          //   width: constraints.maxWidth / 2.009,
                          // ),
                          CachedNetworkImage(
                            imageUrl: imagesList[0] is String
                                ? images[0]
                                : imagesList[0].thumbnail,
                          ),
                          if (imagesList[0] is! String)
                            SvgPicture.asset(
                              "assets/playicon.svg",
                            ),
                        ],
                      ),
                      // const SizedBox(
                      //   width: 2,
                      // ),
                      CachedNetworkImage(
                        imageUrl: images[1],
                        width: constraints.maxWidth / 2.009,
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  height: constraints.maxHeight / 2.04,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image(
                        image: NetworkImage(images[2]),
                        width: constraints.maxWidth / 3.03,
                        height: constraints.maxHeight / 2,
                        fit: BoxFit.cover,
                      ),
                      Image(
                        image: NetworkImage(images[3]),
                        width: constraints.maxWidth / 3.03,
                        height: constraints.maxHeight / 2,
                        fit: BoxFit.cover,
                      ),
                      // Image(
                      //   image: NetworkImage(images[4]),
                      //   width: constraints.maxWidth / 3.03,
                      //   height: constraints.maxHeight / 2,
                      //   fit: BoxFit.cover,
                      // ),
                      Container(
                        width: constraints.maxWidth / 3.03,
                        height: constraints.maxHeight / 2,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(images[4]),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.5),
                                BlendMode.darken),
                          ),
                        ),
                        child: Text(
                          "+${images.length - 4}",
                          style: ThreeKmTextConstants.tk16PXPoppinsWhiteBold,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          }));
    } else if (images.length == 4) {
      return SizedBox(
        height: 250,
        child: LayoutBuilder(builder: (_, constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CachedNetworkImage(
                imageUrl: images[0],
                width: constraints.maxWidth / 2.017,
                height: constraints.maxHeight,
                fit: BoxFit.cover,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CachedNetworkImage(
                    imageUrl: images[1],
                    width: constraints.maxWidth / 2.017,
                    height: constraints.maxHeight / 3.03,
                    fit: BoxFit.cover,
                  ),
                  CachedNetworkImage(
                    imageUrl: images[2],
                    width: constraints.maxWidth / 2.017,
                    height: constraints.maxHeight / 3.03,
                    fit: BoxFit.cover,
                  ),
                  CachedNetworkImage(
                    imageUrl: images[3],
                    width: constraints.maxWidth / 2.017,
                    height: constraints.maxHeight / 3.03,
                    fit: BoxFit.cover,
                  ),
                ],
              )
            ],
          );
        }),
      );
    } else if (images.length == 3) {
      return SizedBox(
        height: 250,
        child: LayoutBuilder(builder: (_, constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: imagesList[0] is String
                        ? images[0]
                        : imagesList[0].thumbnail,
                    width: constraints.maxWidth / 2.017,
                    height: constraints.maxHeight,
                    fit: BoxFit.cover,
                  ),
                  if (imagesList[0] is! String)
                    SvgPicture.asset(
                      "assets/playicon.svg",
                    ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: imagesList[1] is String
                            ? images[1]
                            : imagesList[1].thumbnail,
                        width: constraints.maxWidth / 2.017,
                        height: constraints.maxHeight / 2.03,
                        fit: BoxFit.cover,
                      ),
                      if (imagesList[1] is! String)
                        SvgPicture.asset(
                          "assets/playicon.svg",
                        ),
                    ],
                  ),
                  Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: imagesList[2] is String
                            ? images[2]
                            : imagesList[2].thumbnail,
                        width: constraints.maxWidth / 2.017,
                        height: constraints.maxHeight / 2.03,
                        fit: BoxFit.cover,
                      ),
                      if (imagesList[2] is! String)
                        SvgPicture.asset(
                          "assets/playicon.svg",
                        ),
                    ],
                  ),
                ],
              )
            ],
          );
        }),
      );
    } else if (images.length == 2) {
      return SizedBox(
        height: 250,
        child: LayoutBuilder(builder: (_, constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CachedNetworkImage(
                imageUrl: images[0],
                width: constraints.maxWidth / 2.017,
                height: constraints.maxHeight,
                fit: BoxFit.cover,
              ),
              CachedNetworkImage(
                imageUrl: images[1],
                width: constraints.maxWidth / 2.017,
                height: constraints.maxHeight,
                fit: BoxFit.cover,
              )
            ],
          );
        }),
      );
    } else if (imagesList.length == 1) {
      return Container(
        height: 250,
        width: size(context).width,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              fit: StackFit.expand,
              // alignment: Alignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: imagesList[0] is String
                      ? images[0]
                      : imagesList[0].thumbnail,
                  //width: constraints.maxWidth,
                  //height: constraints.maxHeight,
                  fit: BoxFit.fitWidth,
                ),
                if (imagesList[0] is! String)
                  Center(
                    child: SvgPicture.asset(
                      "assets/playicon.svg",
                    ),
                  )
              ],
            );
          },
        ),
      );
    } else {
      return Container();
    }
  }
}
