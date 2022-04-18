import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:threekm/UI/Animation/AnimatedSizeRoute.dart';
//import 'package:threekm/widgets/reactions_assets.dart' as reactionAssets;

import 'package:threekm/Models/home1_model.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

import '../PostView.dart';

class HeighlightPost extends StatefulWidget {
  final Business business;
  HeighlightPost({required this.business, Key? key}) : super(key: key);

  @override
  _HeighlightPostState createState() => _HeighlightPostState();
}

class _HeighlightPostState extends State<HeighlightPost> {
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: AlignmentDirectional.center, children: [
      Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Color(0xff32335E26), blurRadius: 8),
                ],
                borderRadius: BorderRadius.circular(10)),
            child: Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.only(right: 10),
                          height: 50,
                          width: 50,
                          child: GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => AuthorProfile(
                              //             authorType: newsData.authorType,
                              //             // page: 1,
                              //             // authorType:
                              //             //     "user",
                              //             id: newsData.author!.id!,
                              //             avatar: newsData.author!.image!,
                              //             userName: newsData.author!.name!)));
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(widget
                                          .business.author!.image
                                          .toString()))),
                              child: widget.business.isVerified == true
                                  ? Stack(
                                      children: [
                                        Positioned(
                                            left: 0,
                                            child: Image.asset(
                                              'assets/verified.png',
                                              height: 15,
                                              width: 15,
                                              fit: BoxFit.cover,
                                            ))
                                      ],
                                    )
                                  : Container(),
                            ),
                          )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: Text(
                              widget.business.author!.name.toString(),
                              style:
                                  ThreeKmTextConstants.tk14PXPoppinsBlackBold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(widget.business.createdDate.toString())
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
                //both pics and images is present
                Container(
                  height: 254,
                  width: 254,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(widget
                              .business.videos!.first.thumbnail
                              .toString()))),
                ),

                Row(children: [
                  Padding(
                      padding: EdgeInsets.only(top: 5, left: 5, bottom: 2),
                      child: InkWell(
                        onTap: () {
                          // _showLikedBottomModalSheet(
                          //     newsData.postId!.toInt(), newsData.likes);
                        },
                        child: Row(
                          children: [
                            Text('👍 ❤️ '),
                            Container(
                              child: Center(
                                  child: Text(
                                      '+' + widget.business.likes.toString())),
                            )
                          ],
                        ),
                      )),
                  Spacer(),
                  Padding(
                      padding: EdgeInsets.only(top: 5, right: 5, bottom: 2),
                      child: Text(widget.business.views.toString() + ' Views'))
                ]),
                Text(
                  widget.business.submittedHeadline.toString(),
                  style: ThreeKmTextConstants.tk14PXLatoBlackMedium,
                  textAlign: TextAlign.center,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          AnimatedSizeRoute(
                              page: Postview(
                                  postId: widget.business.postId.toString())));
                    },
                    child: Text(
                      "Read More",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    )),
                SizedBox(
                  height: 35,
                ),
              ],
            )),
          )
        ]),
      ),
      // Positioned(
      //     bottom: 0,
      //     child: Container(
      //       height: 60,
      //       width: 230,
      //       child: ButtonBar(children: [
      //         Container(
      //           height: 60,
      //           width: 60,
      //           child: EmotionButton(
      //               isLiked: widget.business.isLiked!,
      //               initalReaction: widget.business.isLiked!
      //                   ? Reaction(
      //                       icon: Image.asset("assets/thumbs_up_red.png"))
      //                   : Reaction(icon: Image.asset("assets/thumbs-up.png")),
      //               selectedReaction: widget.business.isLiked!
      //                   ? Reaction(
      //                       icon: Image.asset("assets/thumbs_up_red.png"))
      //                   : Reaction(icon: Image.asset("assets/thumbs-up.png")),
      //               postId: widget.business.postId!.toInt(),
      //               reactions: reactionAssets.reactions),
      //           decoration: BoxDecoration(
      //               color: Colors.white,
      //               shape: BoxShape.circle,
      //               boxShadow: [
      //                 BoxShadow(
      //                   color: Colors.black26,
      //                   blurRadius: 8,
      //                 )
      //               ]),
      //         ),
      //         Container(
      //           height: 60,
      //           width: 60,
      //           child: IconButton(
      //               onPressed: () async {
      //                 if (await getAuthStatus()) {
      //                   // _showCommentsBottomModalSheet(
      //                   //     context, newsData.postId!.toInt());
      //                 } else {
      //                   NaviagateToLogin(context);
      //                 }
      //               },
      //               icon: Image.asset('assets/icons-topic.png',
      //                   fit: BoxFit.cover)),
      //           decoration: BoxDecoration(
      //               color: Colors.white,
      //               shape: BoxShape.circle,
      //               boxShadow: [
      //                 BoxShadow(
      //                   color: Colors.black26,
      //                   blurRadius: 8,
      //                 )
      //               ]),
      //         ),
      //         Container(
      //           height: 60,
      //           width: 60,
      //           child: IconButton(
      //               onPressed: () async {
      //                 // showLoading();
      //                 String imgUrl = widget.business.images != null &&
      //                         widget.business.images!.length > 0
      //                     ? widget.business.images!.first.toString()
      //                     : widget.business.videos!.first.thumbnail.toString();
      //                 // handleShare(
      //                 //     newsData.author!.name.toString(),
      //                 //     newsData.author!.image.toString(),
      //                 //     newsData.submittedHeadline.toString(),
      //                 //     imgUrl,
      //                 //     newsData.createdDate,
      //                 //     newsData.postId.toString());
      //               },
      //               icon: Center(
      //                 child: Image.asset('assets/icons-share.png',
      //                     fit: BoxFit.contain),
      //               )),
      //           decoration: BoxDecoration(
      //               color: Colors.white,
      //               shape: BoxShape.circle,
      //               boxShadow: [
      //                 BoxShadow(
      //                   color: Colors.black26,
      //                   blurRadius: 8,
      //                 )
      //               ]),
      //         ),
      //       ]),
      //     )),
    ]);
  }
}
