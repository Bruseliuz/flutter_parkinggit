import 'package:flutter/material.dart';
import 'package:flutterparkinggit/models/user.dart';
import 'package:flutterparkinggit/services/pages/database.dart';
import 'package:flutterparkinggit/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutterparkinggit/services/pages/homescreens/setting_anon.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> parkingType = ['MC','HCP','No Preference'];

  int currentDistance;
  String _currentName;
  String _currentParking;
  int _currentMaxPrice;
  Icon _updateSettingsIcon = new Icon(Icons.refresh, color: Colors.white);
  List<bool> _selections = List.generate(3, (_) => false);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          UserData userData = snapshot.data;
            switch (userData.parking) {
              case 'MC':
                _selections[0] = true;
                break;
              case 'HCP':
                _selections[1] = true;
                break;
              case 'No Preference':
                _selections[2] = true;
                break;
              default:
                break;
            }
            return Stack(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 40
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Text('FILTERS',
                          style: TextStyle(
                              color:  Color(0xff207FC5),
                              fontWeight: FontWeight.bold,
                              fontSize: 20)
                          ),
                          SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('TYPE OF PARKING',
                                style: TextStyle(
                                    color:  Color(0xff207FC5),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                              Text('Choose which type of parking \nto show',
                                style: TextStyle(
                                    color: Color(0xff207FC5),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300
                                ),
                              ),
                              SizedBox(height: 10),
                              ToggleButtons(
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.only(left: 33, right: 33),
                                      child: Icon(Icons.motorcycle)),
                                  Container(
                                      padding: EdgeInsets.only(left: 33, right: 33),
                                      child: Icon(Icons.accessible)),
                                  Container(
                                      padding: EdgeInsets.only(left: 33, right: 33),
                                      child: Icon(Icons.directions_car,)),
                                ],
                                color: Color(0xff207FC5),
                                selectedColor: Colors.white,
                                fillColor: Color(0xff207FC5),
                                isSelected: _selections,
                                onPressed: (int index) {
                                  setState(() {
                                    for (int buttonIndex = 0; buttonIndex < _selections.length; buttonIndex++) {
                                      if (buttonIndex == index) {
                                        _selections[buttonIndex] = true;
                                      } else {
                                        _selections[buttonIndex] = false;
                                      }
                                    }
                                  });
                                  if(index == 0){
                                    _currentParking = 'MC';
                                  } else if(index == 1){
                                    _currentParking = 'HCP';
                                  }else if(index == 2){
                                    _currentParking = 'No preference';
                                  }
                                  print(_currentParking);
                                  _updateSettingsIcon = new Icon(Icons.refresh,
                                      color: Colors.white);
                                },

                              ),
                              SizedBox(height: 20.0),
                              Text(
                                'DISTANCE',
                                style: TextStyle(
                                    color:  Color(0xff207FC5),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                              Text('Select radius around position to search\nfor parking',
                                style: TextStyle(
                                    color: Color(0xff207FC5),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300
                                ),),
                              SizedBox(height: 10.0),
                              Center(
                                  child: Text('${currentDistance ?? userData.radius.toString()} M',
                                  style: TextStyle(
                                      color:  Color(0xff207FC5),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600
                                  ),
                                  )
                              ),
                              Slider(
                                activeColor: Color(0xff207FC5),
                                inactiveColor: Colors.black54,
                                value: (currentDistance ?? userData.radius).toDouble(),
                                min: 100,
                                max: 500,
                                divisions: 4,
                                onChanged: (val) => setState(() {
                                  currentDistance = val.round();
                                  _updateSettingsIcon = new Icon(Icons.refresh,
                                      color: Colors.white);
                                }),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('100',
                                  style: TextStyle(
                                      color:  Color(0xff207FC5),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300
                                  ),),
                                  Text('500',
                                  style: TextStyle(
                                      color:  Color(0xff207FC5),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300
                                  ),),
                                ],
                              ),
                              SizedBox(height: 20.0),
                              Text(
                                  'PRICE',
                                style: TextStyle(
                                    color:  Color(0xff207FC5),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                              Text('Set maxprice for parking',
                              style: TextStyle(
                                  color: Color(0xff207FC5),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300
                              ),),
                              SizedBox(height: 10.0),
                              Center(
                                child: Text('${_currentMaxPrice ?? userData.maxPrice} kr/h',
                                  style: TextStyle(
                                      color:  Color(0xff207FC5),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                              ),
                              Slider(
                                activeColor: Color(0xff207FC5),
                                inactiveColor: Colors.black54,
                                value: (_currentMaxPrice ?? userData.maxPrice).toDouble(),
                                min: 10,
                                max: 50,
                                divisions: 4,
                                onChanged: (val) => setState(() {
                                  _currentMaxPrice = val.round();
                                  _updateSettingsIcon = new Icon(Icons.refresh,
                                      color: Colors.white);
                                }),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 25),
                            width: double.infinity,
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  side: BorderSide(
                                      color: Color(0xff207FC5)
                                  )
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('SET FILTERS ',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.0
                                    ),
                                  ),
                                  _updateSettingsIcon
                                ],
                              ),
                              color: Color(0xff207FC5),
                              elevation: 4.0,
                              onPressed: () async {
                                if(_formKey.currentState.validate()) {
                                  await DatabaseService(uid: user.uid).updateUserData(
                                      _currentParking ?? userData.parking,
                                      _currentName ?? userData.name,
                                      _currentMaxPrice ?? userData.maxPrice,
                                    currentDistance ?? userData.radius,
                                    userData.regNumber
                                  );
                                  _neverSatisfied();
                                  setState(() {
                                    _updateSettingsIcon = new Icon(Icons.check_circle_outline,
                                        color: Colors.white);
                                  });
                                }
                              },
                              padding: EdgeInsets.all(15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }else{
            return SettingsFormAnon();
          }
        }
    );
  }



  Future<void> _neverSatisfied() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18)
          ),
          title: Text('Your settings have been saved.', style: TextStyle(color:  Color(0xff207FC5)),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  decoration: settingsDecoration,
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                ),
                Icon(Icons.check_circle_outline, size: 50, color:  Color(0xff207FC5)),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK', textScaleFactor: 1.5),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}