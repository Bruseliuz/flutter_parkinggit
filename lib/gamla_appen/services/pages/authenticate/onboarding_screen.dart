import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {

  final controller = PageController(
    initialPage: 1,
  );

  List<PageViewModel>  getPages() {
    return[
      PageViewModel(
        title: 'PARK´N STOCKHOLM',
        body: 'Find parkingspots nearby, in real-time!'
      ),
      PageViewModel(
          title: 'PARK´N STOCKHOLM',
          body: 'Add to your favorites'
      ),PageViewModel(
          title: 'PARK´N STOCKHOLM',
          body: 'Settingstext'
      )
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
          globalBackgroundColor: Colors.transparent,
          done: Text('Get started',
          style: TextStyle(
            color: Colors.white
          ),),
          pages: getPages(),
          onDone: (){},
        ),
      ),
    );
  }
}
