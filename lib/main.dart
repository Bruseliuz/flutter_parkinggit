import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/authenticate/onboarding_screen.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/authenticate/register.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/authenticate/sign_in.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/help_page.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/map/park_timer.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/parking_history.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/homescreens/settings_drawer.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/payment.dart';
import 'package:provider/provider.dart';
import 'gamla_appen/services/auth.dart';
import 'gamla_appen/services/pages/authenticate/register.dart';
import 'gamla_appen/services/pages/wrapper.dart';
import 'gamla_appen/models/user.dart';

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
          '/wrapper':(context)=> Wrapper(),
          '/register':(context) => Register(),
          '/onBoarding': (context) => Onboarding(),
          '/signIn': (context) => SignIn(),
          '/timer': (context) => ParkTimer(),
          '/history': (context) => ParkingHistory(),
          '/settings': (context) => SettingsFormDrawer(),
          '/help':(context)=>HelpPage(),
          '/payment': (context)=>Payment()
      }),
    );
  }
}