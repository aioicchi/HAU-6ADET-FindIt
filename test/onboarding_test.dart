import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:findit/app.dart';
import 'package:findit/core/theme/theme_controller.dart';
import 'package:findit/data/app_store.dart';
import 'package:findit/features/onboarding/onboarding_state.dart';

void main() {
  /// Starts the app like a fresh install (or a returning one, with [seen]).
  Future<void> launch(WidgetTester tester, {bool seen = false}) async {
    tester.view.physicalSize = const Size(390 * 2, 844 * 2);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({if (seen) 'findit_onboarded': true});
    await onboarding.load();
    store.logout();

    await tester.pumpWidget(const FindItApp());
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();
  }

  testWidgets('first launch walks through the three slides, then login', (tester) async {
    await launch(tester);

    expect(find.text('Lost something on campus?'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Found something? Report it'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Claim it safely'), findsOneWidget);
    // Hidden (not tappable) on the last slide, where Get Started does the same thing.
    expect(find.text('Skip').hitTestable(), findsNothing);

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();
    expect(find.text('Sign In'), findsOneWidget);
    expect((await SharedPreferences.getInstance()).getBool('findit_onboarded'), isTrue);
  });

  testWidgets('Skip goes straight to login', (tester) async {
    await launch(tester);
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    expect(find.text('Sign In'), findsOneWidget);
    expect(onboarding.seen, isTrue);
  });

  testWidgets('the slides only show once', (tester) async {
    await launch(tester, seen: true);
    expect(find.text('Lost something on campus?'), findsNothing);
    expect(find.text('Sign In'), findsOneWidget);
  });

  for (final dark in [false, true]) {
    testWidgets('slides meet accessibility guidelines (${dark ? 'night' : 'day'})', (tester) async {
      final handle = tester.ensureSemantics();
      themeController.setMode(dark ? ThemeMode.dark : ThemeMode.light);
      await launch(tester);
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      expect(find.bySemanticsLabel(RegExp('Step 1 of 3')), findsOneWidget);
      themeController.setMode(ThemeMode.light);
      handle.dispose();
    });
  }
}
