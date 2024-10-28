import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeClass {
  static ThemeData buildTheme(BuildContext context) {
    ThemeData themeData = ThemeData(
      primaryColor: const Color(0xFF0E0E0E),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: const Color(0xff0E0E0E),
      appBarTheme: const AppBarTheme(
        elevation: 0.0,
        color: Colors.white,
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.grey),
      ),
      bottomAppBarTheme: const BottomAppBarTheme(
        elevation: 0.0,
        color: Color(0xFF1FB5E4),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFFFFFFF)),
      cupertinoOverrideTheme:
      const CupertinoThemeData(brightness: Brightness.dark),
      primaryTextTheme:
      GoogleFonts.pattayaTextTheme(Theme.of(context).textTheme).copyWith(
        displayLarge: GoogleFonts.pattaya(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            fontSize: 24),
        displayMedium: GoogleFonts.pattaya(
            color: Color(0xff05070B),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            fontSize: 18),
        displaySmall: GoogleFonts.pattaya(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            fontStyle: FontStyle.normal),
        headlineLarge: GoogleFonts.pattaya(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
            fontSize: 27),
        headlineMedium: GoogleFonts.pattaya(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
            fontSize: 18),
        headlineSmall: GoogleFonts.pattaya(
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
            fontSize: 14),
        titleLarge: GoogleFonts.pattaya(
            color: const Color(0xFF028AB5),
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
            fontSize: 14),
        titleMedium: GoogleFonts.pattaya(
          color: const Color(0xFF028AB5),
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          fontSize: 12,
        ),
        titleSmall: GoogleFonts.pattaya(
            color: const Color(0xffFFFFFF),
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
            letterSpacing: -0.32),
        bodyLarge: GoogleFonts.pattaya(
            color: const Color(0xffFFFFFF),
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
            letterSpacing: -0.32),
        bodyMedium: GoogleFonts.nunitoSans(
            color: const Color(0xffFFFFFF),
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
            letterSpacing: -0.32),
        bodySmall: GoogleFonts.nunitoSans(
            color: const Color(0xffFFFFFF),
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
            letterSpacing: -0.32),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: const Color(0xFF1FB5E4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
    return themeData;
  }
}
