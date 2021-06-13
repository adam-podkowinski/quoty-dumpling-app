import 'package:flutter/material.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';

//Using my own theme colors because they won't change (the difference between a game (has static game-related colors) and an application (user can change them))
class ThemeColors {
  static const rare = Colors.amber;
  static const epic = Colors.purpleAccent;
  static const legendary = Colors.yellow;

  static const primary = Color(0xffFFA259);
  static const secondary = Color(0xffFF7860);
  static const secondaryLight = Color(0xffFED766);
  static const background = Color(0xffFFEBCC);
  static const surface = Color(0xff91bd3a);
  static const onBackground = Color(0xff3a2e39);
  static const onSurface = Color(0xff3a2e39);
  static const onSecondary = Color(0xffFFFFEA);
  static const onPrimary = Color(0xffFFFFEA);
}

class Styles {
  static final fontFamily = 'SofiaPro';

  static final double? _screenWidth = SizeConfig.screenWidth;

  static final ThemeData mainTheme = ThemeData(
    fontFamily: fontFamily,
    primaryColor: ThemeColors.primary,
    colorScheme: ColorScheme.light().copyWith(
      primary: ThemeColors.primary,
      secondary: ThemeColors.secondary,
    ),
    appBarTheme: AppBarTheme(
      textTheme: TextTheme(
        headline6: TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.bold,
          color: ThemeColors.onSecondary,
          fontSize: 26,
        ),
      ),
    ),
  );

  static TextStyle titleStyle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.bold,
    color: ThemeColors.onBackground,
    fontSize: _screenWidth! * 0.08,
  );

  static TextStyle moneyInShopItemTextStyle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.bold,
    color: ThemeColors.onBackground,
    fontSize: _screenWidth! * 0.04,
  );

  static TextStyle settingsTitleStyle = titleStyle.copyWith(
    fontSize: _screenWidth! * 0.065,
  );

  static TextStyle quoteStyle = TextStyle(
    fontFamily: fontFamily,
    fontStyle: FontStyle.italic,
    color: titleStyle.color,
    decorationStyle: TextDecorationStyle.dashed,
    fontSize: _screenWidth! * 0.05,
  );

  static TextStyle authorStyle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.bold,
    color: titleStyle.color,
    fontSize: _screenWidth! * 0.05,
    wordSpacing: 2,
  );

  static TextStyle buttonTextStyle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.bold,
    color: titleStyle.color,
    fontSize: _screenWidth! * 0.045,
  );

  static TextStyle commonTextStyle = TextStyle(
    fontFamily: fontFamily,
    color: titleStyle.color,
    fontSize: _screenWidth! * 0.04328,
  );

  static TextStyle settingsTextStyle = TextStyle(
    fontFamily: fontFamily,
    color: titleStyle.color,
    fontWeight: FontWeight.bold,
    fontSize: _screenWidth! * 0.04,
  );

  static OutlineInputBorder searchBarBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: ThemeColors.secondaryLight,
      width: 4,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(25.0),
    ),
  );

  static TextStyle searchBarTextStyle = TextStyle(
    color: ThemeColors.background,
    fontFamily: fontFamily,
    fontSize: _screenWidth! * 0.05,
  );

  static TextStyle tabBarTextStyle = TextStyle(
    color: ThemeColors.onSecondary,
    fontFamily: fontFamily,
    fontSize: _screenWidth! * 0.04,
  );

  static TextStyle moneyTextStyle = TextStyle(
    color: ThemeColors.onSecondary,
    fontFamily: fontFamily,
    fontSize: _screenWidth! * 0.05,
  );

  static TextStyle shopItemTitleStyle = TextStyle(
    color: ThemeColors.onSecondary,
    fontFamily: fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: _screenWidth! * 0.055,
  );

  static TextStyle shopItemDescriptionStyle = TextStyle(
    color: ThemeColors.onSecondary,
    fontFamily: fontFamily,
    fontSize: _screenWidth! * 0.04,
  );

  static TextStyle itemLevelTextStyle = TextStyle(
    color: ThemeColors.onSecondary,
    fontFamily: fontFamily,
    fontSize: _screenWidth! * .045,
  );

  static LinearGradient backgroundGradient = LinearGradient(
    colors: [
      ThemeColors.primary,
      ThemeColors.secondary.withOpacity(.8),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [.66, 1],
  );
}
