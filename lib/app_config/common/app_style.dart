import 'package:flutter/material.dart';
import 'package:foodgarden/app_config/common/app_color.dart';

class AppStyle {
  static ThemeData get appThemeData {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: AppColor.primarySwatch,
      textTheme: TextTheme(
        titleLarge: TextStyle(
            color: AppColor.whiteColor,
            fontSize: 35,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold),
        titleMedium: TextStyle(
          color: AppColor.whiteColor,
          fontSize: 25,
        ),
      ),
    );
  }
}
