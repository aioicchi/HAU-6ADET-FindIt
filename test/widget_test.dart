import 'package:flutter_test/flutter_test.dart';

import 'package:findit/app.dart';

void main() {
  testWidgets('splash leads to login', (tester) async {
    await tester.pumpWidget(const FindItApp());
    expect(find.text('University Lost & Found'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();
    expect(find.text('Sign In'), findsOneWidget);

    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();
    expect(find.text('Lost & Found Items'), findsOneWidget);
  });
}
