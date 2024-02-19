import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xync_backup/services/sync_service.dart';

import '../models/models.dart';

class AddSyncFolderPage extends StatefulWidget {
  const AddSyncFolderPage({super.key});

  @override
  State<AddSyncFolderPage> createState() => _AddSyncFolderPageState();
}

class _AddSyncFolderPageState extends State<AddSyncFolderPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _cloudDriverPathController;
  late TextEditingController _localFolderController;
  String _syncMethod = '2-way sync';
  String _selectedDriver = CloudDriver(
    type: 'webdav',
    address: 'https://webdav.example.com',
    userId: 'user',
    token: 'password',
  ).toString();
  bool _includeSubdirs = false;
  bool _includeHiddenFiles = false;
  bool _deleteEmptySubdirs = false;
  bool _useDefaultSyncStrategy = true;
  bool _enableSyncPairs = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _cloudDriverPathController = TextEditingController();
    _localFolderController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cloudDriverPathController.dispose();
    _localFolderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final syncService = Provider.of<SyncService>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Sync Folder'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: _showHelpDialog,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSyncFolder,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Sync Pair Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              // DropdownButtonFormField<String>(
              //   value: _selectedDriver.isNotEmpty ? _selectedDriver : 'empty',
              //   onChanged: (value) => setState(() => _selectedDriver = value!),
              //   items: syncService.cloudDrivers.isNotEmpty
              //       ? syncService.cloudDrivers
              //           .map((item) => DropdownMenuItem(
              //                 value: item.id +
              //                     item.type +
              //                     item.address +
              //                     item.userId,
              //                 child: Text(item.toString().split('.').last),
              //               ))
              //           .toList()
              //       : [
              //           const DropdownMenuItem(
              //               value: 'empty', child: Text('No drivers available'))
              //         ],
              //   decoration: const InputDecoration(labelText: 'Cloud Driver'),
              // ),
              TextFormField(
                controller: _cloudDriverPathController,
                decoration:
                    const InputDecoration(labelText: 'Cloud Driver Path'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a path'
                    : null,
                // onTap: () async {
                //   // Open file picker
                //   final dir = Directory(
                //       await FilePicker.platform.getDirectoryPath() ?? '');
                //   if (dir.path != '') {
                //     setState(() => _cloudDriverPathController.text = dir.path);
                //   }
                // },
              ),
              TextFormField(
                controller: _localFolderController,
                decoration: const InputDecoration(labelText: 'Local Folder'),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please enter a folder path'
                    : null,
                onTap: () async {
                  // Open file picker
                  final directory = Directory(
                      await FilePicker.platform.getDirectoryPath() ?? '');
                  if (directory.path != '') {
                    setState(
                        () => _localFolderController.text = directory.path);
                  }
                },
              ),
              DropdownButtonFormField<String>(
                value: _syncMethod,
                onChanged: (value) => setState(() => _syncMethod = value!),
                items: SyncMethod.values
                    .map((method) => DropdownMenuItem(
                          value: method.toString(),
                          child: Text(method.toString().split('.').last),
                        ))
                    .toList(),
                decoration: const InputDecoration(labelText: 'Sync Method'),
              ),
              CheckboxListTile(
                  title: const Text('Include Subdirectories'),
                  value: _includeSubdirs,
                  onChanged: (value) =>
                      setState(() => _includeSubdirs = value!)),
              CheckboxListTile(
                  title: const Text('Include Hidden Files'),
                  value: _includeHiddenFiles,
                  onChanged: (value) =>
                      setState(() => _includeHiddenFiles = value!)),
              CheckboxListTile(
                  title: const Text('Delete Empty Subdirectories'),
                  value: _deleteEmptySubdirs,
                  onChanged: (value) =>
                      setState(() => _deleteEmptySubdirs = value!)),
              CheckboxListTile(
                  title: const Text('Use Default Sync Strategy'),
                  value: _useDefaultSyncStrategy,
                  onChanged: (value) =>
                      setState(() => _useDefaultSyncStrategy = value!)),
              CheckboxListTile(
                  title: const Text('Enable Sync Pairs'),
                  value: _enableSyncPairs,
                  onChanged: (value) =>
                      setState(() => _enableSyncPairs = value!)),
            ],
          ),
        ),
      ),
    );
  }

  void _saveSyncFolder() {
    if (_formKey.currentState!.validate()) {
      // Save sync folder configuration using controller
      // For example: syncFolderController.addSyncFolder(SyncFolder(...));
      Navigator.pop(context);
    }
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Help'),
          content: const Text('This is a help dialog for adding sync folders.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
