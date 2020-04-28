import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('flutter app test', () {
    FlutterDriver driver;
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });
    tearDownAll(() {
      if (driver != null) {
        driver.close();
      }
    });

    var emailField = find.text('Email');
    var passwordField = find.text('Password');
    var button = find.text('LOGIN');

    //test för att se hur det ser ut när användaren gör detta.
    //Funkar inte :(
    test("integration test", () async {
      await driver.tap(emailField);
      await driver.enterText('admin@parkapp.se');
      await driver.tap(passwordField);
      await driver.enterText('test1234');
      await driver.tap(button);
    });
  });
}
