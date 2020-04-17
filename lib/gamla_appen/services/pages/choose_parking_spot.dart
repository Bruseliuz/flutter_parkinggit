import 'package:flutter/material.dart';


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




