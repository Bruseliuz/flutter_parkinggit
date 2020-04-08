import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/sign_in.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  //Root of app
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      initialRoute: "/signIn",
        routes: {
          '/signIn': (context) => SignIn(),
        },
    );
  }
}