import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/models/user.dart';
import 'package:flutterparkinggit/services/pages/database.dart';
import 'package:flutterparkinggit/services/pages/homescreens/settings_anon_drawer.dart';
import 'package:flutterparkinggit/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutterparkinggit/services/pages/homescreens/setting_anon.dart';

class SettingsFormDrawer extends StatefulWidget {
  @override
  _SettingsFormDrawerState createState() => _SettingsFormDrawerState();
}

class _SettingsFormDrawerState extends State<SettingsFormDrawer> {

  final _formKey = GlobalKey<FormState>();
  final List<String> parkingType = ['MC','HCP','No Preference'];

  bool switchTimeFromEnd = false;
  bool switchEndReminder = false;
  int currentNotMinutes = 1;
  String _currentRegNumber;
  String _currentName;
  Icon _updateSettingsIcon = new Icon(Icons.refresh,
      color: Colors.white);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);



    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            UserData userData = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: Color(0xff207FC5),
                elevation: 0.0,
                title: Text('PARK´N STOCKHOLM',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                  ),),
              ),
              body: Stack(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    height: double.infinity,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 20
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text('NOTIFICATIONS',
                                  style: TextStyle(
                                      color:  Color(0xff207FC5),
                                      fontWeight: FontWeight.bold,
                                    fontSize: 20
                                  ),
                                ),
                                SizedBox(height: 20),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text('Get a reminder that\nyour parking is about to end.\n(Push notification)',
                                        style: TextStyle(
                                            color: Color(0xff207FC5),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 60),
                                        child: Switch(
                                          value: switchTimeFromEnd,
                                          onChanged:(value){
                                            setState(() {
                                              switchTimeFromEnd = value;
                                            });
                                          },
                                          activeTrackColor: Color(0xff207FC5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text('Minutes from \nparking ending',
                                        style: TextStyle(
                                            color: Color(0xff207FC5),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400
                                        )
                                    ),
                                    Slider(
                                        activeColor: Color(0xff207FC5),
                                        inactiveColor: Color(0xff5ca1d1),
                                        value: currentNotMinutes.toDouble() ?? 50,
                                        min: 0,
                                        max: 60,
                                        divisions: 60,
                                        onChanged: (val) => setState(() {
                                          currentNotMinutes = val.round();
                                        })
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 150, right: 40),
                                  child: Text('${currentNotMinutes.toString()} minutes',
                                  style: TextStyle(
                                    color:  Color(0xff207FC5),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                  ),),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text('Get a reminder when your \nparking has ended.',
                                      style: TextStyle(
                                          color: Color(0xff207FC5),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 60),
                                      child: Switch(
                                        value: switchEndReminder,
                                        onChanged:(value){
                                          setState(() {
                                            switchEndReminder = value;
                                          });
                                        },
                                        activeTrackColor: Color(0xff207FC5),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Divider(
                                  color: Color(0xff207FC5),
                                  thickness: 1.0,
                                ),
                                SizedBox(height: 20),
                                Text('ACCOUNT',
                                style: TextStyle(
                                  color:  Color(0xff207FC5),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                                ),),
                                SizedBox(height: 20),
                                Container(
                                  padding: EdgeInsets.only(left: 5,right: 5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('NAME',
                                      style: TextStyle(
                                        color: Color(0xff207FC5),
                                        fontSize: 12,
                                      ),),
                                      TextFormField(
                                        initialValue: ('${userData.name}'),
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(top: 15),
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
                                      SizedBox(height: 20),
                                      Text('REGNR',
                                      style: TextStyle(
                                        color: Color(0xff207FC5)
                                      ),
                                      ),
                                      TextFormField(
                                          initialValue:
                                              ('${userData.regNumber}' ??
                                                  'ABC123'),
                                          maxLength: 6,
                                        style: TextStyle(
                                            color: Color(0xff207FC5)
                                        ),
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(top: 15),
                                            prefixIcon: Icon(
                                              Icons.directions_car,
                                              color: Color(0xff207FC5),
                                            )
                                        ),
                                        onChanged: (val) => setState(() {
                                          _currentRegNumber = val;
                                          _updateSettingsIcon = new Icon(Icons.refresh,
                                              color: Colors.white);
                                        }),
                                      ),
                                      SizedBox(height: 30),
                                      Container(
                                        width: double.infinity,
                                        child: MaterialButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(30),
                                              side: BorderSide(
                                                  color: Color(0xff207FC5),
                                                width: 1.5
                                              )
                                        ),

                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text('Update settings ',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18.0
                                                ),
                                              ),
                                              _updateSettingsIcon
                                            ],
                                          ),
                                          color: Color(0xff207FC5),
                                          elevation: 4.0,
                                          onPressed: () async {
                                            print(_currentRegNumber);
                                            print(userData.regNumber);
                                            if(_formKey.currentState.validate())
                                            await DatabaseService(uid: userData.uid).updateUserData(
                                                userData.parking,
                                                _currentName ?? userData.name,
                                                userData.maxPrice,
                                                userData.radius,
                                              _currentRegNumber ?? userData.regNumber,
                                            );
                                            _neverSatisfied();
                                            setState(() {
                                              _updateSettingsIcon = new Icon(Icons.check_circle_outline,
                                                  color: Colors.white);
                                            });
                                          },
                                          padding: EdgeInsets.all(15),
                                        ),
                                      ),
                                    ],
                                  )
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }else{
            return SettingsFormAnonDrawer();
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
              borderRadius: BorderRadius.circular(15)
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
