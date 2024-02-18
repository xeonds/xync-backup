import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class SyncFolder {
  final String id;
  final String name;
  final String localPath;
  final String cloudPath;
  final SyncMethod method;
  final CloudDriver driver;
  bool isEnabled;

  SyncFolder(
      {required this.id,
      required this.name,
      required this.localPath,
      required this.cloudPath,
      required this.method,
      required this.driver,
      required this.isEnabled});
}

class CloudDriver {
  String id = '';
  final String type;
  final String address;
  final String userId;
  final String token;

  CloudDriver(
      {required this.type,
      required this.address,
      required this.userId,
      required this.token});
}

enum SyncLogType { success, info, error }

class SyncLog {
  final DateTime time;
  final String destination;
  final String filename;
  final SyncLogType type;
  final String details;

  SyncLog({
    required this.time,
    required this.destination,
    required this.filename,
    required this.type,
    required this.details,
  });
}

enum SyncMethod {
  twoWaySync,
  uploadOnly,
  downloadOnly,
  deleteAfterUpload,
  deleteAfterDownload,
  uploadMirror,
  downloadMirror,
}

class CRUD<T> {
  late String _fileName;
  late File _file;

  CRUD(String fileName) {
    _fileName = fileName;
  }

  Future<CRUD> init() async {
    final directory = await getApplicationDocumentsDirectory();
    _file = File('${directory.path}/$_fileName');
    if (!_file.existsSync()) {
      await _file.create();
    }

    return this;
  }

  Future<List<T>> readAll() async {
    try {
      if (!_file.existsSync()) return [];
      final jsonData = await _file.readAsString();
      final List<dynamic> jsonList = json.decode(jsonData);
      return jsonList.map((item) => _fromJson(item)).toList().cast<T>();
    } catch (e) {
      return [];
    }
  }

  Future<void> create(T data) async {
    try {
      List<T> dataList = await readAll();
      dataList.add(data);
      final jsonData = json.encode(dataList.map((item) => item).toList());
      await _file.writeAsString(jsonData);
    } catch (e) {
      if (kDebugMode) {
        print("Error creating data: $e");
      }
    }
  }

  Future<void> update(T oldData, T newData) async {
    try {
      List<T> dataList = await readAll();
      final index = dataList.indexOf(oldData);
      if (index != -1) {
        dataList[index] = newData;
        final jsonData = json.encode(dataList.map((item) => item).toList());
        await _file.writeAsString(jsonData);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error updating data: $e");
      }
    }
  }

  Future<void> delete(T data) async {
    try {
      List<T> dataList = await readAll();
      dataList.remove(data);
      final jsonData = json.encode(dataList.map((item) => item).toList());
      await _file.writeAsString(jsonData);
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting data: $e");
      }
    }
  }

  T _fromJson(dynamic json) {
    return json as T;
  }
}
