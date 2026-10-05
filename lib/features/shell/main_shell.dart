import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';
import 'package:findit/core/utils/sharing.dart';
import 'package:findit/data/app_store.dart';
import 'package:findit/features/home/home_screen.dart';
import 'package:findit/features/item_details/item_details_screen.dart';
import 'package:findit/features/my_items/my_items_screen.dart';
import 'package:findit/features/report/report_item_screen.dart';
import 'package:findit/shared/shared.dart';

/// The report a shared link pointed at (`?item=4`). Opened once, the first
/// time the main screen appears, which is after signing in if needed.
String? _openFromLink = linkedItemId();

/// Bottom-nav container: Browse / Report / My Items.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  void _goTo(int i) => setState(() => _index = i);

  @override
  void initState() {
    super.initState();
    final id = _openFromLink;
    _openFromLink = null;
    if (id == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (store.findItem(id) == null) {
        showSnack(context, 'That report is no longer available.');
      } else {
        pushPage(context, ItemDetailsScreen(itemId: id));
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: IndexedStack(index: _index, children: [
          HomeScreen(onReport: () => _goTo(1)),
          ReportItemScreen(onSubmitted: () => _goTo(2)),
          MyItemsScreen(onReport: () => _goTo(1)),
        ]),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          backgroundColor: AppColors.surface,
          indicatorColor: AppColors.navy,
          height: 62,
          onDestinationSelected: _goTo,
          destinations: [
            NavigationDestination(icon: const Icon(Icons.search), selectedIcon: Icon(Icons.search, color: AppColors.onNavy), label: 'Browse'),
            NavigationDestination(icon: const Icon(Icons.add_box_outlined), selectedIcon: Icon(Icons.add_box, color: AppColors.onNavy), label: 'Report'),
            NavigationDestination(icon: const Icon(Icons.list_alt), selectedIcon: Icon(Icons.list_alt, color: AppColors.onNavy), label: 'My Items'),
          ],
        ),
      );
}
