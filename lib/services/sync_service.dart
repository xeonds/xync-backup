import 'package:flutter/foundation.dart';

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

  void syncFiles(SyncFolder rule) {
    if (kDebugMode) {
      print(
          'Syncing ${rule.localPath} to ${rule.cloudPath} using ${rule.method} method...');
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
