import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';
import 'package:findit/core/theme/app_theme.dart';
import 'package:findit/data/models/item.dart';

import 'item_photo.dart';
import 'status_tag.dart';

class ItemCard extends StatelessWidget {
  const ItemCard(this.item, {super.key, required this.onDetails, this.heroTag});

  final Item item;
  final VoidCallback onDetails;

  /// Pass the same tag to the details page so the photo grows into it.
  final String? heroTag;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppColors.surface, border: Border.all(color: AppColors.line)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ItemPhoto(item, height: 130, heroTag: heroTag),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: Text(item.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700))),
            StatusTag(item),
          ]),
          const SizedBox(height: 8),
          const Text('Location', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
          Text(item.fullLocation, style: TextStyle(fontSize: 12, color: AppColors.muted)),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(item.whenLabel, style: TextStyle(fontSize: 11, color: AppColors.muted)),
            OutlinedButton(
              onPressed: onDetails,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 30),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                textStyle: const TextStyle(fontFamily: AppTheme.font, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: .6),
              ),
              child: Text('DETAILS', semanticsLabel: 'View details for ${item.name}'),
            ),
          ]),
        ]),
      );
}
