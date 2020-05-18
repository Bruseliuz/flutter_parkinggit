import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/gamla_appen/models/user.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/database.dart';
import 'package:flutterparkinggit/gamla_appen/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/homescreens/setting_anon.dart';



class SettingsFormDrawer extends StatefulWidget {
  @override
  _SettingsFormDrawerState createState() => _SettingsFormDrawerState();
}

class _SettingsFormDrawerState extends State<SettingsFormDrawer> {

  final _formKey = GlobalKey<FormState>();
  final List<String> parkingType = ['MC','HCP','No Preference'];

  int currentNotMinutes = 1;
  String _currentName;
  String _currentParking;
  int _currentMaxPrice;
  Icon _updateSettingsIcon = new Icon(Icons.refresh,
      color: Color(0xff207FC5));

  @override
  Widget build(BuildContext context) {

    bool isSwitched = false;
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
                          vertical: 40,
                          horizontal: 20
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
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
                                          value: isSwitched,
                                          onChanged: (value) {
                                            setState(() {
                                              value = isSwitched;
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
                                        min: 1,
                                        max: 60,
                                        divisions: 59,
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
                                Divider(
                                  color: Color(0xff207FC5),
                                  thickness: 1.0,
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
                                        value: isSwitched,
                                        onChanged: (value) {
                                          setState(() {
                                            value = isSwitched;
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
                                Text('Account settings'),
                                Container(
                                  child: TextFormField(
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
