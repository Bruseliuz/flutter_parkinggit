import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/shared/loading.dart';
import 'package:flutterparkinggit/services/auth.dart';
import 'package:flutterparkinggit/shared/constants.dart';
import 'package:flutterparkinggit/services/pages/authenticate/sign_in.dart';

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
                vertical: 60,
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
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                color: Colors.white,),
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
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                color: Colors.white,),
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
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                color: Colors.white,),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(top: 15.0),
                                prefixIcon: Icon(
                                  Icons.perm_identity,
                                  color: Colors.white,
                                ),
                                hintText: 'Full name',
                                hintStyle: TextStyle(color: Colors.white70),
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
                                GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      checkBox = !checkBox;
                                    });
                                  },
                                  child: Text(
                                    'I accept the tems and conditions',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 15.0
                                    ),
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
                              dynamic result = await _auth.registerWithEmailAndPassword(email, password, name);
                              setState(() => loading = false);
                              if(result == null){
                                setState(() {
                                  error = "Woop! Something went wrong, lets try again!";
                                  loading = false;
                                });
                              }
                            }
                            Navigator.pushReplacementNamed(context, '/onBoarding');
                          },
                          padding: EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('REGISTER & LOGIN  ',
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
                    width: double.infinity,
                    child: MaterialButton(
                      color: Colors.transparent,
                      elevation: 0.0,
                      onPressed: (){
                        Navigator.of(context).push(_createRoute());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Already have an account? ',
                            style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 1.5,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                          Text('Sign In!',
                            style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                                letterSpacing: 1.5,
                                fontSize: 12.0,
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
