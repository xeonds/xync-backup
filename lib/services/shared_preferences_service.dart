import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService extends ChangeNotifier {
  static final SharedPreferencesService _instance =
      SharedPreferencesService._internal();
  factory SharedPreferencesService() => _instance;
  late SharedPreferences _prefs;

  SharedPreferencesService._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String get colorScheme =>
      (_getData(SettingKeys.colorScheme) ?? AppTheme.light).toString();
  set colorScheme(String value) =>
      _saveData(SettingKeys.colorScheme, value.toString());

  bool get followSystemTheme =>
      _getData(SettingKeys.followSystemTheme) ?? false;
  set followSystemTheme(bool value) =>
      _saveData(SettingKeys.followSystemTheme, value);

  int get uploadSizeLimit => _getData(SettingKeys.uploadSizeLimit) ?? 10;
  set uploadSizeLimit(int value) =>
      _saveData(SettingKeys.uploadSizeLimit, value);

  int get downloadSizeLimit => _getData(SettingKeys.downloadSizeLimit) ?? 10;
  set downloadSizeLimit(int value) =>
      _saveData(SettingKeys.downloadSizeLimit, value);

  int get uploadSizeLimitWhenUsingData =>
      _getData(SettingKeys.uploadSizeLimitWhenUsingData) ?? 10;
  set uploadSizeLimitWhenUsingData(int value) =>
      _saveData(SettingKeys.uploadSizeLimitWhenUsingData, value);

  int get downloadSizeLimitWhenUsingData =>
      _getData(SettingKeys.downloadSizeLimitWhenUsingData) ?? 10;
  set downloadSizeLimitWhenUsingData(int value) =>
      _saveData(SettingKeys.downloadSizeLimitWhenUsingData, value);

  bool get notifyWhenSyncUsingData =>
      _getData(SettingKeys.notifyWhenSyncUsingData) ?? false;
  set notifyWhenSyncUsingData(bool value) =>
      _saveData(SettingKeys.notifyWhenSyncUsingData, value);

  String get displayLanguage => _getData(SettingKeys.displayLanguage) ?? 'en';
  set displayLanguage(String value) =>
      _saveData(SettingKeys.displayLanguage, value);

  dynamic _getData(SettingKeys key) {
    var value = _prefs.get(key.toString());
    debugPrint('Retrieved $key: $value');
    notifyListeners();
    return value;
  }

  void _saveData(SettingKeys key, dynamic value) {
    debugPrint('Saving $key: $value');
    if (value is String) {
      _prefs.setString(key.toString(), value);
    } else if (value is int) {
      _prefs.setInt(key.toString(), value);
    } else if (value is double) {
      _prefs.setDouble(key.toString(), value);
    } else if (value is bool) {
      _prefs.setBool(key.toString(), value);
    } else if (value is List<String>) {
      _prefs.setStringList(key.toString(), value);
    }
    notifyListeners();
  }
}

enum SettingKeys {
  uploadSizeLimit,
  downloadSizeLimit,
  uploadSizeLimitWhenUsingData,
  downloadSizeLimitWhenUsingData,
  notifyWhenSyncUsingData,

  displayLanguage,
  colorScheme,
  followSystemTheme,
}

enum AppTheme {
  light,
  dark,
}
