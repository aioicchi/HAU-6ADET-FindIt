import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:findit/app.dart';
import 'package:findit/data/app_store.dart';
import 'package:findit/shared/shared.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  /// How visible the card showing [text] is (its nearest FadeSlideIn's opacity).
  double opacityOf(WidgetTester tester, Finder text) => tester
      .widget<Opacity>(find.descendant(of: find.ancestor(of: text, matching: find.byType(FadeSlideIn)).first, matching: find.byType(Opacity)).first)
      .opacity;

  testWidgets('a card waits for its page to finish sliding in, then fades in', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const Scaffold(body: FadeSlideIn(child: Text('card')))),
          ),
          child: const Text('open'),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150)); // Page still sliding in.
    expect(opacityOf(tester, find.text('card')), 0);

    await tester.pumpAndSettle(); // Page done, then the card's own fade.
    expect(opacityOf(tester, find.text('card')), 1);
  });

  testWidgets('pull to refresh plays the cards fade-in again', (tester) async {
    tester.view.physicalSize = const Size(390 * 2, 844 * 2);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    store.logout();
    await tester.pumpWidget(const FindItApp());
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    final card = find.text('Student ID').first;
    expect(opacityOf(tester, card), 1);

    await tester.fling(find.text('SEARCH ITEMS...'), const Offset(0, 400), 1000);
    await tester.pump(); // Start the refresh.
    await tester.pump(const Duration(seconds: 1)); // Refresh finishes, cards are rebuilt.
    await tester.pump(const Duration(milliseconds: 16));
    expect(opacityOf(tester, card), lessThan(1)); // Fading in again.

    await tester.pumpAndSettle();
    expect(opacityOf(tester, card), 1);
  });
}
