import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

class ParkingSpot{
  String streetName;//Street name for UI
  String price;//Price per hour
  String url;//Parking URL for API endpoint
  LatLng locatinCoords; //Location
  String parkingSpots;
  String availableParkingSpots;

  ParkingSpot({this.streetName, this.price, this.locatinCoords, this.parkingSpots, this.availableParkingSpots});

}



final List<ParkingSpot> parkingSpots = [
  ParkingSpot(
    streetName: "Bårdgränd 16",
    price: "21",
    parkingSpots: "10",
    availableParkingSpots: "5",
    locatinCoords: LatLng(59.338871, 17.930309)
  )

  ];

