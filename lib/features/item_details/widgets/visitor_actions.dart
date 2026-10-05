import 'package:flutter/material.dart';

import 'package:findit/data/app_store.dart';
import 'package:findit/data/models/models.dart';
import 'package:findit/features/chat/chat_screen.dart';
import 'package:findit/features/claim/claim_screen.dart';
import 'package:findit/features/claim/widgets/claim_status_card.dart';
import 'package:findit/shared/shared.dart';

/// Shown when viewing someone else's report. Found items can be claimed;
/// lost items can only be messaged about.
class VisitorActions extends StatelessWidget {
  const VisitorActions(this.item, {super.key});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final contact = item.isLost ? 'Contact Owner' : 'Contact Finder';
    void openChat() => pushPage(context, ChatScreen(itemId: item.id));

    if (item.isLost) {
      return FilledButton.icon(icon: const Icon(Icons.mail_outline, size: 18), label: Text(contact), onPressed: openChat);
    }

    final myClaim = store.myClaimFor(item.id);
    final canClaim = !item.resolved && (myClaim == null || myClaim.status == ClaimStatus.rejected);

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      // Cross-fades from "pending" to the finder's decision.
      AnimatedSwitcher(
        duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : const Duration(milliseconds: 300),
        child: myClaim == null
            ? const SizedBox.shrink()
            : ClaimStatusCard(key: ValueKey('${myClaim.id}-${myClaim.status.name}'), claim: myClaim, item: item),
      ),
      if (canClaim) ...[
        FilledButton.icon(
          icon: const Icon(Icons.verified_user_outlined, size: 18),
          label: Text(myClaim == null ? 'Claim This Item' : 'Claim Again'),
          onPressed: () => pushPage(context, ClaimScreen(item: item)),
        ),
        const SizedBox(height: 10),
      ],
      OutlinedButton.icon(icon: const Icon(Icons.mail_outline, size: 18), label: Text(contact), onPressed: openChat),
    ]);
  }
}
