import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utm/utm.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/database.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/map/parkTimer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/map/parking_area.dart';
import 'dart:async';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutterparkinggit/gamla_appen/models/user.dart';
import 'package:provider/provider.dart';

int distance;
TimeOfDay picked;
String preference;
User globalUser;
List<String> favoriteDocumentsId = [];
final CollectionReference parkCollection =
    Firestore.instance.collection("parkingPreference");
List<ParkingArea> parkingSpotsList = [];

class ParkingMap extends StatefulWidget {
//  ParkingMap({@required Key key}) : super(key: key);

  @override
  _ParkingMapState createState() => _ParkingMapState();
}

class _ParkingMapState extends State<ParkingMap> {
  List<DocumentSnapshot> favoriteDocuments = [];
  Location _locationTracker = Location();
  List<Marker> allMarkers = []; //TODO - 3 Lists
  Completer<GoogleMapController> _controller = Completer();
  static LatLng _center = LatLng(59.334591, 18.063240);

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    globalUser = Provider.of<User>(context);
    getFavorites();

    void setPreference(UserData userData) {
      distance = userData.radius;
      print(distance);
      if (userData.parking == 'HCP') {
        preference = 'prorelsehindrad';
      } else if (userData.parking == 'MC') {
        preference = 'pmotorcykel';
      } else if (userData.parking == 'No Preference') {
        preference = 'ptillaten';
      } else {
        preference = 'ptillaten';
      }
    }

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: globalUser.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            setPreference(userData);
            if (picked == null) {
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
                floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.my_location),
                  elevation: 3.0,
                  backgroundColor: Color(0xff207FC5),
                  onPressed: () async {
                    await getCurrentLocation();
                    print(allMarkers.toString());
                    getMarkers();
                    if (allMarkers.isEmpty) {
                      showDialog(
                          context: context,
                          builder: (_) => _noParkingAlertDialogWidget());
                    }
                  },
                ),
              );
            } else {
              return ParkTimer();
            }
          } else {
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
              floatingActionButton: FloatingActionButton(
                elevation: 3.0,
                child: Icon(
                  Icons.my_location,
                ),
                backgroundColor: Color(0xff207FC5),
                onPressed: () async {
                  await getCurrentLocation();
                  print(allMarkers.toString());
                  getMarkers();
                  if (allMarkers.isEmpty) {
                    showDialog(
                        context: context,
                        builder: (_) => _noParkingAlertDialogWidget());
                  }
                },
              ),
            );
          }
        });
  }

  Widget _noParkingAlertDialogWidget() {
    return AlertDialog(
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white70,
      title: Text(
        'No parking available in your area.',
        style: TextStyle(color: Color(0xff207FC5), fontWeight: FontWeight.bold),
      ),
      content: Container(
        child: FlatButton.icon(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.clear,
            color: Color(0xff207FC5),
            size: 25,
          ),
          label: Text(
            'Close',
            style: TextStyle(color: Color(0xff207FC5), fontSize: 20),
          ),
        ),
      ),
    );
  }

  Widget getFavoriteIcon(element) {
    if (element.favorite == true) {
      return Icon(
        Icons.favorite,
        color: Color(0xff207FC5),
      );
    } else {
      return Icon(
        Icons.favorite_border,
        color: Color(0xff207FC5),
      );
    }
  }

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

  Widget getFavoriteLabel(element) {
    if (element.favorite == false) {
      return Text('Add to favorites');
    } else {
      return Text('Remove from favorite');
    }
  }

  Future<void> getData(LatLng location) async {
    print(distance);
    Response response = await get(
        'https://openparking.stockholm.se/LTF-Tolken/v1/${preference.toString()}/within?radius=$distance&lat=${location.latitude.toString()}&lng=${location.longitude.toString()}&outputFormat=json&apiKey=e734eaa7-d9b5-422a-9521-844554d9965b');
    Map data = jsonDecode(response.body);
    var dataList = data['features'] as List;
    List list = dataList
        .map<ParkingArea>((json) => ParkingArea.fromJson(json))
        .toList();
    setState(() {
      parseParkingCoordinates(list);
    });
    allMarkers.clear();
    getMarkers();
  }

  void getMarkers() {
    parkingSpotsList.forEach((element) async {
      BitmapDescriptor bitmapDescriptor = await createCustomMarkerBitmap(element.availableParkingSpots);
      setState(() {
        allMarkers.add(Marker(
            markerId: MarkerId(element.streetName),
            icon: bitmapDescriptor,
            visible: true,
            draggable: false,
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) => ParkingDialogWidget(parkingArea: element));
            },
            position: element.coordinates));
      });
    });
  }

  Future<BitmapDescriptor> createCustomMarkerBitmap(String title) async {
    TextSpan span = new TextSpan(
      style: new TextStyle(
        color: Colors.black,
        fontSize: 35.0,
        fontWeight: FontWeight.bold,
      ),
      text: title,
    );

    TextPainter tp = new TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    PictureRecorder recorder = new PictureRecorder();
    Canvas c = new Canvas(recorder);

    tp.layout();
    tp.paint(c, new Offset(20.0, 10.0));

    /* Do your painting of the custom icon here, including drawing text, shapes, etc. */

    Picture p = recorder.endRecording();
    ByteData pngBytes =
    await (await p.toImage(tp.width.toInt() + 40, tp.height.toInt() + 20))
        .toByteData(format: ImageByteFormat.png);

    Uint8List data = Uint8List.view(pngBytes.buffer);

    return BitmapDescriptor.fromBytes(data);
  }





  void getFavorites() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('parkingPreference')
        .document(globalUser.uid)
        .collection('favoriteParkings')
        .getDocuments();
    favoriteDocuments = result.documents;
    favoriteDocuments.forEach((doc) => favoriteDocumentsId.add(doc.documentID));
  }
}

class ParkingDialogWidget extends StatefulWidget {
  final ParkingArea parkingArea;

  const ParkingDialogWidget({Key key, this.parkingArea}) : super(key: key);

  @override
  State<ParkingDialogWidget> createState() => new ParkingDialogState();
}

class ParkingDialogState extends State<ParkingDialogWidget> {
  TimeOfDay _time = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return _parkingDialogWidget(widget.parkingArea);
  }

  Widget _parkingDialogWidget(element) {
    IconData favoriteIconData = Icons.favorite;
    String favoriteString = 'Add to favorites';
    if (element.favorite == false) {
      favoriteString = 'Add to favorites';
      favoriteIconData = Icons.favorite_border;
    } else {
      favoriteString = 'Remove from favorites';
      favoriteIconData = Icons.favorite;
    }
    return Container(
      child: AlertDialog(

        contentPadding: EdgeInsets.all(20),
        elevation: 3.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Row(
          children: <Widget>[
            Flexible(
              flex: 3,
              fit: FlexFit.tight,
              child: Text(
                element.streetName,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Color(0xff207FC5), fontWeight: FontWeight.bold),
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.loose,
                child: FlatButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.exit_to_app), label: Text(''),
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0)))
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
                  Text(
                    'Price per hours: ',
                    style: TextStyle(color: Color(0xff207FC5)),
                  ),
                  Text(
                    'Price',
                    style: TextStyle(color: Color(0xff207FC5)),
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
                  Text(
                    'Number of parking spots: ',
                    style: TextStyle(color: Color(0xff207FC5)),
                  ),
                  Flexible(
                    child: Text(
                      element.numberOfParkingSpots,
                      style: TextStyle(color: Color(0xff207FC5)),
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
                  Text(
                    'Available parking spots: ',
                    style: TextStyle(color: Color(0xff207FC5)),
                  ),
                  Flexible(
                    child: Text(
                      element.availableParkingSpots,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Color(0xff207FC5)),
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
                    child: Text(
                      element.serviceDayInfo ?? ' No service info',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Color(0xff207FC5)),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                fit: FlexFit.loose,
                child: FlatButton.icon(
                  padding: EdgeInsets.fromLTRB(1, 0, 0, 0),
                  icon: Icon(favoriteIconData),
                  label: Text(favoriteString),
                  onPressed: () async {
                    if (element.favorite == false) {
                      String latLon = element.coordinates.latitude.toString();
                      latLon += ', ${element.coordinates.longitude}';
                      await DatabaseService(uid: globalUser.uid)
                          .updateUserFavorites(
                              latLon,
                              element.streetName,
                              element.serviceDayInfo,
                              element.favorite,
                              element.availableParkingSpots);
                    } else if (element.favorite == true) {
                      await parkCollection
                          .document(globalUser.uid)
                          .collection('favoriteParkings')
                          .document(element.streetName)
                          .delete();
                    }
                    // ignore: unnecessary_statements
                    setState(() {
                      element.favorite == true
                          ? element.favorite = false
                          : element.favorite = true;
                      print(element.favorite);
                      if (element.favorite == false) {
                        favoriteIconData = Icons.favorite_border;
                        favoriteString = 'Add to favorites';
                      } else {
                        favoriteIconData = Icons.favorite;
                        favoriteString = 'Remove from favorites';
                      }
                    });
                    print('Lägg till i favorites');
                  },
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    primaryColor: Color(0xff207FC5),
                    highlightColor: Colors.black,
                    accentColor: Color(0xff207FC5),
                  ),
                  child: Builder(
                    builder: (context) => FlatButton.icon(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: () {
                        Navigator.of(context).pop();
                        selectTime(context);
                      },
                      icon: Icon(
                        Icons.timer,
                        color: Color(0xff207FC5),
                      ),
                      label: Text(
                        'Start parking',
                        style: TextStyle(color: Color(0xff207FC5)),
                      ),
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

  Future<Null> selectTime(BuildContext context) async {
    _time = await showTimePicker(
        context: context,
        initialTime: _time,
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
}

void parseParkingCoordinates(List<dynamic> coordinates) {
  bool favorite = false;
  List<ParkingArea> tempList = [];
//  parkingSpotsList.clear();
  coordinates.forEach((element) {
    if (favoriteDocumentsId.contains(element.streetName)) {
      favorite = true;
    } else {
      favorite = false;
    }
    print('${element.coordinatesList} HÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄR');
    List temp = element.coordinatesList[1];
    double longitude = temp[1];
    double latitude = temp[0];
    LatLng coordinatesParsed = new LatLng(longitude, latitude);
    tempList.add(
      ParkingArea(
          streetName: element.streetName,
          coordinates: coordinatesParsed,
          numberOfParkingSpots: element.coordinatesList.length.toString(),
          serviceDayInfo: element.serviceDayInfo,
          availableParkingSpots:
          getRandomAvailableParkingSpot(element.coordinatesList),
          favorite: favorite),
    );
    parkingSpotsList = tempList;
    checkParkingSpot();
    print('-------------------Lista på parkeringsplatser-------------------');
    print(parkingSpotsList);
    print('Längden på listan: ${parkingSpotsList.length}');
  });
}
