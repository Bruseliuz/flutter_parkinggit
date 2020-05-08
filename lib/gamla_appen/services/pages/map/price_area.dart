import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/map/map.dart';

class PriceArea {
  List<dynamic> coordinates;
  String priceGroup;
  String priceGroupInfo;

  PriceArea({this.coordinates, this.priceGroup, this.priceGroupInfo});


  factory PriceArea.fromJson(Map<String, dynamic> json) {
    return PriceArea(
      coordinates: json['geometry']['coordinates'],
      priceGroup: json['properties']['DISTRICT_NAME'],
      priceGroupInfo: json['properties']['TAXA']
    );
  }
}