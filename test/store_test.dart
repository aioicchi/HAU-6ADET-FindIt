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
    first.sendMessage(first.findItem('4')!, 'Is this mine?');
    await pumpEventQueue();

    // A fresh store, like reopening the page.
    final second = AppStore();
    await second.load();
    expect(second.user?.email, MockData.demoEmail);
    final wallet = second.findItem('new')!;
    expect(wallet.tags, ['WALLET']);
    expect(wallet.photo, [1, 2, 3]);
    expect(second.thread('4').single.text, 'Is this mine?');
    expect(second.findItem('4')!.inquiries, 1);
  });

  test('a new report is matched with the other side and notifies', () async {
    final s = AppStore();
    s.login(MockData.demoEmail, MockData.demoPassword);
    s.addItem(Item(
      id: 'lost-umbrella',
      name: 'Red Umbrella',
      description: '',
      status: ItemStatus.lost,
      location: 'PGN',
      date: DateTime.now(),
      contact: MockData.demoEmail,
      ownerId: s.user!.id,
      tags: ['UMBRELLA'],
    ));

    final mine = s.findItem('lost-umbrella')!;
    expect(s.matchesFor(mine).map((i) => i.id), ['4']); // The found umbrella.
    expect(s.notifications.first.title, 'Possible match');
    expect(s.notifications.first.itemId, '4');
  });

  test('inquiries count people, and the reporter replies', () async {
    final s = AppStore();
    s.login(MockData.demoEmail, MockData.demoPassword);
    final umbrella = s.findItem('4')!;

    s.sendMessage(umbrella, 'Hi, I think this is mine.');
    s.sendMessage(umbrella, 'It has a small tear near the handle.');
    expect(umbrella.inquiries, 1);

    await Future<void>.delayed(const Duration(milliseconds: 1700));
    final replies = s.thread('4').where((m) => !m.fromMe).toList();
    expect(replies, hasLength(1));
    expect(replies.single.sender, 'Finder');
    expect(s.notifications.first.title, 'New reply');
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
