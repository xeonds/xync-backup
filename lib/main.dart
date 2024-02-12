import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/sync_service.dart';
import 'views/configure_folders_drivers.dart';
import 'views/overview.dart';
import 'views/settings.dart';
import 'views/sync_logs.dart';

void main() {
  // startSyncService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SyncService(),
      child: MaterialApp(
        title: 'Xync Backup',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true),
        darkTheme: ThemeData(brightness: Brightness.dark),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const OverviewPage(),
    const SyncLogsPage(),
    const ConfiguredFoldersPage(),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final syncService = Provider.of<SyncService>(context, listen: true);
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        indicatorColor: Theme.of(context).colorScheme.inversePrimary,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home),
              selectedIcon: Icon(Icons.home),
              label: 'Overview'),
          NavigationDestination(
              icon: Icon(Icons.list),
              selectedIcon: Icon(Icons.list),
              label: 'Sync Logs'),
          NavigationDestination(
              icon: Icon(Icons.folder),
              selectedIcon: Icon(Icons.folder),
              label: 'Folders'),
          NavigationDestination(
              icon: Icon(Icons.settings),
              selectedIcon: Icon(Icons.settings),
              label: 'Settings')
        ],
        selectedIndex: _selectedIndex,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: _onItemTapped,
      ),
      floatingActionButton: syncService.isSyncing
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () => syncService.isPaused
                      ? syncService.resumeSync()
                      : syncService.pauseSync(),
                  child: Icon(
                      syncService.isPaused ? Icons.play_arrow : Icons.pause),
                ),
                const SizedBox(width: 16.0),
                FloatingActionButton(
                  onPressed: () => syncService.stopSync(),
                  child: const Icon(Icons.stop),
                ),
              ],
            )
          : FloatingActionButton(
              onPressed: () => syncService.startSync(),
              child: const Icon(Icons.sync),
            ),
    );
  }
}
