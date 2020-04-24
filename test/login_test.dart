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

    SignIn page = SignIn(toggleView: () {});

    await tester.pumpWidget(makeTestableWidget(child: page, auth: mockAuth));
    await tester.tap(find.byKey(Key('SignIn')));

    verifyNever(mockAuth.signInWithEmailAndPassword('', ''));

  });
}