import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

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
              TextFormField(
                controller: _cloudDriverPathController,
                decoration:
                    const InputDecoration(labelText: 'Cloud Driver Path'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a path';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _localFolderController,
                decoration: const InputDecoration(labelText: 'Local Folder'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a folder path';
                  }
                  return null;
                },
                onTap: () async {
                  // Open file picker
                  final Directory directory = Directory(
                      await FilePicker.platform.getDirectoryPath() ?? '');
                  if (directory.path != '') {
                    setState(() {
                      _localFolderController.text = directory.path;
                    });
                  }
                },
              ),
              DropdownButtonFormField<String>(
                value: _syncMethod,
                onChanged: (value) {
                  setState(() {
                    _syncMethod = value!;
                  });
                },
                items: const [
                  DropdownMenuItem(
                    value: '2-way sync',
                    child: Text('2-way sync'),
                  ),
                  DropdownMenuItem(
                    value: 'Upload only',
                    child: Text('Upload only'),
                  ),
                  DropdownMenuItem(
                    value: 'Download only',
                    child: Text('Download only'),
                  ),
                  DropdownMenuItem(
                    value: 'Upload mirror',
                    child: Text('Upload mirror'),
                  ),
                  DropdownMenuItem(
                    value: 'Download mirror',
                    child: Text('Download mirror'),
                  ),
                  DropdownMenuItem(
                    value: 'Delete after upload',
                    child: Text('Delete after upload'),
                  ),
                  DropdownMenuItem(
                    value: 'Delete after download',
                    child: Text('Delete after download'),
                  ),
                ],
                decoration: const InputDecoration(labelText: 'Sync Method'),
              ),
              CheckboxListTile(
                title: const Text('Include Subdirectories'),
                value: _includeSubdirs,
                onChanged: (value) {
                  setState(() {
                    _includeSubdirs = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Include Hidden Files'),
                value: _includeHiddenFiles,
                onChanged: (value) {
                  setState(() {
                    _includeHiddenFiles = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Delete Empty Subdirectories'),
                value: _deleteEmptySubdirs,
                onChanged: (value) {
                  setState(() {
                    _deleteEmptySubdirs = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Use Default Sync Strategy'),
                value: _useDefaultSyncStrategy,
                onChanged: (value) {
                  setState(() {
                    _useDefaultSyncStrategy = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Enable Sync Pairs'),
                value: _enableSyncPairs,
                onChanged: (value) {
                  setState(() {
                    _enableSyncPairs = value!;
                  });
                },
              ),
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
