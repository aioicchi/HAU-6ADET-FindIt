import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';
import 'package:findit/data/models/item.dart';

/// Shows the item's real photo (uploaded or bundled) if it has one, its icon
/// when a placeholder photo is "attached", otherwise an empty wireframe box.
///
/// With [zoomable], tapping a real photo opens it full screen.
///
/// Give a list photo and the details page it opens the same [heroTag] (see
/// [ItemPhoto.tagFor]) and the photo grows from one into the other.
class ItemPhoto extends StatelessWidget {
  const ItemPhoto(this.item, {super.key, this.height = 150, this.emptyLabel = 'No photo', this.zoomable = false, this.heroTag});

  final Item item;
  final double height;
  final String emptyLabel;
  final bool zoomable;
  final String? heroTag;

  /// A tag unique to one place in the app. Home and My Items are both kept
  /// alive, so the same item needs a different tag in each.
  static String tagFor(String place, Item item) => 'photo-$place-${item.id}';

  /// Wraps [child] in a Hero, unless there's no tag or the device asks for reduced motion.
  static Widget hero(BuildContext context, String? tag, Widget child) {
    if (tag == null || MediaQuery.disableAnimationsOf(context)) return child;
    return Hero(tag: tag, child: child);
  }

  @override
  Widget build(BuildContext context) {
    final photo = item.photoImage;
    if (photo != null) {
      // The zoom view always animates from here, even when this page itself
      // was opened without one (e.g. from a notification).
      final tag = zoomable ? (heroTag ?? tagFor('zoom', item)) : heroTag;
      final image = hero(
        context,
        tag,
        Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(color: AppColors.photoBg, border: Border.all(color: AppColors.line)),
          child: Image(image: photo, fit: BoxFit.cover, gaplessPlayback: true, semanticLabel: 'Photo of ${item.name}'),
        ),
      );
      if (!zoomable) return image;
      return Semantics(
        button: true,
        label: 'Photo of ${item.name}. Open full screen',
        excludeSemantics: true,
        child: GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PhotoViewer(item, heroTag: tag))),
          child: Stack(children: [
            image,
            const Positioned(
              right: 8,
              bottom: 8,
              child: CircleAvatar(radius: 14, backgroundColor: Colors.black54, child: Icon(Icons.zoom_in, size: 16, color: Colors.white)),
            ),
          ]),
        ),
      );
    }

    return hero(
      context,
      heroTag,
      Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: item.hasPhoto ? AppColors.photoBg : AppColors.surface,
          border: Border.all(color: AppColors.line),
        ),
        child: Center(
          child: item.hasPhoto
              ? Icon(item.icon, size: height * .45, color: AppColors.navy.withValues(alpha: .6))
              : height < 80
                  ? Icon(Icons.image_outlined, color: AppColors.hint)
                  : Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: AppColors.background, border: Border.all(color: AppColors.line)),
                      child: Text(emptyLabel, style: const TextStyle(fontSize: 11)),
                    ),
        ),
      ),
    );
  }
}

/// Full-screen view of an item's photo with pinch/scroll zoom.
class PhotoViewer extends StatelessWidget {
  const PhotoViewer(this.item, {super.key, this.heroTag});

  final Item item;

  /// The tag of the photo this was opened from, so it grows into place.
  final String? heroTag;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: Text(item.name),
        ),
        body: InteractiveViewer(
          maxScale: 5,
          child: Center(child: ItemPhoto.hero(context, heroTag, Image(image: item.photoImage!))),
        ),
      );
}
