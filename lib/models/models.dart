import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class SyncFolder {
  final String id;
  final String name;
  final String localPath;
  final String cloudPath;

  SyncFolder(
      {required this.id,
      required this.name,
      required this.localPath,
      required this.cloudPath});
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

class SyncEntity {
  String folderName;
  String source;
  String destination;
  SyncMethod method;
  bool isEnabled;

  SyncEntity({
    required this.folderName,
    required this.source,
    required this.destination,
    required this.method,
    required this.isEnabled,
  });
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

class DB<T> {
  late String _fileName;

  DB(String fileName) {
    _fileName = fileName;
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  Future<List<T>> readAll() async {
    try {
      final file = await _getFile();
      if (!file.existsSync()) return [];
      final jsonData = await file.readAsString();
      final List<dynamic> jsonList = json.decode(jsonData);
      return jsonList.map((item) => _fromJson(item)).toList().cast<T>();
    } catch (e) {
      return [];
    }
  }

  Future<void> create(T data) async {
    try {
      final file = await _getFile();
      List<T> dataList = await readAll();
      dataList.add(data);
      final jsonData =
          json.encode(dataList.map((item) => _toJson(item)).toList());
      await file.writeAsString(jsonData);
    } catch (e) {
      if (kDebugMode) {
        print("Error creating data: $e");
      }
    }
  }

  Future<void> update(T oldData, T newData) async {
    try {
      final file = await _getFile();
      List<T> dataList = await readAll();
      final index = dataList.indexOf(oldData);
      if (index != -1) {
        dataList[index] = newData;
        final jsonData =
            json.encode(dataList.map((item) => _toJson(item)).toList());
        await file.writeAsString(jsonData);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error updating data: $e");
      }
    }
  }

  Future<void> delete(T data) async {
    try {
      final file = await _getFile();
      List<T> dataList = await readAll();
      dataList.remove(data);
      final jsonData =
          json.encode(dataList.map((item) => _toJson(item)).toList());
      await file.writeAsString(jsonData);
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting data: $e");
      }
    }
  }

  dynamic _toJson(T data) {
    return data;
  }

  T _fromJson(dynamic json) {
    return json as T;
  }
}
