import 'package:flutter/material.dart';

/// Fades and slides its child up into place the first time it appears.
///
/// It waits until the page it's on has finished its own transition (e.g.
/// after the splash screen or login), so the movement is actually seen.
/// [index] staggers a list so cards arrive one after another (capped, so long
/// lists don't wait). Does nothing when the device asks for reduced motion.
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({super.key, required this.child, this.index = 0});

  final Widget child;
  final int index;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn> with SingleTickerProviderStateMixin {
  static const _move = Duration(milliseconds: 260);
  static const _stagger = Duration(milliseconds: 60);

  // The stagger is built into the animation (it holds still at the start), so
  // no separate timer is needed.
  late final Duration _delay = _stagger * widget.index.clamp(0, 6);
  late final AnimationController _controller = AnimationController(vsync: this, duration: _delay + _move);
  late final Animation<double> _t = CurvedAnimation(
    parent: _controller,
    curve: Interval(_delay.inMilliseconds / (_delay + _move).inMilliseconds, 1, curve: Curves.easeOutCubic),
  );

  Animation<double>? _pageTransition;
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
      _started = true;
      return;
    }
    final page = ModalRoute.of(context)?.animation;
    // On a page's very first build its transition isn't attached yet and
    // reads as "completed", so look again once the first frame is drawn.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _started) return;
      if (page == null || page.isCompleted) {
        _start();
      } else {
        _pageTransition ??= page..addStatusListener(_onPageTransition);
      }
    });
  }

  void _onPageTransition(AnimationStatus status) {
    if (status == AnimationStatus.completed) _start();
  }

  void _start() {
    _pageTransition?.removeStatusListener(_onPageTransition);
    _pageTransition = null;
    if (_started || !mounted) return;
    _started = true;
    _controller.forward();
  }

  @override
  void dispose() {
    _pageTransition?.removeStatusListener(_onPageTransition);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _t,
        child: widget.child,
        builder: (context, child) => Opacity(
          opacity: _t.value,
          child: Transform.translate(offset: Offset(0, 16 * (1 - _t.value)), child: child),
        ),
      );
}
