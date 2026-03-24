import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../widgets/custom_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(icon: const Icon(Icons.edit_rounded), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar + Name
            CustomCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.secondaryColor.withValues(alpha: 0.4),
                          border: Border.all(color: AppColors.primaryColor, width: 2.5),
                        ),
                        child: const Icon(Icons.person_rounded, size: 50, color: AppColors.primaryColor),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt_rounded, size: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text('John Farmer',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  const Text('john.farmer@cropvision.app',
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  const SizedBox(height: 16),
                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _Stat('48', 'Scans'),
                      Container(width: 1, height: 32, color: AppColors.dividerColor),
                      _Stat('12', 'Diseases'),
                      Container(width: 1, height: 32, color: AppColors.dividerColor),
                      _Stat('3', 'Crops'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Settings sections
            _SettingsGroup(
              title: 'Preferences',
              items: [
                _SettingsItem(Icons.dark_mode_rounded, 'Dark Mode', trailing: Switch(
                  value: false,
                  onChanged: (_) {},
                  activeThumbColor: AppColors.primaryColor,
                  activeTrackColor: AppColors.secondaryColor,
                )),
                _SettingsItem(Icons.notifications_rounded, 'Notifications', trailing: Switch(
                  value: true,
                  onChanged: (_) {},
                  activeThumbColor: AppColors.primaryColor,
                  activeTrackColor: AppColors.secondaryColor,
                )),
                _SettingsItem(Icons.language_rounded, 'Language', subtitle: 'English', hasArrow: true),
                _SettingsItem(Icons.location_on_rounded, 'Region', subtitle: 'North America', hasArrow: true),
              ],
            ),
            const SizedBox(height: 16),

            _SettingsGroup(
              title: 'Account',
              items: [
                _SettingsItem(Icons.lock_rounded, 'Change Password', hasArrow: true),
                _SettingsItem(Icons.cloud_upload_rounded, 'Backup Data', hasArrow: true),
                _SettingsItem(Icons.delete_rounded, 'Clear Scan History', hasArrow: true, color: AppColors.warningColor),
              ],
            ),
            const SizedBox(height: 16),

            _SettingsGroup(
              title: 'About',
              items: [
                _SettingsItem(Icons.info_rounded, 'About CropVision', hasArrow: true),
                _SettingsItem(Icons.privacy_tip_rounded, 'Privacy Policy', hasArrow: true),
                _SettingsItem(Icons.description_rounded, 'Terms of Service', hasArrow: true),
                _SettingsItem(Icons.star_rounded, 'Rate the App', hasArrow: true),
                _SettingsItem(Icons.share_rounded, 'Share App', hasArrow: true),
              ],
            ),
            const SizedBox(height: 16),

            // Version + logout
            CustomCard(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: const Icon(Icons.logout_rounded, color: AppColors.errorColor),
                title: const Text('Sign Out',
                    style: TextStyle(color: AppColors.errorColor, fontWeight: FontWeight.w600)),
                onTap: () {},
              ),
            ),
            const SizedBox(height: 16),
            const Text('CropVision v1.0.0',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  const _Stat(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryColor)),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final String title;
  final List<_SettingsItem> items;
  const _SettingsGroup({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
        ),
        CustomCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: items.asMap().entries.map((e) {
              final isLast = e.key == items.length - 1;
              return Column(
                children: [
                  ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: (e.value.color ?? AppColors.primaryColor).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(e.value.icon, size: 20, color: e.value.color ?? AppColors.primaryColor),
                    ),
                    title: Text(e.value.label,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: e.value.color ?? AppColors.textPrimary)),
                    subtitle: e.value.subtitle != null
                        ? Text(e.value.subtitle!, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))
                        : null,
                    trailing: e.value.trailing ??
                        (e.value.hasArrow
                            ? const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 20)
                            : null),
                    onTap: () {},
                  ),
                  if (!isLast)
                    const Divider(height: 1, indent: 68, color: AppColors.dividerColor),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Widget? trailing;
  final bool hasArrow;
  final Color? color;
  const _SettingsItem(this.icon, this.label, {this.subtitle, this.trailing, this.hasArrow = false, this.color});
}
