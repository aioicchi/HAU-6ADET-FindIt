import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({super.key, required this.lost, required this.found, required this.inquiries});

  final int lost;
  final int found;
  final int inquiries;

  Widget _stat(String label, int value) => Expanded(
        child: Column(children: [
          Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, letterSpacing: .5, color: AppColors.muted)),
          const SizedBox(height: 4),
          Text('$value', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        ]),
      );

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: AppColors.surface, border: Border.all(color: AppColors.line)),
        child: Row(children: [
          _stat('LOST FILED', lost),
          _stat('FOUND FILED', found),
          _stat('MATCHES / INQUIRIES', inquiries),
        ]),
      );
}
