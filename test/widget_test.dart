import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  testWidgets('Sahaara app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const GetMaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Sahaara ElderGuard'),
          ),
        ),
      ),
    );
    expect(find.text('Sahaara ElderGuard'), findsOneWidget);
  });
}
