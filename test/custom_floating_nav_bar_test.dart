import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tashaapp/core/widgets/custom_floating_nav_bar.dart';

void main() {
  testWidgets('CustomFloatingNavBar renders correctly', (
    WidgetTester tester,
  ) async {
    // Build the widget
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Stack(children: [CustomFloatingNavBar()])),
      ),
    );

    // Verify that the Home icon is present
    expect(find.byIcon(Icons.home_filled), findsOneWidget);

    // Verify that the "New Trip" text and Add icon are present
    expect(find.text('New Trip'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Verify that the Person icon is present
    expect(find.byIcon(Icons.person), findsOneWidget);
  });
}
