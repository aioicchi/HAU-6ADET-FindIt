import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:findit/app.dart';
import 'package:findit/data/app_store.dart';
import 'package:findit/features/item_details/item_details_screen.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<void> signIn(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 2, 844 * 2);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    store.logout();
    await tester.pumpWidget(const FindItApp());
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();
  }

  /// Images drawn outside every page: only a photo in mid-flight between two pages is.
  int flyingImages(WidgetTester tester) => find.byType(Image).evaluate().where((e) {
        var insidePage = false;
        e.visitAncestorElements((a) {
          insidePage = a.widget.runtimeType.toString().startsWith('_ModalScope');
          return !insidePage;
        });
        return !insidePage;
      }).length;

  /// Taps [button] and checks whether a photo flies during the page change.
  Future<void> tapAndCheckFlight(WidgetTester tester, Finder button, {required bool flies}) async {
    await tester.tap(button);
    await tester.pump(); // Start the page change.
    await tester.pump(const Duration(milliseconds: 150)); // Halfway.
    expect(flyingImages(tester), flies ? greaterThan(0) : 0);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull); // e.g. no "multiple heroes share the same tag".
  }

  Future<void> expectPhotoFlies(WidgetTester tester, Finder button) => tapAndCheckFlight(tester, button, flies: true);

  testWidgets('photo grows from a Home card into Item Details, then full screen', (tester) async {
    await signIn(tester);
    // Visit My Items first so both tabs (with the same items) are alive.
    await tester.tap(find.text('My Items'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Browse'));
    await tester.pumpAndSettle();

    await expectPhotoFlies(tester, find.bySemanticsLabel('View details for Student ID').first);
    expect(find.byType(ItemDetailsScreen), findsOneWidget);

    await expectPhotoFlies(tester, find.bySemanticsLabel('Photo of Student ID. Open full screen'));
    expect(find.byType(InteractiveViewer), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('photo grows from a My Items card', (tester) async {
    await signIn(tester);
    await tester.tap(find.text('My Items'));
    await tester.pumpAndSettle();
    await expectPhotoFlies(tester, find.bySemanticsLabel('View Student ID'));
    expect(find.byType(ItemDetailsScreen), findsOneWidget);
  });

  testWidgets('no photo animation when the device asks for reduced motion', (tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue = const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await signIn(tester);
    expect(find.byType(Hero, skipOffstage: false), findsNothing);
    await tapAndCheckFlight(tester, find.bySemanticsLabel('View details for Student ID').first, flies: false);
    expect(find.byType(ItemDetailsScreen), findsOneWidget);
  });
}
