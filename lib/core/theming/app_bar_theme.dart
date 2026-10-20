import 'package:evetick/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

/// One look for every AppBar: same colour as the screen behind it (no grey
/// Material 3 tint, no shadow when the list scrolls under it).
AppBarTheme buildAppBarTheme(AppColors colors) {
  return AppBarTheme(
    backgroundColor: colors.darkBlue,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: colors.white),
    actionsIconTheme: IconThemeData(color: colors.white),
    titleTextStyle: TextStyle(
      color: colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w700,
    ),
  );
}
