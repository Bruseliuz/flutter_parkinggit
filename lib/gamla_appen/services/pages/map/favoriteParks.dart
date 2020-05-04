import 'package:flutterparkinggit/gamla_appen/services/pages/map/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/*class FavoriteParks extends ParkingAreas {
  String streetName;
  List<dynamic> coordinatesList;
  LatLng coordinates;
  String numberOfParkingSpots;
  String availableParkingSpots;
  String serviceDayInfo;
}*/

class FavoriteParksList {
  List<ParkingAreas> favoriteParks;

  FavoriteParksList() {
    updateFavoriteParks();
  }

  void updateFavoriteParks() {
    for (var item in parkingSpotsList) {
      if (item.favorite == true) {
        favoriteParks.add(item);
      }
    }
  }

 bool isEmpty () {
    if(favoriteParks.isEmpty)
      return true;
    else
      return false;
  }
}