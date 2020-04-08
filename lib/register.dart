import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  bool checkBox = true;
  String email, password, name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(
        title: Text('Register page'),
        centerTitle: true
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              Text('ParkApp',
              style: TextStyle(
                fontSize: 35.0,
                letterSpacing: 2.0,
              ),
              ),
              Divider(
                color: Colors.black,
                thickness: 2.0,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 10.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Repeat password'),
                obscureText: true,
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
                color: Colors.black,
                thickness: 2.0,
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    FlatButton.icon(
                        color: Colors.lightBlue[400],
                        onPressed: () {},
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
