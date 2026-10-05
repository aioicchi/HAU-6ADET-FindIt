import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';

/// Upload box. Shows a preview of [photo] when there is one, the placeholder
/// "attached" state when only [attached] is set, otherwise an upload prompt.
class PhotoUploadBox extends StatelessWidget {
  const PhotoUploadBox({super.key, required this.photo, required this.attached, required this.onTap});

  final ImageProvider? photo;
  final bool attached;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final photo = this.photo;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: photo != null ? 180 : 120,
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: AppColors.line)),
        child: photo != null
            ? Stack(fit: StackFit.expand, children: [
                Image(image: photo, fit: BoxFit.cover),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    color: Colors.black54,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: const Text(
                      'TAP TO CHANGE OR REMOVE',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
              ])
            : Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(
                    attached ? Icons.check_circle : Icons.add_a_photo_outlined,
                    color: attached ? AppColors.found : AppColors.muted,
                    size: 28,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    attached ? 'PHOTO ATTACHED (TAP TO CHANGE)' : 'TAP TO UPLOAD A PHOTO',
                    style: const TextStyle(fontSize: 10, color: AppColors.muted),
                  ),
                ]),
              ),
      ),
    );
  }
}
