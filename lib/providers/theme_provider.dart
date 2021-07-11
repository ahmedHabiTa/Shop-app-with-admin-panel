import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  var primaryColor = Colors.blue[200];
  var accentColor = Colors.blue[900];

  var tm = ThemeMode.system;
  String themeText = "s";
  void themeModeChange(newThemeVal) async {
    tm = newThemeVal;
    _getThemeText(tm);
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("themeText", themeText);
  }

  _getThemeText(ThemeMode tm) {
    if (tm == ThemeMode.dark)
      themeText = "d";
    else if (tm == ThemeMode.light)
      themeText = "l";
    else if (tm == ThemeMode.system) themeText = "s";
  }

  getThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    themeText = prefs.getString("themeText") ?? "s";
    if (themeText == "d")
      tm = ThemeMode.dark;
    else if (themeText == "l")
      tm = ThemeMode.light;
    else if (themeText == "s") tm = ThemeMode.system;
    notifyListeners();
  }
}
