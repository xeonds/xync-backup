import 'package:flutter/material.dart';
import 'package:xync_backup/views/add_cloud_driver.dart';

import '../models/models.dart';
import 'add_sync_folder.dart';

class ConfiguredFoldersPage extends StatelessWidget {
  const ConfiguredFoldersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Folders & Cloud Drivers'),
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Folders'),
              Tab(text: 'Cloud Drivers'),
            ],
            isScrollable: true,
            indicatorColor: Theme.of(context).colorScheme.inversePrimary,
            labelColor: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        body: const TabBarView(
          children: [
            ConfiguredFoldersTab(),
            CloudDriversTab(),
          ],
        ),
      ),
    );
  }
}

class ConfiguredFoldersTab extends StatefulWidget {
  const ConfiguredFoldersTab({super.key});

  @override
  State<ConfiguredFoldersTab> createState() => _ConfiguredFoldersTabState();
}

class _ConfiguredFoldersTabState extends State<ConfiguredFoldersTab> {
  final List<SyncEntity> _syncEntities = [
    SyncEntity(
      folderName: 'Documents',
      source: '/documents',
      destination: 'WebDAV Driver A',
      method: SyncMethod.uploadOnly,
      isEnabled: true,
    ),
    SyncEntity(
      folderName: 'Photos',
      source: '/photos',
      destination: 'SMB Driver B',
      method: SyncMethod.downloadOnly,
      isEnabled: false,
    ),
    SyncEntity(
      folderName: 'Videos',
      source: '/videos',
      destination: 'FTP Driver C',
      method: SyncMethod.twoWaySync,
      isEnabled: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ReorderableListView(
          padding: const EdgeInsets.all(8),
          children: _syncEntities.map((entity) {
            return Card(
              margin: const EdgeInsets.all(8),
              key: ValueKey(entity),
              child: ListTile(
                title: Text(entity.folderName),
                subtitle: Text(
                    'Src: ${entity.source}\nDest: ${entity.destination}\nMethod: ${entity.method}'),
                trailing: Switch(
                  value: entity.isEnabled,
                  onChanged: (value) {
                    setState(() {
                      entity.isEnabled = value;
                    });
                  },
                ),
                onTap: () => _showPopupMenu(context, entity),
              ),
            );
          }).toList(),
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final SyncEntity item = _syncEntities.removeAt(oldIndex);
              _syncEntities.insert(newIndex, item);
            });
          }),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddSyncFolderPage()),
            ),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 72)
        ],
      ),
    );
  }

  void _showPopupMenu(BuildContext context, SyncEntity entity) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(
          overlay.localToGlobal(Offset.zero),
          overlay.localToGlobal(overlay.size.bottomRight(Offset.zero)),
        ),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit'),
            onTap: () {
              Navigator.pop(context);
              _editEntity(entity);
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.sync),
            title: const Text('Sync Immediately'),
            onTap: () {
              Navigator.pop(context);
              _syncImmediately(entity);
            },
          ),
        ),
      ],
    );
  }

  void _editEntity(SyncEntity entity) {
    // Implement editing logic here
  }

  void _syncImmediately(SyncEntity entity) {
    // Implement immediate sync logic here
  }
}

class CloudDriversTab extends StatefulWidget {
  const CloudDriversTab({super.key});
  @override
  State<CloudDriversTab> createState() => _CloudDriversTabState();
}

class _CloudDriversTabState extends State<CloudDriversTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: cloudDrivers.length,
        itemBuilder: (context, index) {
          final driver = cloudDrivers[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(Icons.upload),
              title: Text(driver.type),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(driver.address),
                  Text(driver.userId),
                ],
              ),
              trailing: TextButton(
                child: const Text('Edit'),
                onPressed: () {
                  // Handle edit button tap
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddCloudDriverPage())),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 72)
        ],
      ),
    );
  }

  List<CloudDriver> cloudDrivers = [
    CloudDriver(
        type: 'WebDAV',
        userId: 'user1',
        address: 'http://webdav.example.com',
        token: "null"),
    CloudDriver(
        type: 'SMB',
        userId: 'user2',
        address: 'smb://smb.example.com',
        token: "null"),
    // Add more cloud drivers as needed
  ];
}
