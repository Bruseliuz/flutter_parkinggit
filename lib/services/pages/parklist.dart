import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:flutterparkinggit/services/pages/map/parking_area.dart';
import 'package:flutterparkinggit/services/pages/map/map.dart';
import 'dart:async';


class ParkList extends StatefulWidget {
  @override
  _ParkListState createState() => _ParkListState();
}

class _ParkListState extends State<ParkList> {
  Location _locationTracker = Location();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: Text("Availabe parking areas nearby: ${parkingSpotsList.length.toString()}",
          style: TextStyle(
              color:  Color(0xff207FC5),
            fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
          centerTitle: true,
        ),
        body: ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: Colors.white,
          ),

          padding: const EdgeInsets.all(8),
          itemCount: parkingSpotsList.length,
          itemBuilder: _getParkingAreasList,
        ),
        floatingActionButton:
        FloatingActionButton(
          heroTag: 'button2',
          elevation: 3.0,
          onPressed: () async {
            await getCurrentLocation();
          },
          child: Icon(Icons.refresh
          ),
          backgroundColor: Color(0xff4896cf),
        )
    );
  }

  Widget _getParkingAreasList(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (_) => ParkingDialogWidget(parkingArea: parkingSpotsList[index]));
      },
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black26,
                blurRadius: 5.0,
                offset: Offset(0,2)
            )
          ],
          borderRadius: BorderRadius.circular(10),
          color: Color(0xff207FC5),
        ),
        child: ListTile(
          leading: Column(
            children: <Widget>[
              Text(
                  '${parkingSpotsList[index].availableParkingSpots}',
              style: TextStyle(
                color: Colors.white
              ),),
              Text('    Available \n parking spots',
              style: TextStyle(
                fontSize: 10,
                color: Colors.white
              ),
              ),
            ],
          ),
          title: Text('${parkingSpotsList[index].streetName}',
          maxLines: 2,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600
          ),),
          subtitle: Text(
              'Price: 12 kronor per hour',
          style: TextStyle(
            color: Colors.white
          ),),
          trailing: Icon(Icons.directions_car,
              color: Colors.white),

        ),
      ),
    );
  }

  Widget _emptyList(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Color(0xff207FC5),
      child: Column (
        children: <Widget> [
          SizedBox(height: 50.0),
          Text('There are no available parking areas nearby', style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          )),
        ],),
    );
  }

  Future getCurrentLocation() async {
    var location = await _locationTracker.getLocation();
    LatLng newLocation = LatLng(location.latitude, location.longitude);
    await getData(newLocation);
    setState(() {
    });
  }

  Future<void> getData(LatLng location) async {
    Response response = await get('https://openparking.stockholm.se/LTF-Tolken/v1/${preference.toString()}/within?radius=$distance&lat=${location.latitude.toString()}&lng=${location.longitude.toString()}&outputFormat=json&apiKey=e734eaa7-d9b5-422a-9521-844554d9965b');
    Map data = jsonDecode(response.body);
    var dataList = data['features'] as List;
    List list = dataList.map<ParkingArea>((json) => ParkingArea.fromJson(json)).toList();
    parseParkingCoordinates(list);
  }
}