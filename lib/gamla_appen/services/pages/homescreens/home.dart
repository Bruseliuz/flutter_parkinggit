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
        child: SafeArea(
          child: Scaffold(
              endDrawer: Drawer(
                elevation: 3.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white
                  ),
                  child: ListView(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(25),
                        child: Text('PARK´N STOCKHOLM',
                        style: TextStyle(
                          color: Color(0xff207FC5),
                          fontWeight: FontWeight.bold,
                          fontSize: 35
                        ),),
                      ),
                      SizedBox(height: 20),
                      Divider(color: Color(0xff207FC5),),
                      ListTile(
                        leading: Icon(Icons.tune,
                            color: Color(0xff207FC5)),
                        title: Text('SETTINGS',
                          style: TextStyle(
                              color: Color(0xff207FC5),
                            fontSize: 23,
                            letterSpacing: 1.0,
                          ),),
                        onTap: (){
                          Navigator.pushNamed(context, '/settings');
                        },
                      ),
                      Divider(color: Color(0xff207FC5),),
                      ListTile(
                        leading: Icon(Icons.history,
                        color: Color(0xff207FC5),),
                        title: Text('PARKING HISTORY',
                        style: TextStyle(
                          color: Color(0xff207FC5),
                          fontSize: 23,
                          letterSpacing: 1.0,
                        ),),
                        onTap: (){
                          Navigator.pushNamed(context, '/history');
                        },
                      ),
                      Divider(color: Color(0xff207FC5),),
                      ListTile(
                        leading: Icon(Icons.help_outline,
                        color: Color(0xff207FC5),),
                        title: Text('HELP',
                        style: TextStyle(
                          color: Color(0xff207FC5),
                          fontSize: 23,
                          letterSpacing: 1.0,
                        ),),
                      ),
                      Divider(color: Color(0xff207FC5),),
                      ListTile(
                        leading: Icon(Icons.exit_to_app,
                            color: Color(0xff207FC5)),
                        title: Text('SIGN OUT',
                          style: TextStyle(
                            color: Color(0xff207FC5),
                            fontSize: 23,
                            letterSpacing: 1.0,
                          ),),
                        onTap: (){
                          _auth.signOut();
                        },
                      ),
                      Divider(color: Color(0xff207FC5),),
                      Container(
                        padding: EdgeInsets.only(top: 210,left: 70),
                        child: Text('   An app by students \nat Stockholm University',
                        style: TextStyle(
                          color: Colors.black54
                        ),),
                      )
                    ],
                  ),
                ),
              ),
              appBar: AppBar(
                automaticallyImplyLeading: false,
                centerTitle: true,
                elevation: 0.0,
                backgroundColor: Color(0xff207FC5),
                title: Text(
                  'PARK´N STOCKHOLM',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
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
    ),
        )
    );
  }
}
