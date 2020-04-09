import 'package:flutter/material.dart';
import 'package:geolocation/geolocation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ParkingLots {
  String id;
 // LatLng location;
  bool available;

  ParkingLots ({
    this.id, /*this.location,*/ this.available
  });

}

class ParkingList {
  List<ParkingLots> parkingLots;

  ParkingList (){
    updateParkingLots();
  }

  void updateParkingLots() {
    parkingLots = simParkingLots;
  }

  final simParkingLots = [
    new ParkingLots(
        id: 'test1234',
        //location:
        available: false,
    )

  ];

}
