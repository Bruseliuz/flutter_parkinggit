import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterparkinggit/main.dart';

void main() {
  testWidgets('', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    var textField = find.byType(TextField);
    expect(textField, findsNWidgets(2));

    var button = find.byKey(Key('SignIn'));
    expect(button, findsOneWidget);
  });
}