import 'package:flutter/material.dart';
import 'package:flutterparkinggit/models/user.dart';
import 'package:flutterparkinggit/services/database.dart';
import 'package:flutterparkinggit/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutterparkinggit/services/pages/loading.dart';


class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}



class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> parkingType = ['MC','HCP','No preference'];

  String _currentName;
  String _currentParking;
  int _currentMaxPrice;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          UserData userData = snapshot.data;
            return Form(
              key: _formKey,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Text('Update your settings',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.lightBlue[400],
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Baloo2',
                      ),
                    ),
                    Divider(
                      color: Colors.lightBlue[400],
                      thickness: 1.0,
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      initialValue: userData.name,
                      decoration: textInputDecoration,
                      validator: (val) => val.isEmpty ? 'Please enter a name' : null,
                      onChanged: (val) => setState(() => _currentName = val),
                    ),
                    SizedBox(height: 20.0),
                    //dropdown
                    DropdownButtonFormField(//TODO - Visa det valda maxpriset
                      decoration: textInputDecoration,
                      value: userData.parking ?? _currentParking ,
                      items: parkingType.map((parking){
                        return DropdownMenuItem(
                          value: parking,
                          child: Text('$parking'),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _currentParking = val) //TODO - plockar den upp svaret?
                    ),
                    SizedBox(height: 30.0),
                    Text(
                        'Chosen max price: $_currentMaxPrice kr / hour', //TODO - Visa det valda maxpriset (userData.maxPrice)
                        style: TextStyle(
                          color: Colors.lightBlue[400],
                          fontFamily: 'Baloo2',
                        )
                    ),
                    Slider(
                      activeColor: Colors.lightBlue[400],
                      inactiveColor: Colors.lightBlue[100],
                      value: (_currentMaxPrice ?? userData.maxPrice).toDouble(),
                      min: 10,
                      max: 90,
                      divisions: 8,
                      onChanged: (val) => setState(() => _currentMaxPrice = val.round()),
                    ),
                    //slider
                    RaisedButton(
                      color: Colors.lightBlue[400],
                      child: Text('Update',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if(_formKey.currentState.validate()) {
                          await DatabaseService(uid: user.uid).updateUserData(
                           _currentParking ?? userData.parking,
                           _currentName ?? userData.name,
                           _currentMaxPrice ?? userData.maxPrice
                          );
                          Navigator.pop(context);
                          print(userData.parking);
                        }
                      },
                    ),
                    Divider(
                      color: Colors.lightBlue[400],
                      thickness: 1.0,
                    )
                  ],
                ),
              ),
            );
        }else{
          return settingsform_anon();
        }
      }
    );
  }
}
