import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterparkinggit/gamla_appen/models/user.dart';
import 'package:flutterparkinggit/gamla_appen/services/auth_provider.dart';
import 'package:flutterparkinggit/gamla_appen/services/auth.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/authenticate/authenticate.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/authenticate/sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/mockito.dart';

class MockAuth extends Mock implements AuthService{}

void main() {
  Widget makeTestableWidget({Widget child, AuthService auth}) {
    return AuthProvider(
      auth: auth,
      child: MaterialApp(
        home: child,
      ),
    );
  }

  testWidgets('test empty email or password, dont sign in', (WidgetTester tester) async {
    MockAuth mockAuth = MockAuth();

    bool didSignIn = false;
    SignIn page = SignIn(toggleView: () => didSignIn = true);

    await tester.pumpWidget(makeTestableWidget(child: page, auth: mockAuth));
    await tester.tap(find.byKey(Key('SignIn')));

    verifyNever(mockAuth.signInWithEmailAndPassword('', ''));
    expect(didSignIn, false);
  });

  testWidgets('non-empty email and password, valid account, call sign in, succeed', (WidgetTester tester) async {
    MockAuth mockAuth = MockAuth();

    bool didSignIn = false;
    SignIn page = SignIn(toggleView: () => didSignIn = true);

    await tester.pumpWidget(makeTestableWidget(child: page, auth: mockAuth));
    Finder emailField = find.byKey(Key('email'));
    await tester.enterText(emailField, 'email');
    Finder passwordField = find.byKey(Key('password'));
    await tester.enterText(passwordField, 'password');

    await tester.tap(find.byKey(Key('SignIn')));

    verifyNever(mockAuth.signInWithEmailAndPassword('', ''));
    expect(didSignIn, false);
  });
}