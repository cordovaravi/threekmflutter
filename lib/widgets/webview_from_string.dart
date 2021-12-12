// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_html/style.dart';
// import 'package:google_fonts/google_fonts.dart';

// class WebviewFromString extends StatefulWidget {
//   final String? string;
//   final double? height;
//   final TextAlign? align;
//   WebviewFromString(this.string, {this.height, this.align})
//       : super(key: UniqueKey());

//   @override
//   _WebviewFromStringState createState() => _WebviewFromStringState();
// }

// class _WebviewFromStringState extends State<WebviewFromString> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: widget.height != null
//           ? Html(data: "<div>${widget.string!}</div>", style: {
//               "div": Style(
//                 color: Colors.black,
//                 backgroundColor: Colors.white,
//                 height: widget.height,
//                 padding: EdgeInsets.all(0),
//                 margin: EdgeInsets.all(0),
//                 verticalAlign: VerticalAlign.SUB,
//                 alignment: Alignment.topLeft,
//                 fontSize: FontSize(14),
//               ),
//             })
//           : Html(data: "<div>${widget.string!}</div>", style: {
//               "div": Style(
//                 color: Colors.black,
//                 backgroundColor: Colors.white,
//                 textAlign: widget.align ?? TextAlign.center,
//                 fontWeight: FontWeight.w500,
//                 fontFamily: GoogleFonts.lato().fontFamily,
//                 padding: EdgeInsets.all(0),
//                 margin: EdgeInsets.all(0),
//                 verticalAlign: VerticalAlign.SUB,
//                 alignment: Alignment.topLeft,
//                 fontSize: FontSize(14),
//               ),
//               "p": Style(
//                 color: Colors.black,
//                 backgroundColor: Colors.white,
//                 textAlign: widget.align ?? TextAlign.center,
//                 fontWeight: FontWeight.w500,
//                 fontFamily: GoogleFonts.lato().fontFamily,
//                 padding: EdgeInsets.all(0),
//                 margin: EdgeInsets.all(0),
//                 verticalAlign: VerticalAlign.SUB,
//                 alignment: Alignment.topLeft,
//                 fontSize: FontSize(14),
//               ),
//               "span": Style(
//                 color: Colors.black,
//                 backgroundColor: Colors.white,
//                 textAlign: widget.align ?? TextAlign.center,
//                 fontWeight: FontWeight.w500,
//                 fontFamily: GoogleFonts.lato().fontFamily,
//                 padding: EdgeInsets.all(3),
//                 margin: EdgeInsets.all(5),
//                 verticalAlign: VerticalAlign.SUB,
//                 alignment: Alignment.topLeft,
//                 fontSize: FontSize(14),
//               ),
//             }),
//     );
//   }
// }
