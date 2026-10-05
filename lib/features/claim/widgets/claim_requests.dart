import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';
import 'package:findit/core/theme/app_text_styles.dart';
import 'package:findit/core/utils/date_format.dart';
import 'package:findit/data/app_store.dart';
import 'package:findit/data/models/models.dart';
import 'package:findit/shared/shared.dart';

/// The finder's view of everyone claiming their found [item], with approve/reject.
class ClaimRequests extends StatelessWidget {
  const ClaimRequests({super.key, required this.item, required this.claims});

  final Item item;
  final List<Claim> claims;

  Future<void> _approve(BuildContext context, Claim c) async {
    final ok = await confirmDialog(
      context,
      title: 'Approve ${c.claimant}?',
      message: 'The item will be marked as resolved and any other waiting claims will be declined.',
      confirm: 'Approve',
    );
    if (!ok || !context.mounted) return;
    store.approveClaim(c);
    showSnack(context, 'Claim approved. ${item.name} marked as resolved.');
  }

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text('CLAIM REQUESTS (${claims.length})', style: AppTextStyles.label),
        const SizedBox(height: 4),
        Text('Your question: ${item.claimQuestion}', style: AppTextStyles.caption),
        const SizedBox(height: 8),
        for (final c in claims)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white, border: Border.all(color: AppColors.line)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(c.claimant, style: const TextStyle(fontWeight: FontWeight.w700))),
                _StatusChip(c.status),
              ]),
              Text(timeAgo(c.time), style: const TextStyle(fontSize: 10, color: AppColors.hint)),
              const SizedBox(height: 6),
              Text('"${c.answer}"', style: const TextStyle(fontSize: 13)),
              if (c.isPending) ...[
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(foregroundColor: AppColors.lost),
                      onPressed: () {
                        store.rejectClaim(c);
                        showSnack(context, 'Claim declined.');
                      },
                      child: const Text('Reject'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: AppColors.found),
                      onPressed: () => _approve(context, c),
                      child: const Text('Approve'),
                    ),
                  ),
                ]),
              ],
            ]),
          ),
      ]);
}

class _StatusChip extends StatelessWidget {
  const _StatusChip(this.status);

  final ClaimStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      ClaimStatus.pending => AppColors.navy,
      ClaimStatus.approved => AppColors.found,
      ClaimStatus.rejected => AppColors.lost,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(border: Border.all(color: color)),
      child: Text(status.name.toUpperCase(), style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: color)),
    );
  }
}
