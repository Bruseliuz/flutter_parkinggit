import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/map.dart';
import 'package:flutterparkinggit/sign_in.dart';
import 'package:flutterparkinggit/register.dart';
import 'package:flutterparkinggit/main_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  //Root of app
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      initialRoute: "/signIn",
        routes: {
          '/signIn': (context) => SignIn(),
          '/register': (context) => Register(),
          '/map': (context) => Map(),
          '/mainPage': (context) => MainPage(),
    },
    );
  }
}