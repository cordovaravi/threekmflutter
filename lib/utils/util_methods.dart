import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

import 'intl.dart';
import 'utils.dart';

ValueNotifier<bool> shouldRefresh = ValueNotifier(true);

///
///url launcher
///print log erros
class UtilMethods {
  ///url launcher
  // void launchURL({required String url}) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     logError(" utils_methods.dart launchUrl", "$url");
  //     spToast.showErrorToast(message: "Error launching Url $url");
  //     throw 'Could not launch $url';
  //   }
  // }

//log error
  ///code can be anything best use case would be file name plus function eg login_api.dart otpsend
  static void logError(String code, String message) =>
      print('###### Error: $code\nError Message: $message');
}

var utilMethods = UtilMethods();

Color colorFromRGBAString(String color) {
  String colorsWithOutParentheses =
      color.substring(color.indexOf("(") + 1, color.lastIndexOf(")"));
  List<String> c = colorsWithOutParentheses.split(",");

  return Color.fromARGB(
      int.tryParse(c[3].trim())! * 255,
      int.tryParse(c[0].trim())!,
      int.tryParse(c[1].trim())!,
      int.tryParse(c[2].trim())!);
}

String calculateComments(int comments) {
  if (comments >= 0 && comments <= 10) {
    return "$comments";
  } else if (comments > 100 && comments < 1000) {
    int mark = (comments / 100.0).truncateToDouble().toInt();
    return "+${mark * 100}";
  } else if (comments > 1000) {
    int mark = (comments / 1000.0).truncateToDouble().toInt();
    return "+${mark}k";
  } else {
    int mark = (comments / 10.0).truncateToDouble().toInt();
    return "+${mark * 10}";
  }
}

String translatedText(
    {S? delegate, required String key, required String subKey}) {
  return delegate != null ? delegate.translate(key, subKey)! : "";
}

double degreesToRadians(double degree) {
  return degree * (pi / 180);
}

Widget space({double? width, double? height}) {
  return SizedBox(
    width: width,
    height: height,
  );
}

String removeHtml(String html) {
  RegExp regExp = RegExp(r"<[^>]*>");
  String withOutBreak = html.replaceAll("<div>", "\n");
  String withOutBreak2 = withOutBreak.replaceAll("<br", "\n<br");
  String withOutTag = withOutBreak2.replaceAll(regExp, "");
  String withOutSpace = withOutTag.replaceAll("&nbsp;", " ");
  String withoutAmpersand = withOutSpace.replaceAll("&amp;", "&");
  return withoutAmpersand;
}

// Future<bool> getLocationPermission() async {
//   try {
//     LocationPermission permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied ||
//         permission == LocationPermission.deniedForever) {
//       print(permission.toString());
//       shouldRefresh.value = true;
//       return false;
//     }
//     print(permission.toString());
//     shouldRefresh.value = true;
//     return true;
//   } on PermissionRequestInProgressException catch (e) {
//     print("PermissionRequestInProgressException: " + e.toString());
//     return false;
//   }
// }

// Widget space({double? width, double? height}) {
//   return SizedBox(
//     width: width,
//     height: height,
//   );
// }

// Future<Uint8List> getBytesFromAsset(String path, int width) async {
//   ByteData data = await rootBundle.load(path);
//   ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
//       targetWidth: width);
//   ui.FrameInfo fi = await codec.getNextFrame();
//   return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
//       .buffer
//       .asUint8List();
// }

// void loginNavigateBack(context) {
//   Navigator.popUntil(
//     context,
//     (route) =>
//         route.isFirst ||
//         route.settings.name == "comments" ||
//         route.settings.name == "details",
//   );
// }

// Future<File?> getImageFromPath(String imageURL) async {
//   var directory = await getApplicationDocumentsDirectory();
//   String controlledImageUrl = imageURL.substring(
//       imageURL.lastIndexOf("/") + 1, imageURL.lastIndexOf("."));
//   String url =
//       directory.path + "/cachedImages/3km/" + controlledImageUrl + ".png";
//   // url = url.replaceAll("//", "/");
//   var file = File(url);

//   bool fileExists = await file.exists();

//   if (fileExists) {
//     Uint8List? fileData = await file.readAsBytes();
//     int trial = 0;
//     if (fileData.length <= 0) {
//       File? files;
//       while (files == null && trial < 3) {
//         Uint8List? data = await VideoThumbnail.thumbnailData(video: imageURL);
//         File createdFile = await file.create(recursive: true);
//         print(imageURL + " _ ${data?.toString()}");
//         if (data != null) {
//           File writtenFile = await createdFile.writeAsBytes(data.toList());
//           files = writtenFile;
//         } else {
//           trial += 1;
//         }
//       }
//       return files;
//     } else {
//       return file;
//     }
//   } else {
//     Uint8List? data = await VideoThumbnail.thumbnailData(video: imageURL);
//     File createdFile = await file.create(recursive: true);
//     if (data != null) {
//       File writtenFile = await createdFile.writeAsBytes(data.toList());
//       return writtenFile;
//     } else {
//       return createdFile;
//     }
//   }
// }

// Future<void> showCart(BuildContext context) async {
//   await showDialog(
//       context: context,
//       useRootNavigator: false,
//       useSafeArea: false,
//       builder: (context) {
//         return CartPopUp();
//       });
// }

extension TapExtension on Widget {
  Widget onTap(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: this,
    );
  }

  Widget padding({double? left, double? right, double? top, double? bottom}) {
    return Padding(
      padding: EdgeInsets.only(
          left: left ?? 0,
          right: right ?? 0,
          top: top ?? 0,
          bottom: bottom ?? 0),
      child: this,
    );
  }

  Widget paddingX(double horizontal) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal),
      child: this,
    );
  }

  Widget paddingY(double vertical) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: vertical),
      child: this,
    );
  }

  Widget color(Color color) {
    return Container(
      color: color,
      child: this,
    );
  }

  Widget margin({double? left, double? right, double? top, double? bottom}) {
    return Container(
      margin: EdgeInsets.only(
          left: left ?? 0,
          right: right ?? 0,
          top: top ?? 0,
          bottom: bottom ?? 0),
      child: this,
    );
  }

  Widget circleClip({double? height, double? width}) {
    return Container(
      height: height,
      width: width,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: this,
    );
  }

  Widget size({double? height, double? width}) {
    return Container(
      height: height,
      width: width,
      child: this,
    );
  }

  Widget marginX(double horizontal) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontal),
      child: this,
    );
  }

  Widget marginY(double vertical) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: vertical),
      child: this,
    );
  }
}

enum StylesEnum { POPPINS, LATO }

TextStyle generateStyles(
    {required StylesEnum type,
    double? fontSize,
    FontWeight? fontWeight,
    Color? color}) {
  switch (type) {
    case StylesEnum.POPPINS:
      return GoogleFonts.poppins(
          fontSize: fontSize, fontWeight: fontWeight, color: color);
    case StylesEnum.LATO:
      return GoogleFonts.lato(
          fontSize: fontSize, fontWeight: fontWeight, color: color);
  }
}

void postFrame(VoidCallback callback) {
  WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
    callback.call();
  });
}

// class CommentDetails {
//   bool comment;
//   PostResponse response;
//   bool isLiked;
//   CommentDetails(
//       {required this.comment, required this.response, required this.isLiked});
// }

// Future<void> showDetails(context, int id, {PostResponse? response}) async {
//   CommentDetails? openComments = await showGeneralDialog(
//     context: context,
//     barrierColor: Colors.black12.withOpacity(0.6), // background color
//     barrierDismissible: false, // should dialog be dismissed when tapped outside
//     routeSettings: RouteSettings(name: "details"),
//     transitionDuration: Duration(milliseconds: 400),
//     useRootNavigator: false,
//     pageBuilder: (_context, anim, anim2) {
//       return Material(
//         color: Colors.black.withOpacity(0.1),
//         child: Container(
//           width: MediaQuery.of(_context).size.width,
//           height: MediaQuery.of(_context).size.height,
//           decoration: BoxDecoration(
//             color: Colors.black.withOpacity(0.1),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(
//                 height: 44,
//               ),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.of(_context).pop(null);
//                 },
//                 child: Container(
//                   height: 40,
//                   width: 40,
//                   margin: EdgeInsets.only(left: 18),
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.white.withOpacity(0.8),
//                   ),
//                   child: Icon(
//                     Icons.arrow_back,
//                     color: Color(0xFF0F0F2D),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30),
//                     ),
//                   ),
//                   child: NewsDetailPopupGeneric(
//                     id,
//                     index: 0,
//                     setter: response,
//                     onTapComment: () {},
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
//   print(response?.isLiked);
//   if (openComments != null && openComments.comment) {
//     showComments(context, openComments.response);
//   }
// }

// void showComments(context, PostResponse response) async {
//   await showGeneralDialog(
//     context: context,
//     barrierColor: Colors.black.withOpacity(0.1), // background color
//     barrierDismissible: false, // should dialog be dismissed when tapped outside
//     transitionDuration: Duration(milliseconds: 400),
//     routeSettings: RouteSettings(name: "comments"),
//     useRootNavigator: false,
//     pageBuilder: (_context, anim, anim2) {
//       return Material(
//         color: Colors.black.withOpacity(0.3),
//         child: CommentPop(
//           newsDetailsData: response,
//           onTap: () => Navigator.of(_context).pop(),
//         ),
//       );
//     },
//   );
// }
