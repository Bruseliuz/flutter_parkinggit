import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/services/auth.dart';
import 'package:flutterparkinggit/services/pages/homescreens/settings_form.dart';

class SettingsFormAnon extends StatefulWidget {
  @override
  _SettingsFormAnonState createState() => _SettingsFormAnonState();
}


class _SettingsFormAnonState extends State<SettingsFormAnon> {

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
            color: Colors.white,
          ),
            Container(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  vertical: 120,
                  horizontal: 40
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 40.0), //stumbled on a feature that
                    Text('Woops.. Seen like you',
                      style: TextStyle(
                          color: Color(0xff207FC5),
                          fontSize: 17.0,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w400
                      ),),
                    SizedBox(height: 10.0), //stumbled on a feature that
                    Text('stumbled upon a feature that',
                      style: TextStyle(
                          color: Color(0xff207FC5),
                          fontSize: 17.0,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                    SizedBox(height: 10.0), //stumbled on a feature that
                    RichText(
                      text: TextSpan(
                          text: 'requires a',
                          style: TextStyle(
                              color: Color(0xff207FC5),
                              fontSize: 17.0,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w400
                          ),
                          children: <TextSpan>[
                            TextSpan(text: ' registered ',
                              style: TextStyle(
                                  color: Color(0xff207FC5),
                                  fontSize: 17.0,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.w700
                              ),),
                            TextSpan(text: 'account.',
                              style: TextStyle(
                                  color: Color(0xff207FC5),
                                  fontSize: 17.0,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.w400
                              ),),
                          ]
                      ),
                    ),
                    SizedBox(height: 50.0),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomSheet: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(
                vertical: 25,
                horizontal: 40),
            width: double.infinity,
            child: MaterialButton(
              color: Color(0xff207FC5),
              elevation: 4.0,
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('REGISTER  ',
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.5,
                        fontSize: 18.0
                    ),
                  ),
                  Icon(
                    Icons.person_add,
                    color: Colors.white,
                  )
                ],
              ),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Color(0xff207FC5),
                ),
                borderRadius: BorderRadius.circular(30),
              ),
            )
        ),
      );
    }
  }
