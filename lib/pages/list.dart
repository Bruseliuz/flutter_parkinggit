import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/map/location.dart';

class List extends StatefulWidget {
  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<List> {
  ParkingAreasList _parkingAreasList = new ParkingAreasList();
  ParkingLotsList _parkingLotsList = new ParkingLotsList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Availabe parking areas nearby"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _parkingAreasList.parkingAreas.length,
        itemBuilder: _getParkingAreasList,
      ),
    );
  }

  Widget _getParkingAreasList(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        openPage(context);
      },
      child: Container(
        height: 70,
        color: Color(0xffA5C9EA),
        child: ListTile(
          leading: Text(
              '${_parkingAreasList.parkingAreas[index].vacantParkingLots}'),
          title: Text('ID: ${_parkingAreasList.parkingAreas[index].id}'),
          subtitle: Text(
              'Price: ${_parkingAreasList.parkingAreas[index].price} kronor per hour'),
          trailing: Icon(Icons.directions_car),
        ),
      ),
    );
  }

  void openPage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Available parking lots in this area'),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: _parkingLotsList.parkingLots.length,
          itemBuilder: _getParkingLotsList,
        ),
      );
    }));
  }

  Widget _getParkingLotsList(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 70,
        color: Color(0xffA5C9EA),
        child: ListTile(
          leading: _parkingLotsList.parkingLots[index].occupied == true
              ? new Icon(Icons.sentiment_dissatisfied)
              : new Icon(Icons.sentiment_very_satisfied),
          title: Text(
              'Located: ${_parkingLotsList.parkingLots[index].locationCoords}'),
          subtitle: Text('Go there'),
          trailing: Icon(Icons.accessibility),
        ),
      ),
    );
  }
}
