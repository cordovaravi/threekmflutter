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
  return Container(
    padding: const EdgeInsets.only(top: 20, left: 30, right: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          //margin: const EdgeInsets.only(top: 30, left: 30, right: 20),
          width: size.width,
          height: 50,
          color: Colors.white,
          child: Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Colors.red,
                size: 24,
              ),
              Shimmer.fromColors(
                child: Container(
                  width: size.width / 1.5,
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
          children: [
            Shimmer.fromColors(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                margin: EdgeInsets.only(top: 10, right: 10),
                width: size.width / 2,
                height: 30,
              ),
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              enabled: true,
            ),
            Shimmer.fromColors(
              child: Container(
                margin: EdgeInsets.only(right: 10),
                height: 40,
                width: 40,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              ),
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              enabled: true,
            ),
            Shimmer.fromColors(
              child: Container(
                height: 40,
                width: 40,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
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
              height: 270,
              color: Colors.white),
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          enabled: true,
        ),
        SizedBox(
          height: 20,
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
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Shimmer.fromColors(
                        child: Container(
                            height: 20, width: 80, color: Colors.white),
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        enabled: true,
                      ),
                      Shimmer.fromColors(
                        child: Container(
                            height: 20, width: 30, color: Colors.white),
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        enabled: true,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ContainerBox(),
                      ContainerBox(),
                      ContainerBox(),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ContainerBox(),
                      ContainerBox(),
                      ContainerBox(),
                    ],
                  ),
                ],
              )
      ],
    ),
  );
}

Widget ContainerBox() {
  return Container(
    // margin: EdgeInsets.only(right: 20),
    width: size.width / 4.2,
    height: 140,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Shimmer.fromColors(
          child: Container(
            height: 80,
            width: size.width / 4.2,
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
