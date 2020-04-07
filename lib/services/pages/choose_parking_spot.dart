import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutterparkinggit/services/pages/choose_parking_spot.dart';
import 'package:flutterparkinggit/services/pages/homescreens/setting_anon.dart';
import 'package:flutterparkinggit/services/pages/homescreens/home.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

class ChooseParkingSpot extends StatefulWidget {
  @override
  _ChooseParkingSpotState createState() => _ChooseParkingSpotState();
}

class _ChooseParkingSpotState extends State<ChooseParkingSpot> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("LocationScreen"),
        backgroundColor: Colors.blue[600],
        centerTitle: true,
        elevation: 10,
      ),
    );
  }
}




