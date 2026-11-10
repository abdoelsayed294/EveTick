import 'package:evetick/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

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
