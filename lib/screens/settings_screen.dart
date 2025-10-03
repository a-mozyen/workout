import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../workout_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkoutProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'App'),
            Tab(text: 'Notifications'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _AppSettingsTab(provider: provider),
          const _NotificationSettingsTab(),
        ],
      ),
    );
  }
}

class _AppSettingsTab extends StatelessWidget {
  final WorkoutProvider provider;
  const _AppSettingsTab({required this.provider});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        DropdownButtonFormField<String>(
          initialValue: provider.languageCode,
          decoration: const InputDecoration(labelText: 'Language'),
          items: const [
            DropdownMenuItem(value: 'en', child: Text('English')),
            DropdownMenuItem(value: 'ar', child: Text('Arabic')),
          ],
          onChanged: (v) {
            if (v != null) provider.setLanguageCode(v);
          },
        ),
      ],
    );
  }
}

class _NotificationSettingsTab extends StatelessWidget {
  const _NotificationSettingsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ListTile(
          title: Text('Workout reminder'),
          subtitle: Text('Coming soon'),
        ),
      ],
    );
  }
}
