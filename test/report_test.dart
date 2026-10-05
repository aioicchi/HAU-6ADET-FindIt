import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:findit/app.dart';
import 'package:findit/data/app_store.dart';
import 'package:findit/data/campus.dart';
import 'package:findit/features/report/report_item_screen.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  /// Signs in (if needed) and opens the Report tab on a phone-sized screen.
  Future<void> openReportForm(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 2, 844 * 2);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const FindItApp());
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();
    if (find.text('Sign In').evaluate().isNotEmpty) {
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('Report'));
    await tester.pumpAndSettle();
  }

  /// Scrolls the form until [finder] is built (the list is lazy), then centers it,
  /// clear of the bottom navigation bar.
  Future<void> show(WidgetTester tester, Finder finder) async {
    final form = find.descendant(of: find.byType(ReportItemScreen), matching: find.byType(Scrollable)).first;
    await tester.scrollUntilVisible(finder, 200, scrollable: form);
    await Scrollable.ensureVisible(tester.element(finder.first), alignment: 0.5);
    await tester.pumpAndSettle();
  }

  /// Opens the dropdown showing [dropdownHint] and picks [option].
  /// hitTestable() skips the Home tab, which stays alive (hidden) behind the Report tab.
  Future<void> pick(WidgetTester tester, String dropdownHint, String option) async {
    final dropdown = find.ancestor(
      of: find.text(dropdownHint),
      matching: find.byWidgetPredicate((w) => w is DropdownButtonFormField),
    );
    await show(tester, find.text(dropdownHint));
    await tester.tap(dropdown.first);
    await tester.pumpAndSettle();
    await tester.tap(find.text(option).hitTestable().last);
    await tester.pumpAndSettle();
  }

  Future<void> type(WidgetTester tester, String hint, String text) async {
    final field = find.widgetWithText(TextFormField, hint);
    await show(tester, field);
    await tester.enterText(field, text);
    await tester.pump();
  }

  Future<void> submit(WidgetTester tester) async {
    await show(tester, find.text('Submit Report'));
    await tester.tap(find.text('Submit Report').hitTestable());
    await tester.pumpAndSettle();
  }

  testWidgets('report a lost item at a place not on the campus list', (tester) async {
    await openReportForm(tester);

    await type(tester, 'Enter short title...', 'Black Wallet');
    await pick(tester, 'Select Category', 'Wallet');
    await pick(tester, 'Select Status', 'Lost');
    await pick(tester, 'Select building or area', otherLocation);
    await type(tester, 'Name the place, e.g. Jeepney terminal', 'Jeepney terminal');
    await type(tester, 'Room or exact spot (optional), e.g. Room 304', 'Waiting shed');
    await submit(tester);

    final wallet = store.items.firstWhere((i) => i.name == 'Black Wallet');
    expect(wallet.location, 'Jeepney terminal');
    expect(wallet.spot, 'Waiting shed');
    expect(wallet.fullLocation, 'Jeepney terminal · Waiting shed');
    expect(wallet.tags, ['WALLET']);
  });

  testWidgets('the location is required', (tester) async {
    await openReportForm(tester);
    final before = store.items.length;

    await submit(tester);

    expect(store.items.length, before); // Nothing was reported.
    await show(tester, find.text('Select where it was'));
    expect(find.text('Select where it was'), findsOneWidget);
  });
}
