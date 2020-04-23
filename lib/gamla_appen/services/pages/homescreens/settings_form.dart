import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/gamla_appen/models/user.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/database.dart';
import 'package:flutterparkinggit/gamla_appen/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/homescreens/setting_anon.dart';


class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}


class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> parkingType = ['MC','HCP','No Preference'];


  String _currentName;
  String _currentParking;
  int _currentMaxPrice;
  Icon _updateSettingsIcon = new Icon(Icons.refresh,
  color: Color(0xff207FC5));


  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);


    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          UserData userData = snapshot.data;
            return Stack(
              children: <Widget>[
                Container(
                  color: Color(0xff207FC5),
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                        vertical: 120,
                        horizontal: 40
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: settingsDecoration,
                            height: 60,
                            alignment: Alignment.center,
                            child: TextFormField(
                              initialValue: userData.name,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.perm_identity,
                                    color: Color(0xff207FC5),
                                  )
                              ),
                              validator: (val) => val.isEmpty ? 'Please enter a name' : null,
                              onChanged: (val) => setState(() {
                                _currentName = val;
                                _updateSettingsIcon = new Icon(Icons.refresh,
                                    color: Color(0xff207FC5));
                              }),
                              style: TextStyle(
                                  color: Color(0xff207FC5)
                              ),
                            ),
                          ),

                          SizedBox(height: 20.0),
                          Container(
                            decoration: settingsDecoration,
                            child: DropdownButtonFormField(
                                iconEnabledColor: Color(0xff207FC5),
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(5),
                                    border: InputBorder.none,
                                    hintText: userData.parking,
                                    hintStyle: TextStyle(color: Color(0xff207FC5)),
                                    prefixIcon: Icon(
                                      Icons.directions_car, color: Color(0xff207FC5),

                                    )
                                ),
                                value: userData.parking,
                                items: parkingType.map((parking){
                                  return DropdownMenuItem(
                                    value: parking,
                                    child: Text('$parking',
                                      style: TextStyle(color: Color(0xff207FC5)),),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    _currentParking = val;
                                    print(_currentParking);
                                    _updateSettingsIcon = new Icon(Icons.refresh,
                                        color: Color(0xff207FC5));
                                  });
                                }
                            ),
                          ),
                          SizedBox(height: 60.0),
                          Text(
                              'Chosen max price: ${userData.maxPrice} kr / hour',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              )
                          ),
                          SizedBox(height: 15.0),
                          Slider(
                            label: _currentMaxPrice.toString() ,
                            activeColor: Colors.black54,
                            inactiveColor: Colors.black,
                            value: (_currentMaxPrice ?? userData.maxPrice).toDouble(),
                            min: 10,
                            max: 90,
                            divisions: 8,
                            onChanged: (val) => setState(() {
                              _currentMaxPrice = val.round();
                              _updateSettingsIcon = new Icon(Icons.refresh,
                                  color: Color(0xff207FC5));
                            }),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            padding: EdgeInsets.symmetric(vertical: 25),
                            width: double.infinity,
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  side: BorderSide(
                                      color: Colors.white
                                  )
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('Update settings ',
                                    style: TextStyle(
                                        color: Color(0xff207FC5),
                                        fontSize: 18.0
                                    ),
                                  ),
                                  _updateSettingsIcon
                                ],
                              ),
                              color: Colors.white,
                              elevation: 4.0,
                              onPressed: () async {
                                if(_formKey.currentState.validate()) {
                                  await DatabaseService(uid: user.uid).updateUserData(
                                      _currentParking ?? userData.parking,
                                      _currentName ?? userData.name,
                                      _currentMaxPrice ?? userData.maxPrice
                                  );
                                  _neverSatisfied();
                                  setState(() {
                                    _updateSettingsIcon = new Icon(Icons.check_circle_outline,
                                        color: Color(0xff207FC5));
                                  });
                                  print(userData.parking);
                                }
                              },
                              padding: EdgeInsets.all(15),
                            ),
                          ),
                          /*Container(
                              children: <Widget>[
                                Text('Update your settings',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Baloo2',
                                  ),
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
                                      color: Colors.white,
                                      fontFamily: 'Baloo2',
                                    )
                                ),
                                Slider(
                                  activeColor: Colors.lightBlue[100],
                                  inactiveColor: Colors.white,
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
                              ],
                            ),*/
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
      barrierDismissible: false, // user must tap button!
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
                //Text('You\’re like me. I’m never satisfied.'),
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
