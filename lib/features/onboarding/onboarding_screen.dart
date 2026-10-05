import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';
import 'package:findit/core/theme/app_text_styles.dart';

import 'onboarding_state.dart';

/// Three intro slides: Browse, Report, Claim. Shown once after the splash
/// screen, and again from Profile > How FindIt Works.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onDone});

  /// Called when the user taps Skip or Get Started.
  final VoidCallback onDone;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _Slide {
  const _Slide(this.icon, this.title, this.body);

  final IconData icon;
  final String title;
  final String body;
}

const _slides = [
  _Slide(
    Icons.search,
    'Lost something on campus?',
    'Browse every lost and found report. Filter by category or building, and FindIt tells you when a found item looks like yours.',
  ),
  _Slide(
    Icons.add_box_outlined,
    'Found something? Report it',
    'Add a photo, pick where you found it, and say where the owner can claim it. Your contact info stays private.',
  ),
  _Slide(
    Icons.verified_user_outlined,
    'Claim it safely',
    "Answer the finder's question to prove it's yours. Once they approve, you'll know exactly where to pick it up.",
  ),
];

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pages = PageController();
  int _page = 0;

  bool get _isLast => _page == _slides.length - 1;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _finish() {
    onboarding.markSeen();
    widget.onDone();
  }

  void _next() {
    if (_isLast) {
      _finish();
      return;
    }
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (reduceMotion) {
      _pages.jumpToPage(_page + 1);
    } else {
      _pages.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOutCubic);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Column(children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(8),
                // Hidden on the last slide, where Get Started does the same thing.
                child: Visibility(
                  visible: !_isLast,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: TextButton(onPressed: _finish, child: const Text('Skip')),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pages,
                onPageChanged: (i) => setState(() => _page = i),
                children: [
                  for (final (i, s) in _slides.indexed)
                    Semantics(
                      label: 'Step ${i + 1} of ${_slides.length}',
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(color: AppColors.banner, shape: BoxShape.circle),
                            child: Icon(s.icon, size: 56, color: AppColors.navy),
                          ),
                          const SizedBox(height: 32),
                          Text(s.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 12),
                          Text(s.body, textAlign: TextAlign.center, style: AppTextStyles.caption.copyWith(fontSize: 15, height: 1.4)),
                        ]),
                      ),
                    ),
                ],
              ),
            ),
            // Page dots: decorative, the slide itself already says "Step x of 3".
            ExcludeSemantics(
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                for (var i = 0; i < _slides.length; i++)
                  AnimatedContainer(
                    duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _page ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == _page ? AppColors.navy : AppColors.line,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
              child: FilledButton(onPressed: _next, child: Text(_isLast ? 'Get Started' : 'Next')),
            ),
          ]),
        ),
      );
}
