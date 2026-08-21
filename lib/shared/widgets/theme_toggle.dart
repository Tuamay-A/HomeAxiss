import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/blocs/theme_cubit.dart';
import '../theme/colors.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, mode) {
        final isDark = mode == ThemeMode.dark;
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: GestureDetector(
            onTap: () => context.read<ThemeCubit>().toggle(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 52,
              height: 30,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark ? AppColors.secondaryBlack : AppColors.inputBackgroundLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.borderGold,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black.withOpacity(0.4) : Colors.grey.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Align(
                alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.primaryGold : AppColors.primaryGold,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isDark ? Icons.nightlight_round : Icons.wb_sunny,
                    size: 14,
                    color: isDark ? AppColors.primaryBlack : AppColors.primaryBlack,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
