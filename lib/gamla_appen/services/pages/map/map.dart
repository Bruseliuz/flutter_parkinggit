import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utm/utm.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/database.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/map/parkTimer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/map/location.dart';
import 'dart:async';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutterparkinggit/gamla_appen/models/user.dart';
import 'package:provider/provider.dart';

int distance;
String preference;

class ParkingMap extends StatefulWidget {
  ParkingMap({ @required Key key}) : super(key:key);
  @override
  _ParkingMapState createState() => _ParkingMapState();
}

class _ParkingMapState extends State<ParkingMap> {

  TimeOfDay _time = TimeOfDay.now();
  TimeOfDay picked;
  Future<Null> selectTime(BuildContext context) async {
    _time = await showTimePicker(context: context, initialTime: _time,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        });
    setState(() {
      picked = _time;
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
      backgroundColor: Colors.white70,
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

  Widget getFavoriteIcon(element){
    if(element.favorite == true){
      return Icon(Icons.favorite,
      color: Color(0xff207FC5),);
    } else {
      return Icon(Icons.favorite_border,
      color: Color(0xff207FC5),);
    }
  }

  Widget _alertDialogWidget(element) {
    return Container(
      child: AlertDialog(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: <Widget>[
            Flexible(
              child: Text(element.streetName,
              overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Color(0xff207FC5),
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
        content: Container(
          height: 120,
          width: double.infinity,
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
              SizedBox(height: 5.0),
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
                  Flexible(
                    child: Text(element.numberOfParkingSpots,
                      style: TextStyle(
                          color: Color(0xff207FC5)
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.0),
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
                  Flexible(
                    child: Text(element.availableParkingSpots,
                    overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Color(0xff207FC5)
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.build,
                    color: Colors.grey,
                  ),
                  Flexible(
                    child: Text(element.serviceDayInfo ?? ' No service info',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Color(0xff207FC5)
                    ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        actions: <Widget>[
          Row(
            children: <Widget>[
              FlatButton.icon(
                  onPressed:(){
                    print('Lägg till i favorites');
                  },
                  icon: getFavoriteIcon(element), //TODO - Icon efter favorites eller inte.
                  label: Text('Add to Favorites')
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
      ),
    );
  }

//  void addPolyLines() {
//    _polygons.add(Polygon(
//      polygonId: PolygonId(_lastCameraPosition.toString()),
//      points: _lines,
//      visible: true,
//      strokeColor: Colors.blue,
//      fillColor: Colors.lightBlueAccent
//    ));
//    setState(() {
//      latlngList.add(_new);
//      latlngList.add(_news);
//      _polyLines.add(Polyline(
//        polylineId: PolylineId(_lastCameraPosition.toString()),
//        visible: true,
//        points: latlngList,
//        color: Colors.blue
//      ));
//    });
//  }

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
//    _lastCameraPosition = newLocation;
    CameraPosition cameraPosition = CameraPosition(
      zoom: 15.0,
      target: newLocation,
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    await getData(newLocation);


  }

  Future<void> getData(LatLng location) async {
    Response response = await get('https://openparking.stockholm.se/LTF-Tolken/v1/${preference.toString()}/within?radius=$distance&lat=${location.latitude.toString()}&lng=${location.longitude.toString()}&outputFormat=json&apiKey=e734eaa7-d9b5-422a-9521-844554d9965b');
    Map data = jsonDecode(response.body);
    var dataList = data['features'] as List;
    List list = dataList.map<ParkingAreas>((json) => ParkingAreas.fromJson(json)).toList();
    parseParkingCoordinates(list);
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

    final user = Provider.of<User>(context);

    void setPreference(UserData userData){
      distance = userData.radius;
      if(userData.parking == 'HCP'){
        preference = 'prorelsehindrad';
      } else if(userData.parking == 'MC'){
        preference = 'pmotorcykel';
      } else if(userData.parking == 'No Preference'){
        preference ='ptillaten';
      } else{
        preference ='ptillaten';
      }
    }

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData userData = snapshot.data;
          setPreference(userData);
          if(picked == null) {
            return Scaffold(
              body: Container(
                child: GoogleMap(
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                onMapCreated: _onMapCreated,
                    markers: Set<Marker>.of(allMarkers),
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 12.0,
                ),
                ),
              ),
              floatingActionButton:
              FloatingActionButton(
                child: Icon(Icons.my_location),
                elevation: 3.0,
              backgroundColor: Color(0xff207FC5),
              onPressed: () async {
                await getCurrentLocation();
                print(allMarkers.toString());
                getMarkers();
                if (allMarkers.isEmpty) {
                  showDialog(context: context,
                      builder: (_) => _noParkingAlertDialogWidget());
                }
              },
            ),
          );
          }else{
            return ParkTimer();
          }
        }else{
          distance = 100;
          preference = 'ptillaten';
          return Scaffold(
            body: Container(
              child: GoogleMap(
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
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
                if (allMarkers.isEmpty) {
                  showDialog(context: context,
                      builder: (_) => _noParkingAlertDialogWidget());
                }
              },
            ),
          );
        }
        }
      );
  }
}


