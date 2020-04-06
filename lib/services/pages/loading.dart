import 'package:flutter/material.dart';


class settingsform_anon extends StatefulWidget {
  @override
  _settingsform_anonState createState() => _settingsform_anonState();
}

class _settingsform_anonState extends State<settingsform_anon> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text('To manage your settings you must first create an account.',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.lightBlue[400],
              fontWeight: FontWeight.bold,
              fontFamily: 'Baloo2',
            ),
          ),
          FlatButton(
            onPressed: () {
            },
            child: Text('Click here'),

          )
        ],
      ),
    );
  }
}