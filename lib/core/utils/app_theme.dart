import 'package:egy_go/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

import 'app_constants.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: AppConstants.fontFamily,
      scaffoldBackgroundColor: AppColors.scaffoldBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.scaffoldBackground,
      ));
}
