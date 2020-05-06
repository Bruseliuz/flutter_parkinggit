import 'package:flutterparkinggit/gamla_appen/services/pages/map/parking_area.dart';

class User {

  final String uid;

  User({this.uid});

}

class UserData{

  final String uid;
  final String name;
  final String parking;
  final int maxPrice;
  final int radius;
  final List<ParkingArea> favoritesList;

  UserData({this.uid, this.name, this.parking, this.maxPrice, this.radius, this.favoritesList});

}