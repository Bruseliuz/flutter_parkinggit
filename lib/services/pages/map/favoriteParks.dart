import 'package:flutterparkinggit/services/pages/map/parking_area.dart';
import 'package:flutterparkinggit/services/pages/map/map.dart';

class FavoriteParksList {
  List<ParkingArea> favoriteParks = [];

  FavoriteParksList() {
    updateFavoriteParks();
  }

  void updateFavoriteParks() {
    for (var item in parkingSpotsList) {
      if (item.favorite == true) favoriteParks.add(item);
    }
  }
}
