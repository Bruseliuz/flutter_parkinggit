import 'package:flutter/material.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/map/favoriteParks.dart';



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
          title: const Text("Availabe parking areas nearby"),
        ),
        body: ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(8),
          itemCount: _favParksList.favoriteParks.length,
          itemBuilder: _getFavoriteParksList,
        ),
        floatingActionButton:
        FloatingActionButton(
          elevation: 3.0,
          onPressed: () async {
          },
          child: Icon(Icons.refresh,
          ),
          backgroundColor:Color(0xff207FC5),
        )
    );
  }

  Widget _getFavoriteParksList(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        openPage(context);
      },
      child: Container(
        height: 70,
        color: Color(0xffA5C9EA),
        child: ListTile(
          leading: new Icon(Icons.favorite),
          title: Text('Adress: ${_favParksList.favoriteParks[index].streetName}'),
          subtitle: Text(
              'Price: 12 kronor per hour'),
          trailing: Icon(Icons.directions_car),
        ),
      ),
    );
  }

  void openPage(BuildContext context) {
    //Gå till parkeringsarean i map
  }

}
