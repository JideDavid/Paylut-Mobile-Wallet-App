import 'package:flutter/material.dart';
import 'package:paylut/services/pref_helper.dart';

class SettingsProvider extends ChangeNotifier{
  ThemeMode themeMode = ThemeMode.light;
  bool lightMode = true;

  changeToLightTheme(){
    themeMode = ThemeMode.light;
    lightMode = true;
    PrefHelper().setAppThemeMode(true);
    notifyListeners();
    print("Light Theme Active");
  }

  changeToDarkTheme(){
    themeMode = ThemeMode.dark;
    lightMode = false;
    PrefHelper().setAppThemeMode(false);
    notifyListeners();
    print("Dark Theme Active");
  }

  getSaveTheme() async {
    bool? appTheme = await PrefHelper().getAppThemeMode();

    appTheme! ? changeToLightTheme()
    : changeToDarkTheme();
  }
}