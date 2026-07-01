import 'package:field_track_todo/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App renders splash screen initially', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: App()));

    // Verify that splash screen content is shown.
    expect(find.byIcon(Icons.location_on), findsOneWidget);

    // Wait for the 3-second splash timer to resolve.
    await tester.pump(const Duration(seconds: 3));
  });
}
