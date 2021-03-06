// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hive/hive.dart';

// import 'package:threekm/utility/translations.dart';
// import 'package:threekm/utils/util_methods.dart';
// import 'package:threekm/widgets/language_list_item.dart';
// import 'package:threekm/widgets/paint_line.dart';


// class SelectLanguage extends StatefulWidget {

//   SelectLanguage();

//   @override
//   _SelectLanguageState createState() => _SelectLanguageState();
// }

// class _SelectLanguageState extends State<SelectLanguage>
//     with TickerProviderStateMixin {
//   //final controller = Get.put(SelectLanguageController());
//   AnimationController? animation1;
//   AnimationController? animation2;
//   AnimationController? animation3;
//   Animation? animation;
//   Animation? animationColor1;
//   Animation? animationColor2;
//   double index = 0;
//   Color color1 = Color(0xFFE83F94);
//   Color color2 = Color(0xFF4048EF);
//   double offset1 = 0;
//   double offset2 = 1;
//   double offset3 = 2;

//   @override
//   void initState() {
//     super.initState();
//     animation1 =
//         AnimationController(vsync: this, duration: Duration(seconds: 1));
//     animation2 =
//         AnimationController(vsync: this, duration: Duration(seconds: 1));
//     animation3 =
//         AnimationController(vsync: this, duration: Duration(seconds: 1));

//     animation = Tween<double>(begin: 0, end: 1).animate(animation2!);
//     animationColor1 =
//         ColorTween(begin: Color(0xFFE83F94), end: Color(0xFF4048EF))
//             .animate(animation3!);
//     animationColor1!.addListener(() {
//       setState(() => color1 = animationColor1!.value);
//     });
//     animationColor2 =
//         ColorTween(begin: Color(0xFF4048EF), end: Color(0xFFE83F94))
//             .animate(animation3!);
//     animationColor2!.addListener(() {
//       setState(() => color2 = animationColor2!.value);
//     });

//     animation1?.repeat(reverse: true);
//   }

//   @override
//   void dispose() {
//     animation1?.dispose();
//     animation2?.dispose();
//     animation3?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // key: controller.scaffoldKey,
//       body: Stack(
//         children: [
//           AnimatedBuilder(
//               animation: animation3!,
//               builder: (context, child) {
//                 return Container(
//                   padding: EdgeInsets.only(top: 200),
//                   margin: EdgeInsets.only(top: 125),
//                   height: MediaQuery.of(context).size.height,
//                   width: MediaQuery.of(context).size.width,
//                   alignment: Alignment.bottomCenter,
//                   decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           tileMode: TileMode.mirror,
//                           colors: [
//                         color1,
//                         color2,
//                       ])),
//                 );
//               }),
//           Container(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Container(
//                   height: 165,
//                   width: MediaQuery.of(context).size.width,
//                   padding: EdgeInsets.only(left: 19),
//                   decoration: BoxDecoration(
//                       color: Colors.black,
//                       borderRadius: BorderRadius.only(
//                           bottomLeft: Radius.circular(40),
//                           bottomRight: Radius.circular(40))),
//                   child: StreamBuilder<BoxEvent>(
//                       stream: Hive.box("language").watch(),
//                       builder: (context, snapshot) {
//                         if (snapshot.hasData) {
//                           return Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 translations[select_language]![
//                                     (snapshot.data?.value as Language)
//                                         .language],
//                                 style: GoogleFonts.montserrat().copyWith(
//                                     fontSize: 32,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white),
//                               ),
//                               SizedBox(
//                                 height: 8,
//                               ),
//                               Text(
//                                 translations[
//                                         you_can_change_it_later_in_profile]![
//                                     (snapshot.data?.value as Language)
//                                         .language],
//                                 style: GoogleFonts.montserrat().copyWith(
//                                     fontSize: 16, color: Colors.white),
//                               )
//                             ],
//                           );
//                         } else {
//                           return Container();
//                         }
//                       }),
//                 ),
//                 SizedBox(height: 68.48),
//                 Column(
//                   children: [
//                     StreamBuilder<BoxEvent>(
//                         stream: Hive.box("language").watch(),
//                         builder: (context, snapshot) {
//                           if (snapshot.hasData) {
//                             return Container(
//                               height: MediaQuery.of(context).size.width * 0.9,
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Stack(
//                                     children: [
//                                       AnimatedBuilder(
//                                           animation: animation!,
//                                           builder: (context, child) {
//                                             return Transform.translate(
//                                               offset: Offset(50, 0),
//                                               child: Transform.rotate(
//                                                 angle: degreesToRadians((9 -
//                                                         (animation!.value * 18))
//                                                     .toDouble()),
//                                                 child: Container(
//                                                   width: MediaQuery.of(context)
//                                                           .size
//                                                           .width *
//                                                       0.4,
//                                                   child: AnimatedBuilder(
//                                                     animation: animation1!,
//                                                     builder: (context, child) =>
//                                                         ClipPath(
//                                                             clipper: PaintLine(
//                                                                 radius: animation1!
//                                                                     .value,
//                                                                 index: controller
//                                                                     .languages
//                                                                     .indexWhere((e) =>
//                                                                         e.value ==
//                                                                         (snapshot.data!.value as Language)
//                                                                             .language)
//                                                                     .toDouble()),
//                                                             child: Container(
//                                                                 width: 120,
//                                                                 height: MediaQuery.of(
//                                                                         context)
//                                                                     .size
//                                                                     .width,
//                                                                 decoration:
//                                                                     BoxDecoration(
//                                                                         gradient:
//                                                                             LinearGradient(colors: [
//                                                                   Colors.white
//                                                                       .withOpacity(
//                                                                           0),
//                                                                   Colors.white,
//                                                                   Colors.white
//                                                                       .withOpacity(
//                                                                           0),
//                                                                 ], begin: Alignment.topCenter, end: Alignment.bottomCenter)))),
//                                                   ),
//                                                 ),
//                                               ),
//                                             );
//                                           }),
//                                       Container(
//                                         width:
//                                             MediaQuery.of(context).size.width *
//                                                 0.4,
//                                         margin: EdgeInsets.only(top: 72),
//                                         child: AnimatedBuilder(
//                                             animation: animation1!,
//                                             builder:
//                                                 (context, child) =>
//                                                     AnimatedBuilder(
//                                                         animation: animation!,
//                                                         builder:
//                                                             (context, child) =>
//                                                                 CustomPaint(
//                                                                   painter: PaintLine2(
//                                                                       percent:
//                                                                           animation!
//                                                                               .value,
//                                                                       radius: animation1!
//                                                                           .value,
//                                                                       index: controller
//                                                                           .languages
//                                                                           .indexWhere((e) =>
//                                                                               e.value ==
//                                                                               (snapshot.data!.value as Language).language)
//                                                                           .toDouble()),
//                                                                   size: Size(
//                                                                       110,
//                                                                       MediaQuery.of(context)
//                                                                               .size
//                                                                               .width *
//                                                                           0.50),
//                                                                 ))),
//                                       ),
//                                     ],
//                                   ),
//                                   Container(
//                                     width:
//                                         MediaQuery.of(context).size.width * 0.5,
//                                     height: MediaQuery.of(context).size.width *
//                                         0.65,
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: controller.languages
//                                           .asMap()
//                                           .entries
//                                           .map((e) => InkWell(
//                                                 onTap: () async {
//                                                   controller.updateBox(e.key);
//                                                   animation2 =
//                                                       AnimationController(
//                                                           vsync: this,
//                                                           duration: Duration(
//                                                               seconds: 1));
//                                                   if (e.key == 1) {
//                                                     animation3!.forward();
//                                                     animation = Tween(
//                                                             begin: index,
//                                                             end: 0.5)
//                                                         .animate(animation2!);
//                                                     animation2!.forward().then(
//                                                         (v) => index = 0.5);
//                                                   } else if (e.key == 2) {
//                                                     animation3?.reverse();
//                                                     animation = Tween(
//                                                             begin: index,
//                                                             end: 1.0)
//                                                         .animate(animation2!);
//                                                     animation2!.forward().then(
//                                                         (v) => index = 1.0);
//                                                   } else {
//                                                     animation3?.reverse();
//                                                     animation = Tween(
//                                                             begin: index,
//                                                             end: 0.0)
//                                                         .animate(animation2!);
//                                                     animation2!
//                                                         .forward()
//                                                         .then((v) => index = 0);
//                                                   }
//                                                 },
//                                                 child: Container(
//                                                   width: 140,
//                                                   child: Transform.translate(
//                                                     offset: Offset(0, 0),
//                                                     child: LanguageListItem(
//                                                       selected: e.value.value!
//                                                           .contains((snapshot
//                                                                       .data!
//                                                                       .value
//                                                                   as Language)
//                                                               .language!),
//                                                       name: e.value.language,
//                                                       acronym: e.value.acronym,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ))
//                                           .toList(),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           } else {
//                             return Container();
//                           }
//                         }),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             bottom: 20,
//             child: Container(
//               width: MediaQuery.of(context).size.width,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   InkWell(
//                     onTap: () async {
//                       await controller.updateSelectionState();
//                       context.toBaseNamed(HomePage.path);
//                     },
//                     child: Container(
//                       width: 76,
//                       height: 76,
//                       decoration: BoxDecoration(
//                           color: Color(0xFFFFFFFF).withOpacity(0.5),
//                           backgroundBlendMode: BlendMode.overlay,
//                           shape: BoxShape.circle),
//                       child: Center(
//                         child: Icon(
//                           Icons.arrow_forward,
//                           size: 30,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
