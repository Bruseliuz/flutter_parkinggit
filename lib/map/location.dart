import 'package:flutter/material.dart';
import 'package:geolocation/geolocation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ParkingAreas {
  String id;
  int totalNumberOfParkingLots;
  int vacantParkingLots;
  ParkingLotsList connectedParkingLots; //lista som består av parkinglots
  VacantParkingLotsList vacantParkingLotsList;
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
