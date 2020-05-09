import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/gamla_appen/services/auth.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/database.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/favorites.dart';
import 'package:provider/provider.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/map/map.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/homescreens/settings_form.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/parklist.dart';

class Home extends StatefulWidget {
  Home({this.screens});

  static const Tag = "Skärmar";
  final List<Widget> screens;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  int _currentIndex = 0;
  Widget currentScreen;

  @override
  Widget build(BuildContext context) {

    return StreamProvider.value(
        value: DatabaseService().parking,
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 0.0,
              backgroundColor: Color(0xff207FC5),
              title: Text(
                'PARK´N STOCKHOLM',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed:(){
                    _auth.signOut();
                  },
                  child: Text('SIGN OUT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold
                  ),),
                )
                ],
            ),
            body:
            IndexedStack(
              index: _currentIndex,
              children: widget.screens,
            ),
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
                  icon: Icon(Icons.favorite_border),
                  title: Text('Favorites'),
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
        )
    )
    );
  }
}
