import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/gamla_appen/shared/loading.dart';
import 'package:flutterparkinggit/gamla_appen/services/auth.dart';
import 'package:flutterparkinggit/gamla_appen/shared/constants.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/authenticate/sign_in.dart';


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
  String name= "";
  String email ="";
  String password ="";
  String error = "";
  bool checkBox = false;

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
                        fontSize: 30,
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
                        height: 50,
                        alignment: Alignment.centerLeft,
                        child: TextFormField(
                          validator: (val) => val.isEmpty ? "Enter an email" : null,
                          onChanged: (val){
                            setState(() => email = val);
                          },
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(top: 15.0),
                            prefixIcon: Icon(
                              Icons.mail_outline,
                              color: Colors.white,
                            ),
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.white70)
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            decoration: parkBoxDecoration,
                            height: 50,
                            alignment: Alignment.centerLeft,
                            child: TextFormField(
                              validator: (val) => val.length < 6 ? "Enter a password 6+ chars long" : null,
                              obscureText: true,
                              onChanged: (val) {
                                setState(() => password = val);
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(top: 15.0),
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: Colors.white,
                                ),
                                hintText: 'Password',
                                hintStyle: TextStyle(color: Colors.white70),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            decoration: parkBoxDecoration,
                            height: 50,
                            alignment: Alignment.centerLeft,
                            child: TextFormField(
                              validator: (val) => val != password ? 'Passwords does not match': null,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(top:15.0),
                                prefixIcon: Icon(
                                  Icons.repeat,
                                  color: Colors.white,
                                ),
                                hintText: 'Repeat password',
                                hintStyle: TextStyle(color: Colors.white70)
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            decoration: parkBoxDecoration,
                            alignment: Alignment.centerLeft,
                            height: 50.0,
                            child: TextFormField(
                              validator: (val) => val.length < 1 ? 'Your have to enter a name': null,
                              onChanged: (val){
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
                      SizedBox(height: 10.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Checkbox(
                                  value: checkBox,
                                  onChanged: (bool value){
                                    setState(() {
                                      checkBox = !checkBox;
                                    });
                                  },
                                ),
                                Text(
                                  'I accept the tems and conditions',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15.0
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 25),
                        width: double.infinity,
                        child: MaterialButton(
                          color: Colors.white,
                          elevation: 4.0,
                          onPressed: ()async{
                            if(_formKey.currentState.validate()){
                              setState(() => loading = true);
                              dynamic result = await _auth.registerWithEmailAndPassword(email,password);
                              if(result == null){
                                setState(() {
                                  error = "Woop! Something went wrong, lets try again!";
                                  loading = false;
                                });
                              }
                            }
                          },
                          padding: EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('REGISTER  ',
                              style: TextStyle(
                                color: Color(0xff207FC5),
                                letterSpacing: 1.5,
                                fontSize: 18.0
                              ),
                              ),
                              Icon(
                                Icons.person_add,
                                color: Color(0xff207FC5),
                              )
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        )
                      )
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 25),
                    width: double.infinity,
                    child: MaterialButton(
                      color: Colors.transparent,
                      elevation: 0.0,
                      onPressed: (){
                        Navigator.of(context).push(_createRoute());
                      },
                      padding: EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Already have an account? ',
                            style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 1.5,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                          Text('Sign In!',
                            style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                                letterSpacing: 1.5,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignIn(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, -1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
