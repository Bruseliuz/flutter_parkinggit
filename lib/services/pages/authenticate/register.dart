import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/shared/loading.dart';
import 'package:flutterparkinggit/services/auth.dart';
import 'package:flutterparkinggit/shared/constants.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {


  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //textfield state
  String email ="";
  String password ="";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[400],
        elevation: 3.0,
        title: Text("Register",
        style: TextStyle(
          fontFamily: "Baloo2",
          letterSpacing: 2.0,
        ),),
        centerTitle: true,
        actions: <Widget>[
          FlatButton.icon(
              onPressed:(){
                widget.toggleView();
              },
              icon: Icon(Icons.person,
                  color: Colors.lightBlue[50],
              ),
              label: Text("Sign in",
              style: TextStyle(
                color: Colors.lightBlue[50],
              ),))
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              Text("ParkO´hoj",
                style: TextStyle(
                  fontSize: 35,
                  fontFamily: "Baloo2",
                  letterSpacing: 2.0,
                  color: Colors.lightBlue[400],
                ),
              ),
              Divider(
                color: Colors.lightBlue[400],
                thickness: 1.1,
                indent: 45,
                endIndent: 45,
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: "Email, like admin"),
                  validator: (val) => val.isEmpty ? "Enter an email" : null,
                  onChanged: (val){
                    setState(() => email = val);
                  }
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: "Password"),
                validator: (val) => val.length < 6 ? "Enter a password 6+ chars long" : null,
                obscureText: true,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 20.0),
              Divider(
                color: Colors.lightBlue[400],
                thickness: 1.1,
                indent: 45,
                endIndent: 45,
              ),
              RaisedButton(
                color: Colors.white,
                elevation: 3.0,
                child: Text(
                  "Register",
                  style: TextStyle(
                    fontFamily: "Baloo2",
                      color: Colors.lightBlue[400],
                  ),
                ),
                onPressed: ()async{
                  if(_formKey.currentState.validate()){
                    setState(() => loading = true);
                    dynamic result = await _auth.registerWithEmailAndPassword(email,password);
                    if(result == null){
                      setState(() {
                        error = "Please supply a valid email";
                        loading = false;
                      });
                    }
                  }
                },
              ),
              SizedBox(height: 20.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
