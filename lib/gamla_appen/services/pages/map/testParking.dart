import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'dart:convert';


class testParking{
  String streetName;//Street name for UI
  List coordinates;

  testParking({this.streetName, this.coordinates});


  factory testParking.fromJson(Map<String, dynamic> json){
    return testParking(
      streetName: json['features'][0]['properties']['ADDRESS'],
      coordinates: json['features'][0]['geometry']['coordinates']
    );
  }
}


void addParking(testParking parking){
  parkingSpots.add(parking);
}

final List<testParking> parkingSpots = [];

void getData(LatLng location) async {
  Response response = await get('https://openparking.stockholm.se/LTF-Tolken/v1/ptillaten/within?radius=100&lat=${location.latitude.toString()}&lng=${location.longitude.toString()}&outputFormat=json&apiKey=e734eaa7-d9b5-422a-9521-844554d9965b');
  Map data = jsonDecode(response.body);
  var dataList = data['features'] as List;
  List list = dataList.map<testParking>((json) => testParking.fromJson(json)).toList();
  print(list);
  print(data['features'][0]['properties']['ADDRESS']); //TODO - Göra om varje plats till en "location"
  print(data['features'][0]['geometry']['coordinates']);

}

