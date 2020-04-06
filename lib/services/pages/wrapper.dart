import 'package:flutter/material.dart';
import 'package:flutterparkinggit/services//pages/authenticate/authenticate.dart';
import 'package:flutterparkinggit/models/user.dart';
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
      return Home();
    }
  }
}
