import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';
import 'package:findit/core/theme/app_text_styles.dart';
import 'package:findit/data/models/item.dart';

/// Everything the FILTER sheet controls. Category lives in the chip row instead.
class HomeFilters {
  const HomeFilters({this.status, this.location, this.newestFirst = true, this.showResolved = false});

  final ItemStatus? status;
  final String? location;
  final bool newestFirst;
  final bool showResolved;

  /// How many filters differ from the defaults, shown on the button.
  int get activeCount =>
      (status != null ? 1 : 0) + (location != null ? 1 : 0) + (newestFirst ? 0 : 1) + (showResolved ? 1 : 0);

  bool matches(Item i) =>
      (status == null || i.status == status) && (location == null || i.location == location) && (showResolved || !i.resolved);
}

/// "FILTER ▾" button that opens a bottom sheet of [HomeFilters].
class FilterButton extends StatelessWidget {
  const FilterButton({super.key, required this.value, required this.locations, required this.onChanged});

  final HomeFilters value;
  final List<String> locations;
  final ValueChanged<HomeFilters> onChanged;

  Future<void> _open(BuildContext context) async {
    final result = await showModalBottomSheet<HomeFilters>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _FilterSheet(initial: value, locations: locations),
    );
    if (result != null) onChanged(result);
  }

  @override
  Widget build(BuildContext context) {
    final n = value.activeCount;
    return InkWell(
      onTap: () => _open(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: n > 0 ? AppColors.navy : AppColors.surface,
          border: Border.all(color: n > 0 ? AppColors.navy : AppColors.line),
        ),
        child: Row(children: [
          Icon(Icons.tune, size: 14, color: n > 0 ? Colors.white : null),
          const SizedBox(width: 4),
          Text(
            n > 0 ? 'FILTER ($n)' : 'FILTER',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: n > 0 ? Colors.white : null),
          ),
          Icon(Icons.keyboard_arrow_down, size: 16, color: n > 0 ? Colors.white : null),
        ]),
      ),
    );
  }
}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.initial, required this.locations});

  final HomeFilters initial;
  final List<String> locations;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late ItemStatus? _status = widget.initial.status;
  late String? _location = widget.initial.location;
  late bool _newestFirst = widget.initial.newestFirst;
  late bool _showResolved = widget.initial.showResolved;

  Widget _choice(String label, bool selected, VoidCallback onTap) => ChoiceChip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        selected: selected,
        onSelected: (_) => onTap(),
      );

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Expanded(child: Text('Filters', style: AppTextStyles.sectionTitle)),
              TextButton(
                onPressed: () => Navigator.pop(context, const HomeFilters()),
                child: const Text('Reset'),
              ),
            ]),
            const SizedBox(height: 8),
            Text('STATUS', style: AppTextStyles.label),
            const SizedBox(height: 6),
            Wrap(spacing: 8, children: [
              _choice('All', _status == null, () => setState(() => _status = null)),
              _choice('Lost', _status == ItemStatus.lost, () => setState(() => _status = ItemStatus.lost)),
              _choice('Found', _status == ItemStatus.found, () => setState(() => _status = ItemStatus.found)),
            ]),
            const SizedBox(height: 14),
            Text('LOCATION', style: AppTextStyles.label),
            const SizedBox(height: 6),
            DropdownButtonFormField<String?>(
              initialValue: _location,
              isExpanded: true,
              items: [
                const DropdownMenuItem(value: null, child: Text('Anywhere on campus', style: TextStyle(fontSize: 13))),
                for (final l in widget.locations)
                  DropdownMenuItem(value: l, child: Text(l, style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis)),
              ],
              onChanged: (v) => setState(() => _location = v),
            ),
            const SizedBox(height: 14),
            Text('SORT BY DATE', style: AppTextStyles.label),
            const SizedBox(height: 6),
            Wrap(spacing: 8, children: [
              _choice('Newest first', _newestFirst, () => setState(() => _newestFirst = true)),
              _choice('Oldest first', !_newestFirst, () => setState(() => _newestFirst = false)),
            ]),
            const SizedBox(height: 6),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Show resolved items', style: TextStyle(fontSize: 13)),
              value: _showResolved,
              onChanged: (v) => setState(() => _showResolved = v),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(
                  context,
                  HomeFilters(status: _status, location: _location, newestFirst: _newestFirst, showResolved: _showResolved),
                ),
                child: const Text('Apply'),
              ),
            ),
          ]),
        ),
      );
}
