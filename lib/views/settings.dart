import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xync_backup/services/shared_preferences_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _controllerServerUrl = TextEditingController();
  final TextEditingController _controllerAPIKey = TextEditingController();
  late SharedPreferencesService sharedPrefService;

  @override
  void initState() async {
    super.initState();
    sharedPrefService = await SharedPreferencesService.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Xync Backup"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Xync Backup',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text('Yet another file backup utility.'),
          // 功能1
          const SizedBox(height: 20),
          _buildSection(
            title: "Sync Settings",
            children: [
              ListTile(
                title: const Text('Upload size limit when using Wi-Fi'),
                subtitle: const Text('No limit'),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Download size limit when using Wi-Fi'),
                subtitle: const Text('No limit'),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Upload size limit when using data'),
                subtitle: const Text('No limit'),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Download size limit when using data'),
                subtitle: const Text('No limit'),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Notify when sync using data'),
                subtitle: const Text('Check before manual sync'),
                trailing: Checkbox(value: false, onChanged: (bool? value) {}),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Other settings'),
                onTap: () {},
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSection(
            title: "Language & Appearance",
            children: [
              ListTile(
                title: const Text('Display language'),
                subtitle: const Text('Follow system'),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Color scheme'),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Follow system brightness'),
                onTap: () async {
                  setState(() => sharedPrefService.followSystemTheme =
                      !sharedPrefService.followSystemTheme);
                },
                trailing: Switch(
                  value: sharedPrefService.followSystemTheme,
                  onChanged: (value) async {
                    setState(() => sharedPrefService.followSystemTheme = value);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSection(
            title: "MISC",
            children: [
              ListTile(
                title: const Text('Notification'),
                onTap: () {},
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {},
                ),
              ),
              ListTile(
                title: const Text('Safety'),
                onTap: () {},
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {},
                ),
              ),
              ListTile(
                title: const Text('Turn off battery optimization'),
                subtitle: const Text(
                    'Allow app to run in background to auto synchronize'),
                onTap: () =>
                    showMessageDialog(context, "Battery optimization", ":)"),
              ),
              ListTile(
                title: const Text('About'),
                subtitle: const Text('Version 1.0.0'),
                onTap: () => showMessageDialog(
                    context, "About", "Fish touching <` >-<="),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Copyright 2024 xeonds'),
              Text('All rights reserved')
            ],
          )
        ],
      ),
    );
  }

  Widget _buildListSubtitle(String text) => Row(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        )
      ]);

  Widget _buildSection(
          {String title = '', required List<Widget> children}) =>
      Card(
          child: Column(
              children: title != ''
                  ? [
                      const SizedBox(height: 10),
                      _buildListSubtitle(title),
                      ...children
                    ]
                  : [const SizedBox(height: 10), ...children]));

  void showMessageDialog(BuildContext context, String title, String content) =>
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
}
