import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:math';


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



class TestParking{
  String streetName;
  List<dynamic> coordinatesList;
  LatLng coordinates;
  String numberOfParkingSpots;
  String availableParkingSpots;


  TestParking({this.streetName, this.coordinatesList,this.coordinates, this.numberOfParkingSpots, this.availableParkingSpots});


  factory TestParking.fromJson(Map<String,dynamic> json){
    return TestParking(
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
  List list = dataList.map<TestParking>((json) => TestParking.fromJson(json)).toList();
  print(list);
  parseCoordinates(list);

}

void parseCoordinates(List<dynamic> coordinates){
  parkingSpotsList.clear();
  coordinates.forEach((element){
    print(element.coordinatesList[1]);
    List temp = element.coordinatesList[1];
    double longitude = temp[1];
    double latitude = temp[0];
    LatLng coordinatesParsed = new LatLng(longitude, latitude);
    parkingSpotsList.add(TestParking(
      streetName: element.streetName,
      coordinates: coordinatesParsed,
      numberOfParkingSpots: element.coordinatesList.length.toString(),
      availableParkingSpots: getRandomAvailableParkingSpot(coordinates)
    ));
    print('-------------------Lista på parkeringsplatser-------------------');
    print(parkingSpotsList);
    print('Längden på listan: ${parkingSpotsList.length}');
  });
}

List <TestParking> parkingSpotsList = [];


String getRandomAvailableParkingSpot(List<dynamic> coordinates){
  var random = new Random();
  int randomNumber = random.nextInt(coordinates.length);
  return randomNumber.toString();
}