import 'package:flutter/material.dart';
import 'package:flutterparkinggit/map/map.dart';
import 'package:flutterparkinggit/pages/search.dart';
import 'package:flutterparkinggit/pages/settings.dart';
import 'package:flutterparkinggit/pages/list.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();


}

class _MainPageState extends State<MainPage> {

  int _currentIndex = 0;
  final tabs = [
    Map(),
    Settings(),
    Search(),
    List(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3.0,
        backgroundColor: Colors.lightBlue[400],
        title: Text(
          'ParkApp',
          style: TextStyle(
            fontSize: 25.0,
          ),
        ),
        actions: <Widget>[
          FlatButton(
          child: FlatButton.icon(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/signIn');
              },
              icon: Icon(Icons.input,
              color: Colors.white,),
              label: Text('Sign out', style: TextStyle(color: Colors.white),)),
          )
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
            backgroundColor: Colors.lightBlue[400],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
            backgroundColor: Colors.lightBlue[350],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
            backgroundColor: Colors.lightBlue[300],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('Parkings'),
            backgroundColor: Colors.lightBlue[250],
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
