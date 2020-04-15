import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/map/map.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/search.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/homescreens/settings_form.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/parklist.dart';
import 'package:flutterparkinggit/nya_appen/user.dart';

class MainPage extends StatefulWidget {
  MainPage(this.user);
  final User user;
  @override
  _MainPageState createState() => _MainPageState(user);


}

class _MainPageState extends State<MainPage> {

  _MainPageState(this.user);
  final User user;

  @override
  void initState() {
    print(user.toString());
    super.initState();

  }
  int _currentIndex = 0;
  final tabs = [
    Map(),
    Search(),
    ParkList(),
    SettingsForm(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          },
      ),
    );
  }
}
