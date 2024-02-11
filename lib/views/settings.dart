import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _followSystemDark = false;
  final TextEditingController _controllerServerUrl = TextEditingController();
  final TextEditingController _controllerAPIKey = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _followSystemDark = prefs.getBool("followSystemDark") ?? false;
      _controllerServerUrl.text = prefs.getString("serverUrl") ?? '';
      _controllerAPIKey.text = prefs.getString("apiKey") ?? '';
    });
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
          Card(
              child: Column(
            children: [
              const SizedBox(height: 10),
              _buildListSubtitle("Sync Settings"),
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
          )),
          const SizedBox(height: 20),
          Card(
              child: Column(
            children: [
              const SizedBox(height: 10),
              _buildListSubtitle("Language & Appearance"),
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
                  final prefs = await SharedPreferences.getInstance();
                  final value = prefs.getBool('followSystemDark') ?? false;
                  setState(() {
                    _followSystemDark = !value;
                    prefs.setBool('followSystemDark', !value);
                  });
                },
                trailing: Switch(
                  value: _followSystemDark,
                  onChanged: (value) async {
                    final prefs = await SharedPreferences.getInstance();
                    setState(() {
                      _followSystemDark = value;
                      prefs.setBool('followSystemDark', value);
                    });
                  },
                ),
              ),
            ],
          )),
          const SizedBox(height: 20),
          Card(
            child: Column(
              children: [
                const SizedBox(height: 10),
                _buildListSubtitle("MISC"),
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

  Widget _buildListSubtitle(String text) {
    return Row(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      )
    ]);
  }
}

void showMessageDialog(BuildContext context, String title, String content) {
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
