import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/gamla_appen/services/auth.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/authenticate/authenticate.dart';
import 'package:introduction_screen/introduction_screen.dart';


class Onboarding extends StatefulWidget {


  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {



  List<PageViewModel>  getPages() {
    return[
      PageViewModel(
        titleWidget: Column(
          children: <Widget>[
            Text(
              'PARK´N',
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
                  color: Colors.white,
                  letterSpacing: 1.5,
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        bodyWidget: Container(
          child: Column(
            children: <Widget>[
              Placeholder(),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Find parkingspots in real-time!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  Icon(Icons.directions_car,
                  color: Colors.white
                    ,)
                ],
              )
            ],
          ),
        ),
      ),
      PageViewModel(
        titleWidget: Column(
          children: <Widget>[
            Text(
              'PARK´N',
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
                color: Colors.white,
                letterSpacing: 1.5,
                fontSize: 30,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        bodyWidget: Container(
          child: Column(
            children: <Widget>[
              Placeholder(),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Add to your favorites!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                  )
                ],
              )
            ],
          ),
        ),
      ),
      PageViewModel(
        titleWidget: Column(
          children: <Widget>[
            Text(
              'PARK´N',
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
                color: Colors.white,
                letterSpacing: 1.5,
                fontSize: 30,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        bodyWidget: Container(
          child: Column(
            children: <Widget>[
              Placeholder(),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Set your personal preferences!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.settings,
                  color: Colors.white,)
                ],
              )
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
            stops: [0.1,0.4,0.7,0.9],
          )
      ),
      child: SafeArea(
        child: IntroductionScreen(
          dotsDecorator: DotsDecorator(
            activeColor: Colors.lightBlue[900],
            color: Colors.white70
          ),
          globalBackgroundColor: Colors.transparent,
          done: FloatingActionButton(
            elevation: 3.0,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.arrow_forward,
              color: Color(0xff207FC5),
            ),
          ),
          pages: getPages(),
          onDone: () {
            Navigator.pushReplacementNamed(context, '/signIn');
          },
        ),
      ),
    );
  }
}
