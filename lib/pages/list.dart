import 'package:flutter/material.dart';
import 'package:flutterparkinggit/map/location.dart';

class List extends StatefulWidget {
  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<List> {
  ParkingAreasList _parkingAreasList = new ParkingAreasList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: _parkingAreasList.parkingAreas.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 70,
              color: Colors.lightBlue,
              child: ListTile(
                leading: _parkingAreasList.parkingAreas[index].vacantParkingLots<0?new Icon(Icons.sentiment_dissatisfied):new Icon(Icons.sentiment_very_satisfied),
                title: Text('ID: ${_parkingAreasList.parkingAreas[index].id}'),
                subtitle: Text('Price: ${_parkingAreasList.parkingAreas[index].price} kronor per hour'),
                trailing: FlutterLogo(size: 56.0),
              ),
            );
          }
      ),
    );
  }
}
