import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/gamla_appen/services/auth.dart';
import 'package:flutterparkinggit/gamla_appen/shared/constants.dart';
import 'package:flutterparkinggit/gamla_appen/shared/loading.dart';
import 'package:flutterparkinggit/gamla_appen/shared/constants.dart';


class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

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
                horizontal: 40.0,
                vertical: 120.0,
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
                    SizedBox(height: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          decoration: parkBoxDecoration,
                          height: 60,
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
                                color: Colors.white,
                                elevation: 4.0,
                                onPressed: ()async{
                                  if(_formKey.currentState.validate()){
                                    setState(() => loading = true);
                                    dynamic result = await _auth.singInWithEmailAndPassword(email, password);
                                    if(result == null){
                                      setState(() {
                                        error = "That is not a registered user";
                                        loading = false;
                                      });
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
                                Text('Sign in with',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 25),
                              width: double.infinity,
                              child: MaterialButton(
                                color: Color(0xff3b5998),
                                elevation: 4.0,
                                onPressed: () {
                                  print('facebook login');
                                },
                                padding: EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('facebook',
                                    style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1.5,
                                      fontSize: 18.0
                                    ),
                                    ),
                                  ],
                                ),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Color(0xff3b5998)
                                  ),
                                  borderRadius: BorderRadius.circular(30)
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 25),
                              width: double.infinity,
                              child: MaterialButton(
                                color: Colors.transparent,
                                elevation: 0.0,
                                onPressed: (){
                                  widget.toggleView();
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
                                    Text('Sign Up! ',
                                      style: TextStyle(
                                        color: Colors.white,
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







     /* backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[400],
        elevation: 3.0,
        title: Text("Sign in",
        style: TextStyle(
          fontFamily: "Baloo2",
            letterSpacing: 2.0,
          color: Colors.lightBlue[50],
        ),),
        centerTitle: true,
        actions: <Widget>[
          FlatButton.icon(
              onPressed:(){
                widget.toggleView();
              },
              icon: Icon(Icons.person,
              color: Colors.lightBlue[50],),
              label: Text("Register",
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
              Container(
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 57,),
                    RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0),
                          side: BorderSide(color: Colors.lightBlue[300], width: 2)),
                      color: Colors.white,
                      elevation: 3.0,
                      child: Text(
                        "Sign in",
                        style: TextStyle(
                          fontFamily: "Baloo2",
                          color: Colors.lightBlue[400],
                        ),
                      ),
                      onPressed: ()async{
                        if(_formKey.currentState.validate()){
                          setState(() => loading = true);
                          dynamic result = await _auth.singInWithEmailAndPassword(email, password);
                          if(result == null){
                            setState(() {
                              error = "That is not a registered user";
                              loading = false;
                            });
                          }
                        }
                      },
                    ),
                    SizedBox(width: 20.0),
                    RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0),
                          side: BorderSide(color: Colors.lightBlue[300], width: 2)),
                      color: Colors.white,
                      elevation: 3.0,
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          fontFamily: "Baloo2",
                          color: Colors.lightBlue[400],
                        ),
                      ),
                      onPressed: () {
                        _auth.signInAnon();
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                error,
                style: TextStyle(color: Colors.red[400], fontSize: 14.0),
              )
            ],
          ),
        ),
      ),
    */
  }
}
