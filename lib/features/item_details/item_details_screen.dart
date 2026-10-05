import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';
import 'package:findit/core/theme/app_text_styles.dart';
import 'package:findit/core/utils/date_format.dart';
import 'package:findit/data/app_store.dart';
import 'package:findit/data/models/item.dart';
import 'package:findit/features/report/report_item_screen.dart';
import 'package:findit/shared/shared.dart';

import 'widgets/owner_actions.dart';
import 'widgets/visitor_actions.dart';

class ItemDetailsScreen extends StatelessWidget {
  const ItemDetailsScreen({super.key, required this.itemId});

  final String itemId;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final item = store.findItem(itemId);
          if (item == null) {
            return Scaffold(appBar: AppBar(), body: const EmptyState('This item is no longer available.'));
          }
          final isMine = item.ownerId == store.user?.id;
          final claimAt = item.claimAt;
          final matches = isMine && !item.resolved ? store.matchesFor(item) : const <Item>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Item Details'),
              actions: [
                if (isMine)
                  IconButton(
                    tooltip: 'Edit',
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () => pushPage(context, ReportItemScreen(editing: item)),
                  ),
              ],
            ),
            body: ListView(padding: const EdgeInsets.all(14), children: [
              ItemPhoto(item, height: 220, emptyLabel: 'Item Photo (Optional)', zoomable: true),
              const FieldLabel('Item name'),
              ReadOnlyField(item.name),
              const FieldLabel('Current status'),
              ReadOnlyField(item.resolved ? '[RESOLVED]' : '[${item.statusLabel}]'),
              const FieldLabel('Found/Lost at (location)'),
              ReadOnlyField(item.location, icon: Icons.place_outlined),
              if (!item.isLost && claimAt != null && claimAt.isNotEmpty) ...[
                const FieldLabel('Where to claim'),
                ReadOnlyField(claimAt, icon: Icons.storefront_outlined),
              ],
              const FieldLabel('Date reported'),
              ReadOnlyField(fullDate(item.date), icon: Icons.calendar_today_outlined),
              const FieldLabel('Description'),
              ReadOnlyField(item.description.isEmpty ? '—' : item.description, minHeight: 90),
              if (item.tags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(spacing: 6, runSpacing: 6, children: [for (final t in item.tags) ChipTag(t)]),
              ],
              if (matches.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text('POSSIBLE MATCHES (${matches.length})', style: AppTextStyles.label),
                const SizedBox(height: 4),
                Text(
                  item.isLost ? 'Found reports that look like your item.' : 'Lost reports that look like this item.',
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: 8),
                for (final m in matches) _MatchTile(m),
              ],
              const SizedBox(height: 20),
              isMine ? OwnerActions(item) : VisitorActions(item),
            ]),
          );
        },
      );
}

class _MatchTile extends StatelessWidget {
  const _MatchTile(this.item);

  final Item item;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: InkWell(
          onTap: () => pushPage(context, ItemDetailsScreen(itemId: item.id)),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white, border: Border.all(color: AppColors.line)),
            child: Row(children: [
              SizedBox(width: 52, child: ItemPhoto(item, height: 52)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  Text(item.location, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
                  Text(item.whenLabel, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
                ]),
              ),
              StatusTag(item),
              const Icon(Icons.chevron_right, color: AppColors.hint),
            ]),
          ),
        ),
      );
}
