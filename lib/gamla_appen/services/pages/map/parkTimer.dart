import 'package:flutter/material.dart';


class ParkTimer extends StatefulWidget {
  @override
  _ParkTimerState createState() => _ParkTimerState();
}

class _ParkTimerState extends State<ParkTimer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'PARK´N STOCKHOLM',
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}