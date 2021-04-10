import 'package:flutter/material.dart';

ThemeData fyreworkLightTheme() {
  TextTheme _basicTextTheme(TextTheme base) {
    return base.copyWith(
      headline1: base.headline1.copyWith(
        // fontFamily: 'Montserrat-Light',
        fontSize: 20.0,
        fontWeight: FontWeight.normal,
        color: Color(0xFF000000),
      ),
      headline6: base.headline6.copyWith(
        // fontFamily: 'Montserrat-Light',
        fontSize: 12.0,
        color: Color(0xFF000000),
        fontWeight: FontWeight.normal,
      ),
      bodyText1: base.bodyText1.copyWith(
        // fontFamily: 'Montserrat-Light',
        fontSize: 14.0,
        color: Color(0xFF000000),
        fontWeight: FontWeight.normal,
      ),
      bodyText2: base.bodyText2.copyWith(
        // fontFamily: 'Montserrat-Light',
        fontSize: 14.0,
        color: Color(0xFFFFFFFF),
        fontWeight: FontWeight.normal,
      ),
      caption: base.caption.copyWith(
        // fontFamily: 'Montserrat-Light',
        fontSize: 12.0,
        color: Color(0xFFBDBDBD),
        fontWeight: FontWeight.normal,
      ),
    );
  }

  // final ThemeData base = ThemeData.dark();
  final ThemeData base = ThemeData();
  return base.copyWith(
      inputDecorationTheme:
          InputDecorationTheme(fillColor: Colors.grey.withOpacity(0.1)),
      textTheme: _basicTextTheme(base.textTheme),
      primaryColor: Color(0xFF000000),
      accentColor: Color(0XFFFFFFFF),
      bottomAppBarColor: Color(0XFF212121),
      hintColor: Colors.grey[500],
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.black),
      snackBarTheme: SnackBarThemeData(backgroundColor: Colors.black));
}