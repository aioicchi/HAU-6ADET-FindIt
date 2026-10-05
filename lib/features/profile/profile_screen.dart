import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';
import 'package:findit/core/theme/theme_controller.dart';
import 'package:findit/data/app_store.dart';
import 'package:findit/features/notifications/notifications_screen.dart';
import 'package:findit/shared/shared.dart';

import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final ok = await confirmDialog(context, title: 'Sign out?', message: 'You will need to sign in again.', confirm: 'Sign out');
    if (!ok || !context.mounted) return;
    Navigator.popUntil(context, (r) => r.isFirst);
    store.logout();
  }

  Future<void> _resetData(BuildContext context) async {
    final ok = await confirmDialog(
      context,
      title: 'Reset demo data?',
      message: 'This deletes every account, report, photo and message saved on this device, then restores the demo data. You will be signed out.',
      confirm: 'Reset',
    );
    if (!ok || !context.mounted) return;
    Navigator.popUntil(context, (r) => r.isFirst);
    await store.resetDemoData();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: Listenable.merge([store, themeController]),
        builder: (context, _) {
          final user = store.user;
          if (user == null) return const Scaffold();
          final mine = store.myItems;

          return Scaffold(
            appBar: AppBar(title: const Text('Profile')),
            body: ListView(padding: const EdgeInsets.all(14), children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.surface, border: Border.all(color: AppColors.line)),
                child: Row(children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.navy,
                    child: Text(user.initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(user.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      Text(user.email, style: TextStyle(fontSize: 12, color: AppColors.muted)),
                      if (user.studentId.isNotEmpty) Text('ID: ${user.studentId}', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                    ]),
                  ),
                ]),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(color: AppColors.surface, border: Border.all(color: AppColors.line)),
                child: Row(children: [
                  _Stat('REPORTS', mine.length),
                  _Stat('ACTIVE', mine.where((i) => !i.resolved).length),
                  _Stat('RESOLVED', mine.where((i) => i.resolved).length),
                ]),
              ),
              const FieldLabel('Account'),
              _Tile(Icons.person_outline, 'Edit Profile', () => pushPage(context, const EditProfileScreen())),
              _Tile(Icons.notifications_none, 'Notifications', () => pushPage(context, const NotificationsScreen())),
              _Tile(Icons.dark_mode_outlined, 'Appearance', () => _pickAppearance(context), value: themeController.label),
              const FieldLabel('Support'),
              _Tile(Icons.help_outline, 'How FindIt Works', () => _showHelp(context)),
              _Tile(Icons.info_outline, 'About', () => showAboutDialog(context: context, applicationName: 'FindIt', applicationVersion: '1.0.0')),
              _Tile(Icons.restart_alt, 'Reset Demo Data', () => _resetData(context)),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.lost, side: BorderSide(color: AppColors.lost)),
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Sign Out'),
                onPressed: () => _logout(context),
              ),
            ]),
          );
        },
      );

  void _pickAppearance(BuildContext context) => showModalBottomSheet(
        context: context,
        builder: (sheet) => SafeArea(
          child: RadioGroup<ThemeMode>(
            groupValue: themeController.mode,
            onChanged: (m) {
              if (m != null) themeController.setMode(m);
              Navigator.pop(sheet);
            },
            child: const Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Text('Appearance', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
              RadioListTile(value: ThemeMode.system, title: Text('System'), subtitle: Text('Match your phone or computer')),
              RadioListTile(value: ThemeMode.light, title: Text('Light')),
              RadioListTile(value: ThemeMode.dark, title: Text('Dark (night mode)')),
            ]),
          ),
        ),
      );

  void _showHelp(BuildContext context) => showModalBottomSheet(
        context: context,
        builder: (_) => const Padding(
          padding: EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('How FindIt Works', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            SizedBox(height: 12),
            Text('1. Lost something? Report it as LOST with where you last had it.'),
            SizedBox(height: 6),
            Text('2. Found something? Report it as FOUND and drop it at the Lost & Found office.'),
            SizedBox(height: 6),
            Text('3. See your item in the list? Tap Claim This Item and answer the finder\'s question to prove it\'s yours.'),
            SizedBox(height: 6),
            Text('4. Found something and got a claim? Review the answer, then Approve or Reject it.'),
            SizedBox(height: 6),
            Text('5. Use Contact to message the finder/owner, and mark your report as Resolved once it\'s returned.'),
          ]),
        ),
      );
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value);

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(children: [
          Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.muted)),
          const SizedBox(height: 4),
          Text('$value', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        ]),
      );
}

class _Tile extends StatelessWidget {
  const _Tile(this.icon, this.label, this.onTap, {this.value});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  /// Current setting, shown before the chevron.
  final String? value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: ListTile(
          tileColor: AppColors.surface,
          shape: Border.fromBorderSide(BorderSide(color: AppColors.line)),
          dense: true,
          leading: Icon(icon, color: AppColors.navy),
          title: Text(label),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            if (value != null) Text(value!, style: TextStyle(fontSize: 12, color: AppColors.muted)),
            const Icon(Icons.chevron_right),
          ]),
          onTap: onTap,
        ),
      );
}
