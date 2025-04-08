import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:beautybuddy_app/home_page.dart';

void main() {
  testWidgets('HomePage loads correctly', (WidgetTester tester) async {
    // Build the HomePage widget inside a MaterialApp (required for many widgets).
    await tester.pumpWidget(MaterialApp(home: HomePage()));

    // Look for the text 'Detecting...' (initial emotion state).
    expect(find.text('Detecting...'), findsOneWidget);
  });
}