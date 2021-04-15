import 'package:flutter/material.dart';

ThemeData fyreworkDarkTheme() {
  TextTheme _basicTextTheme(TextTheme base) {
    return base.copyWith(
      headline1: base.headline1.copyWith(
        // fontFamily: 'Montserrat-Light',
        fontSize: 20.0,
        fontWeight: FontWeight.normal,
        color: Color(0xFFFFFFFF),
      ),
      headline6: base.headline6.copyWith(
        // fontFamily: 'Montserrat-Light',
        fontSize: 12.0,
        color: Color(0xFFFFFFFF),
        fontWeight: FontWeight.normal,
      ),
      bodyText1: base.bodyText1.copyWith(
        // fontFamily: 'Montserrat-Light',
        fontSize: 14.0,
        color: Color(0xFFFFFFFF),
        fontWeight: FontWeight.normal,
      ),
      bodyText2: base.bodyText2.copyWith(
        // fontFamily: 'Montserrat-Light',
        fontSize: 14.0,
        color: Color(0xFF000000),
        fontWeight: FontWeight.normal,
      ),
      caption: base.caption.copyWith(
        // fontFamily: 'Montserrat-Light',
        fontSize: 12.0,
        color: Color(0xFFFFFFFF),
        fontWeight: FontWeight.normal,
      ),
    );
  }

  // final ThemeData base = ThemeData.dark();
  final ThemeData base = ThemeData();
  return base.copyWith(
      scaffoldBackgroundColor: Color(0XFF000000),
      indicatorColor: Color(0XFFFFFFFF),
      inputDecorationTheme: InputDecorationTheme(fillColor: Colors.grey[900]),
      textTheme: _basicTextTheme(base.textTheme),
      primaryColor: Color(0xFFFFFFFF),
      accentColor: Color(0XFF000000),
      bottomAppBarColor: Color(0XFF212121),
      hintColor: Colors.grey[500],
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white),
      snackBarTheme: SnackBarThemeData(backgroundColor: Colors.white));
}
