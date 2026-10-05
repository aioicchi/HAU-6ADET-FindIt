import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:findit/core/utils/sharing.dart';
import 'package:findit/data/app_store.dart';
import 'package:findit/data/mock_data.dart';
import 'package:findit/features/item_details/item_details_screen.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('a found item reads as a claim invitation, without contact info', () {
    final umbrella = MockData.items().firstWhere((i) => i.id == '4');
    final link = Uri.parse('https://aioicchi.github.io/HAU-6ADET-FindIt/?item=4');
    final text = shareMessage(umbrella, link);

    expect(text, startsWith('FOUND on campus: Umbrella'));
    expect(text, contains('Where: PGN (Pangilinan Hall) · Bench by the entrance'));
    expect(text, contains('When: Found 2 days ago'));
    expect(text, endsWith('Is it yours? Claim it on FindIt: $link'));
    expect(text, isNot(contains(umbrella.contact)));
  });

  test('a lost item asks people to message the owner', () {
    final id = MockData.items().firstWhere((i) => i.id == '1');
    final text = shareMessage(id, Uri.parse('https://x/?item=1'));
    expect(text, startsWith('LOST on campus: Student ID'));
    expect(text, contains('Seen it? Message the owner on FindIt'));
  });

  test('links point at one report', () {
    final link = itemLink(MockData.items().first);
    expect(link.toString(), '$liveSiteUrl?item=1');
  });

  testWidgets('Copy message puts the report on the clipboard', (tester) async {
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'Clipboard.setData') copied = (call.arguments as Map)['text'] as String;
      return null;
    });
    store.login(MockData.demoEmail, MockData.demoPassword);

    await tester.pumpWidget(const MaterialApp(home: ItemDetailsScreen(itemId: '4')));
    await tester.tap(find.byTooltip('Share'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Copy message'));
    await tester.pumpAndSettle();

    expect(copied, startsWith('FOUND on campus: Umbrella'));
    expect(find.text('Message copied. Paste it in your group chat.'), findsOneWidget);
  });
}
