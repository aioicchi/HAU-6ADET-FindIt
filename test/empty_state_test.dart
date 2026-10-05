import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:findit/app.dart';
import 'package:findit/core/theme/theme_controller.dart';
import 'package:findit/data/app_store.dart';
import 'package:findit/features/item_details/item_details_screen.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<void> signIn(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 2, 844 * 2);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    // Not awaited: the data resets right away, and awaiting would wait on a save
    // started in an earlier test, which never finishes in this one.
    store.resetDemoData();
    await tester.pumpWidget(const FindItApp());
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();
  }

  testWidgets('"Clear search & filters" brings every item back', (tester) async {
    await signIn(tester);
    await tester.enterText(find.byType(TextField).first, 'spaceship');
    await tester.pumpAndSettle();
    expect(find.text('No matches'), findsOneWidget);

    await tester.tap(find.text('Clear search & filters'));
    await tester.pumpAndSettle();
    expect(find.text('No matches'), findsNothing);
    expect(find.text('5 items'), findsOneWidget);
    expect(find.text('spaceship'), findsNothing); // The search box was cleared too.
  });

  testWidgets('"Report an item" on an empty My Items opens the Report tab', (tester) async {
    await signIn(tester);
    for (final i in store.myItems) {
      store.deleteItem(i.id);
    }
    await tester.tap(find.text('My Items'));
    await tester.pumpAndSettle();
    expect(find.text('No active reports'), findsOneWidget);

    await tester.tap(find.text('Report an item'));
    await tester.pumpAndSettle();
    expect(find.text('Report Item'), findsOneWidget);
  });

  testWidgets('a deleted report says so and offers a way back', (tester) async {
    await signIn(tester);
    tester.state<NavigatorState>(find.byType(Navigator).first).push(
      MaterialPageRoute(builder: (_) => const ItemDetailsScreen(itemId: 'deleted')),
    );
    await tester.pumpAndSettle();
    expect(find.text('This report is gone'), findsOneWidget);

    await tester.tap(find.text('Go back'));
    await tester.pumpAndSettle();
    expect(find.text('Lost & Found Items'), findsOneWidget);
  });

  for (final dark in [false, true]) {
    testWidgets('empty states meet accessibility guidelines (${dark ? 'night' : 'day'})', (tester) async {
      final handle = tester.ensureSemantics();
      themeController.setMode(dark ? ThemeMode.dark : ThemeMode.light);
      await signIn(tester);
      await tester.enterText(find.byType(TextField).first, 'spaceship');
      await tester.pumpAndSettle();
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      themeController.setMode(ThemeMode.light);
      handle.dispose();
    });
  }
}
