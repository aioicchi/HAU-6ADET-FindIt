import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:findit/app.dart';
import 'package:findit/core/theme/app_colors.dart';
import 'package:findit/core/theme/theme_controller.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('night mode recolors the screen and keeps what you typed', (tester) async {
    await tester.pumpWidget(const FindItApp());
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'umbrella');
    await tester.pump();
    expect(find.text('1 item'), findsOneWidget);
    expect(AppColors.dark, isFalse);

    await tester.tap(find.byTooltip('Switch to night mode'));
    await tester.pumpAndSettle();

    expect(AppColors.dark, isTrue);
    expect(themeController.mode, ThemeMode.dark);
    final scaffold = tester.element(find.text('1 item'));
    expect(Theme.of(scaffold).scaffoldBackgroundColor, AppColors.background);
    expect(Theme.of(scaffold).brightness, Brightness.dark);
    // Same screen, same search: state survived the switch.
    expect(find.text('umbrella'), findsOneWidget);
    expect(find.byTooltip('Switch to light mode'), findsOneWidget);

    await tester.tap(find.byTooltip('Switch to light mode'));
    await tester.pumpAndSettle();
    expect(AppColors.dark, isFalse);
  });
}
