import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutterparkinggit/pages/main_page.dart';
import 'package:flutterparkinggit/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutterparkinggit/constants.dart';


class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  String _email, _password;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
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
                  stops: [0.1, 0.4, 0.7,0.9],
                )
            ),
          ),
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 120,
              ),
              key: _formKey,
              child: Form(
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
                          letterSpacing: 1.5,
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                    SizedBox(height: 20),
                    emailWidget(),
                    SizedBox(height: 20),
                    passwordWidget(),
                    SizedBox(height: 20),
                    signInButtonWidget(),
                    orSignInWithWidget(),
                    signInFacebookButton(),
                    signUpButton(),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget emailWidget(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration:parkBoxDecoration,
          height: 60,
          alignment: Alignment.centerLeft,
          child: TextFormField(
            validator: (val) => val.isEmpty ? 'Enter email': null,
            onChanged: (val){ setState(() => _email = val);
            },
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 15.0),
              prefixIcon: Icon(
                Icons.mail_outline,
                color: Colors.white,),
              hintText: 'Email',
              hintStyle: TextStyle(color: Colors.white70)
            ),

          ),
        )
      ],
    );
  }
  Widget passwordWidget(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration:parkBoxDecoration,
          height: 60,
          alignment: Alignment.centerLeft,
          child: TextFormField(
            validator: (val) => val.isEmpty ? 'Enter password': null,
            onChanged: (val){
              setState(() => _password = val);
            },
            obscureText: true,
            style: TextStyle(
                color: Colors.white
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 15.0),
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: Colors.white,),
                hintText: 'Password',
                hintStyle: TextStyle(color: Colors.white70)
            ),

          ),
        )
      ],
    );
  }
  Widget signInButtonWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: MaterialButton(
        color: Colors.white,
        elevation: 4.0,
        onPressed: () {
            verifyUser();
        },
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('LOGIN',
              style: TextStyle(
                color: Color(0xff207FC5),
                letterSpacing: 1.5,
                fontSize: 18.0,
              ),
            ),
            Icon(Icons.time_to_leave, color: Color(0xff207FC5))
          ],
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Colors.white,
              width: 3.0),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
  Widget orSignInWithWidget() {
    return Column(
      children: <Widget>[
        Text('- OR -',
        style: TextStyle(
        color: Colors.white,
          fontWeight: FontWeight.bold
        ),
        ),
        SizedBox(height: 15),
        Text('Sign in with',
        style: TextStyle(
          color: Colors.white
        ),
        )
      ],
    );
  }
  Widget signInFacebookButton(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: MaterialButton(
        color: Color(0xff3b5998),
        elevation: 4.0,
        onPressed: () {
          if(_formKey.currentState.validate()) {
            verifyUser();
          }
        },
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('facebook',
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.5,
                fontSize: 18.0,
              ),
            ),

          ],
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Color(0xff3b5998),
              width: 3.0),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
  Widget signUpButton() {
    return GestureDetector(
        onTap: () => Navigator.pushReplacementNamed(context, '/register'),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'No account?  ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400
                )
              ),
              TextSpan(
                  text: 'Sign Up!',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold
                  )
              )
            ]
          ),
      ),
    );
  }


  Future verifyUser() async {
    var findUrl = 'https://group7-15.pvt.dsv.su.se/mysqlspring/findbyemailandpwd?email=$_email&password=$_password';
    http.Response response = await http.get(findUrl);
    String findResponseData = response.body;
    if (findResponseData == "Yes") {
      storeUser();
    } else {
      print("No such user");
    }
  }

  void signIn(User user) {
    Navigator.push(context, new MaterialPageRoute(
        builder: (BuildContext context) => new MainPage(user)));
  }

  void storeUser() async {
    var getUrl = 'https://group7-15.pvt.dsv.su.se/mysqlspring/getbyemail?email=$_email';
    http.Response getResponse = await http.get(getUrl);
    Map getResponseData = jsonDecode(getResponse.body);
    String name = getResponseData['name'].toString();
    String email = getResponseData['email'].toString();
    User newUser = new User(name, email, false);
    signIn(newUser);
  }
}

