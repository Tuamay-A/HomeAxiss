import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/storage/shared_prefs.dart';
import '../../core/constants/storage_constant.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(_getInitialTheme());

  static ThemeMode _getInitialTheme() {
    try {
      final savedTheme = SharedPrefs.getString(StorageKeys.themeMode);
      if (savedTheme == 'light') {
        return ThemeMode.light;
      }
      return ThemeMode.dark;
    } catch (_) {
      return ThemeMode.dark;
    }
  }

  void toggleTheme() {
    final nextMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(nextMode);
    _saveTheme(nextMode);
  }

  void setTheme(ThemeMode mode) {
    emit(mode);
    _saveTheme(mode);
  }

  Future<void> _saveTheme(ThemeMode mode) async {
    try {
      final themeStr = mode == ThemeMode.light ? 'light' : 'dark';
      await SharedPrefs.setString(StorageKeys.themeMode, themeStr);
    } catch (_) {}
  }
}
