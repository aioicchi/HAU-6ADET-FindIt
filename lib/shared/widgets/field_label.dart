import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_text_styles.dart';

class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 6),
        child: Text(text.toUpperCase(), style: AppTextStyles.label),
      );
}
