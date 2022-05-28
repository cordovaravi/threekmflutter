import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';
import 'package:threekm/utils/constants.dart';

Widget Biz_Skeleton(BuildContext context) {
  return Container(
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Shimmer.fromColors(
                    child: Container(
                      width: 110,
                      height: 110,
                      color: Colors.white,
                    ),
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    enabled: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Shimmer.fromColors(
                    child: Container(
                      width: 90,
                      height: 20,
                      color: Colors.white,
                    ),
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    enabled: true,
                  ),
                ],
              ),
              Column(
                children: [
                  Shimmer.fromColors(
                    child: Container(
                      width: 110,
                      height: 110,
                      color: Colors.white,
                    ),
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    enabled: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Shimmer.fromColors(
                    child: Container(
                      width: 90,
                      height: 20,
                      color: Colors.white,
                    ),
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    enabled: true,
                  ),
                ],
              ),
              Column(
                children: [
                  Shimmer.fromColors(
                    child: Container(
                      width: 110,
                      height: 110,
                      color: Colors.white,
                    ),
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    enabled: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Shimmer.fromColors(
                    child: Container(
                      width: 90,
                      height: 20,
                      color: Colors.white,
                    ),
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    enabled: true,
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Shimmer.fromColors(
                    child: Container(
                      width: 110,
                      height: 110,
                      color: Colors.white,
                    ),
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    enabled: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Shimmer.fromColors(
                    child: Container(
                      width: 90,
                      height: 20,
                      color: Colors.white,
                    ),
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    enabled: true,
                  ),
                ],
              ),
              Column(
                children: [
                  Shimmer.fromColors(
                    child: Container(
                      width: 110,
                      height: 110,
                      color: Colors.white,
                    ),
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    enabled: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Shimmer.fromColors(
                    child: Container(
                      width: 90,
                      height: 20,
                      color: Colors.white,
                    ),
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    enabled: true,
                  ),
                ],
              ),
              Column(
                children: [
                  Shimmer.fromColors(
                    child: Container(
                      width: 110,
                      height: 110,
                      color: Colors.white,
                    ),
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    enabled: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Shimmer.fromColors(
                    child: Container(
                      width: 90,
                      height: 20,
                      color: Colors.white,
                    ),
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    enabled: true,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          width: size(context).width,
          height: 300,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (_, i) {
                return Shimmer.fromColors(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    width: size(context).width / 1.2,
                    height: 20,
                    color: Colors.white,
                  ),
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  enabled: true,
                );
              }),
        )
      ],
    ),
  );
}
