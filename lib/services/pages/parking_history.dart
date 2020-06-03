import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterparkinggit/models/active_parking.dart';
import 'package:flutterparkinggit/models/user.dart';
import 'package:flutterparkinggit/services/pages/database.dart';
import 'package:provider/provider.dart';

class ParkingHistory extends StatefulWidget {
  @override
  _ParkingHistoryState createState() => _ParkingHistoryState();
}

User globalUser;

class _ParkingHistoryState extends State<ParkingHistory> {

  List<ActiveParking> parkingHistoryList = [];

  @override
  Widget build(BuildContext context) {
    globalUser = Provider.of<User>(context);
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('parkingPreference').document(globalUser.uid).collection('parkinghistory').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.hasData)
        parkingHistoryList = getParkingHistory(snapshot);
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
          body: parkingHistoryList.isEmpty ? _emptyList(context) :
          ListView.separated(
            separatorBuilder: (context, index) =>
                Divider(
                  color: Color(0xff207FC5),
                ),
            padding: const EdgeInsets.all(8),
            itemCount: parkingHistoryList.length,
            itemBuilder: _getParkingHistoryList,
          ),
          floatingActionButton: FloatingActionButton.extended(
              onPressed: () async{
                setState(() async {
                  await DatabaseService(uid: globalUser.uid).clearUserParkingHistory();
                });
              },
              backgroundColor: Color(0xff207FC5),
              icon: Icon(Icons.delete_forever,
              color: Colors.white70,),
              label: Text('CLEAR HISTORY',
              style: TextStyle(
                color: Colors.white
              ),)),
        );
      }
    );
  }

  Widget _getParkingHistoryList(BuildContext context, int index){
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(10),
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${parkingHistoryList[index].streetName}',
            style: TextStyle(
                color: Color(0xff207FC5),
              fontWeight: FontWeight.w600,
              fontSize: 20
            ),),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Time: ${parkingHistoryList[index].startTime} - ${parkingHistoryList[index].endTime}',
                        style: TextStyle(
                            color: Color(0xff207FC5),
                            fontSize: 14
                        ),),
                      SizedBox(height: 5),
                      Text('Date: ${parkingHistoryList[index].date}',
                        style: TextStyle(
                            color: Color(0xff207FC5),
                            fontSize: 14
                        ),
                      ),
                      SizedBox(height: 5),
                      Text('Total cost: ${parkingHistoryList[index].totalPrice}',
                        style: TextStyle(
                            color: Color(0xff207FC5),
                            fontSize: 14
                        ),
                      ),
                    ],
                  ),
                ],
              )
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('NO PARKING HISTORY',
                  style: TextStyle(
                    color: Color(0xff207FC5),
                    fontSize: 14,
                    fontWeight: FontWeight.w600
                  )),
            ],
          )
        ],
      ),
    );
  }

  getParkingHistory(AsyncSnapshot<QuerySnapshot> snapshot)  {
    return snapshot.data.documents.map((doc) {
      String streetName = doc.data['streetName'];
      String startTime = doc.data['startTime'];
      String endTime = doc.data['endTime'];
      String date = doc.data['date'];
      String totalPrice = doc.data['totalPrice'];
      List<String> temp = date.split('T');
      String dateOnly = temp[0];
      return ActiveParking(
          streetName: streetName,
        startTime: startTime,
        endTime: endTime,
        date: dateOnly,
        totalPrice: totalPrice
      );
    }).toList();
  }
}
