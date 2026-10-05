import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:findit/app.dart';
import 'package:findit/core/theme/theme_controller.dart';
import 'package:findit/data/app_store.dart';
import 'package:findit/data/mock_data.dart';
import 'package:findit/features/onboarding/onboarding_state.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  /// Opens the app the way main.dart does, with the intro slides on.
  Future<void> launch(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 2, 844 * 2);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    showIntroOnLaunch = true;
    addTearDown(() => showIntroOnLaunch = false);

    await tester.pumpWidget(const FindItApp());
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();
  }

  Future<void> getStarted(WidgetTester tester) async {
    for (var i = 0; i < 2; i++) {
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();
  }

  testWidgets('opening the app walks through the three slides, then login', (tester) async {
    store.logout();
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
  });

  testWidgets('Skip goes straight to login', (tester) async {
    store.logout();
    await launch(tester);
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    expect(find.text('Sign In'), findsOneWidget);
  });

  testWidgets('the slides come up again every time the app opens', (tester) async {
    store.logout();
    await launch(tester);
    await getStarted(tester);
    expect(find.text('Sign In'), findsOneWidget);

    // Close and reopen the app.
    await tester.pumpWidget(const SizedBox());
    await launch(tester);
    expect(find.text('Lost something on campus?'), findsOneWidget);
  });

  testWidgets('already signed in: the slides, then straight to Home', (tester) async {
    store.login(MockData.demoEmail, MockData.demoPassword);
    await launch(tester);
    expect(find.text('Lost something on campus?'), findsOneWidget);
    await getStarted(tester);
    expect(find.text('Lost & Found Items'), findsOneWidget);
  });

  for (final dark in [false, true]) {
    testWidgets('slides meet accessibility guidelines (${dark ? 'night' : 'day'})', (tester) async {
      final handle = tester.ensureSemantics();
      themeController.setMode(dark ? ThemeMode.dark : ThemeMode.light);
      store.logout();
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
