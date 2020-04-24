// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutterparkinggit/gamla_appen/main.dart';


void main() {
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows you to build and interact
  // with widgets in the test environment.
  testWidgets('Testa Rebben', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    //testcode


    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MyApp ());

    final titleFinder = find.text('T');
    final messageFinder = find.text('M');

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(titleFinder, findsOneWidget);
    expect(messageFinder, findsOneWidget);

    // Tap the '+' icon and trigger a frame.
  //  await tester.tap(find.byIcon(Icons.add));
   // await tester.pump();

    // Verify that our counter has incremented.
  //  expect(find.text('0'), findsNothing);
  //  expect(find.text('1'), findsOneWidget);
  });
}
