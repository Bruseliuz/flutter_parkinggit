import 'dart:math';

import 'package:flutter/material.dart';

class StartParking extends StatefulWidget {
  @override
  _StartParkingState createState() => _StartParkingState();
}

class _StartParkingState extends State<StartParking> {

  final _formKey = GlobalKey<FormState>();
  final List<int> hours = [1,2,3,4,5,6,7,8,9,10];
  TimeOfDay _time = TimeOfDay.now();
  TimeOfDay picked;
  int _hoursChosen;

  void selectTime() async {
    picked = await showTimePicker(
        context: context,
        initialTime: _time,
    builder: (BuildContext context, Widget child){
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
    });
    setState(() {
      _time = picked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff207FC5),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'REGNR'),
              ),
              FlatButton.icon(
                  onPressed: () {
                    selectTime();
                  },
                  icon: Icon(Icons.timer),
                  label: Text('Set time'))
            ],
        ),
        )
      ),
    );
  }
}
