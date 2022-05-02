import 'package:flutter/material.dart';
import 'package:threekm/utils/screen_util.dart';

class showFullImage extends StatefulWidget {
  const showFullImage({Key? key, this.images}) : super(key: key);
  final images;

  @override
  State<showFullImage> createState() => _showFullImageState();
}

class _showFullImageState extends State<showFullImage> {
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          //mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: InteractiveViewer(
                panEnabled: false, // Set it to false
                boundaryMargin: const EdgeInsets.all(100),
                child: Image(
                  image: NetworkImage('${widget.images[_index]}'),
                  fit: BoxFit.contain,
                  // width: ThreeKmScreenUtil.screenWidthDp /
                  //     1.1888,
                  // height: ThreeKmScreenUtil.screenHeightDp /
                  //     4.7,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 110,
                    height: 80,
                    color: Colors.grey[350],
                  ),
                  loadingBuilder: (_, widget, loadingProgress) {
                    if (loadingProgress == null) {
                      return widget;
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF979EA4),
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 4,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.images.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, i) => Container(
                          padding: EdgeInsets.only(right: 10),
                          child: InkWell(
                            enableFeedback: true,
                            radius: 120,
                            onTap: () {
                              setState(() {
                                _index = i;
                              });
                            },
                            child: SizedBox(
                              width: 80,
                              height: 80,
                              child: Image(
                                image: NetworkImage('${widget.images[i]}'),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
