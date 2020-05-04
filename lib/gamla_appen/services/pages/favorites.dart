import 'package:flutter/material.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/map/favoriteParks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();


}

class _FavoritesState extends State<Favorites> {
  FavoriteParksList _favParksList = new FavoriteParksList();

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff207FC5),
          title: const Text("Your favorites"),
        ),
    body:
    _favParksList.isEmpty != null ? _emptyList(context) : ListView.separated(
          separatorBuilder: (context, index) =>
              Divider(
                color: Color(0xff207FC5),
              ),

          padding: const EdgeInsets.all(8),
          itemCount: _favParksList.favoriteParks.length,
          itemBuilder: _getFavoriteParksList,
        ),
        floatingActionButton:
        FloatingActionButton(
          elevation: 3.0,
          onPressed: () async {},
          child: Icon(Icons.refresh,
          ),
          backgroundColor: Colors.white,
        )
    );
  }

  Widget _getFavoriteParksList(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        openPage(context, _favParksList.favoriteParks[index].coordinates);
      },
      child: Container(
        height: 70,
        color: Color(0xffA5C9EA),
        child: ListTile(
          leading: new Icon(Icons.favorite),
          title: Text(
              'Adress: ${_favParksList.favoriteParks[index].streetName}'),
          subtitle: Text(
              'Price: 12 kronor per hour'),
          trailing: Icon(Icons.directions_car),
        ),
      ),
    );
  }

  Widget _emptyList(BuildContext context) {
    return Container(
      height: double.infinity,
      color: Color(0xff207FC5),
      child: Column (
        Text('You have no favorites'),
      )
   /*   child: ListTile(
        leading: new Icon(Icons.favorite),
        title: Text('You have no favorites'),
        subtitle: Text(
            'Tap a marker on the map to select a favorite'),
        trailing: Icon(Icons.directions_car),
      ), */
    );
  }

  void openPage(BuildContext context, LatLng location) {
    //Gå till parkeringsarean i map
  }

}
