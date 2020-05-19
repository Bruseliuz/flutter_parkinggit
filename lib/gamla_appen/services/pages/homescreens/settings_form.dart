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

  int currentDistance;
  String _currentName;
  String _currentParking;
  int _currentMaxPrice;
  Icon _updateSettingsIcon = new Icon(Icons.refresh,
  color: Color(0xff207FC5));
  List<bool> _selections = List.generate(3, (_) => false);

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
                  color: Colors.white,
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                        vertical: 70,
                        horizontal: 40
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('TYPE OF PARKING',
                          style: TextStyle(
                            color:  Color(0xff207FC5),
                            fontSize: 18,
                            fontWeight: FontWeight.w600
                          ),
                          ),
                          ToggleButtons(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 33, right: 33),
                                  child: Icon(Icons.directions_car,)),
                              Container(
                                  padding: EdgeInsets.only(left: 33, right: 33),
                                  child: Icon(Icons.motorcycle)),
                              Container(
                                  padding: EdgeInsets.only(left: 33, right: 33),
                                  child: Icon(Icons.accessible)),
                            ],
                            isSelected: _selections,
                          ),
                          Container(
                            decoration: settingsDecoration.copyWith(borderRadius: BorderRadius.circular(5), color: Color(0xff207FC5)),
                            child: DropdownButtonFormField(
                              isExpanded: false,
                                iconEnabledColor: Colors.white,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    border: InputBorder.none,
                                    hintText: userData.parking,
                                    hintStyle: TextStyle(color: Colors.white),
                                    prefixIcon: Icon(
                                      Icons.directions_car, color: Colors.white,

                                    )
                                ),
                                value: (_currentParking ?? userData.parking),
                                items: parkingType.map((parking){
                                  return DropdownMenuItem(
                                    value: parking,
                                    child: Text('$parking',
                                      style: TextStyle(color: Colors.white),),
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
                          SizedBox(height: 30.0),
                          Text(
                              'Chosen max price: ${userData.maxPrice} kr / hour',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              )
                          ),
                          SizedBox(height: 20.0),
                          Slider(
                            label: _currentMaxPrice.toString() ,
                            activeColor: Colors.black54,
                            inactiveColor: Colors.white,
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
                          SizedBox(height: 40.0),
                          Text(
                              'Chosen radius: ${userData.radius} meters',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              )
                          ),
                          SizedBox(height: 20.0),
                          Slider(
                            label: currentDistance.toString(),
                            activeColor: Colors.black54,
                            inactiveColor: Colors.white,
                            value: (currentDistance ?? userData.radius).toDouble(),
                            min: 100,
                            max: 500,
                            divisions: 4,
                            onChanged: (val) => setState(() {
                              currentDistance = val.round();
                              _updateSettingsIcon = new Icon(Icons.refresh,
                                  color: Color(0xff207FC5));
                            }),

                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 25),
                            width: double.infinity,
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
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
                                      _currentMaxPrice ?? userData.maxPrice,
                                    currentDistance ?? userData.radius,
                                    userData.regNumber
                                  );
                                  _neverSatisfied();
                                  setState(() {
                                    _updateSettingsIcon = new Icon(Icons.check_circle_outline,
                                        color: Color(0xff207FC5));
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