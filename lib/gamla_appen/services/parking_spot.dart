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

void getData() async {
  Response response = await get('https://openparking.stockholm.se/LTF-Tolken/v1/servicedagar/weekday/måndag?outputFormat=json&apiKey=e734eaa7-d9b5-422a-9521-844554d9965b');
  Map data = jsonDecode(response.body);

  print(data);
  print('HÄÄÄÄÄÄÄÄÄÄÄRRRRRR');
  //TODO - ta in data och gör om till en List
}


final List<ParkingSpot> parkingSpots = [
  ParkingSpot(
    streetName: "Hemma hos martin & bea",
    price: "2 650 000",
    parkingSpots: "10",
    availableParkingSpots: "5",
    locatinCoords: LatLng(59.338871, 17.930309)
  )

  ];

