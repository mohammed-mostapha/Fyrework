import 'package:flutter/material.dart';

// class FyreworkrColors {
//   static final Color bondiBlue = Color.fromRGBO(0, 132, 180, 1.0);
//   static final Color cerulean = Color.fromRGBO(0, 172, 237, 1.0);
//   static final Color spindle = Color.fromRGBO(192, 222, 237, 1.0);
//   static final Color white = Color.fromRGBO(255, 255, 255, 1.0);
//   static final Color black = Color.fromRGBO(0, 0, 0, 1.0);
//   static final Color woodsmoke = Color.fromRGBO(20, 23, 2, 1.0);
//   static final Color woodsmoke_50 = Color.fromRGBO(20, 23, 2, 0.5);
//   static final Color mystic = Color.fromRGBO(230, 236, 240, 1.0);
//   static final Color dodgetBlue = Color.fromRGBO(29, 162, 240, 1.0);
//   static final Color dodgetBlue_50 = Color.fromRGBO(29, 162, 240, 0.5);
//   static final Color paleSky = Color.fromRGBO(101, 119, 133, 1.0);
//   static final Color ceriseRed = Color.fromRGBO(224, 36, 94, 1.0);
//   static final Color paleSky50 = Color.fromRGBO(101, 118, 133, 0.5);
//   // static final Color fyreworkBlack = Color.fromRGBO(0, 0, 0, 1);
//   static final Color fyreworkBlack = Color(0xFF000000);
//   static final Color fyreworkGrey = Color.fromRGBO(104, 107, 116, 1);
// }

ThemeData fyreworkTheme() {
  TextTheme _basicTextTheme(TextTheme base) {
    return base.copyWith(
      headline1: base.headline5.copyWith(
        // fontFamily: 'Montserrat-Light',
        fontSize: 20.0,
        color: Colors.black,
      ),
      bodyText1: base.headline6.copyWith(
        // fontFamily: 'Montserrat-Light',
        fontSize: 16.0,
        color: Color(0xFF000000),
        fontWeight: FontWeight.normal,
      ),
      bodyText2: base.headline6.copyWith(
        // fontFamily: 'Montserrat-Light',
        fontSize: 12.0,
        color: Color(0xFF000000),
        fontWeight: FontWeight.normal,
      ),
      // headline6: base.headline5.copyWith(
      //   // fontFamily: 'Montserrat-Light',
      //   fontSize: 12.0,
      //   color: Colors.grey[500],
      // ),
    );
  }

  // final ThemeData base = ThemeData.dark();
  final ThemeData base = ThemeData();
  return base.copyWith(
    textTheme: _basicTextTheme(base.textTheme),
    primaryColor: Color(0xFF000000),
    accentColor: Color(0XFFFFFFFF),
    hintColor: Colors.grey[500],
  );
}
