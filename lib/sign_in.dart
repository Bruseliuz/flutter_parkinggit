import 'dart:convert';
import 'package:flutterparkinggit/pages/main_page.dart';
import 'package:flutterparkinggit/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


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
        backgroundColor: Colors.lightBlue[400],
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
              onChanged: (input) => _email = input,
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
            onChanged: (input) => _password = input,
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
                    onPressed: () {
                      signIn();
                    },
                    child: Text('Sign in'),
                  ),
                  SizedBox(width: 20.0),
                  RaisedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/mainPage');
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

  Future signIn() async {
    var findUrl = 'https://group7-15.pvt.dsv.su.se/mysqlspring/findbyemailandpwd?email=$_email&password=$_password';
    http.Response response = await http.get(findUrl);
    String findResponseData = response.body;
    if (findResponseData == "Yes") {
      var getUrl = 'https://group7-15.pvt.dsv.su.se/mysqlspring/getbyemail?email=$_email';
      http.Response getResponse = await http.get(getUrl);
      Map getResponseData = jsonDecode(getResponse.body);
      String name = getResponseData['name'].toString();
      String email = getResponseData['email'].toString();
      User newUser = new User(name, email, false);
      Navigator.push(context, new MaterialPageRoute(
          builder: (BuildContext context) => new MainPage(newUser)));
      print(name);

    } else {
      print("No such user");
    }
  }
}

