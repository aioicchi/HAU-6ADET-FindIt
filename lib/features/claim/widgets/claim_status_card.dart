import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';
import 'package:findit/core/utils/date_format.dart';
import 'package:findit/data/models/models.dart';

/// Shows the signed-in user where their claim on [item] stands.
class ClaimStatusCard extends StatelessWidget {
  const ClaimStatusCard({super.key, required this.claim, required this.item});

  final Claim claim;
  final Item item;

  @override
  Widget build(BuildContext context) {
    final (IconData icon, Color color, String title, String body) = switch (claim.status) {
      ClaimStatus.pending => (
          Icons.hourglass_top,
          AppColors.navy,
          'Claim pending',
          'The finder is checking your answer. You will get a notification when they decide.',
        ),
      ClaimStatus.approved => (
          Icons.check_circle,
          AppColors.found,
          'Claim approved',
          'Pick it up at ${item.claimAt ?? item.location}. Bring your school ID.',
        ),
      ClaimStatus.rejected => (
          Icons.cancel,
          AppColors.lost,
          'Claim not approved',
          "The finder couldn't confirm it's yours. You can claim again with more detail.",
        ),
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: color, width: 1.5)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: color),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.w700, color: color)),
            const SizedBox(height: 2),
            Text(body, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 6),
            Text('Your answer: "${claim.answer}"', style: const TextStyle(fontSize: 11, color: AppColors.muted, fontStyle: FontStyle.italic)),
            Text('Sent ${timeAgo(claim.time).toLowerCase()}', style: const TextStyle(fontSize: 10, color: AppColors.hint)),
          ]),
        ),
      ]),
    );
  }
}
