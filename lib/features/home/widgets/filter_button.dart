import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';
import 'package:findit/data/models/item.dart';

/// "FILTER ▾" dropdown: All / Lost / Found.
class FilterButton extends StatelessWidget {
  const FilterButton({super.key, required this.value, required this.onChanged});

  final ItemStatus? value;
  final ValueChanged<ItemStatus?> onChanged;

  @override
  Widget build(BuildContext context) => PopupMenuButton<ItemStatus?>(
        onSelected: onChanged,
        itemBuilder: (_) => const [
          PopupMenuItem(value: null, child: Text('All')),
          PopupMenuItem(value: ItemStatus.lost, child: Text('Lost')),
          PopupMenuItem(value: ItemStatus.found, child: Text('Found')),
        ],
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(color: Colors.white, border: Border.all(color: AppColors.line)),
          child: Row(children: [
            Text(value == null ? 'FILTER' : value!.name.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
            const Icon(Icons.keyboard_arrow_down, size: 16),
          ]),
        ),
      );
}
