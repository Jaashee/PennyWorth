import 'package:flutter/material.dart';

class ThemeModeNotifier with ChangeNotifier {
  ThemeMode _themeMode;
  ThemeModeNotifier(this._themeMode);

  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  ThemeMode get themeMode => _themeMode;
}
