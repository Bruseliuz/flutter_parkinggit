import 'dart:collection';
import 'package:quiver/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/map/map.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:math';

class ParkingAreasList {
  //denna som ska visas på kartan
  List<ParkingAreas> parkingAreas;

  ParkingAreasList() {
    updateParkingLots();
  }

  void updateParkingLots() {
    parkingAreas = parkingSpotsList;
  }
}

class ParkingAreas {
  String streetName;
  List<dynamic> coordinatesList;
  LatLng coordinates;
  String numberOfParkingSpots;
  String availableParkingSpots;
  String serviceDayInfo;
  bool favorite;

  ParkingAreas(
      {this.streetName,
      this.coordinatesList,
      this.coordinates,
      this.numberOfParkingSpots,
      this.availableParkingSpots,
      this.serviceDayInfo,
      this.favorite});

  factory ParkingAreas.fromJson(Map<String, dynamic> json) {
    return ParkingAreas(
        streetName: json['properties']['ADDRESS'],
        coordinatesList: json['geometry']['coordinates'],
        serviceDayInfo: json['properties']['OTHER_INFO']);
  }

  @override
  toString() =>
      'Streetname: $streetName Coordinateslist: $coordinatesList Coordinates: ${coordinates.toString()}';

  bool operator ==(o) =>
      o is ParkingAreas &&
      streetName == o.streetName &&
      coordinates == o.coordinates;

  int get hashCode => hash2(streetName.hashCode, coordinates.hashCode);
}

//Future<void> getData(LatLng location) async {
//  Response response = await get('https://openparking.stockholm.se/LTF-Tolken/v1/ptillaten/within?radius=100&lat=${location.latitude.toString()}&lng=${location.longitude.toString()}&outputFormat=json&apiKey=e734eaa7-d9b5-422a-9521-844554d9965b');
//  Map data = jsonDecode(response.body);
//  var dataList = data['features'] as List;
//  List list = dataList.map<TestParking>((json) => TestParking.fromJson(json)).toList();
//  print(list);
//  parseCoordinates(list);
//
//}

List<ParkingAreas> parkingSpotsList = [];

void parseParkingCoordinates(List<dynamic> coordinates) {
  parkingSpotsList.clear();
  coordinates.forEach((element) {
    print('${element.coordinatesList} HÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄR');
    List temp = element.coordinatesList[1];
    double longitude = temp[1];
    double latitude = temp[0];
    LatLng coordinatesParsed = new LatLng(longitude, latitude);
    parkingSpotsList.add(
      ParkingAreas(
          streetName: element.streetName,
          coordinates: coordinatesParsed,
          numberOfParkingSpots: element.coordinatesList.length.toString(),
          serviceDayInfo: element.serviceDayInfo,
          availableParkingSpots:
              getRandomAvailableParkingSpot(element.coordinatesList),
          favorite: false),
    );
    checkParkingSpot();
    print('-------------------Lista på parkeringsplatser-------------------');
    print(parkingSpotsList);
    print('Längden på listan: ${parkingSpotsList.length}');
  });
}

String getRandomAvailableParkingSpot(List<dynamic> coordinates) {
  var random = new Random();
  int randomNumber = random.nextInt(coordinates.length);
  return randomNumber.toString();
}

void checkParkingSpot() {
  parkingSpotsList =
      LinkedHashSet<ParkingAreas>.from(parkingSpotsList).toList();
  parkingSpotsList.removeWhere((item) => item.availableParkingSpots == '0');
}
