import 'package:flutter_test/flutter_test.dart';
import 'dart:io';

/// Tests to verify the Firestore security rules file exists and has proper structure.
/// Actual rule enforcement is tested via Firebase Emulator Suite,
/// but we validate the file structure here.
void main() {
  group('Firestore Security Rules', () {
    late String rulesContent;

    setUpAll(() {
      final file = File('firestore.rules');
      expect(file.existsSync(), isTrue,
          reason: 'firestore.rules file must exist in project root');
      rulesContent = file.readAsStringSync();
    });

    test('rules file is not empty', () {
      expect(rulesContent.trim().isNotEmpty, isTrue);
    });

    test('uses rules_version 2', () {
      expect(rulesContent, contains("rules_version = '2'"));
    });

    test('protects items collection (read-only)', () {
      expect(rulesContent, contains('match /items/{itemId}'));
      expect(rulesContent, contains('allow read: if request.auth != null'));
    });

    test('protects categories collection (read-only)', () {
      expect(rulesContent, contains('match /categories/{categoryId}'));
    });

    test('protects user documents by email', () {
      expect(rulesContent, contains('match /users/{userEmail}'));
      expect(rulesContent, contains('request.auth.token.email == userEmail'));
    });

    test('protects cart items subcollection', () {
      expect(rulesContent, contains('match /cartItemsList/{cartItemId}'));
    });

    test('protects orders subcollection', () {
      expect(rulesContent, contains('match /orders/{orderId}'));
    });

    test('has default deny rule', () {
      // Ensures a catch-all deny exists
      expect(rulesContent, contains('match /{document=**}'));
      expect(rulesContent, contains('allow read, write: if false'));
    });

    test('does not allow unauthenticated writes to items', () {
      // Items should be write: false (admin only)
      final itemsSection = rulesContent.substring(
        rulesContent.indexOf('match /items/{itemId}'),
        rulesContent.indexOf(
            '}', rulesContent.indexOf('match /items/{itemId}') + 30),
      );
      expect(itemsSection, contains('allow write: if false'));
    });
  });
}
