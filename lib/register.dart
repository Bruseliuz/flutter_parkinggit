import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final _formKey = GlobalKey<FormState>();

  bool checkBox = true;
  String email, password, passwordValidate, name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[400],
        title: Text('Register page'),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/signIn');
              } ,
              icon: Icon(Icons.person, color: Colors.white),
              label: Text('Sign In',
                style: TextStyle(
                  color: Colors.white,
                ),))
        ],
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                Text('ParkApp',
                  style: TextStyle(
                    fontSize: 35.0,
                    letterSpacing: 2.0,
                    color: Colors.lightBlue[400],
                    fontFamily: "Baloo2",
                  ),
                ),
                Divider(
                  color: Colors.lightBlue[400],
                  thickness: 2.0,
                ),
                TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (val) => val.isEmpty ? "Enter an email" : null,
                    onChanged: (val){
                      setState(() => email = val);
                    }
                ),
                SizedBox(height: 10.0),
                TextFormField(
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (val) => val.length < 6 ? 'Password should be minimum 6 chars' : null,
                    onChanged: (val) {
                      setState(() => password = val);}
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Repeat password'),
                  obscureText: true,
                  validator: (val) => val != password ? 'The passwords does not match' : null,
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Full name'),
                  validator: (val) => val.length < 1 ? 'You have to enter a name' : null ,
                  onChanged: (val) {
                    setState(() => name = val);
                  }
                ),
                SizedBox(height: 10.0),
                Container(
                  child: Row(
                    children: <Widget>[
                      Checkbox(

                        value: checkBox,
                        onChanged: (bool value) {
                          setState(() {
                            checkBox = !checkBox;
                          });
                        },
                      ),
                      Text(
                        'I accept the terms and conditions',
                      style: TextStyle(
                        color: Colors.grey[700]
                      ),)
                    ],
                  ),
                ),
                Divider(
                  color: Colors.lightBlue[400],
                  thickness: 2.0,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton.icon(
                          color: Colors.lightBlue[400],
                          onPressed: () {
                            if(_formKey.currentState.validate()) {
                              addUser(name, email, password);
                              print('hejhej');
                            }
                          },
                          icon: Icon(Icons.person_add,
                          color: Colors.white),
                          label: Text(
                              'Register',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ))
                    ],
                  ),
                )
              ],
            ),
          )
      ),
    );
  }

  Future addUser(String name, String email, String password) async {
    var getUrl = 'https://group7-15.pvt.dsv.su.se/mysqlspring/findbyemail?email=$email';
    http.Response getResponse = await http.get(getUrl);
    var getResponseData = jsonDecode(getResponse.body);
    if (getResponseData == "Yes") {
      var url = 'https://group7-15.pvt.dsv.su.se/mysqlspring/add?name=$name&email=$email&password=$password';
      http.Response response = await http.post(url);
      var responseData = jsonDecode(response.body);
      if (responseData != "Saved") {
        print("nånting gick fel");
        //TODO Lägga till någon form av varning om att användaren inte kunde registreras
      }
    } else {
      print("email existerar redan");
      //TODO Lägga till varning om att email redan är registrerad
    }
  }
}
