import 'package:flutter/material.dart';

var mainTheme = ThemeData.light().copyWith(
  primaryColor: Color(0xFFFFA259),
  accentColor: Color(0xffFF7860),
  buttonColor: Color(0xffFED766),
  backgroundColor: Color(0xffFFEBCC),
  appBarTheme: AppBarTheme(
    textTheme: TextTheme(
      title: TextStyle(
        fontFamily: 'Lato',
        fontWeight: FontWeight.bold,
        color: Color(0xffFFFFEA),
        fontSize: 23,
      ),
    ),
  ),
);

TextStyle kTitleStyle(double screenWidth) {
  return TextStyle(
    fontFamily: 'Lato',
    fontWeight: FontWeight.bold,
    color: Color(0xff3A2E39),
    fontSize: screenWidth * 0.08,
  );
}

TextStyle kQuoteStyle(double screenWidth) {
  return TextStyle(
    fontFamily: 'Lato',
    fontStyle: FontStyle.italic,
    color: kTitleStyle(screenWidth).color,
    decorationStyle: TextDecorationStyle.dashed,
    fontSize: screenWidth * 0.05,
  );
}

TextStyle kAuthorStyle(double screenWidth) {
  return TextStyle(
    fontFamily: 'Lato',
    fontWeight: FontWeight.bold,
    color: kTitleStyle(screenWidth).color,
    fontSize: screenWidth * 0.05,
    wordSpacing: 2,
  );
}

TextStyle kButtonTextStyle(double screenWidth) {
  return TextStyle(
    fontFamily: 'Lato',
    fontWeight: FontWeight.bold,
    color: kTitleStyle(screenWidth).color,
    fontSize: screenWidth * 0.045,
  );
}

final rareColor = Colors.amber;
final epicColor = Colors.purpleAccent;
final legendaryColor = Colors.yellow;
