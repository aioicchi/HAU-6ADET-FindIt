import 'package:flutter/material.dart';

import 'package:findit/core/utils/date_format.dart';
import 'package:findit/data/app_store.dart';
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
              const FieldLabel('Date reported'),
              ReadOnlyField(fullDate(item.date), icon: Icons.calendar_today_outlined),
              const FieldLabel('Description'),
              ReadOnlyField(item.description.isEmpty ? '—' : item.description, minHeight: 90),
              if (item.tags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(spacing: 6, runSpacing: 6, children: [for (final t in item.tags) ChipTag(t)]),
              ],
              const SizedBox(height: 20),
              isMine ? OwnerActions(item) : VisitorActions(item),
            ]),
          );
        },
      );
}
