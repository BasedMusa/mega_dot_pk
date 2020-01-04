import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static data() => ThemeData(
        primaryColor: Color(0xFFFF9000),
        brightness: Brightness.light,
        accentColor: Color(0xFFFF9900),
        appBarTheme: AppBarTheme(color: Colors.white),
        scaffoldBackgroundColor: Colors.grey[100],
        canvasColor: Colors.white,
        splashColor: Colors.grey[400].withOpacity(.25),
        highlightColor: Colors.grey.withOpacity(.1),
        dividerColor: Colors.grey[300],
        cupertinoOverrideTheme: CupertinoThemeData(
          primaryColor: Color(0xFFFF9900),
          textTheme: CupertinoTextThemeData(
            navLargeTitleTextStyle: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w700,
              color: CupertinoColors.label,
            ),
          ),
        ),
        popupMenuTheme: PopupMenuThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Colors.grey[300],
            ),
          ),
        ),
        bottomSheetTheme: BottomSheetThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(27.5),
            side: BorderSide(
              color: Colors.grey[300],
            ),
          ),
        ),
        textSelectionColor: Colors.black.withOpacity(.2),
        textSelectionHandleColor: Color(0xFFFF9000),
        cursorColor: Color(0xFFFF9000),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          fillColor: Colors.grey[100],
          filled: true,
        ),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.orangeAccent,
          unselectedLabelColor: Colors.grey[300],
        ),
        textTheme: TextTheme(
          display1: GoogleFonts.poppins(fontWeight: FontWeight.w700).copyWith(
            color: Colors.black,
          ),
          display2: GoogleFonts.poppins(fontWeight: FontWeight.w700)
              .copyWith(color: Colors.black),
          button: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          title: GoogleFonts.poppins(fontWeight: FontWeight.w600)
              .copyWith(color: Colors.black),
        ),
        buttonColor: Color(0xFFFF9000),
        cardTheme: CardTheme(elevation: 0),
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFFFF9000),
        ),
      );
}
