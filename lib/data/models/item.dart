import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';
import 'package:findit/core/utils/date_format.dart';

enum ItemStatus { lost, found }

class Item {
  /// Choices for the report form. The picked one is stored as the item's first tag.
  static const categories = ['ID CARD', 'KEYS', 'BAG', 'WALLET', 'ELECTRONICS', 'TUMBLER', 'UMBRELLA', 'CLOTHING', 'OTHER'];

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
    this.photo,
    this.photoAsset,
    this.resolved = false,
    this.inquiries = 0,
    this.note,
    this.claimAt,
    this.verifyQuestion,
  });

  factory Item.fromJson(Map<String, dynamic> j) {
    final photo = j['photo'] as String?;
    return Item(
      id: j['id'] as String,
      name: j['name'] as String,
      description: j['description'] as String,
      status: ItemStatus.values.byName(j['status'] as String),
      location: j['location'] as String,
      date: DateTime.parse(j['date'] as String),
      contact: j['contact'] as String,
      ownerId: j['ownerId'] as String,
      tags: List<String>.from(j['tags'] as List? ?? const []),
      hasPhoto: j['hasPhoto'] as bool? ?? false,
      photo: photo == null ? null : base64Decode(photo),
      photoAsset: j['photoAsset'] as String?,
      resolved: j['resolved'] as bool? ?? false,
      inquiries: j['inquiries'] as int? ?? 0,
      note: j['note'] as String?,
      claimAt: j['claimAt'] as String?,
      verifyQuestion: j['verifyQuestion'] as String?,
    );
  }

  final String id;
  final String ownerId;
  String name;
  String description;
  ItemStatus status;
  String location;
  DateTime date;
  String contact;
  List<String> tags;
  /// Set without [photo] or [photoAsset] to show the item's [icon] instead.
  bool hasPhoto;

  /// The picked image's bytes. Saved with the item as base64.
  Uint8List? photo;

  /// A bundled image under assets/images/, used by the demo items.
  String? photoAsset;
  bool resolved;
  int inquiries;
  String? note;

  /// Found items only: where the owner can pick it up, e.g. "Security Office".
  String? claimAt;

  /// Found items only: what the finder asks claimers, to check the item is theirs.
  String? verifyQuestion;

  static const defaultVerifyQuestion =
      'Describe something only the owner would know: a mark, a sticker, a name, or what was inside.';

  String get claimQuestion {
    final q = verifyQuestion;
    return q == null || q.trim().isEmpty ? defaultVerifyQuestion : q;
  }

  /// The category picked on the report form, if any.
  String? get category => tags.where(categories.contains).firstOrNull;

  /// The real photo to show, if there is one. An uploaded photo wins over a bundled one.
  ImageProvider? get photoImage {
    final bytes = photo;
    if (bytes != null) return MemoryImage(bytes);
    final asset = photoAsset;
    if (asset != null) return AssetImage(asset);
    return null;
  }

  /// With [withPhoto] false the uploaded photo is left out, to save space.
  Map<String, dynamic> toJson({bool withPhoto = true}) {
    final bytes = photo;
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status.name,
      'location': location,
      'date': date.toIso8601String(),
      'contact': contact,
      'ownerId': ownerId,
      'tags': tags,
      'hasPhoto': hasPhoto,
      'photo': withPhoto && bytes != null ? base64Encode(bytes) : null,
      'photoAsset': photoAsset,
      'resolved': resolved,
      'inquiries': inquiries,
      'note': note,
      'claimAt': claimAt,
      'verifyQuestion': verifyQuestion,
    };
  }

  bool get isLost => status == ItemStatus.lost;
  String get statusLabel => isLost ? 'LOST' : 'FOUND';

  /// "Lost 2 hours ago", "Found yesterday", "Found on January 30, 2026".
  String get whenLabel {
    final verb = isLost ? 'Lost' : 'Found';
    return isOlderThanAWeek(date) ? '$verb on ${fullDate(date)}' : '$verb ${timeAgo(date).toLowerCase()}';
  }
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
    if (n.contains('wallet')) return Icons.account_balance_wallet_outlined;
    if (n.contains('clothing') || n.contains('jacket')) return Icons.checkroom_outlined;
    if (n.contains('electronics') || n.contains('laptop')) return Icons.devices_outlined;
    return Icons.inventory_2_outlined;
  }
}
