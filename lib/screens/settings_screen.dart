import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/timer_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final timerProvider = context.watch<TimerProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Sound Settings Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alerts',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Sound'),
                    subtitle: const Text('Play sound when alerts trigger'),
                    value: timerProvider.isSoundEnabled,
                    onChanged: (_) => timerProvider.toggleSound(),
                    secondary: Icon(
                      timerProvider.isSoundEnabled
                          ? Icons.volume_up
                          : Icons.volume_off,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.vibration),
                    title: const Text('Vibration'),
                    subtitle: const Text('Always enabled for alerts'),
                    trailing: const Icon(Icons.check, color: Colors.green),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Appearance Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Appearance',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Use dark theme'),
                    value: timerProvider.isDarkMode,
                    onChanged: (_) => timerProvider.toggleTheme(),
                    secondary: Icon(
                      timerProvider.isDarkMode
                          ? Icons.dark_mode
                          : Icons.light_mode,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.screen_lock_portrait),
                    title: const Text('Keep Screen On'),
                    subtitle: const Text('Screen stays on while timer runs'),
                    trailing: const Icon(Icons.check, color: Colors.green),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // About Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('Version'),
                    subtitle: const Text('1.0.0'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined),
                    title: const Text('Privacy'),
                    subtitle: const Text('No data collected or sent'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.security_outlined),
                    title: const Text('Permissions'),
                    subtitle: const Text('Only vibration & notifications'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Features Info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Features',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem(
                    context,
                    icon: Icons.notifications_active,
                    title: 'Multiple Alerts',
                    description: 'Add unlimited alert times',
                  ),
                  _buildFeatureItem(
                    context,
                    icon: Icons.timer,
                    title: 'Background Running',
                    description: 'Timer continues when app is minimized',
                  ),
                  _buildFeatureItem(
                    context,
                    icon: Icons.flash_on,
                    title: 'Visual Flash',
                    description: 'White screen flash for alerts',
                  ),
                  _buildFeatureItem(
                    context,
                    icon: Icons.palette,
                    title: 'Modern UI',
                    description: 'Material Design 3 with animations',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
