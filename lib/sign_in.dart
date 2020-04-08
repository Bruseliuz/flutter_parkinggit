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
        backgroundColor: Colors.lightBlue[400],
        appBar: AppBar(
        title: Text(
          'Sign in'
        ),

        actions: <Widget>[
          FlatButton.icon(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/register');
            },
            icon: Icon(Icons.person_add, color: Colors.white,),
            label: Text(
              'Register account',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        key: _formKey,
        child: Form(
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
              SizedBox(height: 10.0),

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
            SizedBox(height: 10.0),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton (
                    onPressed: () {},
                    child: Text('Sign in'),
                  ),
                  SizedBox(width: 20.0),
                  RaisedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/map');
                    },
                    child: Text('Skip'),
                  )
                ],
              )
            ),

          ],

        ),
      )
      ),
    );
  }

  void signIn() {
    //validate
    //login
}

}