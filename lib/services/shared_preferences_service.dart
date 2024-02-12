import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferencesService? _instance;
  static late SharedPreferences _preferences;

  SharedPreferencesService._();

  // Using a singleton pattern
  static Future<SharedPreferencesService> getInstance() async {
    _instance ??= SharedPreferencesService._();
    _preferences = await SharedPreferences.getInstance();

    return _instance!;
  }

  bool get followSystemTheme =>
      _getData(SettingKeys.followSystemTheme) ?? false;
  set followSystemTheme(bool value) =>
      _saveData(SettingKeys.followSystemTheme, value);

  dynamic _getData(SettingKeys key) {
    var value = _preferences.get(key.toString());
    debugPrint('Retrieved $key: $value');
    return value;
  }

  void _saveData(SettingKeys key, dynamic value) {
    debugPrint('Saving $key: $value');
    if (value is String) {
      _preferences.setString(key.toString(), value);
    } else if (value is int) {
      _preferences.setInt(key.toString(), value);
    } else if (value is double) {
      _preferences.setDouble(key.toString(), value);
    } else if (value is bool) {
      _preferences.setBool(key.toString(), value);
    } else if (value is List<String>) {
      _preferences.setStringList(key.toString(), value);
    }
  }
}

enum SettingKeys {
  followSystemTheme,
}
