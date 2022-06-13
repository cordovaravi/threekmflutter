import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

@Deprecated(
    'Use CommentsLoadingEffectsNew() instead, as comment section has been turned into a screen from bottom sheet since new design.')
class CommentsLoadingEffects extends StatelessWidget {
  const CommentsLoadingEffects({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      enabled: true,
      child: ListView.builder(
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 48.0,
                height: 48.0,
                color: Colors.white,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 8.0,
                      color: Colors.white,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    Container(
                      width: double.infinity,
                      height: 8.0,
                      color: Colors.white,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    Container(
                      width: 40.0,
                      height: 8.0,
                      color: Colors.white,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        itemCount: 6,
      ),
    ));
  }
}

class CommentsLoadingEffectsNew extends StatelessWidget {
  const CommentsLoadingEffectsNew({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      enabled: true,
      child: ListView.builder(
        itemBuilder: (_, __) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 35,
              width: 35,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: 80,
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration:
                        BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 16.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       Container(
                  //         height: 22,
                  //         width: 22,
                  //         decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                  //       ),
                  //       SizedBox(width: 10),
                  //       Container(
                  //         height: 16,
                  //         width: 50,
                  //         margin: const EdgeInsets.symmetric(vertical: 8),
                  //         decoration: BoxDecoration(shape: BoxShape.rectangle, color: Colors.white),
                  //       )
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
          ],
        ),
        itemCount: 6,
      ),
    ));
  }
}
