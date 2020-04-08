import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/gamla_appen/models/parking.dart';
import 'package:flutterparkinggit/gamla_appen/services/auth.dart';
import 'package:flutterparkinggit/gamla_appen/services/database.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/homescreens/settings_form.dart';
import 'package:provider/provider.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/map.dart';


class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    void _showSettingsPanel(){
      showModalBottomSheet(
          context: context,
          builder: (context){
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: SettingsForm(),
            );
          });
    }

    return StreamProvider<List<Parking>>.value(
      value: DatabaseService().parking,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xffb4c7e7),
          elevation: 3.0,
          actions: <Widget>[
            Expanded(
              flex: 1,
              child: FlatButton.icon(
                icon: Icon(Icons.perm_identity,
                color: Colors.black),
                onPressed: () async{
                  await _auth.singOut();
                },
                label: Text("Signout",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Baloo2",
                ),),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text('ParkApp',
              style: TextStyle(
                color: Colors.black,
                fontFamily: "Baloo2",
                fontSize: 34.0,
              ),
              ),
            ),
            Expanded(
              flex: 1,
              child: FlatButton.icon(
                  onPressed: () => _showSettingsPanel(),
                  icon: Icon(Icons.settings,
                  color: Colors.black,),
                  label: Text("Settings",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Baloo2",
                    ),)
              ),
            )
          ],
        ),
        body: Map(),
      ),
    );
  }
}