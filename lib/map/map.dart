import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';


class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {

  Location _locationTracker = Location();
  List <Marker> allMarkers = [];

  @override
  void initState(){
    super.initState();
/*
    parkingSpots.forEach((element) {
      allMarkers.add(Marker(
          markerId: MarkerId(element.streetName),
          draggable: false,
          infoWindow: InfoWindow(
              title: element.streetName, snippet: element.price),
          position: element.locatinCoords
      ));
    });
*/
  }

  Completer<GoogleMapController> _controller = Completer();
  static LatLng _center =  LatLng(40.785091, -73.968285);

  void _onMapCreated(GoogleMapController controller){
    _controller.complete(controller);
  }

  void getCurrentLocation() async {
    var location = await _locationTracker.getLocation();
    setLocation(location);
  }

  void setLocation(LocationData location) async{
    LatLng newLocation =  LatLng(location.latitude,location.longitude);
    CameraPosition cameraPosition = CameraPosition(
      zoom: 15.0,
      target: newLocation,

    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    print(newLocation.toString());
  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 12.0,
        ),
        markers: Set.from(allMarkers),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getCurrentLocation();
        },
      ),
      /*Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Card(
                child: Row(
                    children: <Widget> [
                      Expanded(
                        child: Ink(
                          decoration: const ShapeDecoration(
                            color: Colors.white30,
                            shape: OutlineInputBorder(),
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/signIn');
                            }
                            ,
                            icon: Icon(Icons.account_box),
                            iconSize: 50,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Ink(
                          decoration: const ShapeDecoration(
                            color: Colors.white30,
                            shape: OutlineInputBorder(),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.settings),
                            iconSize: 50,
                          ),
                        ),
                      )
                    ]
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 100.0,
                width: 100.0,
                child: IconButton(
                  onPressed: () {
                    getCurrentLocation();
                  },
                  icon: new Image.asset('assets/circle-cropped.png'),
                  tooltip: 'Call',
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Card(
                child: Row(
                    children: <Widget> [
                      Expanded(
                        child: Ink(
                          decoration: const ShapeDecoration(
                            color: Colors.white30,
                            shape: OutlineInputBorder(),
                          ),
                          child: IconButton(

                            icon: Icon(Icons.list),
                            iconSize: 50,
                          ),

                        ),
                      ),
                      Expanded(
                        child: Ink(
                          decoration: const ShapeDecoration(
                            color: Colors.white30,
                            shape: OutlineInputBorder(),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.home),
                            iconSize: 50,
                          ),
                        ),
                      )
                    ]
                ),
              ),
            ),
          ],
        )
      ]),*/
    );
  }
}