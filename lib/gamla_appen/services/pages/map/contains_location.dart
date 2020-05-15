import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';
import 'package:google_maps_utils/google_maps_utils.dart';

bool checkLocationInPoly(double lat, double long, Polygon polygon) {
  List list = polygon.points;
  List<Point> pointList = [];
  for (var latlng in list) {
    pointList.add(new Point(latlng.latitude, latlng.longitude));
  }
  Point point = new Point(lat, long);
  return PolyUtils.containsLocationPoly(point, pointList);
}
