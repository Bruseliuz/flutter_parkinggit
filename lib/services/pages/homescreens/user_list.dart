import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutterparkinggit/models/parking.dart';
import 'package:flutterparkinggit/services/auth.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}


class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {

    final parkings = Provider.of<List<Parking>>(context);
    final AuthService _auth = AuthService();



    return Container(
        child: Scaffold(
          body: Text(''
          ),
        ),
    );
  }

}
