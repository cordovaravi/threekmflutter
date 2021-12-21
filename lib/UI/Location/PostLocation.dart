import 'package:flutter/material.dart';

class PostLocation extends StatefulWidget {
  final double lattitude;
  final double longitude;
  PostLocation({required this.lattitude, required this.longitude, Key? key})
      : super(key: key);

  @override
  _PostLocationState createState() => _PostLocationState();
}

class _PostLocationState extends State<PostLocation> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
