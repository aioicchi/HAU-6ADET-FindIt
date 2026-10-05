import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';

/// Upload placeholder. Toggles a simulated photo; wire up `image_picker` here later.
class PhotoUploadBox extends StatelessWidget {
  const PhotoUploadBox({super.key, required this.attached, required this.onTap});

  final bool attached;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Container(
          height: 120,
          decoration: BoxDecoration(color: Colors.white, border: Border.all(color: AppColors.line)),
          child: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(
                attached ? Icons.check_circle : Icons.add_a_photo_outlined,
                color: attached ? AppColors.found : AppColors.muted,
                size: 28,
              ),
              const SizedBox(height: 6),
              Text(
                attached ? 'PHOTO ATTACHED (TAP TO REMOVE)' : 'CLICK TO UPLOAD SCHEMATIC',
                style: const TextStyle(fontSize: 10, color: AppColors.muted),
              ),
            ]),
          ),
        ),
      );
}
