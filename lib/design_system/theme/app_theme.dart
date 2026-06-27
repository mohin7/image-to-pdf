import 'package:flutter/cupertino.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

abstract final class AppTheme {
  static CupertinoThemeData cupertinoTheme(Brightness brightness) {
    return CupertinoThemeData(
      brightness: brightness,
      primaryColor: AppColors.accentRed,
      scaffoldBackgroundColor: AppColors.backgroundPrimary,
      barBackgroundColor: AppColors.tabBarBackground,
      textTheme: CupertinoTextThemeData(
        primaryColor: AppColors.accentRed,
        textStyle: AppTypography.body,
        navTitleTextStyle: AppTypography.headline,
        navLargeTitleTextStyle: AppTypography.largeTitleBold,
        actionTextStyle: AppTypography.body.copyWith(
          color: AppColors.accentRed,
        ),
        tabLabelTextStyle: AppTypography.caption2,
      ),
    );
  }
}
