import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiver/core.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutterparkinggit/services/pages/map/map.dart';
import 'dart:math';

class ParkingAreasList {
  List<ParkingArea> parkingAreas;

  ParkingAreasList() {
    updateParkingLots();
  }

  void updateParkingLots() {
    parkingAreas = parkingSpotsList;
  }
}

class ParkingArea {
  String streetName;
  List<dynamic> coordinatesList;
  LatLng coordinates;
  String numberOfParkingSpots;
  String availableParkingSpots;
  String serviceDayInfo;
  bool favorite;
  String price;

  ParkingArea(
      {this.streetName,
      this.coordinatesList,
      this.coordinates,
      this.numberOfParkingSpots,
      this.availableParkingSpots,
      this.serviceDayInfo,
      this.favorite,
      this.price});

  factory ParkingArea.fromJson(Map<String, dynamic> json) {
    return ParkingArea(
        streetName: json['properties']['ADDRESS'],
        coordinatesList: json['geometry']['coordinates'],
        serviceDayInfo: json['properties']['OTHER_INFO']);
  }

  factory ParkingArea.fromSnapshot(DocumentSnapshot snapshot) {
    return ParkingArea(
      streetName: snapshot['streetName'],
      coordinates: snapshot['coordinates']
    );
  }

  @override
  toString() =>
      'Streetname: $streetName Coordinateslist: $coordinatesList Coordinates: ${coordinates.toString()} No: ${numberOfParkingSpots}';

  bool operator ==(o) =>
      o is ParkingArea &&
      streetName == o.streetName &&
      coordinates == o.coordinates;

  int get hashCode => hash2(streetName.hashCode, coordinates.hashCode);
}

String getRandomAvailableParkingSpot(List<dynamic> coordinates) {
  var random = new Random();
  int randomNumber = random.nextInt(coordinates.length);
  return randomNumber.toString();
}

void checkParkingSpot() {
  parkingSpotsList =
      LinkedHashSet<ParkingArea>.from(parkingSpotsList).toList();
  parkingSpotsList.removeWhere((item) => item.availableParkingSpots == '0');
}
