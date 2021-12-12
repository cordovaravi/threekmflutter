import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:threekm/Models/PostModel.dart';

class DetailNewspage extends StatefulWidget {
  final postData;
  DetailNewspage({required this.postData, Key? key}) : super(key: key);

  @override
  _DetailNewspageState createState() => _DetailNewspageState();
}

class _DetailNewspageState extends State<DetailNewspage> {
  Posts? _post;
  @override
  void initState() {
    setState(() {
      _post = widget.postData;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: Container(
              height: 50,
              width: 50,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(FeatherIcons.arrowLeft)),
            )),
        body: Column(children: [
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20))),
            child: Row(),
          )
        ]));
  }
}
