import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/services/auth.dart';
import 'package:flutterparkinggit/shared/constants.dart';
import 'package:flutterparkinggit/shared/loading.dart';
import 'package:flutterparkinggit/services/pages/authenticate/register.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutterparkinggit/models/user.dart';

class SignIn extends StatefulWidget {
  const SignIn({this.toggleView});
  final VoidCallback toggleView;

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = "";
  String password = "";
  String error = "";

  String errorMessage;

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
                  horizontal: 40.0,
                  vertical: 60.0,
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
                    Text(
                      'STOCKHOLM',
                      style: TextStyle(
                          letterSpacing: 1.5,
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                    SizedBox(height: 40.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          decoration: parkBoxDecoration,
                          height: 60,
                          alignment: Alignment.centerLeft,
                          child: TextFormField(
                            key: Key('email'),
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
                                contentPadding: EdgeInsets.only(top: 15),
                                prefixIcon: Icon(
                                  Icons.mail_outline,
                                  color: Colors.white,
                                ),
                                hintText: 'Email',
                                hintStyle: TextStyle(
                                    color: Colors.white70
                                )
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              decoration: parkBoxDecoration,
                              height: 60,
                              alignment: Alignment.centerLeft,
                              child: TextFormField(
                                key: Key('password'),
                                validator: (val) => val.length < 6 ? "Enter a password 6+ chars long" : null,
                                onChanged: (val) {
                                  setState(() => password = val);
                                },
                                obscureText: true,
                                style: TextStyle(
                                    color: Colors.white
                                ),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(top:15),
                                    prefixIcon: Icon(
                                      Icons.lock_outline,
                                      color: Colors.white,
                                    ),
                                    hintText: 'Password',
                                    hintStyle: TextStyle(color: Colors.white70)
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 25),
                              width: double.infinity,
                              child: MaterialButton(
                                key: Key('SignIn'),
                                color: Colors.white,
                                elevation: 4.0,
                                onPressed: ()async{
                                  if(_formKey.currentState.validate()) {
                                    setState(() => loading = true);
                                    dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                                    if (result is! User) {
                                      setState(() => loading = false);
                                      _signInError(result);
                                    }
                                    if (this.mounted) {
                                      setState(() => loading = false);
                                    }
                                  }
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
                                        color: Colors.white
                                    ),
                                    borderRadius: BorderRadius.circular(30)
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Column(
                              children: <Widget>[
                                SizedBox(width: 400.0),
                                Text('- OR -',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  top: 15, bottom: 5, left: 20, right: 20),
                              width: double.infinity,
                              child:FacebookSignInButton(
                                textStyle: TextStyle(fontSize: 16, color: Colors.white),
                                borderRadius: 5,
//                                color: Color(0xff3b5998),
//                                elevation: 4.0,
                                onPressed: () async{
                                  if(_formKey.currentState.validate()){
                                    setState(() => loading = true);
                                    dynamic result = await _auth.handleFacebookSignIn();
                                    if (this.mounted) {
                                      setState(() => loading = false);
                                    }
                                    if(result == null){
                                      setState(() {
                                        error = "That is not a registered user";
                                        loading = false;
                                      });
                                    }
                                  }
                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  top: 5, bottom: 5, left: 20, right: 20),
                              width: double.infinity,
                              child: GoogleSignInButton(
                                onPressed: () async {
                                  if(_formKey.currentState.validate()){
                                    setState(() => loading = true);
                                    dynamic result = await _auth.handleGoogleSignIn();
                                    if (this.mounted) {
                                      setState(() => loading = false);
                                    }
                                    if(result == null){
                                      setState(() {
                                        error = "That is not a registered user";
                                        loading = false;
                                      });
                                    }
                                  }
                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 0),
                              width: double.infinity,
                              child: MaterialButton(
                                color: Colors.transparent,
                                elevation: 0.0,
                                onPressed: (){
                                  _auth.signInAnon();
                                },
                                padding: EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('Continue without signing in',
                                      style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 1.5,
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w400
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white70,
                                      size: 14,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 15),
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
                                    Text('No account? ',
                                      style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 1.5,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w400
                                      ),
                                    ),
                                    Text('Sign Up!',
                                      style: TextStyle(
                                          color: Colors.white,
                                          decoration: TextDecoration.underline,
                                          letterSpacing: 1.5,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )
          )
        ],
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Register(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
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


  Future<void> _signInError(String error) async {
    String errorMessage;
    switch (error) {
      case "ERROR_INVALID_EMAIL":
        errorMessage = "The email or password is invalid";
        break;
      case "ERROR_WRONG_PASSWORD":
        errorMessage = "The email or password is invalid";
        break;
      case "ERROR_USER_NOT_FOUND":
        errorMessage = "A user with this email doesn't exist.";
        break;
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18)
          ),
          title: Text('$errorMessage \n           Let´s try that again!', style: TextStyle(color:  Color(0xff207FC5)),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  decoration: settingsDecoration,
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                ),
                Icon(Icons.error_outline, size: 50, color:  Color(0xff207FC5)),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK', textScaleFactor: 1.5),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
