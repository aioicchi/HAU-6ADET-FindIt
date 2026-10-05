import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';
import 'package:findit/core/theme/app_theme.dart';
import 'package:findit/core/theme/app_text_styles.dart';
import 'package:findit/core/utils/date_format.dart';
import 'package:findit/data/app_store.dart';
import 'package:findit/data/models/models.dart';
import 'package:findit/features/item_details/item_details_screen.dart';
import 'package:findit/features/report/report_item_screen.dart';
import 'package:findit/shared/shared.dart';

class MyItemCard extends StatelessWidget {
  const MyItemCard(this.item, {super.key});

  final Item item;

  String? get _statusLine {
    if (item.resolved) {
      final approved = store.claimsFor(item.id).where((c) => c.status == ClaimStatus.approved).firstOrNull;
      return approved == null ? 'Resolved' : 'Claimed by ${approved.claimant}';
    }
    final n = item.inquiries;
    final m = store.matchesFor(item).length;
    final c = store.pendingClaimsFor(item.id);
    final parts = [
      if (c > 0) '$c ${c == 1 ? 'claim' : 'claims'} to review',
      if (n > 0) '$n ${n == 1 ? 'inquiry' : 'inquiries'}',
      if (m > 0) '$m possible ${m == 1 ? 'match' : 'matches'}',
    ];
    return parts.isEmpty ? item.note : parts.join(' · ');
  }

  /// [spoken] is what a screen reader says, naming the item ("Edit Umbrella").
  Widget _smallButton(IconData icon, String label, String spoken, VoidCallback onTap) => OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 12),
        label: Text(label, semanticsLabel: spoken),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 28),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          side: BorderSide(color: AppColors.line),
          textStyle: const TextStyle(fontFamily: AppTheme.font, fontSize: 9, fontWeight: FontWeight.w700),
        ),
      );

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: AppColors.surface, border: Border.all(color: AppColors.line)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            StatusTag(item),
            Text(timeAgo(item.date), style: AppTextStyles.mono),
          ]),
          const SizedBox(height: 8),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(width: 56, child: ItemPhoto(item, height: 56)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                Text('◉ ${item.fullLocation}', style: AppTextStyles.mono),
                if (_statusLine != null) Text('● $_statusLine', style: AppTextStyles.mono),
              ]),
            ),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Flexible(
              child: _smallButton(Icons.edit, 'EDIT', 'Edit ${item.name}', () => pushPage(context, ReportItemScreen(editing: item))),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: _smallButton(
                item.resolved ? Icons.undo : Icons.check_circle_outline,
                item.resolved ? 'REOPEN' : 'MARK RESOLVED',
                item.resolved ? 'Reopen ${item.name}' : 'Mark ${item.name} as resolved',
                () => store.toggleResolved(item),
              ),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () => pushPage(context, ItemDetailsScreen(itemId: item.id)),
              style: FilledButton.styleFrom(
                minimumSize: const Size(54, 28),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                textStyle: const TextStyle(fontFamily: AppTheme.font, fontSize: 9, fontWeight: FontWeight.w700),
              ),
              child: Text('VIEW', semanticsLabel: 'View ${item.name}'),
            ),
          ]),
        ]),
      );
}
