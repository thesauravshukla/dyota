import 'package:dyota/components/shared/app_confirm_dialog.dart';
import 'package:dyota/components/shared/app_empty_state.dart';
import 'package:dyota/components/shared/app_loading_indicator.dart';
import 'package:dyota/components/shared/app_price_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget wrapInApp(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('AppEmptyState', () {
    testWidgets('shows message', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const AppEmptyState(message: 'Nothing here'),
      ));
      expect(find.text('Nothing here'), findsOneWidget);
    });

    testWidgets('shows icon when provided', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const AppEmptyState(message: 'Empty', icon: Icons.inbox),
      ));
      expect(find.byIcon(Icons.inbox), findsOneWidget);
    });
  });

  group('AppLoadingBar', () {
    testWidgets('renders LinearProgressIndicator', (tester) async {
      await tester.pumpWidget(wrapInApp(const AppLoadingBar()));
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });
  });

  group('AppSpinner', () {
    testWidgets('renders CircularProgressIndicator', (tester) async {
      await tester.pumpWidget(wrapInApp(const AppSpinner()));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('AppPriceText', () {
    testWidgets('formats double with 2 decimals', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const AppPriceText(amount: 99.5),
      ));
      expect(find.text('Rs. 99.50'), findsOneWidget);
    });

    testWidgets('formats int without decimals', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const AppPriceText(amount: 100),
      ));
      expect(find.text('Rs. 100'), findsOneWidget);
    });
  });

  group('AppConfirmDialog', () {
    testWidgets('returns true on confirm', (tester) async {
      bool? result;
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              result = await showAppConfirmDialog(
                context,
                title: 'Delete',
                message: 'Sure?',
              );
            },
            child: const Text('Open'),
          ),
        ),
      ));

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Delete'), findsOneWidget);
      expect(find.text('Sure?'), findsOneWidget);

      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();

      expect(result, isTrue);
    });

    testWidgets('returns false on cancel', (tester) async {
      bool? result;
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              result = await showAppConfirmDialog(
                context,
                title: 'Delete',
                message: 'Sure?',
              );
            },
            child: const Text('Open'),
          ),
        ),
      ));

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(result, isFalse);
    });
  });
}
