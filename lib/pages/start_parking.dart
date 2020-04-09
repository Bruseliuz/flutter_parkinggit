import 'package:flutter/material.dart';

class StartParking extends StatefulWidget {
  @override
  _StartParkingState createState() => _StartParkingState();
}

class _StartParkingState extends State<StartParking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[400],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(

        )
      ),
    );
  }
}
