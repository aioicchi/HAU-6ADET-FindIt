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
  const MyItemsScreen({super.key});

  @override
  State<MyItemsScreen> createState() => _MyItemsScreenState();
}

class _MyItemsScreenState extends State<MyItemsScreen> {
  bool _showResolved = false;

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

            return ListView(padding: const EdgeInsets.all(12), children: [
              Row(children: [
                const Expanded(child: Text('My Reported Items', style: AppTextStyles.sectionTitle)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  color: AppColors.navy,
                  child: Text('${active.length} ACTIVE', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                ),
              ]),
              const Text('Track status, edits, and resolved items', style: AppTextStyles.caption),
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
                EmptyState(_showResolved ? 'No resolved items yet.' : 'You have no active reports.')
              else
                for (final item in shown) MyItemCard(item),
            ]);
          },
        ),
      );
}
