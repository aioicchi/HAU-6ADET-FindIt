import 'package:flutter/material.dart';

import 'package:findit/data/app_store.dart';
import 'package:findit/features/item_details/item_details_screen.dart';
import 'package:findit/shared/shared.dart';

import 'widgets/notification_tile.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          actions: [TextButton(onPressed: store.markAllRead, child: const Text('Mark all read'))],
        ),
        body: ListenableBuilder(
          listenable: store,
          builder: (context, _) {
            final list = store.notifications;
            if (list.isEmpty) {
              return const EmptyState(
                'Possible matches, replies and claim updates will show up here.',
                title: "You're all caught up",
                icon: Icons.notifications_none,
              );
            }
            return ListView.separated(
              itemCount: list.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final n = list[i];
                return NotificationTile(
                  n,
                  onTap: () {
                    store.markRead(n);
                    if (n.itemId != null) pushPage(context, ItemDetailsScreen(itemId: n.itemId!));
                  },
                );
              },
            );
          },
        ),
      );
}
