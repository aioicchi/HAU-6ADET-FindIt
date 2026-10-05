import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:findit/data/app_store.dart';
import 'package:findit/data/mock_data.dart';
import 'package:findit/data/models/models.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('data survives a restart', () async {
    final first = AppStore();
    await first.load();
    first.login(MockData.demoEmail, MockData.demoPassword);
    first.addItem(Item(
      id: 'new',
      name: 'Blue Wallet',
      description: 'Leather',
      status: ItemStatus.lost,
      location: 'Canteen',
      date: DateTime(2026, 10, 1),
      contact: MockData.demoEmail,
      ownerId: first.user!.id,
      tags: ['WALLET'],
      hasPhoto: true,
      photo: Uint8List.fromList([1, 2, 3]),
    ));
    first.sendMessage(first.findItem('2')!, 'Is this mine?');
    await pumpEventQueue();

    // A fresh store, like reopening the page.
    final second = AppStore();
    await second.load();
    expect(second.user?.email, MockData.demoEmail);
    final wallet = second.findItem('new')!;
    expect(wallet.tags, ['WALLET']);
    expect(wallet.photo, [1, 2, 3]);
    expect(second.thread('2').single.text, 'Is this mine?');
    expect(second.findItem('2')!.inquiries, 1);
  });

  test('reset brings back the demo data and signs out', () async {
    final s = AppStore();
    await s.load();
    s.login(MockData.demoEmail, MockData.demoPassword);
    s.deleteItem('1');
    await pumpEventQueue();

    await s.resetDemoData();
    expect(s.user, isNull);
    expect(s.findItem('1'), isNotNull);

    final reopened = AppStore();
    await reopened.load();
    expect(reopened.user, isNull);
    expect(reopened.findItem('1'), isNotNull);
  });
}
