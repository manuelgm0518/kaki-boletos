import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kaki_boletos/utils/ui_utils.dart';
import 'package:derived_colors/derived_colors.dart';
export 'package:derived_colors/derived_colors.dart';

const Color kPrimaryColor = Color(0xFFC672D1);
const Color kSecondaryColor = Color(0xFF7855A0);
const Color kInfoColor = Color(0xFF00BCD4); //Cyan
const Color kSuccessColor = Color(0xFF00E676); //Green Secondary 400
const Color kErrorColor = Color(0xFFEF5350); //Red 400
const Color kWarningColor = Color(0xFFF57C00); //Orange 800
const Color kLightColor = Color(0xFFF5F5F5);
const Color kDarkColor = Color(0xFF959595);

class AppThemes {
  static ThemeData main = ThemeData(
    primaryColor: kPrimaryColor,
    fontFamily: 'Poppins',
    colorScheme: ColorScheme(
      primary: kPrimaryColor,
      primaryVariant: kPrimaryColor.variants.dark,
      secondary: kSecondaryColor,
      secondaryVariant: kSecondaryColor.variants.dark,
      surface: Colors.white,
      background: kLightColor,
      error: kErrorColor,
      onPrimary: kPrimaryColor.onColor,
      onSecondary: kSecondaryColor.onColor,
      onSurface: Colors.white.onColor,
      onBackground: kLightColor.onColor,
      onError: kErrorColor.onColor,
      brightness: Brightness.light,
    ),
    textTheme: const TextTheme(
      headline1: TextStyle(fontSize: 122, fontWeight: FontWeight.bold),
      headline2: TextStyle(fontSize: 56, fontWeight: FontWeight.bold),
      headline3: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
      headline4: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
      headline5: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      headline6: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      subtitle1: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      subtitle2: TextStyle(fontSize: 16),
      bodyText1: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      bodyText2: TextStyle(fontSize: 14),
      caption: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
      button: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Limelight'),
      overline: TextStyle(fontSize: 10),
    ),
    scaffoldBackgroundColor: kLightColor,
    cardTheme: const CardTheme(
      shape: RoundedRectangleBorder(borderRadius: kRoundedBorder),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      color: kPrimaryColor,
      elevation: 0,
    ),
    inputDecorationTheme: const InputDecorationTheme(border: InputBorder.none),
    // inputDecorationTheme: InputDecorationTheme(
    //   labelStyle: const TextStyle(fontSize: 16),
    //   filled: true,
    //   fillColor: kSecondaryColor.variants.light,
    //   border: const UnderlineInputBorder(borderRadius: kRoundedBorder, borderSide: BorderSide.none),
    //   focusedBorder: const OutlineInputBorder(borderRadius: kRoundedBorder, borderSide: BorderSide(color: kPrimaryColor)),
    //   errorBorder: const OutlineInputBorder(borderRadius: kRoundedBorder, borderSide: BorderSide(color: kErrorColor)),
    //   focusedErrorBorder: const OutlineInputBorder(borderRadius: kRoundedBorder, borderSide: BorderSide(color: kErrorColor)),
    //   isDense: true,
    // ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(borderRadius: kRoundedBorder),
        minimumSize: const Size(44, 44),
        onPrimary: Colors.white,
        primary: kSecondaryColor,
        elevation: 0,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: const RoundedRectangleBorder(borderRadius: kRoundedBorder),
        minimumSize: const Size(44, 44),
        primary: kSecondaryColor,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: const RoundedRectangleBorder(borderRadius: kRoundedBorder),
        minimumSize: const Size(44, 44),
        primary: kSecondaryColor,
      ),
    ),
  );
}
