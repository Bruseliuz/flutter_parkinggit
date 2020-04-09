import 'package:flutter/cupertino.dart';
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
      appBar: AppBar(
        title: Text("Availabe parking areas nearby"),
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
        color: Colors.pinkAccent,
        child: ListTile(
          leading: Text(
              '${_parkingAreasList.parkingAreas[index].vacantParkingLots}'),
          title: Text('ID: ${_parkingAreasList.parkingAreas[index].id}'),
          subtitle: Text(
              'Price: ${_parkingAreasList.parkingAreas[index].price} kronor per hour'),
          trailing: FlutterLogo(size: 56.0),
        ),
      ),
    );
  }

  void openPage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Happy Rebben'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'This is a happy Reb:',
              ),
            ],
          ),
        ),
      );
    }));
  }
}
