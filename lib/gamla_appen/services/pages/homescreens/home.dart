import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/gamla_appen/models/parking.dart';
import 'package:flutterparkinggit/gamla_appen/services/auth.dart';
import 'package:flutterparkinggit/gamla_appen/services/database.dart';
import 'package:flutterparkinggit/pages/parklist.dart';
import 'package:flutterparkinggit/pages/settings.dart';
import 'package:flutterparkinggit/pages/search.dart';
import 'package:provider/provider.dart';
import 'package:flutterparkinggit/map/map.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home> {

  final AuthService _auth = AuthService();

  int _currentIndex = 0;
  final tabs = [
    Map(),
    Search(),
    ParkList(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {

    /*void _showSettingsPanel(){
      showModalBottomSheet(
          context: context,
          builder: (context){
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: SettingsForm(),
            );
          });
    }*/

    return StreamProvider.value(
      value: DatabaseService().parking,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 3.0,
          backgroundColor: Color(0xff207FC5),
          title: Text(
            'PARK´N STOCKHOLM',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          actions: <Widget>[
            FlatButton.icon(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/signIn');
                },
                icon: Icon(Icons.input,
                  color: Colors.white,),
                label: Text('Sign out', style: TextStyle(color: Colors.white),)),
          ],
        ),
        body: tabs[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          elevation: 3.0,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              title: Text('Map'),
              backgroundColor: Color(0xff207FC5),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text('Search'),
              backgroundColor: Color(0xff207FC5),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              title: Text('Parkings'),
              backgroundColor: Color(0xff207FC5),
            ),BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('Settings'),
              backgroundColor: Color(0xff207FC5),
            )
          ],
        ),
      ),
    );
  }
}
