import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';
import 'package:findit/core/theme/theme_controller.dart';
import 'package:findit/data/app_store.dart';
import 'package:findit/features/notifications/notifications_screen.dart';
import 'package:findit/features/profile/profile_screen.dart';
import 'package:findit/shared/shared.dart';

/// "FindIt" app bar with night mode toggle, notifications bell and profile button.
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
        title: const Text('FindIt'),
        actions: [
          IconButton(
            tooltip: AppColors.dark ? 'Switch to light mode' : 'Switch to night mode',
            icon: Icon(AppColors.dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
            onPressed: () => themeController.setMode(AppColors.dark ? ThemeMode.light : ThemeMode.dark),
          ),
          ListenableBuilder(
            listenable: store,
            builder: (context, _) => IconButton(
              tooltip: store.unreadCount > 0 ? 'Notifications, ${store.unreadCount} unread' : 'Notifications',
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
