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
        elevation: 0.0,
        backgroundColor: Color(0xff207FC5),
        title: Text('This is a future feature.',style: TextStyle(
          color: Colors.white
        ),),
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xff207FC5),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 70, horizontal: 40),
          child: Column(
            children: <Widget>[Text('Soon...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 45,
              fontWeight: FontWeight.bold
            ),)],
          ),
        ),
      ),
    );
  }
}
