import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/models.dart';

class SyncService extends ChangeNotifier {
  bool _isSyncing = false;
  bool _isPaused = false;
  late CRUD rules, logs, drivers;
  late List<SyncFolder> syncFolders;
  late List<CloudDriver> cloudDrivers;

  bool get isSyncing => _isSyncing;
  bool get isPaused => _isPaused;

  Future<void> init() async {
    rules = await CRUD('sync_rules.json').init();
    logs = await CRUD('sync_logs.json').init();
    drivers = await CRUD('cloud_drivers.json').init();
    syncFolders = await readSyncFolders();
    cloudDrivers = await readCloudDrivers();
  }

  Future<List<SyncFolder>> readSyncFolders() async {
    final data = await rules.readAll();
    return data.cast<SyncFolder>();
  }

  Future<List<CloudDriver>> readCloudDrivers() async {
    final data = await drivers.readAll();
    return data.cast<CloudDriver>();
  }

  Future<void> syncFiles(SyncFolder rule) async {
    if (kDebugMode) {
      print(
          'Syncing ${rule.localPath} to ${rule.cloudPath} using ${rule.method} method...');
    }
    if (rule.localPath.isEmpty || rule.cloudPath.isEmpty) {
      if (kDebugMode) {
        print('Please select a folder and cloud destination.');
      }
      return;
    }

    final files = Directory(rule.localPath).listSync();

    for (var file in files) {
      if (file is File) {
        try {
          uploadFileToWebDav(
              rule.cloudPath, rule.cloudPath, rule.cloudPath, file);
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      }
    }
  }

  void startSync() {
    _isSyncing = true;
    notifyListeners();
    for (var rule in syncFolders) {
      syncFiles(rule);
    }
  }

  void stopSync() {
    _isSyncing = false;
    _isPaused = false;
    notifyListeners();
  }

  void pauseSync() {
    _isPaused = true;
    notifyListeners();
  }

  void resumeSync() {
    _isPaused = false;
    notifyListeners();
  }
}

Future<void> uploadFileToWebDav(
    String url, String username, String password, File file) async {
  var bytes = await file.readAsBytes();
  var uri = Uri.parse(url);

  var basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

  var request = http.Request('PUT', uri)
    ..headers['authorization'] = basicAuth
    ..bodyBytes = bytes;

  var response = await request.send();

  if (response.statusCode == 201) {
    if (kDebugMode) {
      print('Failed to upload file: ${response.statusCode}');
    }
  }
}
