import 'package:flutter/material.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';

class Styles {
  static const rareColor = Colors.amber;
  static const epicColor = Colors.purpleAccent;
  static const legendaryColor = Colors.yellow;
  static const appBarTextColor = Color(0xffFFFFEA);

  static final fontFamily = 'SofiaPro';

  static double _screenWidth = SizeConfig.screenWidth;

  static final mainTheme = ThemeData.light().copyWith(
    primaryColor: Color(0xffFFA259),
    accentColor: Color(0xffFF7860),
    buttonColor: Color(0xffFED766),
    secondaryHeaderColor: Color(0xff91bd3a),
    backgroundColor: Color(0xffFFEBCC),
    appBarTheme: AppBarTheme(
      textTheme: TextTheme(
        title: TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.bold,
          color: appBarTextColor,
          fontSize: 23,
        ),
      ),
    ),
  );

  static TextStyle kTitleStyle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.bold,
    color: Color(0xff3A2E39),
    fontSize: _screenWidth * 0.08,
  );

  static TextStyle kMoneyInShopItemTextStyle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.bold,
    color: Color(0xff3A2E39),
    fontSize: _screenWidth * 0.04,
  );

  static TextStyle kSettingsTitleStyle = kTitleStyle.copyWith(
    fontSize: _screenWidth * 0.065,
  );

  static TextStyle kQuoteStyle = TextStyle(
    fontFamily: fontFamily,
    fontStyle: FontStyle.italic,
    color: kTitleStyle.color,
    decorationStyle: TextDecorationStyle.dashed,
    fontSize: _screenWidth * 0.05,
  );

  static TextStyle kAuthorStyle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.bold,
    color: kTitleStyle.color,
    fontSize: _screenWidth * 0.05,
    wordSpacing: 2,
  );

  static TextStyle kButtonTextStyle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.bold,
    color: kTitleStyle.color,
    fontSize: _screenWidth * 0.045,
  );

  static TextStyle kCommonTextStyle = TextStyle(
    fontFamily: fontFamily,
    color: kTitleStyle.color,
    fontSize: _screenWidth * 0.04328,
  );

  static TextStyle kSettingsTextStyle = TextStyle(
    fontFamily: fontFamily,
    color: kTitleStyle.color,
    fontWeight: FontWeight.bold,
    fontSize: _screenWidth * 0.04,
  );

  static OutlineInputBorder kSearchBarBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: mainTheme.buttonColor,
      width: 4,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(25.0),
    ),
  );

  static TextStyle kSearchBarTextStyle = TextStyle(
    color: mainTheme.backgroundColor,
    fontFamily: fontFamily,
    fontSize: _screenWidth * 0.05,
  );

  static TextStyle kTabBarTextStyle = TextStyle(
    color: appBarTextColor,
    fontFamily: fontFamily,
    fontSize: _screenWidth * 0.04,
  );

  static TextStyle kMoneyTextStyle = TextStyle(
    color: appBarTextColor,
    fontFamily: fontFamily,
    fontSize: _screenWidth * 0.05,
  );

  static TextStyle kShopItemTitleStyle = TextStyle(
    color: appBarTextColor,
    fontFamily: fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: _screenWidth * 0.055,
  );

  static TextStyle kShopItemDescriptionStyle = TextStyle(
    color: appBarTextColor,
    fontFamily: fontFamily,
    fontSize: _screenWidth * 0.04,
  );

  static TextStyle kItemLevelTextStyle = TextStyle(
    color: appBarTextColor,
    fontFamily: fontFamily,
    fontSize: _screenWidth * .045,
  );

  static LinearGradient backgroundGradient = LinearGradient(
    colors: [
      mainTheme.primaryColor,
      mainTheme.accentColor.withOpacity(.8),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [.66, 1],
  );
}
