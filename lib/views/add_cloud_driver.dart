import 'package:flutter/material.dart';

class AddCloudDriverPage extends StatefulWidget {
  const AddCloudDriverPage({super.key});

  @override
  State<AddCloudDriverPage> createState() => _AddCloudDriverPageState();
}

class _AddCloudDriverPageState extends State<AddCloudDriverPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _typeController;
  late TextEditingController _addressController;
  late TextEditingController _userIdController;

  @override
  void initState() {
    super.initState();
    _typeController = TextEditingController();
    _addressController = TextEditingController();
    _userIdController = TextEditingController();
  }

  @override
  void dispose() {
    _typeController.dispose();
    _addressController.dispose();
    _userIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Cloud Driver'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: _showHelpDialog,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveCloudDriver,
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
                controller: _typeController,
                decoration: const InputDecoration(labelText: 'Type'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a type';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _userIdController,
                decoration: const InputDecoration(labelText: 'User ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a user ID';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveCloudDriver() {
    if (_formKey.currentState!.validate()) {
      // Save cloud driver configuration using controller
      // For example: cloudDriverController.addCloudDriver(CloudDriver(...));
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
