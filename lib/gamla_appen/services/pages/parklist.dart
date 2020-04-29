import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/gamla_appen/services/pages//map/location.dart';


class ParkList extends StatefulWidget {
  @override
  _ParkListState createState() => _ParkListState();
}

class _ParkListState extends State<ParkList> {
  ParkingAreasList _parkingAreasList = new ParkingAreasList();

  @override
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
        itemCount: _parkingAreasList.parkingAreas.length,
        itemBuilder: _getParkingAreasList,
      ),
      floatingActionButton:
      FloatingActionButton(
        elevation: 3.0,
        onPressed: (){
        },
        child: Icon(Icons.refresh,
        ),
        backgroundColor:Color(0xff207FC5),
      )
    );
  }

  Widget _getParkingAreasList(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        openPage(context);
      },
      child: Container(
        height: 70,
        color: Color(0xffA5C9EA),
        child: ListTile(
          leading: Text(
              '${_parkingAreasList.parkingAreas[index].availableParkingSpots}'),
          title: Text('Adress: ${_parkingAreasList.parkingAreas[index].streetName}'),
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



 /* void openPage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff207FC5),
          title: const Text('Available parking lots in this area'),
        ),
        body: ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(8),
          itemCount: _parkingLotsList.parkingLots.length,
          itemBuilder: _getParkingLotsList,
        ),
      );
    }));
  } */

/*  Widget _getParkingLotsList(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 70,
        color: Color(0xffA5C9EA),
        child: ListTile(
          leading: _parkingLotsList.parkingLots[index].occupied == true
              ? new Icon(Icons.sentiment_dissatisfied)
              : new Icon(Icons.sentiment_very_satisfied),
          title: Text(
              'Located: ${_parkingLotsList.parkingLots[index].locationCoords}'),
          subtitle: Text('Go there'),
          trailing: Icon(Icons.accessibility),
        ),
      ),
    );
  }
}
*/