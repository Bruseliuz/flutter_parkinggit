import 'package:flutter/material.dart';

class StartParking extends StatefulWidget {
  @override
  _StartParkingState createState() => _StartParkingState();
}

class _StartParkingState extends State<StartParking> {

  final _formKey = GlobalKey<FormState>();
  final List<int> hours = [1,2,3,4,5,6,7,8,9,10];

  int _hoursChosen;

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
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(hintText: 'REGNR'),
              ),
              DropdownButtonFormField(
                items: hours.map((hour){
                  return DropdownMenuItem(
                    value: hour,
                    child: Text('$hour')
                  );
                }).toList(),
                onChanged: (val) => setState(() => _hoursChosen = val),
              )
            ],
        ),
        )
      ),
    );
  }
}
