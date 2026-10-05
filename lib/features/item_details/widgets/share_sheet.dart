import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import 'package:findit/core/theme/app_colors.dart';
import 'package:findit/core/theme/app_text_styles.dart';
import 'package:findit/core/utils/sharing.dart';
import 'package:findit/data/models/item.dart';
import 'package:findit/shared/shared.dart';

/// Shows the share message for [item] with Share and Copy buttons.
Future<void> showShareSheet(BuildContext context, Item item) => showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _ShareSheet(item),
    );

class _ShareSheet extends StatelessWidget {
  const _ShareSheet(this.item);

  final Item item;

  Future<void> _copy(BuildContext context, String text, String done) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    Navigator.pop(context);
    showSnack(context, done);
  }

  /// Opens the phone's share sheet. Where there isn't one (most desktop
  /// browsers), copies the message instead.
  Future<void> _share(BuildContext context, String text) async {
    try {
      final result = await SharePlus.instance.share(ShareParams(text: text, subject: '${item.statusLabel}: ${item.name}'));
      if (result.status != ShareResultStatus.unavailable) {
        if (context.mounted) Navigator.pop(context);
        return;
      }
    } catch (_) {
      // Fall through to copying.
    }
    if (context.mounted) await _copy(context, text, 'Sharing isn\'t available here, so the message was copied instead.');
  }

  @override
  Widget build(BuildContext context) {
    final link = itemLink(item);
    final message = shareMessage(item, link);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Text('Share this report', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 4),
          Text('Post it in your class or org group chat so more people see it.', style: AppTextStyles.caption),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.banner, border: Border.all(color: AppColors.line)),
            child: SelectableText(message, style: TextStyle(fontSize: 12, color: AppColors.text, height: 1.4)),
          ),
          const SizedBox(height: 6),
          Text("The reporter's contact info isn't included. People reach them through FindIt.", style: AppTextStyles.caption),
          const SizedBox(height: 14),
          FilledButton.icon(
            icon: const Icon(Icons.share, size: 18),
            label: const Text('Share…'),
            onPressed: () => _share(context, message),
          ),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.copy, size: 16),
                label: const Text('Copy message'),
                onPressed: () => _copy(context, message, 'Message copied. Paste it in your group chat.'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.link, size: 16),
                label: const Text('Copy link'),
                onPressed: () => _copy(context, link.toString(), 'Link copied.'),
              ),
            ),
          ]),
        ]),
      ),
    );
  }
}
