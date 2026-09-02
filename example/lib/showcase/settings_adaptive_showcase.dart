import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

import 'common.dart';
import 'showcase_scaffold.dart';

/// Settings and adaptive showcase.

class SettingsAdaptiveShowcase extends StatefulWidget {
  const SettingsAdaptiveShowcase({super.key});

  @override
  State<SettingsAdaptiveShowcase> createState() =>
      _SettingsAdaptiveShowcaseState();
}

class _SettingsAdaptiveShowcaseState extends State<SettingsAdaptiveShowcase> {
  int _adaptiveIndex = 0;
  bool _pushNotifications = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return ShowcaseScaffold(
      title: 'Settings & Adaptive Layouts',
      child: Column(
        children: [
          ShowcaseTile(
            name: 'UISettingsPageScaffold',
            child: UIPrimaryTextButton(
              text: 'Open Settings Page Demo',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (ctx) => UISettingsPageScaffold(
                      title: 'Account Settings',
                      onSave: () {
                        UIToastManager.show(
                          ctx,
                          message: 'Settings saved successfully',
                          icon: Icons.check_circle_outline,
                        );
                        Navigator.of(ctx).pop();
                      },
                      body: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          const UISettingsSectionLabel(label: 'PREFERENCES'),
                          UISettingsSwitchTile(
                            leading: UISettingsTiles.materialIconLeading(
                              ctx,
                              icon: Icons.notifications_active_outlined,
                            ),
                            title: 'Push Notifications',
                            subtitle: 'Receive real-time system alerts',
                            value: _pushNotifications,
                            onChanged: (val) =>
                                setState(() => _pushNotifications = val),
                          ),
                          UISettingsSwitchTile(
                            leading: UISettingsTiles.materialIconLeading(
                              ctx,
                              icon: Icons.dark_mode_outlined,
                            ),
                            title: 'Dark Mode Override',
                            subtitle: 'Force app dark theme',
                            value: _darkMode,
                            onChanged: (val) =>
                                setState(() => _darkMode = val),
                          ),
                          const SizedBox(height: 16),
                          const UISettingsSectionLabel(label: 'ACCOUNT & SECURITY'),
                          UISettingsNavigationTile(
                            leading: UISettingsTiles.materialIconLeading(
                              ctx,
                              icon: Icons.lock_outline,
                            ),
                            title: 'Change Password',
                            subtitle: 'Last changed 3 months ago',
                            onTap: () {},
                          ),
                          UISettingsNavigationTile(
                            leading: UISettingsTiles.materialIconLeading(
                              ctx,
                              icon: Icons.verified_user_outlined,
                            ),
                            title: 'Two-Factor Authentication',
                            subtitle: 'Enabled',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          ShowcaseTile(
            name: 'UIDynamicOverflow',
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const UIText(
                    'Dynamic Overflow Toolbar (Resize width to test)',
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 12),
                  UIDynamicOverflow(
                    spacing: 8,
                    overflowBuilder: (context, hiddenIndices) {
                      return UIDynamicOverflowMenuButton(
                        hiddenIndices: hiddenIndices,
                        menuItems: const [
                          UIContextMenuItem(
                            label: 'Format Document',
                            icon: Icons.format_align_left_rounded,
                          ),
                          UIContextMenuItem(
                            label: 'Export Data',
                            icon: Icons.download_rounded,
                          ),
                          UIContextMenuItem(
                            label: 'Share Project',
                            icon: Icons.share_rounded,
                          ),
                        ],
                      );
                    },
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('New Item'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.filter_list, size: 16),
                        label: const Text('Filter'),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.refresh),
                        tooltip: 'Refresh',
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.file_download_outlined),
                        tooltip: 'Download',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UIAdaptiveScaffold',
            child: UIPrimaryTextButton(
              text: 'Open Adaptive Scaffold Demo',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (ctx) => StatefulBuilder(
                      builder: (context, setDemoState) {
                        return UIAdaptiveScaffold(
                          appBar: AppBar(
                            title: const Text('Adaptive Layout Screen'),
                          ),
                          selectedIndex: _adaptiveIndex,
                          onDestinationSelected: (idx) =>
                              setDemoState(() => _adaptiveIndex = idx),
                          destinations: const [
                            UIAdaptiveDestination(
                              icon: Icon(Icons.home_outlined),
                              selectedIcon: Icon(Icons.home),
                              label: 'Overview',
                            ),
                            UIAdaptiveDestination(
                              icon: Icon(Icons.analytics_outlined),
                              selectedIcon: Icon(Icons.analytics),
                              label: 'Analytics',
                            ),
                            UIAdaptiveDestination(
                              icon: Icon(Icons.settings_outlined),
                              selectedIcon: Icon(Icons.settings),
                              label: 'Settings',
                            ),
                          ],
                          body: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _adaptiveIndex == 0
                                      ? Icons.home
                                      : _adaptiveIndex == 1
                                          ? Icons.analytics
                                          : Icons.settings,
                                  size: 64,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(height: 16),
                                UIText(
                                  'Active View: Destination ${_adaptiveIndex + 1}',
                                  size: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                const SizedBox(height: 8),
                                const UIText(
                                  'Resize window width to see NavigationBar (Mobile) change to NavigationRail (Tablet/Desktop).',
                                  textAlign: TextAlign.center,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
