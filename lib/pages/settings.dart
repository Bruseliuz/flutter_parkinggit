import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}



class _SettingsState extends State<Settings> {

  final _formKey = GlobalKey<FormState>();
  final List<String> parkingType = ['MC','HCP','No preference'];

  String _currentParkingType;
  int _currentMaxPrice = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(hintText: 'Name'),

              ),
              DropdownButtonFormField(
                value: _currentParkingType,
                items: parkingType.map((parking){
                  return DropdownMenuItem(
                    value: parking,
                    child: Text('$parking'),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _currentParkingType = val),
              ),
              Slider(
                inactiveColor: Colors.lightBlue[400],
                activeColor: Colors.lightBlue[500],
                value: _currentMaxPrice.toDouble(),
                min: 1,
                max: 100,
                divisions: 10,
                onChanged: (val) => setState(() => _currentMaxPrice = val.round()),
              )
            ],
          ),
        ),
        ),
    );
  }
}
