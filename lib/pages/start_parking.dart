import 'dart:math';

import 'package:flutter/cupertino.dart';
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
  String _displayTime = "None";
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
      if (picked.hour < 10) {
        _displayTime = '0';
        _displayTime += picked.hour.toString();
        _displayTime += ":";
        _displayTime += picked.minute.toString();
      } else {
        _displayTime = picked.hour.toString();
        _displayTime += ":";
        _displayTime += picked.minute.toString();
      }
      print(picked.hour - TimeOfDay.now().hour);
      print(picked.minute - TimeOfDay.now().minute);
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
          child: Center(
            child: Column(
              children: <Widget>[
                FlatButton.icon(
                  color: Color(0xff207FC5),
                    onPressed: () {
                      selectTime();
                    },
                    icon: Icon(Icons.timer, color: Colors.white,),
                    label: Text('Set time', style: TextStyle(color: Colors.white),)),
                SizedBox(height: 40.0),
                Text('Your parking is set for: $_displayTime')
              ],
        ),
          ),
        )
      ),
    );
  }
}
