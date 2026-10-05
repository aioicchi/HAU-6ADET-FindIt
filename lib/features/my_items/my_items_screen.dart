import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';
import 'package:findit/core/theme/app_text_styles.dart';
import 'package:findit/data/app_store.dart';
import 'package:findit/data/models/item.dart';
import 'package:findit/shared/shared.dart';

import 'widgets/my_item_card.dart';
import 'widgets/posts_tab_bar.dart';
import 'widgets/stats_row.dart';

class MyItemsScreen extends StatefulWidget {
  const MyItemsScreen({super.key, this.onReport});

  /// Opens the Report tab, offered when there are no active reports.
  final VoidCallback? onReport;

  @override
  State<MyItemsScreen> createState() => _MyItemsScreenState();
}

class _MyItemsScreenState extends State<MyItemsScreen> {
  bool _showResolved = false;

  /// Bumped by pull to refresh. It's part of each card's key, so the cards
  /// count as new and play their fade-in again.
  int _round = 0;

  Future<void> _refresh() async {
    await store.refresh();
    if (mounted) setState(() => _round++);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('FindIt')),
        body: ListenableBuilder(
          listenable: store,
          builder: (context, _) {
            final mine = store.myItems;
            final active = mine.where((i) => !i.resolved).toList();
            final resolved = mine.where((i) => i.resolved).toList();
            final shown = _showResolved ? resolved : active;

            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(), // So a short list can still be pulled.
                padding: const EdgeInsets.all(12),
                children: [
                  Row(children: [
                    const Expanded(child: Text('My Reported Items', style: AppTextStyles.sectionTitle)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      color: AppColors.navy,
                      child: Text('${active.length} ACTIVE', style: TextStyle(color: AppColors.onNavy, fontSize: 9, fontWeight: FontWeight.w700)),
                    ),
                  ]),
                  Text('Track status, edits, and resolved items', style: AppTextStyles.caption),
                  const SizedBox(height: 12),
                  PostsTabBar(
                    activeCount: active.length,
                    resolvedCount: resolved.length,
                    showResolved: _showResolved,
                    onChanged: (v) => setState(() => _showResolved = v),
                  ),
                  const SizedBox(height: 10),
                  StatsRow(
                    lost: active.where((i) => i.status == ItemStatus.lost).length,
                    found: active.where((i) => i.status == ItemStatus.found).length,
                    inquiries: active.fold(0, (sum, i) => sum + i.inquiries),
                  ),
                  const SizedBox(height: 10),
                  if (shown.isEmpty)
                    _showResolved
                        ? const EmptyState(
                            "When an item is back with its owner, mark it resolved and it moves here.",
                            title: 'Nothing resolved yet',
                            icon: Icons.task_alt,
                          )
                        : EmptyState(
                            'Lost or found something? Report it, then track replies and claims here.',
                            title: 'No active reports',
                            icon: Icons.inventory_2_outlined,
                            actionLabel: 'Report an item',
                            actionIcon: Icons.add_box_outlined,
                            onAction: widget.onReport,
                          )
                  else
                    for (final (i, item) in shown.indexed) FadeSlideIn(key: ValueKey((_round, item.id)), index: i, child: MyItemCard(item)),
                ],
              ),
            );
          },
        ),
      );
}
