import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutterparkinggit/map/map.dart';

class List extends StatefulWidget {
  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<List> {

  Location _locationTracker = Location();

  void getCurrentLocation() async {
    var location = await _locationTracker.getLocation();
    setLocation(location);
  }

  void setLocation(LocationData location) async {
    LatLng newLocation = LatLng(location.latitude, location.longitude);
    print(newLocation.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( //TODO - Skapa en lista av parkeringsplatser som kan visas upp
      body: Text('List'),
      floatingActionButton: FloatingActionButton(
        elevation: 3.0,
        child: Icon(Icons.refresh,
        ),
        backgroundColor: Colors.lightBlue[400],
        onPressed: () {
          getCurrentLocation();
        },
      ),
    );
  }
}
