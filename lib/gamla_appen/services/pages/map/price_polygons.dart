import 'package:flutter/services.dart' show rootBundle;
import 'package:geojson/geojson.dart';


/// Data for the Flutter map polylines layer

List getLatLngForPoints(GeoJsonLine line){
  return line.geoSerie.toLatLng();
}