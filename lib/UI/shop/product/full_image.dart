import 'package:flutter/material.dart';

class FullImage extends StatelessWidget {
  const FullImage({Key? key, required this.imageurl}) : super(key: key);
  final String imageurl;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InteractiveViewer(
          panEnabled: false, // Set it to false
          boundaryMargin: const EdgeInsets.all(100),
          //minScale: 0.5,
          //maxScale: 2,
          child: Hero(
            tag: 'hero1',
            child: Image(
              image: NetworkImage(imageurl),
            ),
          )),
    );
  }
}

        
        