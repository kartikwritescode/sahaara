import 'package:flutter_test/flutter_test.dart';
import 'package:sahaara/main.dart';

void main() {
  testWidgets('Sahaara app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SahaaraApp());
    expect(find.byType(SahaaraApp), findsOneWidget);
  });
}
