import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';
import 'package:findit/data/models/item.dart';

/// Shows the item's real photo (uploaded or bundled) if it has one, its icon
/// when a placeholder photo is "attached", otherwise an empty wireframe box.
///
/// With [zoomable], tapping a real photo opens it full screen.
class ItemPhoto extends StatelessWidget {
  const ItemPhoto(this.item, {super.key, this.height = 150, this.emptyLabel = 'No photo', this.zoomable = false});

  final Item item;
  final double height;
  final String emptyLabel;
  final bool zoomable;

  @override
  Widget build(BuildContext context) {
    final photo = item.photoImage;
    if (photo != null) {
      final image = Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(color: AppColors.photoBg, border: Border.all(color: AppColors.line)),
        child: Image(image: photo, fit: BoxFit.cover, gaplessPlayback: true),
      );
      if (!zoomable) return image;
      return GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PhotoViewer(item))),
        child: Stack(children: [
          image,
          const Positioned(
            right: 8,
            bottom: 8,
            child: CircleAvatar(radius: 14, backgroundColor: Colors.black54, child: Icon(Icons.zoom_in, size: 16, color: Colors.white)),
          ),
        ]),
      );
    }

    return Container(
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
}

/// Full-screen view of an item's photo with pinch/scroll zoom.
class PhotoViewer extends StatelessWidget {
  const PhotoViewer(this.item, {super.key});

  final Item item;

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
          child: Center(child: Image(image: item.photoImage!)),
        ),
      );
}
