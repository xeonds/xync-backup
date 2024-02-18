import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:webdav_client/webdav_client.dart';

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
    final files = Directory(rule.localPath).listSync();
    final client = getStorageService(
        cloudDrivers.firstWhere((driver) => driver.id == rule.driver.id,
            orElse: () => CloudDriver(
                  type: rule.driver.type,
                  address: rule.driver.address,
                  userId: rule.driver.userId,
                  token: rule.driver.token,
                )));

    for (var file in files) {
      if (file is File) {
        try {
          switch (rule.method) {
            case SyncMethod.twoWaySync:
              await client.uploadFile(file as File, rule);
              break;
            case SyncMethod.uploadOnly:
              await client.uploadFile(file as File, rule);
              break;
            case SyncMethod.downloadOnly:
              break;
            case SyncMethod.uploadMirror:
              break;
            case SyncMethod.downloadMirror:
              break;
            case SyncMethod.deleteAfterUpload:
              break;
            case SyncMethod.deleteAfterDownload:
              break;
            default:
              if (kDebugMode) {
                print('Invalid sync method');
              }
          }
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

abstract class StorageService {
  Future<void> uploadFile(File file, SyncFolder rule);
}

StorageService getStorageService(CloudDriver driver) {
  switch (driver.type) {
    case 'WebDAV':
      return WebDAVService(driver);
    case 'SMB':
    // return SMBService(driver);
    case 'FTP':
    // return FTPService(driver);
    default:
      throw UnimplementedError('Unsupported cloud driver type');
  }
}

class WebDAVService implements StorageService {
  final CloudDriver driver;
  late final Client webdav;

  WebDAVService(this.driver) {
    webdav =
        newClient(driver.address, user: driver.userId, password: driver.token);
  }

  @override
  Future<void> uploadFile(File file, SyncFolder rule) async {
    try {
      await webdav.writeFromFile(
        '${rule.localPath}/${file.path!}',
        '${rule.cloudPath}/${file.path!}',
        onProgress: (count, total) {
          // TODO: Add progress bar
          if (kDebugMode) {
            print('Upload progress: ${(count / total) * 100}%');
          }
        },
      );
      if (kDebugMode) {
        print('File uploaded successfully.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading file: $e');
      }
    }
  }
}
