import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';
import 'package:findit/data/models/item.dart';

class StatusTag extends StatelessWidget {
  const StatusTag(this.item, {super.key});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final color = item.resolved ? AppColors.muted : item.statusColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: AppColors.surface, border: Border.all(color: color)),
      child: Text(
        item.resolved ? '[RESOLVED]' : '[${item.statusLabel}]',
        // Read as "Lost", not "left bracket LOST right bracket".
        semanticsLabel: item.resolved ? 'Resolved' : (item.isLost ? 'Lost' : 'Found'),
        style: TextStyle(fontFamily: 'monospace', fontSize: 10, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }
}
