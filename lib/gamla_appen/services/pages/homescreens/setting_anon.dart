import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/gamla_appen/services/auth.dart';


class settings_form_anon extends StatefulWidget {
  @override
  _settings_form_anonState createState() => _settings_form_anonState();
}

class _settings_form_anonState extends State<settings_form_anon> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              color: Color(0xff207FC5),
            ),
            Container(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  vertical: 120,
                  horizontal: 40
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('PARK´N',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text('STOCKHOLM',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                    SizedBox(height: 40.0),
                    Text('To adjust your settings you \nmust first create an account.',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                    SizedBox(height: 50.0),
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 25),
                        width: double.infinity,
                        child: MaterialButton(
                          color: Colors.white,
                          elevation: 4.0,
                          onPressed: (){
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
              ),
            ),
          ],
        ),

      );
    }
  }
