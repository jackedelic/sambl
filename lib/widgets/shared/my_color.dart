import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyColors {
  /// This is the most prevalent color through out the app. E.g the home page's 'Order' and 'Deliver' turns
  /// this color when pressed.
  static const int mainRedValue = 0xFFDF1B01;
  static Color mainRed = new Color(mainRedValue);
  static const MaterialColor mainRedSwatches = const MaterialColor(
      mainRedValue,
      const <int, Color>{
        50: const Color(0xFFFFEBEE),
        100: const Color(0xFFFFCDD2),
        200: const Color(0xFFEF9A9A),
        300: const Color(0xFFE57373),
        400: const Color(0xFFEF5350),
        500: const Color(mainRedValue),
        600: const Color(0xFFE53935),
        700: const Color(0xFFD32F2F),
        800: const Color(0xFFC62828),
        900: const Color(0xFFB71C1C),
      });
  static const MaterialColor semiTransparent = const MaterialColor(
      0x38FFFFFF,
      const <int, Color> {
        50: const Color(0x38FFFFFF),
        100: const Color(0x58FFFFFF)
      }
  );

  /// This is the background color.
  static Color mainBackground = new Color(0xFFEBEBEB);
  /// This is the color of border of some of the buttons like the in openOrderListPage page
  static Color borderGrey = new Color(0xFFEBEBEB);

}