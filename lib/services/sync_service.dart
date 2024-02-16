import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../models/models.dart';

class SyncRule {
  final String source;
  final String destination;
  final String method;

  SyncRule({
    required this.source,
    required this.destination,
    required this.method,
  });

  factory SyncRule.fromJson(Map<String, dynamic> json) {
    return SyncRule(
      source: json['source'],
      destination: json['destination'],
      method: json['method'],
    );
  }
}

class SyncService extends ChangeNotifier {
  bool _isSyncing = false;
  bool _isPaused = false;

  bool get isSyncing => _isSyncing;
  bool get isPaused => _isPaused;

  Future<void> init() async {}

  List<SyncRule> readSyncRules() {
    String jsonContent = File('sync_rules.json').readAsStringSync();
    List<dynamic> jsonList = json.decode(jsonContent);
    return jsonList.map((json) => SyncRule.fromJson(json)).toList();
  }

  void syncFiles(SyncRule rule) {
    if (kDebugMode) {
      print(
          'Syncing ${rule.source} to ${rule.destination} using ${rule.method} method...');
    }
  }

  void startSync() {
    _isSyncing = true;
    notifyListeners();
    List<SyncRule> syncRules = readSyncRules();
    for (var rule in syncRules) {
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

class SyncFolderController {
  List<SyncFolder> _syncFolders = [];

  Future<void> loadSyncFolders() async {
    try {
      final jsonString = await File('sync_folders.json').readAsString();
      final jsonData = json.decode(jsonString);
      _syncFolders =
          jsonData.map<SyncFolder>((item) => item as SyncFolder).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading sync folders: $e');
      }
    }
  }

  List<SyncFolder> get syncFolders => _syncFolders;

  Future<void> addSyncFolder(SyncFolder folder) async {
    _syncFolders.add(folder);
    await _saveSyncFolders();
  }

  Future<void> editSyncFolder(SyncFolder folder) async {
    final index = _syncFolders.indexWhere((element) => element.id == folder.id);
    if (index != -1) {
      _syncFolders[index] = folder;
      await _saveSyncFolders();
    }
  }

  Future<void> deleteSyncFolder(String id) async {
    _syncFolders.removeWhere((element) => element.id == id);
    await _saveSyncFolders();
  }

  Future<void> _saveSyncFolders() async {
    final jsonString = json.encode(_syncFolders);
    await File('sync_folders.json').writeAsString(jsonString);
  }
}

class CloudDriverController {
  List<CloudDriver> _cloudDrivers = [];

  Future<void> loadCloudDrivers() async {
    try {
      final jsonString = await File('cloud_drivers.json').readAsString();
      final jsonData = json.decode(jsonString);
      _cloudDrivers =
          jsonData.map<CloudDriver>((item) => item as CloudDriver).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading cloud drivers: $e');
      }
    }
  }

  List<CloudDriver> get cloudDrivers => _cloudDrivers;

  Future<void> addCloudDriver(CloudDriver driver) async {
    _cloudDrivers.add(driver);
    await _saveCloudDrivers();
  }

  Future<void> editCloudDriver(CloudDriver driver) async {
    final index =
        _cloudDrivers.indexWhere((element) => element.id == driver.id);
    if (index != -1) {
      _cloudDrivers[index] = driver;
      await _saveCloudDrivers();
    }
  }

  Future<void> deleteCloudDriver(String id) async {
    _cloudDrivers.removeWhere((element) => element.id == id);
    await _saveCloudDrivers();
  }

  Future<void> _saveCloudDrivers() async {
    final jsonString = json.encode(_cloudDrivers);
    await File('cloud_drivers.json').writeAsString(jsonString);
  }
}

// TODO: write controller that provides CRUD functions for folders and cloud drivers
// TODO: implement cloud drivers in different protocols and provide same apis for sync
// TODO: implement workers function, which do sync works with generic api of driver options
// TODO: handle exceptions for file sync
// TODO: write log using logger service