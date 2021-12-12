import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var lightTheme = ThemeData(
    primaryColor: Color(0xFF165EDB),
    backgroundColor: Colors.grey.shade100,
    scaffoldBackgroundColor: Colors.white,
    canvasColor: Colors.white,
    textTheme: TextTheme(
        bodyText1: GoogleFonts.lato(),
        bodyText2: GoogleFonts.lato(),
        button: GoogleFonts.lato(),
        caption: GoogleFonts.lato(),
        headline1: GoogleFonts.lato(),
        headline2: GoogleFonts.lato(),
        headline3: GoogleFonts.lato(),
        headline4: GoogleFonts.lato(),
        headline5: GoogleFonts.lato(),
        headline6: GoogleFonts.lato(),
        subtitle1: GoogleFonts.lato(),
        subtitle2: GoogleFonts.lato(),
        overline: GoogleFonts.lato()));

var darkTheme = ThemeData(
    primaryColor: Color(0xFF165EDB),
    backgroundColor: Colors.grey.shade900,
    scaffoldBackgroundColor: Colors.black,
    canvasColor: Colors.black,
    iconTheme: IconThemeData(color: Colors.white),
    textTheme: TextTheme(
      bodyText1: GoogleFonts.lato().copyWith(color: Colors.white),
      bodyText2: GoogleFonts.lato().copyWith(color: Colors.white),
      button: GoogleFonts.lato().copyWith(color: Colors.white),
      caption: GoogleFonts.lato().copyWith(color: Colors.white),
      headline1: GoogleFonts.lato().copyWith(color: Colors.white),
      headline2: GoogleFonts.lato().copyWith(color: Colors.white),
      headline3: GoogleFonts.lato().copyWith(color: Colors.white),
      headline4: GoogleFonts.lato().copyWith(color: Colors.white),
      headline5: GoogleFonts.lato().copyWith(color: Colors.white),
      headline6: GoogleFonts.lato().copyWith(color: Colors.white),
      subtitle1: GoogleFonts.lato().copyWith(color: Colors.white),
      subtitle2: GoogleFonts.lato().copyWith(color: Colors.white),
      overline: GoogleFonts.lato().copyWith(color: Colors.white),
    ));

var textStyle = GoogleFonts.poppins();
var textStyleLato = GoogleFonts.lato();
