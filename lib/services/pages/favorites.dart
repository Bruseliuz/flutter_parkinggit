import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/models/user.dart';
import 'package:flutterparkinggit/services/pages/database.dart';
import 'package:flutterparkinggit/services/pages/homescreens/setting_anon.dart';
import 'package:flutterparkinggit/services/pages/map/map.dart';
import 'package:flutterparkinggit/services/pages/map/parking_area.dart';
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
        stream: Firestore.instance
            .collection('parkingPreference')
            .document(globalUser.uid)
            .collection('favoriteParkings')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return new Text("There are no favorites");
          _favParksList = getParkingSpots(snapshot);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.white,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("FAVORITES",
                    style: TextStyle(
                        color: Color(0xff207FC5),
                        fontWeight: FontWeight.bold,
                        fontSize: 20),),
                ],
              ),
            ),
            body: _favParksList.isEmpty ? _emptyList(context) : ListView
                .separated(
              separatorBuilder: (context, index) =>
                  Divider(
                    color: Colors.white,
                  ),
              padding: const EdgeInsets.all(8),
              itemCount: _favParksList.length,
              itemBuilder: _getFavoriteParksList,
            ),
          );
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
          price: doc.data['price'],
          streetName: doc.data['streetName'],
          coordinates: latlng,
          favorite: doc.data['favorite'],
          serviceDayInfo: doc.data['serviceDayInfo'],
          availableParkingSpots: doc.data['availableParkingSpots'],
          numberOfParkingSpots: doc.data['numberOfParkingSpots']
      );
    }).toList();
  }

  Widget _getFavoriteParksList(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        print(_favParksList[index]);
        showDialog(
            context: context,
            builder: (_) =>
                ParkingDialogWidget(parkingArea: _favParksList[index]));
      },
      child: Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          setState(() {
            parkCollection
                .document(globalUser.uid)
                .collection('favoriteParkings')
                .document(_favParksList[index].streetName) //streetName
                .delete();
          });
        },
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5.0,
                  offset: Offset(0, 2)
              )
            ],
            borderRadius: BorderRadius.circular(10),
            color: Color(0xff207FC5),
          ),
          child: ListTile(
            leading: Column(
              children: <Widget>[
                Expanded(
                  child: Text(
                    '${_favParksList[index].availableParkingSpots.toString()}',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Text(
                    '     Available \n parking spots',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
            title: Text('${_favParksList[index].streetName}',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white
              ),
              maxLines: 2,),
            subtitle: Text('${_favParksList[index].price}',
              style: TextStyle(
                  color: Colors.white
              ),),
            trailing: GestureDetector(
                onTap: () {
                  setState(() {
                    parkCollection
                        .document(globalUser.uid)
                        .collection('favoriteParkings')
                        .document(_favParksList[index].streetName) //streetName
                        .delete();
                  });
                },
                child: Icon(
                  Icons.delete_forever,
                  size: 35,
                  color: Colors.white70,
                )
            ),
          ),
        ),
      ),
    );
  }

  Widget _emptyList(BuildContext context) {
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: globalUser.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 50.0),
                  Text('You have no favorites',
                      style: TextStyle(
                        color: Color(0xff207FC5),
                        fontSize: 18,
                      )),
                  SizedBox(height: 20.0),
                  Text('Tap a marker on the map to select a favorite',
                      style: TextStyle(
                        color: Color(0xff207FC5),
                        fontSize: 18,
                      ))
                ],
              ),
            );
          } else {
            return SettingsFormAnon();
          }
        });
  }
}
