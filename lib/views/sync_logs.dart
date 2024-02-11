import 'package:flutter/material.dart';

import '../models/models.dart';

class SyncLogsPage extends StatefulWidget {
  const SyncLogsPage({super.key});

  @override
  State<SyncLogsPage> createState() => _SyncLogsPageState();
}

class _SyncLogsPageState extends State<SyncLogsPage> {
  final List<SyncLog> _syncLogs = [
    SyncLog(
      time: DateTime.now(),
      destination: 'WebDAV',
      filename: 'file1.txt',
      type: SyncLogType.success,
      details: 'File uploaded successfully',
    ),
    SyncLog(
      time: DateTime.now(),
      destination: 'SMB',
      filename: 'file2.txt',
      type: SyncLogType.info,
      details: 'File downloaded successfully',
    ),
    SyncLog(
      time: DateTime.now(),
      destination: 'FTP',
      filename: 'file3.txt',
      type: SyncLogType.error,
      details: 'File upload failed',
    ),
  ];

  void _clearLogs() {
    setState(() {
      _syncLogs.clear();
    });
  }

  void _showLogDetails(SyncLog log) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Details'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Filename: ${log.filename}'),
            Text('Destination: ${log.destination}'),
            Text('Type: ${log.type.toString().split('.').last}'),
            Text('Details: ${log.details}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _clearLogs,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _syncLogs.length,
        itemBuilder: (context, index) {
          final log = _syncLogs[index];
          Color textColor;
          switch (log.type) {
            case SyncLogType.success:
              textColor = Colors.green;
              break;
            case SyncLogType.info:
              textColor = Colors.blue;
              break;
            case SyncLogType.error:
              textColor = Colors.red;
              break;
          }
          return ListTile(
            onTap: () => _showLogDetails(log),
            title: Text(
              '${log.destination} - ${log.filename}',
              style: TextStyle(color: textColor),
            ),
            subtitle:
                Text('${log.time.hour}:${log.time.minute}:${log.time.second}'),
          );
        },
      ),
    );
  }
}
