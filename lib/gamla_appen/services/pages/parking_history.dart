import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/gamla_appen/models/active_parking.dart';
import 'package:flutterparkinggit/gamla_appen/models/user.dart';
import 'package:provider/provider.dart';

class ParkingHistory extends StatefulWidget {
  @override
  _ParkingHistoryState createState() => _ParkingHistoryState();
}

User globalUser;

class _ParkingHistoryState extends State<ParkingHistory> {

  List<ActiveParking> tempList = [];

  @override
  Widget build(BuildContext context) {
    globalUser = Provider.of<User>(context);

    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('parkingPreference').document(globalUser.uid).collection('parkinghistory').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Text("There are no favorites");
        tempList = getParkingHistory(snapshot);
        print(tempList);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff207FC5),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('PARKING HISTORY',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(width: 10),
                Icon(Icons.history,
                color: Colors.white,
                size: 20,)
              ],
            ),
          ),
          body: tempList.isEmpty ? _emptyList(context) :
          ListView.separated(
            separatorBuilder: (context, index) =>
                Divider(
                  color: Colors.white,
                ),
            padding: const EdgeInsets.all(8),
            itemCount: tempList.length,
            itemBuilder: _getParkingHistoryList,
          ),
        );
      }
    );
  }

  Widget _getParkingHistoryList(BuildContext context, int index){
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          color:  Color(0xff207FC5),
        ),
        child: ListTile(
          title: Column(
            children: <Widget>[
              Text('${tempList[index].streetName}',
            style: TextStyle(
                color: Colors.white,
              fontWeight: FontWeight.w600,
            ),),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Time: ${tempList[index].startTime} - ${tempList[index].endTime}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12
                  ),),
                  Text('Date: ',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12
                    ),),
                ],
              ),
            ],
        ),
      ),
    ),
    );
  }

  Widget _emptyList(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 50.0),
          Text('Youre parking history\nis empty.',
              style: TextStyle(
                color: Color(0xff207FC5),
                fontSize: 18,
              )),
        ],
      ),
    );
  }


  getParkingHistory(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents.map((doc) {
      String streetName = doc.data['streetName'];
      String startTime = doc.data['startTime'];
      String endTime = doc.data['endTime'];
      return ActiveParking(
          streetName: streetName,
        startTime: startTime,
        endTime: endTime,
      );
    }).toList();
  }
}
