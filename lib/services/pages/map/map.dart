import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutterparkinggit/services/pages/map/contains_location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'dart:typed_data';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterparkinggit/services/pages/map/price_area.dart';
import 'package:location/location.dart' as Location;
import 'package:path_provider/path_provider.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutterparkinggit/services/pages/database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutterparkinggit/services/pages/map/parking_area.dart';
import 'dart:async';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutterparkinggit/models/user.dart';
import 'package:provider/provider.dart';
import 'package:proj4dart/proj4dart.dart';


ParkingArea selectedParking;
int distance;
String preference;
String parkingPrice;
User globalUser;
UserData userData;
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

  @override
  _ParkingMapState createState() => _ParkingMapState();
}

class _ParkingMapState extends State<ParkingMap> {
  double screenWidth;
  double screenHeight;
  double middleX;
  double middleY;
  ScreenCoordinate screenCoordinate;
  final _textController = TextEditingController();
  var textFocusNode = new FocusNode();
  List<DocumentSnapshot> favoriteDocuments = [];
  Location.Location _locationTracker = Location.Location();
  Set<Marker> allMarkers = {};
  Completer<GoogleMapController> _controller = Completer();
  static LatLng _center = LatLng(59.334591, 18.063240);
  LatLng _lastCameraPosition;
  GoogleMapController mapController;
  String searchAddress = '';
  final Set<Polyline> polyline = {};
  List<LatLng> routeCoords;
  GoogleMapPolyline googleMapPolyline =
  new GoogleMapPolyline(apiKey: "AIzaSyDCKuA95vaqlu92GXWkgpc2vSrgYmCVabI");
  GoogleMapsPlaces _places =
  GoogleMapsPlaces(apiKey: "AIzaSyAMeqs9sFXRF0Wxi8t1c8hRMMDh20rx7rY");
  bool searchInitiated = false;

  getPoints(ParkingArea p) async {
    setState(() {
      polyline.clear();
    });
    var currentLocation = await Geolocator().getCurrentPosition();
    routeCoords = await googleMapPolyline.getCoordinatesWithLocation(
        origin: LatLng(currentLocation.latitude, currentLocation.longitude),
        destination: p.coordinates,
        mode: RouteMode.driving);
    setState(() {
      polyline.add(Polyline(
          polylineId: PolylineId('route1'),
          visible: true,
          points: routeCoords,
          width: 4,
          color: Color(0xff207FC5),
          startCap: Cap.roundCap,
          endCap: Cap.buttCap));
    });
  }

  @override
  void initState() {
    if (polygons.isEmpty) {
      getPriceAreas();
    }
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
            userData = snapshot.data;
            setPreference(userData);
          } else {
            distance = 100;
            preference = 'ptillaten';
          }

          return Scaffold(
            body: Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: () =>
                      FocusScope.of(context).requestFocus(new FocusNode()),
                  child: GoogleMap(
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    onMapCreated: _onMapCreated,
                      markers: allMarkers,
                      polylines: polyline,
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 12.0,
                    ),
                  ),
                ),
                Positioned(
                  top: 15.0,
                  right: 15.0,
                  left: 15.0,
                  child: Column(children: <Widget>[
                    Row(children: <Widget>[
                      Expanded(
                        child: TextField(
                          textCapitalization: TextCapitalization.sentences,
                          controller: _textController,
                          focusNode: textFocusNode,
                          autofocus: false,
                          onTap: () async {
                            setState(() {
                              searchInitiated = true;
                            });
                                  },
                                  cursorColor: Color(0xff207FC5),
                                  textInputAction: TextInputAction.search,
                                  onEditingComplete: () {
                                    if (searchAddress != '') {
                                      searchAndNavigate();
                                    } else {
                                      showCenterShortToast();
                                      setState(() {
                                        searchInitiated = false;
                                      });
                                    }
                                    FocusScope.of(context).requestFocus(
                                        new FocusNode());
                                  },
                                  decoration: InputDecoration(
                                      hintText: 'Search for address',
                                      hintStyle: TextStyle(
                                          color: Color(0xff207FC5)),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff207FC5)),
                                          borderRadius: BorderRadius.circular(
                                              15)),
                                      contentPadding:
                                      EdgeInsets.only(
                                          left: 15.0, top: 15.0, right: 15.0),
                                      fillColor: Colors.white,
                                      filled: true,
                                      suffixIcon: searchAddress == ''
                                          ? null
                                          : IconButton(
                                          icon: Icon(Icons.clear),
                                          color: Color(0xff808080),
                                          onPressed: () {
                                            _textController.clear();
                                            searchAddress = '';
                                          },
                                          iconSize: 30.0)),
                                  onChanged: (val) {
                                    setState(() {
                                      searchAddress = val;
                                    });
                                  },
                                ),
                              ),
                              IconButton(
                                  padding: EdgeInsets.fromLTRB(10, 10, 5, 0),
                                  icon: Icon(Icons.search,
                                    size: 40,),
                                  splashColor: Colors.white,
                                  color: Color(0xff207FC5),
                                  onPressed: () {
                                    if (searchAddress != '') {
                                      FocusScope.of(context).requestFocus(
                                          new FocusNode());
                                      setState(() {
                                        polyline.clear();
                                      });
                                      searchAndNavigate();
                                    } else {
                                      showCenterShortToast();
                                    }
                                  },
                                  iconSize: 30.0)
                            ]
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ]
                  ),
                ),

              ],
            ),
            floatingActionButtonLocation:
            FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 500),
                      opacity: searchInitiated ? 0.0 : 1.0,
                      child: FloatingActionButton(
                        child: Icon(Icons.my_location),
                        backgroundColor: Color(0xff207FC5),
                        onPressed: searchInitiated ? null : () async {
                          setState(() {
                            polyline.clear();
                            _textController.clear();
                            searchAddress = '';
                          });
                          await getCurrentLocation();
                        },
                      ),
                    ),
                  ],
                ),
                FloatingActionButton.extended(
                  heroTag: 'area',
                  label: Text('Find Parking\nIn This Area',
                      textAlign: TextAlign.center),
                  backgroundColor: Color(0xff207FC5),
                  elevation: 3.0,
                  icon: Icon(Icons.aspect_ratio),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  onPressed: () async {
                    final GoogleMapController controller = await _controller
                        .future;
                    setState(() {
                      allMarkers.clear();
                      screenWidth = MediaQuery
                          .of(context)
                          .size
                          .width;
                      screenHeight = MediaQuery
                          .of(context)
                          .size
                          .height;
                      middleX = screenWidth / 2;
                      middleY = screenHeight / 2;
                      screenCoordinate = ScreenCoordinate(
                          x: middleX.round(), y: middleY.round());
                    });
                    _lastCameraPosition =
                    await controller.getLatLng(screenCoordinate);
                    await getData(_lastCameraPosition);
                  },
                ),
              ],
            )
          );
        });
  }

  void showCenterShortToast() {
    Fluttertoast.showToast(
        backgroundColor: Color(0xff207FC5),
        msg: "You have to enter\n     an address!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2);
  }

  Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
    if (p != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;

      scaffold.showSnackBar(
        SnackBar(content: Text("${p.description} - $lat/$lng")),
      );
    }
  }

  searchAndNavigate() {
    Geolocator().placemarkFromAddress(searchAddress).then((result) async {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:
          LatLng(result[0].position.latitude, result[0].position.longitude),
          zoom: 15.0)));
      await getData(
          LatLng(result[0].position.latitude, result[0].position.longitude));
      setState(() {
        searchInitiated = false;
      });
    });
  }

  Widget _noParkingAlertDialogWidget() {
    return AlertDialog(
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white70,
      title: Text(
        'Parking is either not available in your area or to the price you have chosen.',
        style: TextStyle(color: Color(0xff207FC5), fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
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
              tempList, () => '${area.priceGroupInfo}, $counter');
          counter++;
        });
      } else if (area.polygonType == 'MultiPolygon') {
        area.multiCoordinates.forEach((coordinates) {
          coordinates.forEach((coordinate) {
            List<LatLng> tempList = [];
            coordinate.forEach((coord) {
              String c = coord.toString();
              String coords = c.replaceAll(RegExp(r"[[\]]"), '');
              List coordList = coords.split(',');
              double x = double.parse(coordList[0]);
              double y = double.parse(coordList[1]);
              if (!tempList.contains(parsePriceArea(x, y))) {
                tempList.add(parsePriceArea(x, y));
              }
            });
            polygonPointsExtended.putIfAbsent(
                tempList, () => '${area.priceGroupInfo}, $counter');
            counter++;
          });
        });
      }
    });
    polygonPointsExtended.forEach((key, value) {
      createPolygon(key, value);
    });
  }

  List parsePriceCoordinates(String coord) {
    String c = coord.toString();
    String coords = c.replaceAll(RegExp(r"[[\]]"), '');
    List coordList = coords.split(',');
    double x = double.parse(coordList[0]);
    double y = double.parse(coordList[1]);
    List list = new List();
    list.add(x);
    list.add(y);
    return list;
  }

  LatLng parsePriceArea(double x, double y) {
    var pointSrc = Point(x: x, y: y);
    var def =
        'PROJCS["SWEREF99 18 00",GEOGCS["SWEREF99",DATUM["SWEREF99",SPHEROID["GRS 1980",6378137,298.257222101,AUTHORITY["EPSG","7019"]],TOWGS84[0,0,0,0,0,0,0],AUTHORITY["EPSG","6619"]],PRIMEM["Greenwich",0,AUTHORITY["EPSG","8901"]],UNIT["degree",0.01745329251994328,AUTHORITY["EPSG","9122"]],AUTHORITY["EPSG","4619"]],UNIT["metre",1,AUTHORITY["EPSG","9001"]],PROJECTION["Transverse_Mercator"],PARAMETER["latitude_of_origin",0],PARAMETER["central_meridian",18],PARAMETER["scale_factor",1],PARAMETER["false_easting",150000],PARAMETER["false_northing",0],AUTHORITY["EPSG","3011"],AXIS["y",EAST],AXIS["x",NORTH]]';
    var projection = Projection.parse(def);
    var projSrc = Projection('EPSG:4326');

    var pointForward = projection.transform(projSrc, pointSrc);

    return new LatLng(pointForward.y, pointForward.x);
  }

  void createPolygon(List list, String id) {
    setState(() {
      polygons.add(Polygon(
          polygonId: PolygonId(id),
          visible: true,
          points: list,
          strokeColor: Colors.red,
          strokeWidth: 1,
          fillColor: Colors.lightBlueAccent.withOpacity(0.1)));
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
    mapController = controller;
  }

  Future getCurrentLocation() async {
    var location = await _locationTracker.getLocation();
    await setLocation(location);
  }

  Future setLocation(Location.LocationData location) async {
    final GoogleMapController controller = await _controller.future;
    LatLng newLocation = LatLng(location.latitude, location.longitude);
    _lastCameraPosition = newLocation;
    CameraPosition cameraPosition = CameraPosition(
      zoom: 15.0,
      target: newLocation,
    );

    await controller
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    await getData(newLocation);
  }

  Widget getFavoriteLabel(element) {
    if (element.favorite == false) {
      return Text('Add to favorites');
    } else {
      return Text('Remove from favorite');
    }
  }

  Future getData(LatLng location) async {
    parkingSpotsList.clear();
    Response response = await get(
        'https://openparking.stockholm.se/LTF-Tolken/v1/${preference.toString()}/within?radius=$distance&lat=${location.latitude.toString()}&lng=${location.longitude.toString()}&outputFormat=json&apiKey=e734eaa7-d9b5-422a-9521-844554d9965b');
    print('https://openparking.stockholm.se/LTF-Tolken/v1/${preference
        .toString()}/within?radius=$distance&lat=${location.latitude
        .toString()}&lng=${location.longitude
        .toString()}&outputFormat=json&apiKey=e734eaa7-d9b5-422a-9521-844554d9965b');
    try {
      if (response != null) {
        Map data = jsonDecode(response.body);
        if (data['features'] != null) {
          var dataList = data['features'] as List;

          List list = dataList
              .map<ParkingArea>((json) => ParkingArea.fromJson(json))
              .toList();
          setState(() {
            parseParkingCoordinates(list);
          });
          allMarkers.clear();

          bool markers = await getMarkers();
          if (markers == false || markers == null) {
            showDialog(
                context: context,
                builder: (_) => _noParkingAlertDialogWidget());
          }
        }

      }
    } catch (e) {
      showDialog(
          context: context, builder: (_) => _noParkingAlertDialogWidget());
    }
  }

  Future fakeMarkers() async {
    Location.LocationData location = await _locationTracker.getLocation();

    LatLng loc =
    new LatLng((location.latitude + 0.01), (location.longitude + 0.01));
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

  Future<Marker> createMarker(ParkingArea area, int id) async {
    double price;
    Marker newMarker;
    bool visibility = true;
    BitmapDescriptor bitmapDescriptor = await createCustomMarkerBitmap(area);
    for (var polygon in polygons) {
      bool result = checkLocationInPoly(
          area.coordinates.latitude, area.coordinates.longitude, polygon);
      if (result == true) {
        List priceInfo = polygon.polygonId.value.split(' ');
        String priceInt = priceInfo[0];
        price = double.parse(priceInt);
        if (price > userData.maxPrice) {
          visibility = false;
        }
        newMarker = Marker(
            markerId: MarkerId('${area.streetName}, $price, $id'),
            icon: bitmapDescriptor,
            visible: visibility,
            draggable: false,
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) => ParkingDialogWidget(parkingArea: area));
              getPoints(area);
            },
            position: area.coordinates);
        List valueList = newMarker.markerId.value.split(', ');
        String markerValue = valueList[0];
        markerPrice.putIfAbsent(markerValue, () => polygon.polygonId.value);
        break;
      }
    }
    return newMarker;
  }

  Future<bool> getMarkers() async {
    int counter = 0;
    Set<Marker> list = {};
    bool markers = false;
    if (parkingSpotsList.isNotEmpty || parkingSpotsList != null) {
      for (var element in parkingSpotsList) {
        Marker marker = await createMarker(element, counter);
        list.add(marker);
        counter++;
      }
      if (list.elementAt(0) != null) {
        setState(() {
          allMarkers = list;
        });
      }

      for (var element in allMarkers) {
        if (element.visible == true) {
          markers = true;
          break;
        } else {
          markers = false;
        }
      }
    }
    print(markers);
    return markers;

//    setMarkersPrice();
  }

  Future<BitmapDescriptor> createCustomMarkerBitmap(ParkingArea element) async {
    String price = '';
    for (var polygon in polygons) {
      if (price == '') {
        if (checkLocationInPoly(element.coordinates.latitude,
            element.coordinates.longitude, polygon)) {
          price = polygon.polygonId.value;
        }
      }
    }
    List stringList = price.split(' ');
    price = stringList[0];
    String imagePath = '';
    switch (price) {
      case '50':
        imagePath = 'locmarker778.png';
        break;
      case '26':
      case '15':
        imagePath = 'locmarker776.png';
        break;
      case '10':
      case '5':
        imagePath = 'locmarker775.png';
        break;
      default:
        imagePath = 'locmarker777.png';
    }

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

    TextSpan span = new TextSpan(
      style: new TextStyle(
        backgroundColor: Colors.transparent,
        color: Colors.black,
        fontSize: 34.0,
        fontWeight: FontWeight.bold,
      ),
      text: element.availableParkingSpots,
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

    ui.Image image = await getImageFromPath(imagePath);
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
    String price = 'Ingen prisinfo';
    String priceInfo = markerPrice[element.streetName];
    if (priceInfo != null) {
      List<String> infoList = priceInfo.split(' ');
      price = '${infoList[0]} ${infoList[1]}';
    }

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                    icon: Icon(Icons.exit_to_app,
                      color: Color(0xff207FC5),),
                    label: Text(''),
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0)))
          ],
        ),
        content: Container(
          height: 130,
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
                      overflow: TextOverflow.clip,
                      style: TextStyle(color: Color(0xff207FC5)),
                      textAlign: TextAlign.left,
                    ),
                  )
                ],
              ),
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
                      String latLon =
                          '${element.coordinates.latitude.toString()}, '
                          '${element.coordinates.longitude}';
                      await DatabaseService(uid: globalUser.uid)
                          .updateUserFavorites(
                          price,
                          latLon,
                          element.streetName,
                          element.serviceDayInfo,
                          element.favorite,
                          element.numberOfParkingSpots,
                          element.availableParkingSpots);
                    } else if (element.favorite == true) {
                      await parkCollection
                          .document(globalUser.uid)
                          .collection('favoriteParkings')
                          .document(element.streetName)
                          .delete();
                    }
                    setState(() {
                      element.favorite == true
                          ? element.favorite = false
                          : element.favorite = true;
                      if (element.favorite == false) {
                        favoriteIconData = Icons.favorite_border;
                        favoriteString = 'Add to favorites';
                      } else {
                        favoriteIconData = Icons.favorite;
                        favoriteString = 'Remove';
                      }
                    });
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
