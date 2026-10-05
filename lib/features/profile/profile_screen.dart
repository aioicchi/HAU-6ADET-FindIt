import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';
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

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final user = store.user;
          if (user == null) return const Scaffold();
          final mine = store.myItems;

          return Scaffold(
            appBar: AppBar(title: const Text('Profile')),
            body: ListView(padding: const EdgeInsets.all(14), children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, border: Border.all(color: AppColors.line)),
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
                      Text(user.email, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                      if (user.studentId.isNotEmpty) Text('ID: ${user.studentId}', style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                    ]),
                  ),
                ]),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(color: Colors.white, border: Border.all(color: AppColors.line)),
                child: Row(children: [
                  _Stat('REPORTS', mine.length),
                  _Stat('ACTIVE', mine.where((i) => !i.resolved).length),
                  _Stat('RESOLVED', mine.where((i) => i.resolved).length),
                ]),
              ),
              const FieldLabel('Account'),
              _Tile(Icons.person_outline, 'Edit Profile', () => pushPage(context, const EditProfileScreen())),
              _Tile(Icons.notifications_none, 'Notifications', () => pushPage(context, const NotificationsScreen())),
              const FieldLabel('Support'),
              _Tile(Icons.help_outline, 'How FindIt Works', () => _showHelp(context)),
              _Tile(Icons.info_outline, 'About', () => showAboutDialog(context: context, applicationName: 'FindIt', applicationVersion: '1.0.0')),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.lost, side: const BorderSide(color: AppColors.lost)),
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Sign Out'),
                onPressed: () => _logout(context),
              ),
            ]),
          );
        },
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
            Text('3. Browse items and use Contact to message the finder/owner.'),
            SizedBox(height: 6),
            Text('4. Once returned, mark your report as Resolved.'),
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
          Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.muted)),
          const SizedBox(height: 4),
          Text('$value', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        ]),
      );
}

class _Tile extends StatelessWidget {
  const _Tile(this.icon, this.label, this.onTap);

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: ListTile(
          tileColor: Colors.white,
          shape: const Border.fromBorderSide(BorderSide(color: AppColors.line)),
          dense: true,
          leading: Icon(icon, color: AppColors.navy),
          title: Text(label),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      );
}
