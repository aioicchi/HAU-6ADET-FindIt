import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';
import 'package:findit/core/utils/date_format.dart';
import 'package:findit/data/models/item.dart';

import 'item_photo.dart';
import 'status_tag.dart';

class ItemCard extends StatelessWidget {
  const ItemCard(this.item, {super.key, required this.onDetails});

  final Item item;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: AppColors.line)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ItemPhoto(item, height: 130),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: Text(item.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700))),
            StatusTag(item),
          ]),
          const SizedBox(height: 8),
          const Text('Location', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
          Text(item.location, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(timeAgo(item.date), style: const TextStyle(fontSize: 11, color: AppColors.muted)),
            OutlinedButton(
              onPressed: onDetails,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 30),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: .6),
              ),
              child: const Text('DETAILS'),
            ),
          ]),
        ]),
      );
}
