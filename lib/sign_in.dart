import 'package:flutter/material.dart';


class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign in'
        ),

        actions: <Widget>[
          FlatButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/register');
            },
            icon: Icon(Icons.settings),
            label: Text(
              'Register account'
            ),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              validator: (input) {
                if(input.isEmpty) {
                  return 'Can not be empty';
                }
              },
              onSaved: (input) => _email = input,
              decoration: InputDecoration(
                labelText: 'Email'
              ),
            ),
        TextFormField(
            validator: (input) {
              if(input.isEmpty) {
                return 'Can not be empty';
              }
            },
            onSaved: (input) => _password = input,
            decoration: InputDecoration(
              labelText: 'Password'
            ),
          obscureText: true,
        ),
            RaisedButton (
              onPressed: () {},
              child: Text('Sign in'),

            )
          ],
        )
      )
    );
  }

  void signIn() {
    //validate
    //login
}

}