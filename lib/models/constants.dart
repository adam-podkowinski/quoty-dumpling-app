import 'package:flutter/material.dart';

final mainTheme = ThemeData.light().copyWith(
  primaryColor: Color.fromRGBO(255, 162, 89, 1),
  backgroundColor: Color.fromRGBO(254, 104, 69, 1),
  accentColor: Color.fromRGBO(250, 66, 82, .9),
  buttonColor: Color.fromRGBO(145, 189, 58, 1),
  textTheme: TextTheme(
    title: TextStyle(
      fontFamily: 'Lato',
      fontWeight: FontWeight.bold,
      color: Color.fromRGBO(255, 246, 230, 1),
    ),
  ),
);
