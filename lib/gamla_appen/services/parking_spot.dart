import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'dart:convert';

class ParkingSpot{
  String streetName;//Street name for UI
  LatLng coordinates;
  String price;
  String parkingSpots;

  ParkingSpot({this.streetName, this.coordinates, this.price, this.parkingSpots});



}



final List<ParkingSpot> parkingSpots = [
  ParkingSpot(
    streetName: "Bårdgränd 16",
    coordinates: LatLng(59.338871, 17.930309),
    price: '21',
    parkingSpots: '10'
  )

  ];

