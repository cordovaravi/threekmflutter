import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NewsListLoading extends StatelessWidget {
  const NewsListLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(children: [
                        Shimmer.fromColors(
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                          ),
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          enabled: true,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 7),
                          child: Shimmer.fromColors(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            enabled: true,
                          ),
                        )
                      ]),
                    ),
                    Shimmer.fromColors(
                      child: Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        width: MediaQuery.of(context).size.width,
                        height: 224,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      enabled: true,
                    )
                  ],
                ),
              )),
        ),
      ],
    );
  }
}
