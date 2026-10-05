import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_text_styles.dart';
import 'package:findit/data/app_store.dart';
import 'package:findit/data/campus.dart';
import 'package:findit/data/models/item.dart';
import 'package:findit/features/item_details/item_details_screen.dart';
import 'package:findit/shared/shared.dart';

import 'widgets/filter_button.dart';
import 'widgets/home_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _query = '';
  String? _category;
  HomeFilters _filters = const HomeFilters();

  List<Item> _visibleItems() {
    final q = _query.trim().toLowerCase();
    return store.items.where((i) {
      if (!_filters.matches(i)) return false;
      if (_category != null && !i.tags.contains(_category)) return false;
      if (q.isEmpty) return true;
      return '${i.name} ${i.fullLocation} ${i.description} ${i.tags.join(' ')}'.toLowerCase().contains(q);
    }).toList()
      ..sort((a, b) => _filters.newestFirst ? b.date.compareTo(a.date) : a.date.compareTo(b.date));
  }

  Widget _categoryChip(String label, String? value) => ChoiceChip(
        label: Text(label, style: const TextStyle(fontSize: 11)),
        selected: _category == value,
        materialTapTargetSize: MaterialTapTargetSize.padded, // At least 48 px to tap.
        onSelected: (_) => setState(() => _category = value),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const HomeAppBar(),
        body: ListenableBuilder(
          listenable: store,
          builder: (context, _) {
            final items = _visibleItems();
            // Campus places that have reports, in campus-list order, then any "Other…" places.
            final used = {for (final i in store.items) i.location};
            final locations = [
              ...campusLocations.where(used.contains),
              ...(used.difference(campusLocations.toSet()).toList()..sort()),
            ];
            final filtering = _query.isNotEmpty || _category != null || _filters.activeCount > 0;

            return RefreshIndicator(
              onRefresh: store.refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(), // So a short list can still be pulled.
                padding: const EdgeInsets.all(12),
                children: [
                  Text('SEARCH ITEMS...', style: AppTextStyles.label),
                  const SizedBox(height: 6),
                  TextField(
                    onChanged: (v) => setState(() => _query = v),
                    decoration: const InputDecoration(hintText: 'e.g. Blue Backpack, Keys...', prefixIcon: Icon(Icons.search, size: 18)),
                  ),
                  const SizedBox(height: 10),
                  // Wraps onto more lines instead of scrolling sideways, so no chip is cut off at the edge.
                  // No run spacing: each chip's 48 px tap area already leaves a gap between rows.
                  Wrap(spacing: 6, children: [
                    _categoryChip('All', null),
                    for (final c in Item.categories) _categoryChip(Item.categoryLabel(c), c),
                  ]),
                  const SizedBox(height: 12),
                  Row(children: [
                    const Expanded(child: Text('Lost & Found Items', style: AppTextStyles.sectionTitle)),
                    FilterButton(value: _filters, locations: locations, onChanged: (v) => setState(() => _filters = v)),
                  ]),
                  const SizedBox(height: 4),
                  Text('${items.length} item${items.length == 1 ? '' : 's'}', style: AppTextStyles.caption),
                  const SizedBox(height: 10),
                  if (items.isEmpty)
                    EmptyState(filtering ? 'No items match your search or filters.' : 'No items reported yet.', icon: Icons.search_off)
                  else
                    for (final (i, item) in items.indexed)
                      FadeSlideIn(
                        key: ValueKey(item.id),
                        index: i,
                        child: ItemCard(item, onDetails: () => pushPage(context, ItemDetailsScreen(itemId: item.id))),
                      ),
                ],
              ),
            );
          },
        ),
      );
}
