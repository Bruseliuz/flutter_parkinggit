import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/models/user.dart';
import 'package:flutterparkinggit/services//pages/wrapper.dart';
import 'package:flutterparkinggit/services/auth.dart';
import 'package:flutterparkinggit/services//pages/homescreens/home.dart';
import 'package:flutterparkinggit/services//pages/map.dart';
import 'package:flutterparkinggit/services/pages/authenticate/register.dart';
import 'package:flutterparkinggit/services/pages/homescreens/settings_form_anon.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  //Root of app
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        routes: {
          "/wrapper": (context) => Wrapper(),
          "/map": (context) => Map(),
          "/home": (context) => Home(),
          '/locationsLoader': (context) => LocationLoader(),
          "/register": (context) => Register(),
        },
        home: Wrapper(),
      ),
    );
  }
}