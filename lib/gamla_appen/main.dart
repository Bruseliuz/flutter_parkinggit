import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/authenticate/register.dart';
import 'package:provider/provider.dart';
import 'services/auth.dart';
import 'services/pages/authenticate/register.dart';
import 'services/pages/wrapper.dart';
import 'models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  //Root of app
  @override
  Widget build(BuildContext context) {
    return  StreamProvider<User>.value(
        value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
        routes: {
      '/register':(context) => Register(),
      }
      ),
    );
  }
}