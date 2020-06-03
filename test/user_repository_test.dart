import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterparkinggit/services/auth.dart';
import 'package:flutterparkinggit/services/pages/database.dart';
import 'package:flutterparkinggit/main.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseUser extends Mock implements FirebaseUser {}

class MockAuthResult extends Mock implements AuthResult {}

void main() {
  MockFirebaseAuth mockAuth = MockFirebaseAuth();
  BehaviorSubject<MockFirebaseUser> user = BehaviorSubject<MockFirebaseUser>();


  group('user repository test', () {
    test("sign in with email and password", () async {});

    test('sign out', () {});
  });

  testWidgets('', (WidgetTester tester) async {});
}
