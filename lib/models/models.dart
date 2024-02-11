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
  String method;
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
