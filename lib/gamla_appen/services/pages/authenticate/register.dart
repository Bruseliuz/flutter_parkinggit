import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/gamla_appen/shared/loading.dart';
import 'package:flutterparkinggit/gamla_appen/services/auth.dart';
import 'package:flutterparkinggit/gamla_appen/shared/constants.dart';

import '../../../../constants.dart';

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
      body: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff207FC5),
                    Color(0xff348aca),
                    Color(0xff4896cf),
                    Color(0xff5ca1d4)
                  ],
                  stops: [0.1,0.4,0.7,0.9],
                )
              ),
            ),
          ),
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                vertical: 120,
                horizontal: 40,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('PARK´N',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                  Text('STOCKHOLM',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: parkBoxDecoration,
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );






      /*backgroundColor: Colors.lightBlue[100],
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
                decoration: textInputDecoration.copyWith(hintText: "Email"),
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
    */
  }
}
