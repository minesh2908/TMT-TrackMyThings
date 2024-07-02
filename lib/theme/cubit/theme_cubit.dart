import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:track_my_things/service/shared_prefrence.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(AppPrefHelper.getDarkTheme());
  Future<void> changeTheme(bool isDark) async {
    if (isDark) {
      await AppPrefHelper.setDarkTheme(darkTheme: true);
      final currentTheme = AppPrefHelper.getDarkTheme();
      emit(currentTheme);
    } else {
      await AppPrefHelper.setDarkTheme(darkTheme: false);
      final currentTheme = AppPrefHelper.getDarkTheme();
      emit(currentTheme);
    }
  }
}
