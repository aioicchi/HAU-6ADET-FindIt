import 'package:flutter/material.dart';

/// On wide screens (web/desktop), renders the app inside a centered
/// phone-sized viewport so it looks like a mobile device. On real phones
/// it's a no-op.
class PhoneFrame extends StatelessWidget {
  const PhoneFrame({super.key, required this.child});

  final Widget child;

  static const _phoneSize = Size(390, 844); // iPhone 14-ish
  static const _breakpoint = 600.0;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    if (media.size.width < _breakpoint) return child;

    final height = (media.size.height - 32).clamp(500.0, _phoneSize.height);
    final size = Size(_phoneSize.width, height);

    return ColoredBox(
      color: const Color(0xFF1A1B1F),
      child: Center(
        child: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(36),
            border: Border.all(color: const Color(0xFF3A3B40), width: 8),
            boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 30, offset: Offset(0, 10))],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            // Tell the app its screen is phone-sized so layouts, dialogs and
            // bottom sheets all size themselves to the frame.
            child: MediaQuery(
              data: media.copyWith(size: Size(size.width - 16, size.height - 16)),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
