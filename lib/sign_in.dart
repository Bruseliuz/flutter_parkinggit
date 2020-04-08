import 'package:flutter/material.dart';


class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign in page - Test'
        ),
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/register');
            },
            icon: Icon(Icons.settings),
            label: Text(
              'Register'
            ),
          )
        ],
      ),
    );
  }
}