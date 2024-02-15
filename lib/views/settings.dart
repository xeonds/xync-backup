import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xync_backup/services/shared_preferences_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final prefs = Provider.of<SharedPreferencesService>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
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
                subtitle: Text(prefs.uploadSizeLimit.toString()),
                onTap: () => showTextInputDialog(
                    context,
                    "Upload size limit",
                    "Enter new value",
                    (value) => setState(
                        () => prefs.uploadSizeLimit = int.parse(value))),
              ),
              ListTile(
                title: const Text('Download size limit when using Wi-Fi'),
                subtitle: Text(prefs.downloadSizeLimit.toString()),
                onTap: () => showTextInputDialog(
                    context,
                    "Download size limit",
                    "Enter new value",
                    (value) => setState(
                        () => prefs.downloadSizeLimit = int.parse(value))),
              ),
              ListTile(
                title: const Text('Upload size limit when using data'),
                subtitle: Text(prefs.uploadSizeLimitWhenUsingData.toString()),
                onTap: () => showTextInputDialog(
                    context,
                    "Upload size limit",
                    "Enter new value",
                    (value) => setState(() =>
                        prefs.uploadSizeLimitWhenUsingData = int.parse(value))),
              ),
              ListTile(
                title: const Text('Download size limit when using data'),
                subtitle: Text(prefs.downloadSizeLimitWhenUsingData.toString()),
                onTap: () => showTextInputDialog(
                    context,
                    "Download size limit",
                    "Enter new value",
                    (value) => setState(() => prefs
                        .downloadSizeLimitWhenUsingData = int.parse(value))),
              ),
              ListTile(
                title: const Text('Notify when sync using data'),
                subtitle: const Text('Check before manual sync'),
                trailing: Checkbox(
                    value: prefs.notifyWhenSyncUsingData,
                    onChanged: (bool? value) =>
                        prefs.notifyWhenSyncUsingData = value!),
                onTap: () => prefs.notifyWhenSyncUsingData =
                    !prefs.notifyWhenSyncUsingData,
              ),
              ListTile(
                title: const Text('Other settings'),
                onTap: () => showMessageDialog(
                    context, 'Other settings', 'Under construction'),
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
                subtitle: Text(prefs.displayLanguage),
                onTap: () => showRadioDialog(
                    context,
                    "Display language",
                    ["English", "简体中文", "繁體中文"],
                    prefs.displayLanguage,
                    (value) => setState(() => prefs.displayLanguage = value)),
              ),
              ListTile(
                title: const Text('Color scheme'),
                subtitle: Text('${prefs.colorScheme} - Reload to take effect'),
                onTap: () => showRadioDialog(
                    context,
                    'Color Scheme',
                    AppTheme.values.map((e) => e.toString()).toList(),
                    prefs.colorScheme,
                    (p0) => setState(() => prefs.colorScheme = p0)),
              ),
              ListTile(
                title: const Text('Follow system theme'),
                onTap: () => setState(
                    () => prefs.followSystemTheme = !prefs.followSystemTheme),
                trailing: Switch(
                  value: prefs.followSystemTheme,
                  onChanged: (value) =>
                      setState(() => prefs.followSystemTheme = value),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSection(
            title: "MISC",
            children: [
              // ListTile(
              //   title: const Text('Notification'),
              //   onTap: () {},
              //   trailing: IconButton(
              //     icon: const Icon(Icons.arrow_forward),
              //     onPressed: () {},
              //   ),
              // ),
              // ListTile(
              //   title: const Text('Safety'),
              //   onTap: () {},
              //   trailing: IconButton(
              //     icon: const Icon(Icons.arrow_forward),
              //     onPressed: () {},
              //   ),
              // ),
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
          ),
          const SizedBox(height: 20),
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
  void showTextInputDialog(BuildContext context, String title, String content,
          Function(String) ok) =>
      showDialog(
        context: context,
        builder: (BuildContext context) {
          final TextEditingController controller = TextEditingController();
          return AlertDialog(
            title: Text(title),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: content),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  ok(controller.text);
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

  void showRadioDialog(BuildContext context, String title, List<String> options,
          String selected, Function(String) ok) =>
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: options
                  .map((e) => RadioListTile(
                        title: Text(e),
                        value: e,
                        groupValue: selected,
                        onChanged: (String? value) {
                          ok(value!);
                          Navigator.of(context).pop();
                        },
                      ))
                  .toList(),
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
}
