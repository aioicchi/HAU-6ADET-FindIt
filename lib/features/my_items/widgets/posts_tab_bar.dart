import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';

/// "MY POSTS (n) | RESOLVED (n)" segmented toggle.
class PostsTabBar extends StatelessWidget {
  const PostsTabBar({
    super.key,
    required this.activeCount,
    required this.resolvedCount,
    required this.showResolved,
    required this.onChanged,
  });

  final int activeCount;
  final int resolvedCount;
  final bool showResolved;
  final ValueChanged<bool> onChanged;

  Widget _tab(String label, bool selected, VoidCallback onTap) => Expanded(
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: selected ? AppColors.navy : Colors.transparent,
            alignment: Alignment.center,
            child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: selected ? Colors.white : AppColors.navy)),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(color: AppColors.surface, border: Border.all(color: AppColors.line)),
        child: Row(children: [
          _tab('MY POSTS ($activeCount)', !showResolved, () => onChanged(false)),
          _tab('RESOLVED ($resolvedCount)', showResolved, () => onChanged(true)),
        ]),
      );
}
