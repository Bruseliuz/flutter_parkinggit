import 'package:flutter/material.dart';


class ParkingHistory extends StatefulWidget {
  @override
  _ParkingHistoryState createState() => _ParkingHistoryState();
}

class _ParkingHistoryState extends State<ParkingHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Text('This is a future feature')
        ],
      ),
    );
  }
}
