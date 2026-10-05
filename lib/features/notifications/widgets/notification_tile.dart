import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';
import 'package:findit/core/utils/date_format.dart';
import 'package:findit/data/models/app_notification.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile(this.notification, {super.key, required this.onTap});

  final AppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final n = notification;
    return ListTile(
      tileColor: n.read ? null : Colors.white,
      leading: Icon(n.read ? Icons.notifications_none : Icons.notifications_active, color: AppColors.navy),
      title: Text(n.title, style: TextStyle(fontWeight: n.read ? FontWeight.w500 : FontWeight.w700, fontSize: 14)),
      subtitle: Text('${n.body}\n${timeAgo(n.time)}', style: const TextStyle(fontSize: 12)),
      isThreeLine: true,
      onTap: onTap,
    );
  }
}
