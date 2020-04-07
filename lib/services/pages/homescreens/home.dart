import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/models/parking.dart';
import 'package:flutterparkinggit/services/auth.dart';
import 'package:flutterparkinggit/services/database.dart';
import 'package:flutterparkinggit/services/pages/homescreens/settings_form.dart';
import 'package:provider/provider.dart';
import 'package:flutterparkinggit/services/pages/map.dart';


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
          backgroundColor: Color.fromRGBO(180, 199, 231, 1),
          elevation: 3.0,
          actions: <Widget>[
            Expanded(
              flex: 1,
              child: FlatButton(
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.perm_identity,
                        color: Colors.black),
                    Text("  Signout",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Baloo2",
                      ),)
                  ],
                ),
                onPressed: () async{
                  await _auth.singOut();
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Text('ParkOhoj',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Baloo2",
                    fontSize: 34.0,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: FlatButton(
                child: Row(
                  children: <Widget>[
                    Text(
                      "           Settings ",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Baloo2"
                      ),
                    ),
                    Icon(Icons.settings,
                      color: Colors.black,
                    ),
                  ],
                ),
                onPressed: () => _showSettingsPanel(),



              ),
            )
          ],
        ),
        body: Map(),
      ),
    );
  }
}
