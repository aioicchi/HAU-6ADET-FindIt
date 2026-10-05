import 'package:flutter/material.dart';

import 'package:findit/data/app_store.dart';
import 'package:findit/features/notifications/notifications_screen.dart';
import 'package:findit/features/profile/profile_screen.dart';
import 'package:findit/shared/shared.dart';

/// "FindIt" app bar with notifications bell and profile button.
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
        title: const Text('FindIt'),
        actions: [
          ListenableBuilder(
            listenable: store,
            builder: (context, _) => IconButton(
              tooltip: 'Notifications',
              icon: Badge(
                isLabelVisible: store.unreadCount > 0,
                label: Text('${store.unreadCount}'),
                child: const Icon(Icons.notifications_none),
              ),
              onPressed: () => pushPage(context, const NotificationsScreen()),
            ),
          ),
          IconButton(
            tooltip: 'Profile',
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () => pushPage(context, const ProfileScreen()),
          ),
        ],
      );
}
