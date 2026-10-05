import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';

class ReadOnlyField extends StatelessWidget {
  const ReadOnlyField(this.text, {super.key, this.icon, this.minHeight = 0});

  final String text;
  final IconData? icon;
  final double minHeight;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: minHeight),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.surface, border: Border.all(color: AppColors.line)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (icon != null) ...[Icon(icon, size: 16, color: AppColors.muted), SizedBox(width: 8)],
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ]),
      );
}
