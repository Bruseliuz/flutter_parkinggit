import 'package:flutter/material.dart';
import 'package:flutterparkinggit/gamla_appen/services/auth.dart';
import 'package:flutterparkinggit/main.dart';


class settings_form_anon extends StatefulWidget {
  @override
  _settings_form_anonState createState() => _settings_form_anonState();
}

class _settings_form_anonState extends State<settings_form_anon> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: Column(
          children: <Widget>[
            Text('To manage your settings you must first create an account.',
              style: TextStyle(
                fontSize: 18.0,
                color: Color(0xffb4c7e7),
                fontWeight: FontWeight.bold,
                fontFamily: 'Baloo2',
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child:
              Text('Click here to register'),
              color: Color(0xffb4c7e7),
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  side: BorderSide(color: Colors.black, width: 2)),
            )
          ],
        ),
      );
    }
  }
