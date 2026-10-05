import 'package:flutter/material.dart';

import 'package:findit/data/models/item.dart';
import 'package:findit/features/chat/chat_screen.dart';
import 'package:findit/shared/shared.dart';

/// Shown when viewing someone else's report.
class VisitorActions extends StatelessWidget {
  const VisitorActions(this.item, {super.key});

  final Item item;

  @override
  Widget build(BuildContext context) => FilledButton.icon(
        icon: const Icon(Icons.mail_outline, size: 18),
        label: Text(item.isLost ? 'Contact Owner' : 'Contact Finder'),
        onPressed: () => pushPage(context, ChatScreen(itemId: item.id)),
      );
}
