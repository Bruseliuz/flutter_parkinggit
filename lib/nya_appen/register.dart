import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/nya_appen/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final _formKey = GlobalKey<FormState>();

  bool checkBox = false;
  String email, password, passwordValidate, name;

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
                  stops: [0.1, 0.4, 0.7, 0.9],
                )
            ),
          ),
          Container(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                    vertical: 120,
                    horizontal: 40
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
                          fontWeight: FontWeight.w400,
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      enterNameWidget(),
                      SizedBox(height: 20.0),
                      enterPasswordWidget(),
                      SizedBox(height: 20.0),
                      repeatPasswordWidget(),
                      SizedBox(height: 20.0),
                      fullNameWidget(),
                      SizedBox(height: 10.0),
                      termAndConditionWidget(),
                      SizedBox(height: 10.0),
                      registerButtonWidget(),
                      SizedBox(height: 20.0),
                      alreadyHaveAccountWidget()
                    ],
                  ),
                ),
              )
          )
        ],
      ),
    );
  }

  Widget enterNameWidget(){
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: parkBoxDecoration,
            height: 50,
            alignment: Alignment.centerLeft,
            child: TextFormField(
                validator: (val) => val.isEmpty ? "Enter an email" : null,
                onChanged: (val){
                  setState(() => email = val);
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
      ),
    );
  }
  Widget enterPasswordWidget(){
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration:parkBoxDecoration,
            height: 50,
            alignment: Alignment.centerLeft,
            child: TextFormField(
              validator: (val) => val.length < 6 ? 'Password should be minimum 6 chars' : null,
              onChanged: (val) {
                setState(() => password = val);}
                ,
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
      ),
    );
  }
  Widget repeatPasswordWidget(){
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration:parkBoxDecoration,
            height: 50,
            alignment: Alignment.centerLeft,
            child: TextFormField(
              validator: (val) => val != password ? 'The passwords does not match' : null,
              obscureText: true,
              style: TextStyle(
                  color: Colors.white
              ),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 15.0),
                  prefixIcon: Icon(
                    Icons.repeat,
                    color: Colors.white,),
                  hintText: 'Repeat password',
                  hintStyle: TextStyle(color: Colors.white70)
              ),

            ),
          )
        ],
      ),
    );
  }
  Widget fullNameWidget() {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: parkBoxDecoration,
            alignment: Alignment.centerLeft,
            height: 50,
            child: TextFormField(
                validator: (val) => val.length < 1 ? 'You have to enter a name' : null ,
                onChanged: (val) {
                  setState(() => name = val);
                },
              style: TextStyle(
                color: Colors.white
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 15.0),
                prefixIcon: Icon(
                  Icons.perm_identity,
                  color: Colors.white,
                ),
                hintText: 'Full name',
                hintStyle: TextStyle(color: Colors.white70)
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget termAndConditionWidget(){
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Checkbox(
          value: checkBox,
        onChanged: (bool value) {
            setState(() {
              checkBox = !checkBox;
                    });
                  },
              ),
              Text('I accept the terms and conditions',
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15.0),
              )
            ],
            )
          )
        ],
      ),
    );
  }
  Widget registerButtonWidget(){
    return Form(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 25),
        width: double.infinity,
        child: MaterialButton(
          color: Colors.white,
          elevation: 4.0,
          onPressed: (){
              addUser(name, email, password);
              print('hejhej');
          },
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('REGISTER ',
              style: TextStyle(
                color: Color(0xff0207FC5),
                letterSpacing: 1.5,
                fontSize: 18.0,
              ),
              ),
              Icon(Icons.person_add,
              color: Color(0xff207FC5)
              )
            ],
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Colors.white,
                width: 3.0),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
  Widget alreadyHaveAccountWidget(){
    return GestureDetector(
      onTap: () => Navigator.pushReplacementNamed(context, '/signIn'),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Already have an account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400
              )
            ),
            TextSpan(
              text: 'Sign In!',
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              )
            )
          ]
        ),
      ),
    );
  }

    /*(
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
      body: Stack(
        children: <Widget> [
          SingleChildScrollView(
            child: Container(
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
                ),
            ),
          ),
        ]
      ),
    );*/


  Future addUser(String name, String email, String password) async {
    var getUrl = 'https://group7-15.pvt.dsv.su.se/mysqlspring/findbyemail?email=$email';
    http.Response getResponse = await http.get(getUrl);
    var getResponseData = getResponse.body;
    if (getResponseData == "No") {
      var url = 'https://group7-15.pvt.dsv.su.se/mysqlspring/add?name=$name&email=$email&password=$password';
      http.Response response = await http.post(url);
      var responseData = response.body;
      if (responseData != "Saved") {
        print("nånting gick fel");
        //TODO Lägga till någon form av varning om att användaren inte kunde registreras
      } else {
        print("success!");
      }
    } else {
      print("email existerar redan");
      //TODO Lägga till varning om att email redan är registrerad
    }
  }
}
