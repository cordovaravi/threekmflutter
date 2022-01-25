import 'dart:math';

import 'package:flutter/material.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

Future CheckoutSuccess(BuildContext? context, mode, projectId) async {
  return await showModalBottomSheet(
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 700,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: ClipPath(
                  clipper: MyCustomShape(),
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 3,
                    color: Colors.green,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Center(
                          child: Image(
                            image: AssetImage('assets/shopImg/check_back.png'),
                            height: 290,
                            width: 290,
                          ),
                        ),
                        Center(
                          child: Image(
                            image: AssetImage('assets/shopImg/check_front.png'),
                            height: 60,
                            width: 60,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            'Thank You for your order!',
                            style: ThreeKmTextConstants.tk16PXPoppinsWhiteBold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Text('Confirming With Sellers:'),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: 1,
                  itemBuilder: (_, i) {
                    return Container(
                      height: 60,
                      width: double.infinity,
                      child: Text(''),
                    );
                  })
            ],
          ),
        );
      },
      context: context!);
}

class MyCustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path()
      ..relativeLineTo(0, 210)
      ..quadraticBezierTo(size.width / 2, 310.0, size.width, 210)
      ..relativeLineTo(0, -210)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    //throw UnimplementedError();
    return false;
  }
}
