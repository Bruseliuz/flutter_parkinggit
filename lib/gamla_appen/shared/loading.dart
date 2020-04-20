import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
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
      child: Center(
          child: SpinKitWave(
            color: Colors.white,
            size: 40.0,
          )
      ),
    );
  }
}