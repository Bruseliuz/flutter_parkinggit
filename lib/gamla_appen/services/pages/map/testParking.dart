import 'dart:collection';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'dart:convert';

class ParkingSpots{
  bool occupied;
  String name;

  ParkingSpots({this.occupied});

}

class ParkingArea{
  LatLng latLng; //Bara ta en latlog per "parking area"??
  String price; //String pga Taxa områden
  String streetName;
  List<ParkingSpots> parkingSpotsInArea;

  ParkingArea({this.latLng,this.price, this.streetName, this.parkingSpotsInArea});

  factory ParkingArea.fromJson(Map<dynamic, dynamic> json){
    return ParkingArea(
      latLng: json['coordinates'],
      price: json['VF_PLATS_TYP'],
      streetName: json['Adress']);
  }

}


void getData(LatLng location) async {
  print('1 check'); //
  Response response = await get('https://openparking.stockholm.se/LTF-Tolken/v1/ptillaten/within?radius=100&lat=${location.latitude.toString()}&lng=${location.longitude.toString()}&outputFormat=json&apiKey=e734eaa7-d9b5-422a-9521-844554d9965b');
  Map data = jsonDecode(response.body);
  var rest = data['features'] as List;
  print(rest);
  print('list size: ${rest.length}');
 // print(data);//TODO - Göra om varje plats till en "location"
  print('2 check');

}