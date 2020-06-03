import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/services/auth.dart';
import 'package:flutterparkinggit/services/pages/authenticate/authenticate.dart';
import 'package:introduction_screen/introduction_screen.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  List<PageViewModel> getPages() {
    return [
      PageViewModel(
        titleWidget: Container(
          padding: EdgeInsets.only(top: 20),
          child: Column(
            children: <Widget>[
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Find parkingspots in real-time!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
        bodyWidget: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Center(
                child: Container(
                  padding: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          ('assets/Parkeringar I Stockholm.jpg'),
                          scale: 4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20.0),

              SizedBox(height: 10),
              Center(
                child: Container(
                  width: 280,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Available parkingspots are shown as numbers in '
                        'each parking area tag, with the color indicating '
                        'the price of the parking area.',
                        style: TextStyle(
                            color: Color(0xff207FC5),
                            fontWeight: FontWeight.w300,
                            fontSize: 13),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Image.asset('assets/locmarker775.png', scale: 15),
                              Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Text(
                                  '5 - 10kr/h',
                                  style: TextStyle(
                                      color: Color(0xff207FC5),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13),
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Image.asset('assets/locmarker776.png', scale: 15),
                              Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Text(
                                  '15 - 26kr/h',
                                  style: TextStyle(
                                      color: Color(0xff207FC5),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13),
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Image.asset('assets/locmarker778.png', scale: 15),
                              Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Text(
                                  '50kr/h',
                                  style: TextStyle(
                                      color: Color(0xff207FC5),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      PageViewModel(
        titleWidget: Container(
          padding: EdgeInsets.only(top: 20),
          child: Column(
            children: <Widget>[
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Get directions! ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
        bodyWidget: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Center(
                child: Container(
                  padding: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          ('assets/Vägbeskrivning.jpg'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0),

              SizedBox(height: 10),
              Center(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'By simply tapping on a parking area, you will automatically get directions to that parking area.',
                        style: TextStyle(
                            color: Color(0xff207FC5),
                            fontWeight: FontWeight.w300,
                            fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      PageViewModel(
        titleWidget: Container(
          padding: EdgeInsets.only(top: 20),
          child: Column(
            children: <Widget>[
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Find parkingspots in real-time!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        bodyWidget: Container(
          padding: EdgeInsets.only(top: 0,left: 30,right: 30, bottom: 30),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              Center(
                child: Container(
                  padding: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          ('assets/Starta parkering.jpg'),
                          height: 400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Container(
                  width: 250,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: 'Set your desiered time by tapping',
                            style: TextStyle(
                                color: Color(0xff207FC5),
                                fontWeight: FontWeight.w300,
                                fontSize: 13
                            )),
                            TextSpan(text: ' SET TIMER ',
                                style: TextStyle(
                                    color: Color(0xff207FC5),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13
                                )),
                            TextSpan(text: 'and the app will calculate your price for you.',
                                style: TextStyle(
                                    color: Color(0xff207FC5),
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13
                                )),
                          ]
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      PageViewModel(
        titleWidget: Container(
          padding: EdgeInsets.only(top: 20),
          child: Column(
            children: <Widget>[
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Set personal preferences!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        bodyWidget: Container(
          padding: EdgeInsets.only(top: 0,left: 30,right: 30, bottom: 30),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              Center(
                child: Container(
                  padding: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          ('assets/Filters.jpg'),
                          height: 400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Container(
                  width: 300,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: <Widget>[
                      Text('Choose which types of parking you want to see and filter them by price and distance.',
                      style: TextStyle(
                          color: Color(0xff207FC5),
                          fontWeight: FontWeight.w300,
                          fontSize: 13
                      ),)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      )),
        child: IntroductionScreen(
          dotsDecorator: DotsDecorator(
              activeColor: Colors.lightBlue[900], color: Colors.white70),
          globalBackgroundColor: Colors.transparent,
          done: FloatingActionButton(
            elevation: 0.0,
            backgroundColor: Colors.white70,
            child: Icon(
              Icons.arrow_forward,
              color: Color(0xff207FC5),
            ),
          ),
          pages: getPages(),
          onDone: () {
            Navigator.pushReplacementNamed(context, '/wrapper');
          },
        ),
    );
  }
}
