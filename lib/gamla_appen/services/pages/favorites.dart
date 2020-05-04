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
      backgroundColor: Color(0xff207FC5),
        appBar: AppBar(
          backgroundColor: Color(0xff207FC5),
          title: const Text("Your favorites"),
        ),
        body: _favParksList.favoriteParks.isEmpty ? _emptyList(context) : ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  color: Color(0xff207FC5),
                ),
                padding: const EdgeInsets.all(8),
                itemCount: _favParksList.favoriteParks.length,
                itemBuilder: _getFavoriteParksList,
              ),
        floatingActionButton: FloatingActionButton(
          elevation: 3.0,
          onPressed: () async {},
          child: Icon(Icons.refresh, color: Color(0xff207FC5)),
          backgroundColor: Colors.white,
        ));
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
          title:
              Text('Adress: ${_favParksList.favoriteParks[index].streetName}'),
          subtitle: Text('Price: 12 kronor per hour'),
          trailing: Icon(Icons.directions_car),
        ),
      ),
    );
  }

  Widget _emptyList(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Color(0xff207FC5),
      child: Column(
        children: <Widget>[
          SizedBox(height: 50.0),
          Text('You have no favorites',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              )),
          SizedBox(height: 20.0),
          Text('Tap a marker on the map to select a favorite',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ))
        ],
      ),
    );
  }

  void openPage(BuildContext context, LatLng location) {
    //Gå till parkeringsarean i map
  }
}
