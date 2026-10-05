// Renders README screenshots of the real app into docs/assets/.
//
// Run from the project folder:
//   flutter test tool/screenshots_test.dart --update-goldens
//
// It lives in tool/ (not test/) so it doesn't run with the normal tests.
// Text uses the Roboto and Material Icons fonts that ship with the Flutter SDK.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:findit/app.dart';
import 'package:findit/core/theme/theme_controller.dart';
import 'package:findit/data/app_store.dart';
import 'package:findit/features/item_details/item_details_screen.dart';

const _photos = [
  'assets/images/student_id.jpg',
  'assets/images/student_id_found.jpg',
  'assets/images/tumbler.jpg',
  'assets/images/umbrella.jpg',
  'assets/images/keys.jpg',
];

Future<void> _loadFonts() async {
  final dir = '${Platform.environment['FLUTTER_ROOT']}/bin/cache/artifacts/material_fonts';
  Future<ByteData> font(String file) async => ByteData.sublistView(await File('$dir/$file').readAsBytes());

  // 'FlutterTest' and 'Ahem' are the test's fallback fonts, used where a style names no font.
  for (final family in ['Roboto', 'monospace', 'FlutterTest', 'Ahem']) {
    final loader = FontLoader(family);
    for (final f in ['roboto-regular.ttf', 'roboto-medium.ttf', 'roboto-bold.ttf']) {
      loader.addFont(font(f));
    }
    await loader.load();
  }
  await (FontLoader('MaterialIcons')..addFont(font('materialicons-regular.otf'))).load();
}

void main() {
  setUpAll(_loadFonts);
  // This file is a test, just not in test/, so the analyzer needs telling.
  // ignore: invalid_use_of_visible_for_testing_member
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<void> open(WidgetTester tester, {bool dark = false}) async {
    tester.view.physicalSize = const Size(390 * 2, 844 * 2);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    themeController.setMode(dark ? ThemeMode.dark : ThemeMode.light);
    store.logout(); // Each shot starts from the login screen; the demo data is never changed.

    await tester.pumpWidget(const FindItApp());
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();
  }

  /// Images decode outside the fake test clock, so load them for real first.
  Future<void> loadPhotos(WidgetTester tester) async {
    await tester.runAsync(() async {
      final context = tester.element(find.byType(Scaffold).last);
      for (final p in _photos) {
        await precacheImage(AssetImage(p), context);
      }
    });
    await tester.pumpAndSettle();
  }

  Future<void> push(WidgetTester tester, Widget page) async {
    tester.state<NavigatorState>(find.byType(Navigator).first).push(MaterialPageRoute(builder: (_) => page));
    await tester.pumpAndSettle();
  }

  Future<void> shoot(String name) =>
      expectLater(find.byType(MaterialApp), matchesGoldenFile('../docs/assets/$name.png'));

  testWidgets('home', (tester) async {
    await open(tester);
    await loadPhotos(tester);
    await shoot('screen-home');
  });

  testWidgets('item details', (tester) async {
    await open(tester);
    await push(tester, const ItemDetailsScreen(itemId: '4'));
    await loadPhotos(tester);
    await shoot('screen-detail');
  });

  testWidgets('claim requests', (tester) async {
    await open(tester);
    await push(tester, const ItemDetailsScreen(itemId: '2'));
    await loadPhotos(tester);
    await tester.drag(find.byType(ListView).last, const Offset(0, -1000));
    await tester.pumpAndSettle();
    await shoot('screen-claims');
  });

  testWidgets('report form', (tester) async {
    await open(tester);
    await tester.tap(find.text('Report'));
    await tester.pumpAndSettle();
    await shoot('screen-add');
  });

  testWidgets('night mode', (tester) async {
    await open(tester, dark: true);
    await loadPhotos(tester);
    await shoot('screen-dark');
    themeController.setMode(ThemeMode.system);
  });
}
