import 'package:evetick/core/theming/dark_theme.dart';
import 'package:evetick/core/theming/light_theme.dart';
import 'package:flutter/material.dart';

abstract class AppTheme {
  static ThemeData get lightTheme => lightThemeData;

  static ThemeData get darkTheme => darkThemeData;
}