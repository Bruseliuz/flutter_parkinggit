import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('flutter app test', () {
    final emailField = find.byValueKey("email");
    final passwordField = find.byValueKey("password");
    final signInButton = find.byValueKey("SignIn");
    final googleMapsPage = find.byType("ParkingMap");
    final googleMap = find.byType('GoogleMap');
    FlutterDriver driver;
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });
    tearDownAll(() {
      if (driver != null) {
        driver.close();
      }
    });

    test("login and map test", () async {
      await driver.tap(emailField);
      await driver.enterText('admin@parkapp.se');
      await driver.tap(passwordField);
      await driver.enterText('test1234');
      await driver.tap(signInButton);
      assert(googleMapsPage != null);
      await driver.waitUntilNoTransientCallbacks();
      assert(googleMap!= null);

    });
  });

}
