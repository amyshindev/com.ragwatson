import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Maestro intro hero renders', (WidgetTester tester) async {
    await tester.pumpWidget(const MaestroApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('Your sound'), findsOneWidget);
    expect(find.textContaining('How it works'), findsOneWidget);
    expect(find.text('Maestro'), findsOneWidget);
  });
}
