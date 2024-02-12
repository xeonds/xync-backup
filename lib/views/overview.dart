import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/sync_service.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xync Backup'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          SyncStatusCard(),
          SizedBox(height: 16.0),
          FilesDiffCard(),
          SizedBox(height: 16.0),
          CloudDriversCard(),
        ],
      ),
    );
  }
}

class SyncStatusCard extends StatelessWidget {
  const SyncStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final syncService = Provider.of<SyncService>(context, listen: true);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sync Status',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            const Text('Last Sync Time: [Replace with actual time]'),
            const Text('Ended At: [Replace with actual time]'),
            const Text('Time Spent: [Replace with actual time]'),
            Text(
                'Syncing: ${syncService.isSyncing ? syncService.isPaused ? 'Paused' : 'Yes' : 'No'}'),
          ],
        ),
      ),
    );
  }
}

class FilesDiffCard extends StatelessWidget {
  const FilesDiffCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Files Diff',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('Files Uploaded: [Replace with actual count]'),
            Text('Files Downloaded: [Replace with actual count]'),
            Text('Total Size Uploaded: [Replace with actual size]'),
            Text('Total Size Downloaded: [Replace with actual size]'),
          ],
        ),
      ),
    );
  }
}

class CloudDriversCard extends StatelessWidget {
  const CloudDriversCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cloud Drivers',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            CloudDriverItem(
              title: 'WebDAV',
              userId: 'user1',
              address: 'http://webdav.example.com',
              totalSpace: '100 GB',
              usedSpace: '50 GB',
            ),
            CloudDriverItem(
              title: 'SMB',
              userId: 'user2',
              address: 'smb://smb.example.com',
              totalSpace: '200 GB',
              usedSpace: '100 GB',
            ),
            // Add more CloudDriverItem widgets for other drivers
          ],
        ),
      ),
    );
  }
}

class CloudDriverItem extends StatelessWidget {
  final String title;
  final String userId;
  final String address;
  final String totalSpace;
  final String usedSpace;

  const CloudDriverItem({
    super.key,
    required this.title,
    required this.userId,
    required this.address,
    required this.totalSpace,
    required this.usedSpace,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Title: $title'),
        Text('User ID: $userId'),
        Text('Address: $address'),
        Text('Total Space: $totalSpace'),
        Text('Used Space: $usedSpace'),
        const Divider(),
      ],
    );
  }
}
