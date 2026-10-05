import 'package:flutter/material.dart';

/// Fades and slides its child up into place the first time it appears.
/// [index] staggers a list so cards arrive one after another (capped, so
/// long lists don't wait). Does nothing when the device asks for reduced motion.
class FadeSlideIn extends StatelessWidget {
  const FadeSlideIn({super.key, required this.child, this.index = 0});

  final Widget child;
  final int index;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 260 + 50 * index.clamp(0, 6)),
      curve: Curves.easeOutCubic,
      child: child,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(offset: Offset(0, 16 * (1 - t)), child: child),
      ),
    );
  }
}
