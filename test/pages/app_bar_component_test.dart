import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dyota/pages/Home/Components/app_bar_component.dart';

void main() {
  group('CustomAppBar', () {
    testWidgets('renders brand logo and search bar', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: CustomAppBar(),
          ),
        ),
      );

      // Brand logo
      expect(find.text('dyota'), findsOneWidget);

      // Search bar
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('search field accepts input', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: CustomAppBar(),
          ),
        ),
      );

      final textField = find.byType(TextField);
      await tester.enterText(textField, 'silk');
      expect(find.text('silk'), findsOneWidget);
    });

    testWidgets('preferredSize has correct height', (tester) async {
      const appBar = CustomAppBar();
      expect(appBar.preferredSize.height, kToolbarHeight + 48.0);
    });

    testWidgets('disposes controller without error on unmount', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: CustomAppBar(),
          ),
        ),
      );

      // Replace with a different widget to trigger dispose
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('replaced'),
          ),
        ),
      );

      // No errors means controller was properly disposed
      expect(find.text('replaced'), findsOneWidget);
    });
  });
}
