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
    List<String> imgdemo = [
      "https://bakdocdn.sgp1.cdn.digitaloceanspaces.com/general/0/c4952010-db65-11ec-821e-ef41c94e4686.png",
      "https://bakdocdn.sgp1.cdn.digitaloceanspaces.com/general/0/58f16770-dbd7-11ec-a853-c917454e9eb7.png",
      // "https://bakdocdn.sgp1.cdn.digitaloceanspaces.com/general/0/380a31f0-dc1c-11ec-9195-41f59e28f45a.png",
      // "https://bakdocdn.sgp1.cdn.digitaloceanspaces.com/general/0/d823d190-dc3b-11ec-a9e8-e913160274aa.png",
      // "https://bakdocdn.sgp1.cdn.digitaloceanspaces.com/post/0/8507d400-dc06-11ec-ad63-0f73ee49e705.png",
      // "https://bakdocdn.sgp1.cdn.digitaloceanspaces.com/post/0/84f0a280-dc06-11ec-83fd-f96bffb79d4e.png",
      // "https://bakdocdn.sgp1.cdn.digitaloceanspaces.com/post/0/82dc1a60-dc06-11ec-8ad6-1f2866c84187.png"
    ];
    List imagesList = [...images, ...video];

    if (imagesList.length > 5) {
      return Container(
          constraints: BoxConstraints(
            minHeight: 20,
            maxHeight: 250,
            maxWidth: size(context).width,
            minWidth: 20,
          ),
          // height: 250,
          // width: size(context).width,
          child: LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                SizedBox(
                  height: constraints.maxHeight / 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Stack(
                      //   children: [

                      //     CachedNetworkImage(
                      //       imageUrl: imagesList[0] is String
                      //           ? images[0]
                      //           : imagesList[0].thumbnail,
                      //     ),
                      //     if (imagesList[0] is! String)
                      //       SvgPicture.asset(
                      //         "assets/playicon.svg",
                      //       ),
                      //   ],
                      // ),
                      ImageWidget(
                        imagesList: imagesList[0],
                        //height: constraints.maxHeight/2,
                        width: constraints.maxWidth / 2.02,
                        fit: BoxFit.cover,
                      ),
                      // CachedNetworkImage(
                      //   imageUrl: images[1],
                      //   width: constraints.maxWidth / 2.009,
                      // )
                      ImageWidget(
                        imagesList: imagesList[1],
                        // height: constraints.maxHeight/2,
                        width: constraints.maxWidth / 2.009,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  height: constraints.maxHeight / 2.04,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Image(
                      //   image: NetworkImage(images[2]),
                      //   width: constraints.maxWidth / 3.03,
                      //   height: constraints.maxHeight / 2,
                      //   fit: BoxFit.cover,
                      // ),
                      ImageWidget(
                        imagesList: imagesList[2],
                        height: constraints.maxHeight / 2,
                        width: constraints.maxWidth / 3.03,
                        fit: BoxFit.cover,
                      ),
                      // Image(
                      //   image: NetworkImage(images[3]),
                      //   width: constraints.maxWidth / 3.03,
                      //   height: constraints.maxHeight / 2,
                      //   fit: BoxFit.cover,
                      // ),
                      ImageWidget(
                        imagesList: imagesList[3],
                        height: constraints.maxHeight / 2,
                        width: constraints.maxWidth / 3.03,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        width: constraints.maxWidth / 3.03,
                        height: constraints.maxHeight / 2,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(imagesList[4] is String
                                ? imagesList[4]
                                : imagesList[4].thumbnail),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.5),
                                BlendMode.darken),
                          ),
                        ),
                        child: Text(
                          "+${imagesList.length - 4}",
                          style: ThreeKmTextConstants.tk16PXPoppinsWhiteBold,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          }));
    } else if (imagesList.length == 4) {
      return SizedBox(
        height: 250,
        width: size(context).width,
        child: LayoutBuilder(builder: (_, constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // CachedNetworkImage(
              //   imageUrl: images[0],
              //   width: constraints.maxWidth / 2.017,
              //   height: constraints.maxHeight,
              //   fit: BoxFit.cover,
              // ),
              ImageWidget(
                imagesList: imagesList[0],
                height: constraints.maxHeight,
                width: constraints.maxWidth / 2.017,
                fit: BoxFit.cover,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // CachedNetworkImage(
                  //   imageUrl: images[1],
                  //   width: constraints.maxWidth / 2.017,
                  //   height: constraints.maxHeight / 3.03,
                  //   fit: BoxFit.cover,
                  // ),
                  ImageWidget(
                    imagesList: imagesList[1],
                    height: constraints.maxHeight / 3.1,
                    width: constraints.maxWidth / 2.017,
                    fit: BoxFit.cover,
                  ),
                  // CachedNetworkImage(
                  //   imageUrl: images[2],
                  //   width: constraints.maxWidth / 2.017,
                  //   height: constraints.maxHeight / 3.03,
                  //   fit: BoxFit.cover,
                  // ),
                  ImageWidget(
                    imagesList: imagesList[2],
                    height: constraints.maxHeight / 3.05,
                    width: constraints.maxWidth / 2.017,
                    fit: BoxFit.cover,
                  ),
                  // CachedNetworkImage(
                  //   imageUrl: images[3],
                  //   width: constraints.maxWidth / 2.017,
                  //   height: constraints.maxHeight / 3.03,
                  //   fit: BoxFit.cover,
                  // ),
                  ImageWidget(
                    imagesList: imagesList[3],
                    height: constraints.maxHeight / 3.05,
                    width: constraints.maxWidth / 2.017,
                    fit: BoxFit.cover,
                  ),
                ],
              )
            ],
          );
        }),
      );
    } else if (imagesList.length == 3) {
      return SizedBox(
        height: 250,
        width: size(context).width,
        child: LayoutBuilder(builder: (_, constraints) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ImageWidget(
                imagesList: imagesList[0],
                height: constraints.maxHeight,
                width: constraints.maxWidth / 2.017,
                fit: BoxFit.cover,
              ),
              // Stack(
              //   children: [
              //     CachedNetworkImage(
              //       imageUrl: imagesList[0] is String
              //           ? images[0]
              //           : imagesList[0].thumbnail,
              //       width: constraints.maxWidth / 2.017,
              //       height: constraints.maxHeight,
              //       fit: BoxFit.cover,
              //     ),
              //     if (imagesList[0] is! String)
              //       SvgPicture.asset(
              //         "assets/playicon.svg",
              //       ),
              //   ],
              // ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ImageWidget(
                    imagesList: imagesList[1],
                    height: constraints.maxHeight / 2.03,
                    width: constraints.maxWidth / 2.017,
                    fit: BoxFit.cover,
                  ),
                  // Stack(
                  //   children: [
                  //     CachedNetworkImage(
                  //       imageUrl: imagesList[1] is String
                  //           ? images[1]
                  //           : imagesList[1].thumbnail,
                  //       width: constraints.maxWidth / 2.017,
                  //       height: constraints.maxHeight / 2.03,
                  //       fit: BoxFit.cover,
                  //     ),
                  //     if (imagesList[1] is! String)
                  //       SvgPicture.asset(
                  //         "assets/playicon.svg",
                  //       ),
                  //   ],
                  // ),
                  ImageWidget(
                    imagesList: imagesList[2],
                    height: constraints.maxHeight / 2.03,
                    width: constraints.maxWidth / 2.017,
                    fit: BoxFit.cover,
                  )
                  // Stack(
                  //   children: [
                  //     CachedNetworkImage(
                  //       imageUrl: imagesList[2] is String
                  //           ? images[2]
                  //           : imagesList[2].thumbnail,
                  //       width: constraints.maxWidth / 2.017,
                  //       height: constraints.maxHeight / 2.03,
                  //       fit: BoxFit.cover,
                  //     ),
                  //     if (imagesList[2] is! String)
                  //       SvgPicture.asset(
                  //         "assets/playicon.svg",
                  //       ),
                  //   ],
                  // ),
                ],
              )
            ],
          );
        }),
      );
    } else if (imagesList.length == 2) {
      return SizedBox(
        height: 250,
        width: size(context).width,
        child: LayoutBuilder(builder: (_, constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ImageWidget(
                imagesList: imagesList[0],
                height: constraints.maxHeight,
                width: constraints.maxWidth / 2.017,
                fit: BoxFit.cover,
              ),
              // CachedNetworkImage(
              //   imageUrl: imagesList[0] is String
              //       ? images[0]
              //       : imagesList[0].thumbnail,
              //   width: constraints.maxWidth / 2.017,
              //   height: constraints.maxHeight,
              //   fit: BoxFit.cover,
              // ),
              // Stack(
              //   fit: StackFit.expand,
              //   children: [
              //     CachedNetworkImage(
              //       imageUrl: imagesList[1] is String
              //           ? images[1]
              //           : imagesList[1].thumbnail,
              //       width: constraints.maxWidth / 2.017,
              //       height: constraints.maxHeight,
              //       fit: BoxFit.cover,
              //     ),
              //     if (imagesList[1] is! String)
              //       Center(
              //         child: SvgPicture.asset(
              //           "assets/playicon.svg",
              //         ),
              //       )
              //   ],
              // )
              ImageWidget(
                imagesList: imagesList[1],
                height: constraints.maxHeight,
                width: constraints.maxWidth / 2.017,
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
            return ImageWidget(
              imagesList: imagesList[0],
              fit: BoxFit.fitWidth,
            );
          },
        ),
      );
    } else {
      return Container();
    }
  }
}

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    Key? key,
    required this.imagesList,
    this.width,
    this.height,
    this.fit,
  }) : super(key: key);

  final imagesList;
  final width;
  final height;
  final fit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        // alignment: Alignment.center,
        children: [
          CachedNetworkImage(
            imageUrl: imagesList is String ? imagesList : imagesList.thumbnail,
            width: width,
            height: height,
            fit: fit,
          ),
          imagesList is String == false
              ? Center(
                  child: SvgPicture.asset(
                    "assets/playicon.svg",
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
