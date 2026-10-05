import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';
import 'package:findit/features/home/home_screen.dart';
import 'package:findit/features/my_items/my_items_screen.dart';
import 'package:findit/features/report/report_item_screen.dart';

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
  Widget build(BuildContext context) => Scaffold(
        body: IndexedStack(index: _index, children: [
          const HomeScreen(),
          ReportItemScreen(onSubmitted: () => _goTo(2)),
          const MyItemsScreen(),
        ]),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          backgroundColor: Colors.white,
          indicatorColor: AppColors.navy,
          height: 62,
          onDestinationSelected: _goTo,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.search), selectedIcon: Icon(Icons.search, color: Colors.white), label: 'Browse'),
            NavigationDestination(icon: Icon(Icons.add_box_outlined), selectedIcon: Icon(Icons.add_box, color: Colors.white), label: 'Report'),
            NavigationDestination(icon: Icon(Icons.list_alt), selectedIcon: Icon(Icons.list_alt, color: Colors.white), label: 'My Items'),
          ],
        ),
      );
}
