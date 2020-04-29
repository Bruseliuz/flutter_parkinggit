import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/homescreens/settings_form.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/map/location.dart';
import 'dart:async';
import 'package:http/http.dart';
import 'dart:convert';

class ParkingMap extends StatefulWidget {
  ParkingMap({ @required Key key}) : super(key:key);
  @override
  _ParkingMapState createState() => _ParkingMapState();
}

class _ParkingMapState extends State<ParkingMap> {

  TimeOfDay _time = TimeOfDay.now();
  Future<Null> selectTime(BuildContext context) async {
    _time = await showTimePicker(context: context, initialTime: _time,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        });
  }

  Location _locationTracker = Location();
  List <Marker> allMarkers = []; //TODO - 3 Lists

  @override
  void initState() {
    super.initState();
  }

  Widget _noParkingAlertDialogWidget(){
    return AlertDialog(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
      ),
      backgroundColor: Colors.white,
      title: Text('No parking available in your area.',
        style: TextStyle(
            color: Color(0xff207FC5),
            fontWeight: FontWeight.bold
        ),
      ),
      content: Container(
        child: FlatButton.icon(
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.clear, color: Color(0xff207FC5), size: 25,),
          label: Text('Close', style: TextStyle(color: Color(0xff207FC5), fontSize: 20),
          ),
        ),
      ),
    );
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
          mainAxisAlignment: MainAxisAlignment.start,
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
            Theme(
              data: Theme.of(context).copyWith(
                primaryColor:  Color(0xff207FC5),
                highlightColor:  Colors.black,
                accentColor: Color(0xff207FC5),
              ),
              child: Builder(
                builder: (context)=> FlatButton.icon(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    selectTime(context);
                  },
                  icon: Icon(Icons.timer, color: Color(0xff207FC5),),
                  label: Text('Start parking', style: TextStyle(color: Color(0xff207FC5)),
                  ),
                ),
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

  Future getCurrentLocation() async {
    var location = await _locationTracker.getLocation();
    allMarkers.clear();
    await setLocation(location);
  }


  Future<void> setLocation(LocationData location) async {
    LatLng newLocation = LatLng(location.latitude, location.longitude);
    CameraPosition cameraPosition = CameraPosition(
      zoom: 15.0,
      target: newLocation,
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    await getData(newLocation);

  }

  Future<void> getData(LatLng location) async {
    Response response = await get('https://openparking.stockholm.se/LTF-Tolken/v1/${preference.toString()}/within?radius=100&lat=${location.latitude.toString()}&lng=${location.longitude.toString()}&outputFormat=json&apiKey=e734eaa7-d9b5-422a-9521-844554d9965b');
    Map data = jsonDecode(response.body);
    var dataList = data['features'] as List;
    List list = dataList.map<ParkingAreas>((json) => ParkingAreas.fromJson(json)).toList();
    parseCoordinates(list);
    allMarkers.clear();
    getMarkers();

  }

  void getMarkers() {
    parkingSpotsList.forEach((element) {
      setState(() {
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
          markers: Set<Marker>.of(allMarkers),
        ),
      ),
      floatingActionButton:
          FloatingActionButton(
            elevation: 3.0,
            child: Icon(Icons.my_location,
            ),
            backgroundColor: Color(0xff207FC5),
            onPressed: () async {
              await getCurrentLocation();
              print(allMarkers.toString());
              getMarkers();
              if(allMarkers.isEmpty){
                showDialog(context: context, builder: (_) => _noParkingAlertDialogWidget());
              }
            },
          ),
      );
  }
}


