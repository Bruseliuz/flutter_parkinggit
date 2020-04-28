import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/map/location.dart';
import 'dart:async';

class Map extends StatefulWidget {
  Map({ @required Key key}) : super(key:key);
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {



  Location _locationTracker = Location();
  List <Marker> allMarkers = []; //TODO - 3 Lists

  @override
  void initState() {
    super.initState();
  }



  Widget _alertDialogWidget(element) {
    return AlertDialog(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
      ),
      backgroundColor: Colors.white,
      title: Text(element.streetName,
        style: TextStyle(
            color: Color(0xff207FC5),
            fontWeight: FontWeight.bold
        ),
      ),
      content: Container(
        height: 140,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.attach_money,
                  color: Color(0xff207FC5),
                ),
                Text('Price per hours: ',
                  style: TextStyle(
                      color: Color(0xff207FC5)
                  ),
                ),
                Text('Price',
                  style: TextStyle(
                      color: Color(0xff207FC5)
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Icon(
                  Icons.directions_car,
                  color: Color(0xff207FC5),
                ),
                Text('Number of parking spots: ',
                  style: TextStyle(
                      color: Color(0xff207FC5)
                  ),
                ),
                Text(element.numberOfParkingSpots,
                  style: TextStyle(
                      color: Color(0xff207FC5)
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Icon(
                  Icons.local_car_wash,
                  color: Colors.green,
                ),
                Text('Available parking spots: ',
                  style: TextStyle(
                      color: Color(0xff207FC5)
                  ),
                ),
                Text(element.availableParkingSpots,
                  style: TextStyle(
                      color: Color(0xff207FC5)
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      actions: <Widget>[
        Row(
          children: <Widget>[
            FlatButton.icon(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.check_circle_outline, color: Color(0xff207FC5),),
              label: Text('OK', style: TextStyle(color: Color(0xff207FC5)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Completer<GoogleMapController> _controller = Completer();
  static LatLng _center = LatLng(59.334591, 18.063240);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void getCurrentLocation() async {
    var location = await _locationTracker.getLocation();
    allMarkers.clear();
    setLocation(location);
  }


  void setLocation(LocationData location) async {
    LatLng newLocation = LatLng(location.latitude, location.longitude);
    CameraPosition cameraPosition = CameraPosition(
      zoom: 15.0,
      target: newLocation,
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    getData(newLocation);
    getMarkers(); // Sätter alla markers på kartan.
  }

  Future getMarkers() async{
    parkingSpotsList.forEach((element) {
      allMarkers.add(Marker(
          markerId: MarkerId(element.streetName),
          icon: BitmapDescriptor.defaultMarker,
          visible: true,
          draggable: false,
          onTap: () {
            showDialog(context: context, builder: (_) => _alertDialogWidget(element)
            );
          },
          position: element.coordinates
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: GoogleMap(
          zoomControlsEnabled: false,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 12.0,
          ),
          markers: Set.from(allMarkers),
        ),
      ),
      floatingActionButton:
      FloatingActionButton(
        elevation: 3.0,
        child: Icon(Icons.my_location,
        ),
        backgroundColor: Color(0xff207FC5),
        onPressed: () {
          allMarkers.clear();// Ta bort alla Markers ifrån kartan
          getCurrentLocation();
        },
      ),
    );
  }
}
