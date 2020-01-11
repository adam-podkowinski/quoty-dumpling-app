import 'package:flutter/material.dart';

var mainTheme = ThemeData.light().copyWith(
  primaryColor: Color(0xffFFA259),
  accentColor: Color(0xffFF7860),
  buttonColor: Color(0xffFED766),
  secondaryHeaderColor: Color(0xff91bd3a),
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

TextStyle kCommonTextStyle(double screenWidth) {
  return TextStyle(
    fontFamily: 'Lato',
    color: kTitleStyle(screenWidth).color,
    fontSize: screenWidth * 0.04,
  );
}

OutlineInputBorder kSearchBarBorder = OutlineInputBorder(
  borderSide: BorderSide(
    color: mainTheme.buttonColor,
    width: 4,
  ),
  borderRadius: BorderRadius.all(
    Radius.circular(25.0),
  ),
);

TextStyle kSearchBarTextStyle(double screenWidth) {
  return TextStyle(
    color: mainTheme.backgroundColor,
    fontSize: screenWidth * 0.05,
  );
}

final rareColor = Colors.amber;
final epicColor = Colors.purpleAccent;
final legendaryColor = Colors.yellow;
