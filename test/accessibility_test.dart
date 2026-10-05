import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:findit/app.dart';
import 'package:findit/core/theme/theme_controller.dart';
import 'package:findit/data/app_store.dart';
import 'package:findit/data/mock_data.dart';
import 'package:findit/features/chat/chat_screen.dart';
import 'package:findit/features/claim/claim_screen.dart';
import 'package:findit/features/item_details/item_details_screen.dart';
import 'package:findit/features/notifications/notifications_screen.dart';
import 'package:findit/features/profile/profile_screen.dart';

/// Flutter's accessibility guidelines (the ones Android and iOS use), checked
/// on the main screens in both day and night mode:
/// - every tappable thing has a label a screen reader can read out,
/// - tap targets are at least 48x48 (Android) / 44x44 (iOS),
/// - text has enough contrast against its background.
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

  Future<void> checkGuidelines(WidgetTester tester) async {
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
  }

  Future<void> openPage(WidgetTester tester, Widget page) async {
    tester.state<NavigatorState>(find.byType(Navigator).first).push(MaterialPageRoute(builder: (_) => page));
    await tester.pumpAndSettle();
  }

  for (final dark in [false, true]) {
    final mode = dark ? 'night' : 'day';

    testWidgets('home ($mode)', (tester) async {
      final handle = tester.ensureSemantics();
      themeController.setMode(dark ? ThemeMode.dark : ThemeMode.light);
      await signIn(tester);
      await checkGuidelines(tester);
      handle.dispose();
    });

    testWidgets('item details ($mode)', (tester) async {
      final handle = tester.ensureSemantics();
      themeController.setMode(dark ? ThemeMode.dark : ThemeMode.light);
      await signIn(tester);
      await openPage(tester, const ItemDetailsScreen(itemId: '2'));
      await checkGuidelines(tester);
      handle.dispose();
    });

    testWidgets('report form ($mode)', (tester) async {
      final handle = tester.ensureSemantics();
      themeController.setMode(dark ? ThemeMode.dark : ThemeMode.light);
      await signIn(tester);
      await tester.tap(find.text('Report'));
      await tester.pumpAndSettle();
      await checkGuidelines(tester);
      handle.dispose();
    });

    for (final (name, page) in [
      ('chat', const ChatScreen(itemId: '4')),
      ('claim', ClaimScreen(item: MockData.items().firstWhere((i) => i.id == '4'))),
      ('profile', const ProfileScreen()),
      ('notifications', const NotificationsScreen()),
    ]) {
      testWidgets('$name ($mode)', (tester) async {
        final handle = tester.ensureSemantics();
        themeController.setMode(dark ? ThemeMode.dark : ThemeMode.light);
        await signIn(tester);
        await openPage(tester, page);
        await checkGuidelines(tester);
        handle.dispose();
      });
    }

    testWidgets('my items ($mode)', (tester) async {
      final handle = tester.ensureSemantics();
      themeController.setMode(dark ? ThemeMode.dark : ThemeMode.light);
      await signIn(tester);
      await tester.tap(find.text('My Items'));
      await tester.pumpAndSettle();
      await checkGuidelines(tester);
      handle.dispose();
    });
  }

  testWidgets('screen readers hear what each button does', (tester) async {
    final handle = tester.ensureSemantics();
    themeController.setMode(ThemeMode.light);
    await signIn(tester);

    // Each DETAILS button names its item, and tags read as words, not brackets.
    expect(find.bySemanticsLabel('View details for Student ID'), findsWidgets);
    expect(find.bySemanticsLabel(RegExp(r'(^|\n)Lost($|\n)')), findsWidgets);
    expect(find.bySemanticsLabel(RegExp(r'\[LOST\]')), findsNothing);
    expect(find.byTooltip(RegExp(r'^Notifications, \d+ unread$')), findsOneWidget);
    expect(find.bySemanticsLabel('Filters'), findsOneWidget);

    await openPage(tester, const ChatScreen(itemId: '4'));
    expect(find.byTooltip('Send message'), findsOneWidget);
    handle.dispose();
  });
}
