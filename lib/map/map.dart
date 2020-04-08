import 'package:flutter/material.dart';
import 'package:flutterparkinggit/pages/main_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ParkApp',
          style: TextStyle(
            fontSize: 25.0,
          ),
        ),
      ),
      body: Map(),
    );
  }
}
