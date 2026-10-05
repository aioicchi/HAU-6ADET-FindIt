import 'package:flutter/material.dart';

import 'package:findit/data/models/item.dart';

class StatusTag extends StatelessWidget {
  const StatusTag(this.item, {super.key});

  final Item item;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: item.statusColor)),
        child: Text(
          '[${item.statusLabel}]',
          style: TextStyle(fontFamily: 'monospace', fontSize: 10, fontWeight: FontWeight.w700, color: item.statusColor),
        ),
      );
}
