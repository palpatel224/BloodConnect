import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService with ChangeNotifier {
  final String key = "isDarkMode";
  late SharedPreferences _prefs;
  late bool _isDarkModeOn;

  bool get isDarkModeOn => _isDarkModeOn;

  ThemeService() {
    _isDarkModeOn = false;
    _loadFromPrefs();
  }

  _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _isDarkModeOn = _prefs.getBool(key) ?? false;
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    _prefs.setBool(key, _isDarkModeOn);
  }

  toggleTheme() {
    _isDarkModeOn = !_isDarkModeOn;
    _saveToPrefs();
    notifyListeners();
  }
}
