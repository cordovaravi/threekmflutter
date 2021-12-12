import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:threekm/Models/home1_model.dart';

class NewsSecondContainer extends StatefulWidget {
  final Finalpost finalPost;

  NewsSecondContainer({required this.finalPost, Key? key}) : super(key: key);

  @override
  _NewsSecondContainerState createState() => _NewsSecondContainerState();
}

class _NewsSecondContainerState extends State<NewsSecondContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 190,
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(this
                                  .widget
                                  .finalPost
                                  .category!
                                  .icon
                                  .toString()))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(widget.finalPost.category!.name.toString()),
                  )
                ],
              ),
            ),
            Container(
              height: 150,
              width: double.infinity,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: widget.finalPost.category!.posts!.length,
                itemBuilder: (context, postIndex) {
                  final contentPost = widget.finalPost.category!.posts;
                  dynamic imgUrl = CachedNetworkImageProvider(
                    contentPost![postIndex].image.toString(),
                  );
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        height: 145,
                        width: 150,
                        child: Column(children: [
                          Container(
                            height: 100,
                            width: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                image: DecorationImage(
                                    onError: (obj, st) {
                                      setState(() {
                                        imgUrl = Icon(Icons.error);
                                      });
                                    },
                                    fit: BoxFit.cover,
                                    image: imgUrl)),
                            child: Stack(
                              children: [],
                            ),
                          ),
                          Container(
                            height: 34,
                            width: 150,
                            child: Text(
                                contentPost[postIndex].headline.toString()),
                          ),
                        ])),
                  );
                },
              ),
            )
          ],
        ));
  }
}
