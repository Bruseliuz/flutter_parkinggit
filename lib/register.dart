import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        title: Text('Register page'),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/signIn');
              } ,
              icon: Icon(Icons.arrow_back, color: Colors.white),
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
                        'Accept the terms and conditions',
                    )
                  ],
                ),
              ),
              Divider(
                color: Colors.lightBlue[400],
                thickness: 2.0,
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    FlatButton.icon(
                        color: Colors.lightBlue[400],
                        onPressed: () {
                          if(_formKey.currentState.validate()){
                            print('hejhej');
                          }
                        },
                        icon: Icon(Icons.person_add),
                        label: Text(
                            'Register'
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
}
