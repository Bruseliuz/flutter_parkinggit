import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final _formKey = GlobalKey<FormState>();
  final List<String> parkingType = ['HCP','No preference'];

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
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 20.0),
              DropdownButtonFormField(
                decoration: InputDecoration(hintText:'Parkingpreference'),
                value: _currentParkingType,
                items: parkingType.map((parking){
                  return DropdownMenuItem(
                    value: parking,
                    child: Text('$parking'),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _currentParkingType = val),
              ),
              SizedBox(height: 50.0),
              Text('Filter price: $_currentMaxPrice kr/hour',
              style: TextStyle(
                color: Colors.lightBlue[400],
                fontSize: 18.0,
              ),),
              Slider(
                inactiveColor: Colors.lightBlue[400],
                activeColor: Colors.lightBlue[500],
                value: _currentMaxPrice.toDouble(),
                min: 1,
                max: 100,
                divisions: 100,
                onChanged: (val) => setState(() => _currentMaxPrice = val.round()),
              ),
              FlatButton(
                child: FlatButton.icon(
                    color: Colors.lightBlue[400],
                    icon: Icon(Icons.check_circle_outline, color: Colors.white,),
                    label: Text('Update profile',style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
