// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../app_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final impact = provider.impact;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                Container(
                  height: 180,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.primaryDark, AppTheme.primary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                        child: Row(
                          children: [
                            const Text(
                              'My Profile',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.settings_rounded,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppTheme.primary,
                                    AppTheme.primaryLight
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text('👤',
                                    style: TextStyle(fontSize: 28)),
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Rahul Sharma',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'rahul@email.com',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Row(
                                    children: [
                                      _LevelBadge(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.edit_rounded,
                                  size: 18, color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick stats
                  Row(
                    children: [
                      _QuickStatCard(
                          '${impact.bagsSaved}', 'Bags Saved', '🛍️'),
                      const SizedBox(width: 10),
                      _QuickStatCard(
                          '${impact.totalKgSaved} kg', 'Food Saved', '🥗'),
                      const SizedBox(width: 10),
                      _QuickStatCard(
                          '₹${impact.moneySaved.toInt()}', 'Saved', '💰'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _SettingsSection(
                    title: 'Account',
                    items: [
                      _SettingsItem(
                          Icons.location_on_rounded, 'My Location', 'Kalyan West, Mumbai'),
                      _SettingsItem(Icons.notifications_rounded,
                          'Notifications', provider.notificationsEnabled ? 'Enabled' : 'Disabled'),
                      _SettingsItem(
                          Icons.payment_rounded, 'Payment Methods', ''),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.divider),
                    ),
                    child: SwitchListTile(
                      title: const Text(
                        'Allow Notifications',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        provider.notificationsEnabled
                            ? 'You will receive order and pickup updates.'
                            : 'Turn on notifications to get live updates.',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      value: provider.notificationsEnabled,
                      onChanged: (v) async {
                        await provider.setNotificationsEnabled(v);
                      },
                      activeThumbColor: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SettingsSection(
                    title: 'Preferences',
                    items: [
                      _SettingsItem(
                          Icons.restaurant_menu_rounded, 'Dietary Preferences', 'Vegetarian'),
                      _SettingsItem(Icons.radar_rounded, 'Search Radius', '5 km'),
                      _SettingsItem(
                          Icons.language_rounded, 'Language', 'English'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _SettingsSection(
                    title: 'About',
                    items: [
                      _SettingsItem(Icons.info_outline_rounded, 'About PlatePal', ''),
                      _SettingsItem(Icons.privacy_tip_rounded, 'Privacy Policy', ''),
                      _SettingsItem(Icons.help_rounded, 'Help & Support', ''),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await provider.logout();
                        if (context.mounted) {
                          Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                        }
                      },
                      icon: const Icon(Icons.logout_rounded),
                      label: const Text('Sign Out'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.error,
                        side: BorderSide(
                            color: AppTheme.error.withOpacity(0.4)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelBadge extends StatelessWidget {
  const _LevelBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🌿', style: TextStyle(fontSize: 10)),
          SizedBox(width: 4),
          Text(
            'Eco Warrior',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  final String value;
  final String label;
  final String emoji;
  const _QuickStatCard(this.value, this.label, this.emoji);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: AppTheme.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<_SettingsItem> items;
  const _SettingsSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppTheme.textSecondary,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.divider),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(
              height: 1,
              color: AppTheme.divider,
              indent: 48,
            ),
            itemBuilder: (_, i) => _buildSettingsTile(context, items[i]),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(BuildContext context, _SettingsItem item) {
    return ListTile(
      leading: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(item.icon, size: 16, color: AppTheme.primary),
      ),
      title: Text(
        item.label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.value.isNotEmpty)
            Text(
              item.value,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right_rounded,
              size: 18, color: AppTheme.textLight),
        ],
      ),
      onTap: () {},
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String label;
  final String value;
  const _SettingsItem(this.icon, this.label, this.value);
}
