import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';

enum ItemStatus { lost, found }

class Item {
  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.location,
    required this.date,
    required this.contact,
    required this.ownerId,
    this.tags = const [],
    this.hasPhoto = false,
    this.resolved = false,
    this.inquiries = 0,
    this.note,
  });

  final String id;
  final String ownerId;
  String name;
  String description;
  ItemStatus status;
  String location;
  DateTime date;
  String contact;
  List<String> tags;
  bool hasPhoto;
  bool resolved;
  int inquiries;
  String? note;

  bool get isLost => status == ItemStatus.lost;
  String get statusLabel => isLost ? 'LOST' : 'FOUND';
  Color get statusColor => isLost ? AppColors.lost : AppColors.found;

  /// Icon used as a photo placeholder, picked from the item's name and tags.
  IconData get icon {
    final n = '$name ${tags.join(' ')}'.toLowerCase();
    if (n.contains('id') || n.contains('card')) return Icons.badge_outlined;
    if (n.contains('key')) return Icons.vpn_key_outlined;
    if (n.contains('umbrella')) return Icons.beach_access_outlined;
    if (n.contains('bag') || n.contains('backpack')) return Icons.backpack_outlined;
    if (n.contains('phone') || n.contains('charger')) return Icons.smartphone_outlined;
    if (n.contains('tumbler') || n.contains('bottle') || n.contains('flask')) return Icons.local_drink_outlined;
    return Icons.inventory_2_outlined;
  }
}
