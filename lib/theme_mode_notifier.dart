import 'package:flutter/material.dart';

class ThemeModeNotifier extends ChangeNotifier {
  ThemeMode _themeMode;

  ThemeModeNotifier(this._themeMode);

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode themeMode) {
    if (_themeMode != themeMode) {
      _themeMode = themeMode;
      notifyListeners();
    }
  }
}
