import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';
import 'package:findit/data/models/item.dart';

/// Photo placeholder: shows the item's icon when a photo is "attached",
/// otherwise an empty wireframe box.
class ItemPhoto extends StatelessWidget {
  const ItemPhoto(this.item, {super.key, this.height = 150, this.emptyLabel = 'No photo'});

  final Item item;
  final double height;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: item.hasPhoto ? AppColors.photoBg : Colors.white,
          border: Border.all(color: AppColors.line),
        ),
        child: Center(
          child: item.hasPhoto
              ? Icon(item.icon, size: height * .45, color: AppColors.navy.withValues(alpha: .6))
              : height < 80
                  ? const Icon(Icons.image_outlined, color: AppColors.hint)
                  : Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: AppColors.background, border: Border.all(color: AppColors.line)),
                      child: Text(emptyLabel, style: const TextStyle(fontSize: 11)),
                    ),
        ),
      );
}
