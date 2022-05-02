import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import '../main.dart';

var size = MediaQuery.of(navigatorKey.currentContext!).size;
late BuildContext dialogContext;
void showLoading() {
  WidgetsBinding.instance?.addPostFrameCallback((_) {
    showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (context) {
          dialogContext = context;
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Lottie.asset("assets/loading.json",
                      height: 100,
                      fit: BoxFit.cover,
                      alignment: Alignment.center),
                )
              ],
            ),
          );
        });
  });
}

void hideLoading() {
  Navigator.pop(dialogContext);
  //Navigator.pop(navigatorKey.currentContext!);
}

void showMessage(String message) {
  showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => Center(
              child: AlertDialog(
            content: Material(
              color: Colors.white,
              child: Text(message),
            ),
          )));
}

Widget showLayoutLoading(mode) {
  return Scaffold(
    body: Container(
      padding: const EdgeInsets.only(top: 0, left: 14, right: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: size.width,
            height: 50,
            color: Colors.white,
            child: Row(
              children: [
                Shimmer.fromColors(
                  child: Container(
                    width: size.width / 1.2,
                    height: 20,
                    color: Colors.white,
                  ),
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  enabled: true,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Shimmer.fromColors(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  // margin: EdgeInsets.only(top: 10, right: 10),
                  width: size.width / 1.8,
                  height: 30,
                ),
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                enabled: true,
              ),
              Shimmer.fromColors(
                child: Container(
                  //margin: EdgeInsets.only(right: 10),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                ),
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                enabled: true,
              ),
              Shimmer.fromColors(
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                ),
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                enabled: true,
              ),
            ],
          ),
          Shimmer.fromColors(
            child: Container(
                margin: EdgeInsets.only(top: 10),
                width: size.width,
                height: 200,
                color: Colors.white),
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            enabled: true,
          ),
          SizedBox(
            height: mode == "shop" ? 20 : 0,
          ),
          mode == "shop"
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Shimmer.fromColors(
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                          ),
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          enabled: true,
                        ),
                        Shimmer.fromColors(
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                          ),
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          enabled: true,
                        ),
                        Shimmer.fromColors(
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                          ),
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          enabled: true,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Shimmer.fromColors(
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                          ),
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          enabled: true,
                        ),
                        Shimmer.fromColors(
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                          ),
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          enabled: true,
                        ),
                        Shimmer.fromColors(
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                          ),
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          enabled: true,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Center(
                      child: Shimmer.fromColors(
                        child: Container(
                          height: 40,
                          width: 150,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        enabled: true,
                      ),
                    )
                  ],
                )
              : Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Shimmer.fromColors(
                                  child: Container(
                                      height: 20,
                                      width: 80,
                                      color: Colors.white),
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  enabled: true,
                                ),
                                Shimmer.fromColors(
                                  child: Container(
                                      height: 20,
                                      width: 30,
                                      color: Colors.white),
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  enabled: true,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                ContainerBox(),
                                SizedBox(
                                  width: 15,
                                ),
                                ContainerBox(),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
        ],
      ),
    ),
  );
}

Widget ContainerBox() {
  return Container(
    width: 150,
    height: 200,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Shimmer.fromColors(
          child: Container(
            height: 150,
            width: 170,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
          ),
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          enabled: true,
        ),
        SizedBox(
          height: 10,
        ),
        Shimmer.fromColors(
          child: Container(height: 15, width: 100, color: Colors.white),
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          enabled: true,
        ),
        SizedBox(
          height: 10,
        ),
        Shimmer.fromColors(
          child: Container(height: 15, width: 60, color: Colors.white),
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          enabled: true,
        ),
      ],
    ),
  );
}

Widget cusinesData() {
  return Padding(
    padding: const EdgeInsets.only(top: 20),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Shimmer.fromColors(
              child: Container(
                height: 80,
                width: 80,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              ),
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              enabled: true,
            ),
            Shimmer.fromColors(
              child: Container(
                height: 80,
                width: 80,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              ),
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              enabled: true,
            ),
            Shimmer.fromColors(
              child: Container(
                height: 80,
                width: 80,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              ),
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              enabled: true,
            ),
          ],
        ),
        SizedBox(
          height: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Shimmer.fromColors(
              child: Container(
                height: 80,
                width: 80,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              ),
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              enabled: true,
            ),
            Shimmer.fromColors(
              child: Container(
                height: 80,
                width: 80,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              ),
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              enabled: true,
            ),
            Shimmer.fromColors(
              child: Container(
                height: 80,
                width: 80,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              ),
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              enabled: true,
            ),
          ],
        ),
      ],
    ),
  );
}

Widget ShowRestroLoading() {
  return Column(
    children: [
      Container(
        // padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Color(0xFFE2E4E6))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[200]!,
              highlightColor: Colors.white38,
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                height: size.height / 4,
                color: Colors.grey,
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[200]!,
              highlightColor: Colors.white38,
              child: Container(
                margin: EdgeInsets.all(18),
                height: 10,
                color: Colors.grey,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[200]!,
                  highlightColor: Colors.white38,
                  child: Container(
                      width: size.width / 1.9,
                      height: 15,
                      margin: EdgeInsets.all(18.0),
                      color: Colors.grey),
                ),
              ],
            )
          ],
        ),
      ),
    ],
  );
}
