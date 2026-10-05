import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';

import 'fade_slide_in.dart';

/// Shown in place of an empty list or a missing page: an icon in a circle, a
/// short [title], a [message] saying what to do, and optionally a button
/// ([actionLabel] + [onAction]) that does it.
class EmptyState extends StatelessWidget {
  const EmptyState(
    this.message, {
    super.key,
    this.title,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
  });

  final String message;
  final String? title;
  final IconData icon;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    final label = actionLabel;
    return FadeSlideIn(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            ExcludeSemantics(
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(color: AppColors.banner, shape: BoxShape.circle),
                child: Icon(icon, size: 44, color: AppColors.navy),
              ),
            ),
            const SizedBox(height: 16),
            if (title != null) ...[
              Semantics(
                header: true,
                child: Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 6),
            ],
            Text(message, textAlign: TextAlign.center, style: TextStyle(color: AppColors.muted, height: 1.4)),
            if (label != null && onAction != null) ...[
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: onAction,
                icon: Icon(actionIcon ?? Icons.arrow_forward, size: 18),
                label: Text(label),
                // Sized to its label, not stretched across the screen like form buttons.
                style: FilledButton.styleFrom(minimumSize: const Size(0, 48), padding: const EdgeInsets.symmetric(horizontal: 24)),
              ),
            ],
          ]),
        ),
      ),
    );
  }
}

/// A whole page for a report that was deleted while it was open, or a link to one that's gone.
class MissingReport extends StatelessWidget {
  const MissingReport({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: EmptyState(
          'It may have been deleted by the person who reported it.',
          title: 'This report is gone',
          icon: Icons.search_off,
          actionLabel: 'Go back',
          actionIcon: Icons.arrow_back,
          onAction: () => Navigator.maybePop(context),
        ),
      );
}
