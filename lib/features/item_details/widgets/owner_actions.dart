import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';
import 'package:findit/data/app_store.dart';
import 'package:findit/data/models/item.dart';
import 'package:findit/features/chat/chat_screen.dart';
import 'package:findit/shared/shared.dart';

/// Shown when viewing your own report: resolve, inquiries, delete.
class OwnerActions extends StatelessWidget {
  const OwnerActions(this.item, {super.key});

  final Item item;

  Future<void> _delete(BuildContext context) async {
    final ok = await confirmDialog(context, title: 'Delete report?', message: 'This cannot be undone.', confirm: 'Delete');
    if (!ok || !context.mounted) return;
    Navigator.pop(context);
    store.deleteItem(item.id);
    showSnack(context, 'Report deleted.');
  }

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        FilledButton.icon(
          icon: Icon(item.resolved ? Icons.undo : Icons.check_circle_outline, size: 18),
          label: Text(item.resolved ? 'Reopen Item' : 'Mark as Resolved'),
          onPressed: () => store.toggleResolved(item),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          icon: const Icon(Icons.chat_bubble_outline, size: 18),
          label: Text('View Inquiries (${item.inquiries})'),
          onPressed: () => pushPage(context, ChatScreen(itemId: item.id)),
        ),
        const SizedBox(height: 10),
        TextButton.icon(
          style: TextButton.styleFrom(foregroundColor: AppColors.lost),
          icon: const Icon(Icons.delete_outline, size: 18),
          label: const Text('Delete Report'),
          onPressed: () => _delete(context),
        ),
      ]);
}
