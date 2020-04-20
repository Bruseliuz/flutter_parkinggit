import 'package:google_maps_flutter/google_maps_flutter.dart';


class testParking{
  String streetName;//Street name for UI
  String coordinates;

  testParking({this.streetName, this.coordinates});

}


void addParking(testParking parking){
  parkingSpots.add(parking);
}

final List<testParking> parkingSpots = [];

