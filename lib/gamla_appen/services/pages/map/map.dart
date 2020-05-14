//import 'dart:html';
import 'dart:math';

import 'package:geojson/geojson.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyutil/google_map_polyutil.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/map/price_area.dart';
import 'package:path_provider/path_provider.dart';
import 'package:utm/utm.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/database.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/map/park_timer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/map/parking_area.dart';
import 'dart:async';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutterparkinggit/gamla_appen/models/user.dart';
import 'package:provider/provider.dart';
import 'package:proj4dart/proj4dart.dart';

ParkingArea selectedParking;
int distance;
String preference;
String parkingPrice;
User globalUser;
List<String> favoriteDocumentsId = [];
final CollectionReference parkCollection =
    Firestore.instance.collection("parkingPreference");
List<ParkingArea> parkingSpotsList = [];
Set<List<LatLng>> polygonPoints = {};
Map<List<LatLng>, String> polygonPointsExtended = {};
Set<LatLng> priceAreaPoints = {};
Set<Polygon> polygons = {};
Set<PriceArea> priceAreas = {};
Map<String, String> markerPrice = {};

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
  String searchAddress;

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
            return Scaffold(
              body: Stack(
                children: <Widget>[
                  GoogleMap(
                    polygons: polygons,
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
                  Positioned(
                    top: 30.0,
                    right: 15.0,
                    left: 15.0,
                    child: Container(
                      height: 50.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search for address',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                          suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                          onPressed: searchAndNavigate,
                          iconSize: 30.0
                          )
                        ),
                        onChanged: (val) {
                          setState(() {
                            searchAddress = val;
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: FloatingActionButton.extended(
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                icon: Icon(
                  Icons.local_parking,
                ),
                label: Text('Find Nearby\n   Parking'),
                backgroundColor: Color(0xff207FC5),
                onPressed: () async {
                  await getPriceAreas();
                  await getCurrentLocation();
//                    print(allMarkers.toString());
                  print(allMarkers);
                  allMarkers.forEach((marker) {
                    polygons.forEach((poly) async {
                      bool result = await GoogleMapPolyUtil.containsLocation(
                          point: marker.position, polygon: poly.points);
                      if (result == true) {
                        markerPrice.putIfAbsent(
                            marker.markerId.value, () => poly.polygonId.value);
                      }
                    });
                  });
                  if (allMarkers.isEmpty) {
                    showDialog(
                        context: context,
                        builder: (_) => _noParkingAlertDialogWidget());
                  }
                },
              ),
            );
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
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: FloatingActionButton.extended(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0))),
                elevation: 3.0,
                icon: Icon(
                  Icons.local_parking,
                ),
                label: Text('Find Nearby Parking'),
                backgroundColor: Color(0xff207FC5),
                onPressed: () async {
                  await getCurrentLocation();
//                  print(allMarkers.toString());
//                  getMarkers();
                  if (allMarkers.isEmpty) {
                    showDialog(
                        context: context,
                        builder: (_) => _noParkingAlertDialogWidget());
                  }
                  getPriceAreas();
                },
              ),
            );
          }
        });
  }

  searchAndNavigate() {
    Geolocator().placemarkFromAddress(searchAddress).then((result) async {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target:
          LatLng(result[0].position.latitude, result[0].position.longitude), zoom: 15.0)));
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

  Future getPriceAreas() async {
    var response = await get(
        'http://openstreetgs.stockholm.se/geoservice/api/e734eaa7-d9b5-422a-9521-844554d9965b/wfs/?version=1.0.0&request=GetFeature&typename=ltfr:LTFR_TAXA_VIEW&outputFormat=json');
    Map data = jsonDecode(response.body);
    var dataList = data['features'] as List;
    priceAreas =
        dataList.map<PriceArea>((json) => PriceArea.fromJson(json)).toSet();
    int counter = 0;
    priceAreas.forEach((area) {
//      print(area.coordinates);
      if (area.polygonType == 'Polygon') {
        area.coordinates.forEach((coordinates) {
          List<LatLng> tempList = [];
          coordinates.forEach((coordinate) {
            String c = coordinate.toString();
            String coords = c.replaceAll(RegExp(r"[[\]]"), '');
            List coordList = coords.split(',');
            double x = double.parse(coordList[0]);
            double y = double.parse(coordList[1]);
            tempList.add(parsePriceArea(x, y));
          });
          polygonPointsExtended.putIfAbsent(
              tempList, () => '${area.areaId.toString()}, ${area.priceGroup}');
//          polygonPoints.add(tempList);
//          createPolygon(tempList, area.priceGroup);
        });
      } else if (area.polygonType == 'MultiPolygon') {
        List<List<LatLng>> tempMultiList = [];
        area.multiCoordinates.forEach((coordinates) {
          coordinates.forEach((coordinate) {
            List<LatLng> tempList = [];
            coordinate.forEach((coord) {
//              print(coord);
              String c = coord.toString();
              String coords = c.replaceAll(RegExp(r"[[\]]"), '');
              List coordList = coords.split(',');
              double x = double.parse(coordList[0]);
              double y = double.parse(coordList[1]);
              if (!tempList.contains(parsePriceArea(x, y))) {
                tempList.add(parsePriceArea(x, y));
              }
            });
<<<<<<< HEAD
            polygonPointsExtended.putIfAbsent(tempList
                , () => '${area.priceGroupInfo}');
=======
            polygonPointsExtended.putIfAbsent(
                tempList,
                () =>
                    '${area.areaId.toString()}, ${area.priceGroup}, $counter');
>>>>>>> c34feba3c7d3e567ccb90700210e4b5fc8793344
            counter++;
//            polygonPoints.add(tempList);
          });
        });
      }
    });
    print(polygonPointsExtended.length);
    polygonPointsExtended.forEach((key, value) {
      createPolygon(key, value);
    });
//    int counter = 0;
//    polygonPoints.forEach((list) {
//      createPolygon(list, 'test$counter');
//      counter++;
//    });
  }

  Map<int, String> getPriceGroup(PriceArea priceArea) {
    switch (priceArea.priceGroup) {
      case 'Taxa 1':
        return [50, '50 kronor per timme, dygnet runt alla dagar.'].asMap();
      case 'Taxa 11':
        return [10, '10 kronor per timme, dygnet runt alla dagar.'].asMap();
      case 'Taxa 2':
        return [26, ''].asMap();
    }
  }

<<<<<<< HEAD

=======
>>>>>>> c34feba3c7d3e567ccb90700210e4b5fc8793344
  LatLng parsePriceArea(double x, double y) {
    var pointSrc = Point(x: x, y: y);
    var def =
        'PROJCS["SWEREF99 18 00",GEOGCS["SWEREF99",DATUM["SWEREF99",SPHEROID["GRS 1980",6378137,298.257222101,AUTHORITY["EPSG","7019"]],TOWGS84[0,0,0,0,0,0,0],AUTHORITY["EPSG","6619"]],PRIMEM["Greenwich",0,AUTHORITY["EPSG","8901"]],UNIT["degree",0.01745329251994328,AUTHORITY["EPSG","9122"]],AUTHORITY["EPSG","4619"]],UNIT["metre",1,AUTHORITY["EPSG","9001"]],PROJECTION["Transverse_Mercator"],PARAMETER["latitude_of_origin",0],PARAMETER["central_meridian",18],PARAMETER["scale_factor",1],PARAMETER["false_easting",150000],PARAMETER["false_northing",0],AUTHORITY["EPSG","3011"],AXIS["y",EAST],AXIS["x",NORTH]]';
    var projection = Projection.parse(def);
    var projSrc = Projection('EPSG:4326');
// Projection without name signature
    var pointForward = projection.transform(projSrc, pointSrc);

    return new LatLng(pointForward.y, pointForward.x);
  }

  void createPolygon(List list, String id) {
    setState(() {
      polygons.add(Polygon(
          polygonId: PolygonId(id),
          points: list,
          strokeColor: Colors.red,
          strokeWidth: 1,
          fillColor: Colors.lightBlueAccent.withOpacity(0.1)));
    });
  }

  void createMultiPolygon(List list, String id) {
    setState(() {
      polygons.add(Polygon(
          polygonId: PolygonId(id),
          points: list,
          strokeWidth: 1,
          strokeColor: Colors.red,
          fillColor: Colors.lightBlueAccent.withOpacity(0.3)));
    });
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
//    fakeMarkers();
  }

  Widget getFavoriteLabel(element) {
    if (element.favorite == false) {
      return Text('Add to favorites');
    } else {
      return Text('Remove from favorite');
    }
  }

  Future<void> getData(LatLng location) async {
//    print(distance);
    Response response = await get(
        'https://openparking.stockholm.se/LTF-Tolken/v1/${preference.toString()}/within?radius=$distance&lat=${location.latitude.toString()}&lng=${location.longitude.toString()}&outputFormat=json&apiKey=e734eaa7-d9b5-422a-9521-844554d9965b');
    try {
      Map data = jsonDecode(response.body);
      var dataList = data['features'] as List;
      List list = dataList
          .map<ParkingArea>((json) => ParkingArea.fromJson(json))
          .toList();
      setState(() {
        parseParkingCoordinates(list);
      });
      allMarkers.clear();
<<<<<<< HEAD
      await getMarkers();
    } catch  (e){
=======
      getMarkers();
    } catch (e) {
>>>>>>> c34feba3c7d3e567ccb90700210e4b5fc8793344
      //TODO - Felmeddelande vid fel i APIet
    }
  }

  Future fakeMarkers() async {
    LocationData location = await _locationTracker.getLocation();
<<<<<<< HEAD
    LatLng loc = new LatLng(
        (location.latitude + 0.01), (location.longitude + 0.01));
=======
    LatLng loc =
        new LatLng((location.latitude + 0.01), (location.longitude + 0.01));
>>>>>>> c34feba3c7d3e567ccb90700210e4b5fc8793344
    //  BitmapDescriptor bitmapDescriptor = await createCustomMarkerBitmap(
    //       '5');
    setState(() {
      allMarkers.add(Marker(
          markerId: MarkerId('test'),
//          icon: BitmapDescriptor.defaultMarker,
          icon: BitmapDescriptor.defaultMarker,
          visible: true,
          draggable: false,
          onTap: () {
            showDialog(context: context, builder: (_) => fakeParkingAlert(loc));
          },
          position: loc));
    });
  }

  Widget fakeParkingAlert(LatLng latLng) {
    return Container(
        child: AlertDialog(
            contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 10),
            elevation: 3.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            backgroundColor: Colors.white,
            title: Row(children: <Widget>[
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
                        selectedParking =
                            new ParkingArea(streetName: 'Randomvägen 1');
                        Navigator.pushNamed(context, '/timer');
                      },
                      icon: Icon(
                        Icons.timer,
                        color: Color(0xff207FC5),
                      ),
                      label: Text(
                        'Start parking',
                        style: TextStyle(
                          color: Color(0xff207FC5),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ])));
  }

  Future getMarkers() async {
    parkingSpotsList.forEach((element) async {
<<<<<<< HEAD
//      BitmapDescriptor bitmapDescriptor = await createCustomMarkerBitmap(
//          element.availableParkingSpots);
=======
      BitmapDescriptor bitmapDescriptor =
          await createCustomMarkerBitmap(element.availableParkingSpots);
>>>>>>> c34feba3c7d3e567ccb90700210e4b5fc8793344
      setState(() {
        allMarkers.add(Marker(
            markerId: MarkerId(element.streetName),
//            icon: bitmapDescriptor,
            icon: BitmapDescriptor.defaultMarker,
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
    final Size size = Size(170, 170);
    final PictureRecorder recorder = new PictureRecorder();
    final Canvas c = new Canvas(recorder);
    final double imageOffset = 18.0;
    final Paint paint = Paint()..color = Colors.transparent;
    final Radius radius = Radius.circular(size.width / 2);

    c.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
              0.0, 0.0, size.width.toDouble(), size.height.toDouble()),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        paint);

<<<<<<< HEAD

=======
>>>>>>> c34feba3c7d3e567ccb90700210e4b5fc8793344
    TextSpan span = new TextSpan(
      style: new TextStyle(
        backgroundColor: Colors.white,
        color: Colors.black,
        fontSize: 33.0,
        fontWeight: FontWeight.bold,
      ),
      text: title,
    );

    TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    Rect oval = Rect.fromLTWH(imageOffset, imageOffset,
        size.width - (imageOffset * 2), size.height - (imageOffset * 2));

    tp.layout();
    tp.paint(
        c,
        Offset((size.width * 0.5) - tp.width * 0.5,
            (size.height * .5) - tp.height * 0.5));

    c.clipPath(Path()..addOval(oval));

    ui.Image image = await getImageFromPath('locmarker35.png');
    paintImage(canvas: c, image: image, rect: oval, fit: BoxFit.fitWidth);

    final ui.Image markerAsImage = await recorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());

    // Convert image to bytes
    final ByteData byteData =
        await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }

  Future<ui.Image> getImageFromPath(String imagePath) async {
    File imageFile = await getImageFileFromAssets(imagePath);

    Uint8List imageBytes = imageFile.readAsBytesSync();

    final Completer<ui.Image> completer = new Completer();

    ui.decodeImageFromList(imageBytes, (ui.Image img) {
      return completer.complete(img);
    });

    return completer.future;
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
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
  @override
  Widget build(BuildContext context) {
    return _parkingDialogWidget(widget.parkingArea);
  }

  Widget _parkingDialogWidget(element) {
<<<<<<< HEAD
    String priceInfo = markerPrice[element.streetName];
    List<String> infoList = priceInfo.split(', ');
    String price = infoList[0];
=======
    checkLocationPrice(element.coordinates);
>>>>>>> c34feba3c7d3e567ccb90700210e4b5fc8793344
    IconData favoriteIconData = Icons.favorite;
    String favoriteString = 'Add to favorites';
    if (element.favorite == false) {
      favoriteString = 'Add to favorites';
      favoriteIconData = Icons.favorite_border;
    } else {
      favoriteString = 'Remove';
      favoriteIconData = Icons.favorite;
    }
    return Container(
      child: AlertDialog(
        contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 10),
        elevation: 3.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                    icon: Icon(Icons.exit_to_app),
                    label: Text(''),
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0)))
          ],
        ),
        content: Container(
          height: 150,
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
                    price,
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
                  icon: Icon(
                    favoriteIconData,
                    color: Color(0xff207FC5),
                  ),
                  label: Text(
                    favoriteString,
                    style: TextStyle(color: Color(0xff207FC5)),
                  ),
                  onPressed: () async {
                    if (element.favorite == false) {
                      String latLon = '${element.coordinates.latitude
                          .toString()}, '
                          '${element.coordinates.longitude}';
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
//                      print(element.favorite);
                      if (element.favorite == false) {
                        favoriteIconData = Icons.favorite_border;
                        favoriteString = 'Add to favorites';
                      } else {
                        favoriteIconData = Icons.favorite;
                        favoriteString = 'Remove';
                      }
                    });
//                    print('Lägg till i favorites');
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
                        List list = price.split(' ');
                        selectedParking = element;
                        parkingPrice = list[0];
                        Navigator.pushNamed(context, '/timer');
                      },
                      icon: Icon(
                        Icons.timer,
                        color: Color(0xff207FC5),
                      ),
                      label: Text(
                        'Start parking',
                        style: TextStyle(
                          color: Color(0xff207FC5),
                          fontSize: 12,
                        ),
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

<<<<<<< HEAD

=======
  void checkLocationPrice(LatLng latlng) {
    polygons.forEach((poly) {
      GoogleMapPolyUtil.containsLocation(point: latlng, polygon: poly.points)
          .then((result) => print(result));
    });
  }
>>>>>>> c34feba3c7d3e567ccb90700210e4b5fc8793344
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
  });
}
