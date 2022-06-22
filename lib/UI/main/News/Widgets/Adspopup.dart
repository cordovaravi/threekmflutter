import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AdspopUp extends StatefulWidget {
  final String url;
  final String phoneNumber;
  AdspopUp({required this.phoneNumber, required this.url});
  @override
  State<StatefulWidget> createState() => AdspopUpState();
}

class AdspopUpState extends State<AdspopUp>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller!, curve: Curves.elasticInOut);

    controller!.addListener(() {
      setState(() {});
    });

    controller!.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation!,
          child: Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                if (widget.phoneNumber != "")
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: ListTile(
                      onTap: () {
                        InAppBrowser.openWithSystemBrowser(
                                url: Uri.parse("tel:${widget.phoneNumber}"))
                            .whenComplete(() => Navigator.pop(context));
                      },
                      leading: Icon(Icons.phone),
                      title: Text(widget.phoneNumber),
                    ),
                  ),
                if (widget.url != "")
                  Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: ListTile(
                        onTap: () {
                          ChromeSafariBrowser()
                              .open(url: Uri.parse(widget.url))
                              .whenComplete(() => Navigator.pop(context));
                        },
                        leading: Icon(Icons.web),
                        title: Text(widget.url),
                      ))
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
