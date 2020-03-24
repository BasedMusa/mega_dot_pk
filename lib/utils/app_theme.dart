import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static Color _primaryColor = Color(0xFFFF9000);
  static Color _dividerColor = Colors.grey[200];

  static data() => ThemeData(
        appBarTheme: AppBarTheme(
          color: _primaryColor,
          elevation: 0,
          brightness: Brightness.dark,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        primaryColor: _primaryColor,
        brightness: Brightness.light,
        accentColor: _primaryColor,
        scaffoldBackgroundColor: Color(0xFFF6F6F6),
        canvasColor: Colors.blueGrey[050],
        cardColor: Colors.white,
        splashColor: Colors.grey[400].withOpacity(.25),
        highlightColor: Colors.grey.withOpacity(.1),
        dividerColor: _dividerColor,
        cupertinoOverrideTheme: CupertinoThemeData(
          primaryColor: _primaryColor,
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
        textSelectionHandleColor: _primaryColor,
        cursorColor: _primaryColor,
        inputDecorationTheme: InputDecorationTheme(
          border: InputBorder.none,
          fillColor: Colors.white,
          filled: true,
        ),
        tabBarTheme: TabBarTheme(
          labelColor: _primaryColor.withOpacity(.3),
          unselectedLabelColor: Colors.grey[300],
        ),
        primaryTextTheme: TextTheme(
          headline4: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 27,
          ),
          headline6: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          subtitle1: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          subtitle2: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          button: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        buttonColor: _primaryColor,
        cardTheme: CardTheme(elevation: 0),
        buttonTheme: ButtonThemeData(
          buttonColor: _primaryColor,
        ),
      );
}
