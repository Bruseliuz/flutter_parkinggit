import 'package:flutter_test/flutter_test.dart';
import 'package:flutterparkinggit/services/pages/authenticate/sign_in.dart';
import 'package:flutterparkinggit/services/pages/wrapper.dart';
import 'package:flutterparkinggit/main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

void main() {

  testWidgets('Find Email',(WidgetTester tester)
  async{
    final testKey = Key('email');

    await tester.pumpWidget(MaterialApp(key: testKey, home: SignIn()));
    var textFormFieldEmail = find.byKey(testKey);
    expect(find.byKey(testKey), findsOneWidget);
  });

  testWidgets('Find Password',(WidgetTester tester)
  async{
    final testKey = Key('Password');

    await tester.pumpWidget(MaterialApp(key: testKey, home: SignIn()));
    var textFormFieldPassword = find.byType(TextFormField);
    expect(find.byKey(testKey), findsWidgets);
    await tester.enterText(textFormFieldPassword, 'test1234');

  });
}