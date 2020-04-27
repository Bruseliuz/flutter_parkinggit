import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutterparkinggit/gamla_appen/services/pages/map/map.dart' as karta;

class ParkingAreas {
  String id;
  int totalNumberOfParkingLots;
  int vacantParkingLots;
  ParkingLotsList connectedParkingLots; //lista som består av parkinglots
  LatLng locationCoords;
  int price;

  ParkingAreas(
      {this.id,
      this.locationCoords,
      this.totalNumberOfParkingLots,
      this.vacantParkingLots,
      this.connectedParkingLots,
      this.price});
}

class ParkingLot {
  //för att kunna veta hur många av parkeringareas lots som är tillgängliga
  LatLng locationCoords;
  bool occupied;

  ParkingLot({this.locationCoords, this.occupied});
}

class ParkingLotsList {
  List<ParkingLot> parkingLots;

  ParkingLotsList() {
    addParkingLot();
  }

  addParkingLot() {
    parkingLots = simParkingLots;
  }

  final simParkingLots = [
    new ParkingLot(locationCoords: LatLng(59.338871, 17.930309), occupied: true),
    new ParkingLot(locationCoords: LatLng(59.338871, 17.930344), occupied: false),
    new ParkingLot(locationCoords: LatLng(59.338871, 17.930344), occupied: true)
  ];
}


class ParkingAreasList {
  //denna som ska visas på kartan
  List<ParkingAreas> parkingAreas;

  ParkingAreasList() {
    updateParkingLots();
  }

  void updateParkingLots() {
    parkingAreas = simParkingAreas;
  }

  final simParkingAreas = [
    new ParkingAreas(
        id: 'test1234',
        totalNumberOfParkingLots: 3,
        vacantParkingLots: 1,
        connectedParkingLots: new ParkingLotsList(),
        locationCoords: LatLng(59.338871, 17.930309),
        price: 10)
  ];
}



class testParking{
  String streetName;
  List<dynamic> coordinatesList;
  LatLng coordinates;


  testParking({this.streetName, this.coordinatesList,this.coordinates});


  factory testParking.fromJson(Map<String,dynamic> json){
    return testParking(
        streetName: json['properties']['ADDRESS'],
        coordinatesList: json['geometry']['coordinates']
    );
  }




  @override toString() => 'Streetname: $streetName Coordinateslist: $coordinatesList Coordinates: ${coordinates.toString()}';
}


void getData(LatLng location) async {
  Response response = await get('https://openparking.stockholm.se/LTF-Tolken/v1/ptillaten/within?radius=100&lat=${location.latitude.toString()}&lng=${location.longitude.toString()}&outputFormat=json&apiKey=e734eaa7-d9b5-422a-9521-844554d9965b');
  Map data = jsonDecode(response.body);
  var dataList = data['features'] as List;
  List list = dataList.map<testParking>((json) => testParking.fromJson(json)).toList();
  print(list);
  parseCoordinates(list);
 // parseCoordinates(list);

}

void parseCoordinates(List<dynamic> coordinates){
  parkingSpotsList.clear();
  coordinates.forEach((element){
    String coordinatesCleaned = coordinates.toString().trim().replaceAll('[', '').replaceAll(']', '');
    print('-------------------Coordinater utan krimskrams-------------------');
    print(coordinatesCleaned);
    print('-------------------Coordinater utan krimskrams-------------------');
    List temp = coordinatesCleaned.split(',');
    print('-------------------Coordinates-------------------');
    print(temp);
    print('Longitude: ${temp[1]}');//TODO - Loopa för att kika på varje idividuell "sak" i listan
    print('Latitude: ${temp[2]}');
    double longitude = double.parse(temp[1]);
    double latitude = double.parse(temp[2]);
    LatLng coordinatesParsed = new LatLng(longitude, latitude);
    parkingSpotsList.add(testParking(
      streetName: element.streetName,
      coordinates: coordinatesParsed,
      coordinatesList: null
    ));
    print('-------------------Lista på parkeringsplatser-------------------');
    print(parkingSpotsList);
    print('Längden på listan: ${parkingSpotsList.length}');

  });
      }




void createNewParking(testParking newParking) {
  parkingSpotsList.add(newParking);
  print(parkingSpotsList);
}

List <testParking> parkingSpotsList = [];

