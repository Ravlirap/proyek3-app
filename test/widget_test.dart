import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app_1/main.dart';

void main() {
  testWidgets('GoHealth app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const GoHealthApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
