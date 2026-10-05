import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';

class ChipTag extends StatelessWidget {
  const ChipTag(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: const Color(0xFFE5E7EB), border: Border.all(color: AppColors.line)),
        child: Text(text, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: .5)),
      );
}
