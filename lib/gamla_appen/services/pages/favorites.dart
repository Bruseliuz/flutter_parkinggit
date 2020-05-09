import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/gamla_appen/models/user.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/map/map.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages/map/parking_area.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

User globalUser;

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {

  List<ParkingArea> _favParksList = [];

  Widget build(BuildContext context) {
    globalUser = Provider.of<User>(context);

    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('parkingPreference').document(globalUser.uid).collection('favoriteParkings').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return new Text("There are no favorites");
            _favParksList = getParkingSpots(snapshot);
          return Scaffold(
              backgroundColor: Color(0xff207FC5),
              appBar: AppBar(
                backgroundColor: Color(0xff207FC5),
                title: const Text("Your favorites"),
                centerTitle: true,
              ),
              body: _favParksList.isEmpty ? _emptyList(context) : ListView
                  .separated(
                separatorBuilder: (context, index) =>
                    Divider(
                      color: Color(0xff207FC5),
                    ),
                padding: const EdgeInsets.all(8),
                itemCount: _favParksList.length,
                itemBuilder: _getFavoriteParksList,
              ),
              floatingActionButton: FloatingActionButton(
                elevation: 3.0,
                onPressed: () async {},
                child: Icon(Icons.refresh, color: Color(0xff207FC5)),
                backgroundColor: Colors.white,
              ));
        }

    );
  }

  getParkingSpots(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents.map((doc) {
      String latlong = doc.data['coordinates'];
      List splitList = latlong.split(', ');
      String lat = splitList[0];
      String long = splitList[1];
      LatLng latlng = new LatLng(double.tryParse(lat), double.tryParse(long));
      return ParkingArea(
          streetName: doc.data['streetName'],
          coordinates: latlng,
          favorite: doc.data['favorite'],
          serviceDayInfo: doc.data['serviceDayInfo'],
          availableParkingSpots: doc.data['availableParkingSpots']
      );
    }).toList();
  }

  Widget _getFavoriteParksList(BuildContext context, int index) {
    return GestureDetector(
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(0xffA5C9EA),
        ),
        child: Dismissible(
          key: UniqueKey(),
          onDismissed: (direction) {
          },
          child: ListTile(
            leading: Column(
              children: <Widget>[
                Text('${_favParksList[index].availableParkingSpots.toString()}',
                  style: TextStyle(
                    fontSize: 25,
                  ),),
                Text('     Available \n parking spots',
                style: TextStyle(
                  fontSize: 7
                ),)
              ],
            ),
            title: Text('Adress: ${_favParksList[index].streetName}'),
            subtitle: Text('Price: 12 kronor per hour'),
            trailing: GestureDetector(
              onTap: (){
                setState((){
                  parkCollection
                      .document(globalUser.uid)
                      .collection('favoriteParkings')
                      .document(_favParksList[index].streetName)//streetName
                      .delete();
                });
              },
                child: Icon(
                    Icons.delete_forever,
                  size: 35,
                )
            ),
          ),
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
