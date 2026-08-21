import 'package:flutter/material.dart';
import 'colors.dart';

class ThemeColors {
  static Color dialogBackground(BuildContext context) {
    final theme = Theme.of(context);
    return theme.dialogTheme.backgroundColor ??
        (theme.brightness == Brightness.dark ? AppColors.secondaryBlack : AppColors.secondaryLight);
  }

  static Color titleColor(BuildContext context) {
    final theme = Theme.of(context);
    return theme.textTheme.titleLarge?.color ??
        (theme.brightness == Brightness.dark ? AppColors.textWhite : AppColors.textPrimaryLight);
  }

  static Color bodyColor(BuildContext context) {
    final theme = Theme.of(context);
    return theme.textTheme.bodyMedium?.color ??
        (theme.brightness == Brightness.dark ? AppColors.textGray : AppColors.textSecondaryLight);
  }

  static Color surfaceColor(BuildContext context) {
    final theme = Theme.of(context);
    return theme.colorScheme.surface;
  }

  static Color inputFill(BuildContext context) {
    final theme = Theme.of(context);
    return theme.brightness == Brightness.dark ? AppColors.inputBackground : AppColors.inputBackgroundLight;
  }

  static Color inputTextColor(BuildContext context) {
    final theme = Theme.of(context);
    return theme.brightness == Brightness.dark ? AppColors.textWhite : AppColors.textPrimaryLight;
  }

  static Color placeholderColor(BuildContext context) {
    final theme = Theme.of(context);
    return theme.brightness == Brightness.dark ? AppColors.textDark : AppColors.textSecondaryLight;
  }

  static Color successBackground(BuildContext context) {
    return AppColors.successGreen.withOpacity(0.12);
  }

  static Color errorBackground(BuildContext context) {
    return AppColors.errorRed.withOpacity(0.12);
  }

  static Color primaryButtonBg(BuildContext context, {bool danger = false}) {
    if (danger) return AppColors.errorRed;
    return AppColors.primaryGold;
  }

  static Color primaryButtonFg(BuildContext context, {bool danger = false}) {
    return danger ? AppColors.textWhite : AppColors.primaryBlack;
  }
}
