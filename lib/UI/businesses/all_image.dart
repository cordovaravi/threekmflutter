import 'package:flutter/material.dart';
import 'package:threekm/utils/screen_util.dart';

import '../../main.dart';

// class AllImages extends StatelessWidget {
//   const AllImages({Key? key, required this.images}) : super(key: key);
//   final List<String> images;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         foregroundColor: Colors.black,
//       ),
//       body: Container(
//           height: double.infinity,
//           width: double.infinity,
//           child: PageView.builder(
//               physics: const BouncingScrollPhysics(),
//               scrollDirection: Axis.horizontal,
//               // pageSnapping: true,
//               onPageChanged: (val) {
//                 print(val);
//               },
//               itemCount: images.length,
//               itemBuilder: (context, index) {
//                 return Hero(
//                   tag: 'hero2',
//                   child: InteractiveViewer(
//                     panEnabled: false, // Set it to false
//                     boundaryMargin: const EdgeInsets.all(100),
//                     child: Image(
//                       image: NetworkImage('${images[index]}'),
//                       fit: BoxFit.contain,
//                       // width: ThreeKmScreenUtil.screenWidthDp /
//                       //     1.1888,
//                       // height: ThreeKmScreenUtil.screenHeightDp /
//                       //     4.7,
//                       errorBuilder: (context, error, stackTrace) => Container(
//                         width: 110,
//                         height: 80,
//                         color: Colors.grey[350],
//                       ),
//                       loadingBuilder: (_, widget, loadingProgress) {
//                         if (loadingProgress == null) {
//                           return widget;
//                         }
//                         return Center(
//                           child: CircularProgressIndicator(
//                             color: Color(0xFF979EA4),
//                             value: loadingProgress.expectedTotalBytes != null
//                                 ? loadingProgress.cumulativeBytesLoaded /
//                                     loadingProgress.expectedTotalBytes!
//                                 : null,
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 );
//               })),
//     );

//   }
// }

showFullImage(images) {
  WidgetsBinding.instance?.addPostFrameCallback((_) {
    showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (context) => Container(
              height: ThreeKmScreenUtil.screenHeightDp,
              child: Column(
                children: [
                  PageView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      // pageSnapping: true,
                      onPageChanged: (val) {
                        print(val);
                      },
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return Hero(
                          tag: 'hero2',
                          child: InteractiveViewer(
                            panEnabled: false, // Set it to false
                            boundaryMargin: const EdgeInsets.all(100),
                            child: Image(
                              image: NetworkImage('${images[index]}'),
                              fit: BoxFit.contain,
                              // width: ThreeKmScreenUtil.screenWidthDp /
                              //     1.1888,
                              // height: ThreeKmScreenUtil.screenHeightDp /
                              //     4.7,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
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
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: images.length,
                      itemBuilder: (_, i) => Container(
                            child: Image(image: NetworkImage('${images[i]}')),
                          ))
                ],
              ),
            ));
  });
}
