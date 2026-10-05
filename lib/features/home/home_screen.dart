import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_text_styles.dart';
import 'package:findit/data/app_store.dart';
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
  ItemStatus? _filter;

  List<Item> _visibleItems() {
    final q = _query.trim().toLowerCase();
    return store.browseItems.where((i) {
      if (_filter != null && i.status != _filter) return false;
      if (q.isEmpty) return true;
      return '${i.name} ${i.location} ${i.description} ${i.tags.join(' ')}'.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const HomeAppBar(),
        body: ListenableBuilder(
          listenable: store,
          builder: (context, _) {
            final items = _visibleItems();
            return ListView(padding: const EdgeInsets.all(12), children: [
              const Text('SEARCH ITEMS...', style: AppTextStyles.label),
              const SizedBox(height: 6),
              TextField(
                onChanged: (v) => setState(() => _query = v),
                decoration: const InputDecoration(hintText: 'e.g. Blue Backpack, Keys...', prefixIcon: Icon(Icons.search, size: 18)),
              ),
              const SizedBox(height: 16),
              Row(children: [
                const Expanded(child: Text('Lost & Found Items', style: AppTextStyles.sectionTitle)),
                FilterButton(value: _filter, onChanged: (v) => setState(() => _filter = v)),
              ]),
              const SizedBox(height: 10),
              if (items.isEmpty)
                const EmptyState('No items match your search.', icon: Icons.search_off)
              else
                for (final item in items)
                  ItemCard(item, onDetails: () => pushPage(context, ItemDetailsScreen(itemId: item.id))),
            ]);
          },
        ),
      );
}
