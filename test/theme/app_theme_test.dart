import 'package:dyota/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme', () {
    late ThemeData theme;

    setUp(() {
      theme = AppTheme.dark();
    });

    test('is dark theme', () {
      expect(theme.brightness, Brightness.dark);
    });

    test('scaffold is pure black', () {
      expect(theme.scaffoldBackgroundColor, AppColors.background);
    });

    test('uses black app bar', () {
      expect(theme.appBarTheme.backgroundColor, AppColors.background);
      expect(theme.appBarTheme.foregroundColor, AppColors.onSurface);
    });

    test('uses black bottom nav with white items', () {
      expect(theme.bottomNavigationBarTheme.backgroundColor, AppColors.background);
      expect(theme.bottomNavigationBarTheme.selectedItemColor, AppColors.onSurface);
    });

    test('elevated button has stadium shape', () {
      final style = theme.elevatedButtonTheme.style!;
      final shape = style.shape!.resolve({});
      expect(shape, isA<StadiumBorder>());
    });

    test('input decoration is filled with dark surface', () {
      expect(theme.inputDecorationTheme.filled, isTrue);
      expect(theme.inputDecorationTheme.fillColor, AppColors.surfaceVariant);
    });

    test('progress indicator uses brown accent', () {
      expect(theme.progressIndicatorTheme.color, AppColors.accent);
    });
  });

  group('AppColors', () {
    test('background is pure black', () {
      expect(AppColors.background, Colors.black);
    });

    test('primary is white', () {
      expect(AppColors.primary, Colors.white);
    });

    test('surface is dark grey', () {
      expect(AppColors.surface, const Color(0xFF424242));
    });
  });
}
