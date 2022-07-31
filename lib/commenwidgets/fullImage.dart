import 'package:flutter/material.dart';

class ProfileFullImage extends StatelessWidget {
  final String src;
  final String? Imagetag;

  const ProfileFullImage({Key? key, required this.src, this.Imagetag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Container(
          child: Imagetag != null
              ? Hero(
                  tag: Imagetag.toString(),
                  child: InteractiveViewer(
                    child: Image(
                      image: NetworkImage(src),
                    ),
                  ),
                )
              : Image(
                  image: NetworkImage(src),
                ),
        ),
      ),
    );
  }
}
