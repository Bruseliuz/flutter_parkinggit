import 'package:flutter/material.dart';
import 'package:flutterparkinggit/services//pages/authenticate/authenticate.dart';
import 'package:flutterparkinggit/models/user.dart';
import 'package:flutterparkinggit/services/pages/favorites.dart';
import 'package:flutterparkinggit/services/pages/homescreens/settings_form.dart';
import 'package:flutterparkinggit/services/pages/map/map.dart';
import 'package:flutterparkinggit/services/pages/parklist.dart';
import 'package:provider/provider.dart';
import 'package:flutterparkinggit/services//pages/homescreens/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    //return either home or authenticate
    if(user == null){
      return Authenticate();
    }else{
      return Home(screens: <Widget>[ParkingMap(),
        Favorites(),
        ParkList(),
        SettingsForm(),
      ],
      );
    }
  }
}
