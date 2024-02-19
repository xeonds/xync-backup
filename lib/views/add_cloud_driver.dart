import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xync_backup/models/models.dart';
import 'package:xync_backup/services/sync_service.dart';

class AddCloudDriverPage extends StatefulWidget {
  const AddCloudDriverPage({super.key});

  @override
  State<AddCloudDriverPage> createState() => _AddCloudDriverPageState();
}

class _AddCloudDriverPageState extends State<AddCloudDriverPage> {
  final _formKey = GlobalKey<FormState>();
  late SyncService syncService;
  late TextEditingController _typeController,
      _addressController,
      _userIdController,
      _tokenController;

  @override
  void initState() {
    super.initState();
    _typeController = TextEditingController();
    _addressController = TextEditingController();
    _userIdController = TextEditingController();
    _tokenController = TextEditingController();
    syncService = Provider.of<SyncService>(context, listen: true);
  }

  @override
  void dispose() {
    _typeController.dispose();
    _addressController.dispose();
    _userIdController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Add Cloud Driver'), actions: [
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: _showHelpDialog,
          )
        ]),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                    controller: _typeController,
                    decoration: const InputDecoration(labelText: 'Type'),
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Please enter a type'
                        : null),
                TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Please enter an address'
                        : null),
                TextFormField(
                    controller: _userIdController,
                    decoration: const InputDecoration(labelText: 'User ID'),
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Please enter a user id'
                        : null),
                TextFormField(
                    controller: _tokenController,
                    decoration: const InputDecoration(labelText: 'Token'),
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Please enter a token'
                        : null),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _saveCloudDriver,
          child: const Icon(Icons.save),
        ));
  }

  void _saveCloudDriver() {
    if (_formKey.currentState!.validate()) {
      syncService.drivers.create(CloudDriver(
        type: _typeController.text,
        address: _addressController.text,
        userId: _userIdController.text,
        token: _tokenController.text,
      ));
      Navigator.pop(context);
    }
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Help'),
          content:
              const Text('This is a help dialog for adding cloud drivers.'),
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
